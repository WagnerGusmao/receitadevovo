<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\Recipe;
use App\Modules\Inventory\Models\ProductionOrder;
use App\Modules\Inventory\Models\ProductionOrderItem;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Ecommerce\Models\InventoryMovement;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ProductionService
{
    public function __construct(
        private readonly InventoryService $inventoryService,
        private readonly QualityService   $qualityService,
    ) {}

    /* ─────────────────────────────────────────────────────────────
     | 1. CRIAR ORDEM (rascunho) — calcula planejado, não consome
     ──────────────────────────────────────────────────────────── */
    public function createOrder(
        Recipe $recipe,
        int $batches,
        ?int $userId = null,
        ?string $notes = null
    ): ProductionOrder {
        $recipe->load('ingredients.rawMaterial', 'product');

        $planned_yield = round($recipe->effective_yield * $batches, 3);
        $planned_cost  = round(
            $recipe->ingredients->sum(fn($i) => $i->quantity_with_waste * $i->rawMaterial->average_cost) * $batches,
            2
        );

        return DB::transaction(function () use ($recipe, $batches, $userId, $notes, $planned_yield, $planned_cost) {
            $order = ProductionOrder::create([
                'recipe_id'       => $recipe->id,
                'product_id'      => $recipe->product_id,
                'user_id'         => $userId,
                'status'          => 'draft',
                'planned_batches' => $batches,
                'planned_yield'   => $planned_yield,
                'planned_cost'    => $planned_cost,
                'notes'           => $notes,
            ]);

            // Pré-preencher itens planejados (sem consumir)
            foreach ($recipe->ingredients as $ingredient) {
                $qtd = $ingredient->quantity_with_waste * $batches;
                ProductionOrderItem::create([
                    'production_order_id' => $order->id,
                    'raw_material_id'     => $ingredient->raw_material_id,
                    'planned_quantity'    => round($qtd, 4),
                    'unit_cost'           => $ingredient->rawMaterial->average_cost,
                    'total_cost'          => round($qtd * $ingredient->rawMaterial->average_cost, 4),
                ]);
            }

            return $order->load('items.rawMaterial', 'recipe', 'product', 'user');
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 2. INICIAR PRODUÇÃO — valida estoque (sem consumir ainda)
     ──────────────────────────────────────────────────────────── */
    public function startOrder(ProductionOrder $order): ProductionOrder
    {
        if ($order->status !== 'draft') {
            throw new \DomainException("Apenas ordens em rascunho podem ser iniciadas.");
        }

        $order->load('items.rawMaterial');

        // Validar estoque de TODOS os itens antes de iniciar
        $shortages      = [];
        $qualityHolds   = [];

        foreach ($order->items as $item) {
            $material = $item->rawMaterial;

            // 1. Verificar estoque total
            if ($material->stock_quantity < $item->planned_quantity) {
                $shortages[] = sprintf(
                    '%s: necessário %.4f %s, disponível %.4f %s',
                    $material->name,
                    $item->planned_quantity,
                    $material->unit,
                    $material->stock_quantity,
                    $material->unit
                );
                continue;
            }

            // 2. Verificar se estoque disponível sem quarentena é suficiente
            $hasBatches = \App\Modules\Inventory\Models\Batch
                ::where('raw_material_id', $material->id)
                ->exists();

            if ($hasBatches) {
                $availableStock = \App\Modules\Inventory\Models\Batch
                    ::where('raw_material_id', $material->id)
                    ->whereNotIn('status', ['quarantine', 'depleted', 'expired'])
                    ->sum('quantity_remaining');

                if ($availableStock < $item->planned_quantity) {
                    $qualityHolds[] = sprintf(
                        '%s: %.4f %s necessário mas apenas %.4f %s disponível fora de quarentena',
                        $material->name,
                        $item->planned_quantity,
                        $material->unit,
                        $availableStock,
                        $material->unit
                    );
                }
            }
        }

        if (!empty($shortages)) {
            throw new \DomainException(
                "Estoque insuficiente para iniciar a produção:\n" . implode("\n", $shortages)
            );
        }

        if (!empty($qualityHolds)) {
            throw new \DomainException(
                "Lotes em quarentena impedem o início da produção:\n" . implode("\n", $qualityHolds)
            );
        }

        $order->update([
            'status'     => 'in_progress',
            'started_at' => now(),
        ]);

        return $order->fresh(['items.rawMaterial', 'recipe', 'product']);
    }

    /* ─────────────────────────────────────────────────────────────
     | 3. FINALIZAR PRODUÇÃO — consome MP, cria produto, rastreabilidade
     ──────────────────────────────────────────────────────────── */
    public function completeOrder(
        ProductionOrder $order,
        float $actualYield,
        array $actualItems = [],    // [['item_id' => X, 'actual_quantity' => Y], ...]
        ?float $wasteQuantity = null,
        ?string $wasteNotes = null,
        ?string $notes = null,
        array $outputs = []         // [['itemable_type' => X, 'itemable_id' => Y, 'quantity' => Z], ...]
    ): ProductionOrder {
        if ($order->status !== 'in_progress') {
            throw new \DomainException("Apenas ordens em andamento podem ser finalizadas.");
        }

        if (empty($outputs) && $actualYield <= 0) {
            throw new \DomainException("O rendimento real deve ser maior que zero.");
        }

        $order->load('items.rawMaterial', 'product');

        // Se outputs estiver vazio, definimos como padrão o produto principal da ordem
        if (empty($outputs)) {
            $outputs = [[
                'itemable_type' => get_class($order->product),
                'itemable_id' => $order->product_id,
                'quantity' => $actualYield
            ]];
        }

        return DB::transaction(function () use ($order, $actualYield, $actualItems, $wasteQuantity, $wasteNotes, $notes, $outputs) {
            $actualCost  = 0;
            $itemMap     = collect($actualItems)->keyBy('item_id');

            // Consumir matérias-primas e registrar rastreabilidade
            foreach ($order->items as $item) {
                $override = $itemMap->get($item->id);
                $qty      = isset($override['actual_quantity'])
                    ? (float) $override['actual_quantity']
                    : $item->planned_quantity;

                $material = RawMaterial::lockForUpdate()->findOrFail($item->raw_material_id);

                // Baixar estoque via InventoryService (registra CMP + movimento)
                $movement = $this->inventoryService->registerExit(
                    material:      $material,
                    quantity:      $qty,
                    type:          'consumed',
                    userId:        $order->user_id,
                    notes:         "OP: {$order->code}",
                    referenceType: ProductionOrder::class,
                    referenceId:   $order->id,
                );

                $lineCost = round($qty * $item->unit_cost, 4);
                $actualCost += $lineCost;

                // Atualizar item com quantidade real
                $item->update([
                    'actual_quantity' => $qty,
                    'unit_cost'       => $item->unit_cost,
                    'total_cost'      => $lineCost,
                ]);
            }

            // Calcular o volume total produzido para o rateio proporcional de custos
            $totalVolume = 0;
            $outputsWithModels = [];

            foreach ($outputs as $out) {
                $modelClass = $out['itemable_type'];
                
                // Se for criar uma nova variante "on-the-fly"
                if ($modelClass === \App\Modules\Ecommerce\Models\ProductVariant::class && (empty($out['itemable_id']) || $out['itemable_id'] === 'null' || $out['itemable_id'] === 0)) {
                    if (empty($out['name']) || empty($out['price']) || empty($out['volume'])) {
                        throw new \DomainException("Para cadastrar um novo tamanho/variante durante a finalização, é necessário preencher Nome, Preço e Volume.");
                    }
                    
                    // Gerar um SKU simples se não houver
                    $sku = isset($out['sku']) && !empty($out['sku']) 
                        ? $out['sku'] 
                        : 'VAR-' . $order->product_id . '-' . strtoupper(\Illuminate\Support\Str::slug($out['name']));

                    $model = \App\Modules\Ecommerce\Models\ProductVariant::create([
                        'product_id'  => $order->product_id,
                        'name'        => $out['name'],
                        'price'       => $out['price'],
                        'volume'      => $out['volume'],
                        'volume_unit' => $out['volume_unit'] ?? 'ml',
                        'stock'       => 0,
                        'unit_cost'   => 0,
                        'sku'         => $sku,
                    ]);
                } else {
                    $model = $modelClass::findOrFail($out['itemable_id']);
                }

                $qty = (float) $out['quantity'];

                // Obter volume relativo (se for variante, usamos o campo volume, se for o produto base, volume é 1)
                $volumeFactor = isset($model->volume) ? (float) $model->volume : 1.0;

                $totalVolume += $qty * $volumeFactor;
                $outputsWithModels[] = [
                    'model' => $model,
                    'quantity' => $qty,
                    'volume_factor' => $volumeFactor,
                ];
            }

            // Distribuir o custo real e incrementar estoques
            $costPerVolumeUnit = $totalVolume > 0 ? ($actualCost / $totalVolume) : 0;
            $totalYieldQuantity = 0;

            foreach ($outputsWithModels as $outData) {
                $model = $outData['model'];
                $qty = $outData['quantity'];
                $totalYieldQuantity += $qty;

                // Incrementar estoque do itemable
                $model->increment('stock', (int) floor($qty));

                // Calcular custo unitário baseado no volume/tamanho
                $unitCost = round($costPerVolumeUnit * $outData['volume_factor'], 4);

                // Atualizar o custo unitário do modelo
                $model->update(['unit_cost' => $unitCost]);

                // Registrar no banco de dados o output da OP
                \App\Modules\Inventory\Models\ProductionOrderOutput::create([
                    'production_order_id' => $order->id,
                    'itemable_type'       => get_class($model),
                    'itemable_id'         => $model->id,
                    'quantity'            => $qty,
                    'unit_cost'           => $unitCost,
                ]);

                // Registrar movimentação de estoque
                InventoryMovement::create([
                    'itemable_type' => get_class($model),
                    'itemable_id'   => $model->id,
                    'type'          => 'in',
                    'quantity'      => (int) floor($qty),
                    'reason'        => 'production',
                    'user_id'       => $order->user_id,
                    'notes'         => "Produção OP: {$order->code}",
                ]);
            }

            // Fechar ordem
            $order->update([
                'status'          => 'completed',
                'actual_batches'  => $order->planned_batches,
                'actual_yield'    => $totalYieldQuantity,
                'actual_cost'     => round($actualCost, 2),
                'waste_quantity'  => $wasteQuantity,
                'waste_notes'     => $wasteNotes,
                'completed_at'    => now(),
                'notes'           => $notes ?? $order->notes,
            ]);

            Log::info("Produção finalizada", [
                'order'          => $order->code,
                'actual_yield'   => $totalYieldQuantity,
                'actual_cost'    => round($actualCost, 2),
            ]);

            $fresh = $order->fresh(['items.rawMaterial', 'recipe', 'product', 'user']);

            // Criar inspeção de qualidade automaticamente
            try {
                $this->qualityService->createCheck(
                    checkable: $fresh,
                    checkType: 'production',
                    userId:    $fresh->user_id,
                    notes:     "Gerado automaticamente ao concluir OP {$fresh->code}",
                );
            } catch (\DomainException $e) {
                // Inspeção já existente — não bloquear a finalização
                Log::warning("QualityCheck não criado para OP {$fresh->code}: " . $e->getMessage());
            }

            return $fresh;
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 4. CANCELAR ORDEM — só permite se ainda não consumiu MP
     ──────────────────────────────────────────────────────────── */
    public function cancelOrder(ProductionOrder $order, ?string $reason = null): ProductionOrder
    {
        if ($order->status === 'completed') {
            throw new \DomainException("Ordens concluídas não podem ser canceladas.");
        }

        if ($order->status === 'cancelled') {
            throw new \DomainException("Esta ordem já está cancelada.");
        }

        // Se estava em andamento, verificar se algum item já foi consumido
        if ($order->status === 'in_progress') {
            $hasConsumed = $order->items()->whereNotNull('actual_quantity')->exists();
            if ($hasConsumed) {
                throw new \DomainException(
                    "Não é possível cancelar: matérias-primas já foram baixadas. Finalize a produção."
                );
            }
        }

        $order->update([
            'status' => 'cancelled',
            'notes'  => $reason ? ($order->notes ? $order->notes . "\nCancelamento: " . $reason : "Cancelamento: $reason") : $order->notes,
        ]);

        return $order->fresh();
    }

    /* ─────────────────────────────────────────────────────────────
     | 5. DASHBOARD DE PRODUÇÃO — métricas operacionais
     ──────────────────────────────────────────────────────────── */
    public function getDashboard(): array
    {
        $now            = now();
        $startOfMonth   = $now->copy()->startOfMonth();

        $ordersThisMonth = ProductionOrder::whereIn('status', ['completed', 'in_progress', 'draft'])
            ->where('created_at', '>=', $startOfMonth)
            ->count();

        $completedThisMonth = ProductionOrder::where('status', 'completed')
            ->where('completed_at', '>=', $startOfMonth)
            ->get(['actual_yield', 'actual_cost', 'waste_quantity', 'product_id', 'planned_cost']);

        $totalUnitsProduced = $completedThisMonth->sum('actual_yield');
        $totalCost          = $completedThisMonth->sum('actual_cost');
        $totalWaste         = $completedThisMonth->sum('waste_quantity');
        $totalPlanned       = $completedThisMonth->sum('planned_cost');
        $costVariance       = round($totalCost - $totalPlanned, 2);

        $inProgress = ProductionOrder::where('status', 'in_progress')
            ->with(['recipe', 'product'])
            ->orderBy('started_at')
            ->get();

        $recent = ProductionOrder::with(['recipe', 'product', 'user'])
            ->latest()
            ->limit(10)
            ->get();

        return [
            'orders_this_month'    => $ordersThisMonth,
            'units_produced'       => round($totalUnitsProduced, 0),
            'total_cost'           => round($totalCost, 2),
            'total_waste'          => round($totalWaste, 3),
            'cost_variance'        => $costVariance,
            'in_progress_count'    => $inProgress->count(),
            'in_progress_orders'   => $inProgress,
            'recent_orders'        => $recent,
        ];
    }
}
