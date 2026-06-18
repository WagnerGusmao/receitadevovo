<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Models\Batch;
use App\Modules\Inventory\Models\RawMaterialMovement;
use Illuminate\Support\Facades\DB;

class InventoryService
{
    /**
     * Registra entrada de matéria-prima (compra ou ajuste).
     * Recalcula custo médio ponderado automaticamente.
     */
    public function registerEntry(
        RawMaterial $material,
        float $quantity,
        float $unitCost,
        string $type,
        ?int $batchId = null,
        ?int $userId = null,
        ?string $notes = null,
        ?string $referenceType = null,
        ?int $referenceId = null
    ): RawMaterialMovement {
        return DB::transaction(function () use (
            $material, $quantity, $unitCost, $type,
            $batchId, $userId, $notes, $referenceType, $referenceId
        ) {
            // Custo Médio Ponderado (CMP):
            // CMP_novo = (Estoque_atual × CMP_atual + Qtd_entrada × Custo_novo)
            //            ÷ (Estoque_atual + Qtd_entrada)
            $currentStock  = $material->stock_quantity;
            $currentCost   = $material->average_cost;
            $totalCost     = $quantity * $unitCost;

            $newStock       = $currentStock + $quantity;
            $newAverageCost = $newStock > 0
                ? (($currentStock * $currentCost) + $totalCost) / $newStock
                : $unitCost;

            // Atualizar matéria-prima
            $material->update([
                'stock_quantity' => $newStock,
                'average_cost'   => round($newAverageCost, 4),
            ]);

            // Atualizar saldo restante do lote
            if ($batchId) {
                Batch::where('id', $batchId)->increment('quantity_remaining', $quantity);
            }

            // Registrar movimentação
            return RawMaterialMovement::create([
                'raw_material_id'    => $material->id,
                'batch_id'           => $batchId,
                'user_id'            => $userId,
                'type'               => $type,
                'quantity'           => $quantity,
                'unit_cost'          => $unitCost,
                'total_cost'         => $totalCost,
                'stock_after'        => $newStock,
                'average_cost_after' => round($newAverageCost, 4),
                'reference_type'     => $referenceType,
                'reference_id'       => $referenceId,
                'notes'              => $notes,
            ]);
        });
    }

    /**
     * Registra saída de matéria-prima (consumo, perda, ajuste).
     * Usa o custo médio atual para valorizar a saída.
     * Garante que o estoque não fique negativo.
     */
    public function registerExit(
        RawMaterial $material,
        float $quantity,
        string $type,
        ?int $batchId = null,
        ?int $userId = null,
        ?string $notes = null,
        ?string $referenceType = null,
        ?int $referenceId = null
    ): RawMaterialMovement {
        return DB::transaction(function () use (
            $material, $quantity, $type,
            $batchId, $userId, $notes, $referenceType, $referenceId
        ) {
            if ($material->stock_quantity < $quantity) {
                throw new \DomainException(
                    "Estoque insuficiente para '{$material->name}'. " .
                    "Disponível: {$material->stock_quantity} {$material->unit}, " .
                    "Necessário: {$quantity} {$material->unit}."
                );
            }

            $unitCost  = $material->average_cost;
            $totalCost = $quantity * $unitCost;
            $newStock  = $material->stock_quantity - $quantity;

            // Custo médio permanece igual em saídas (CMP só muda em entradas)
            $material->update(['stock_quantity' => $newStock]);

            // Debitar do lote específico (FEFO — First Expire, First Out)
            if ($batchId) {
                $batch = Batch::findOrFail($batchId);
                $remaining = $batch->quantity_remaining - $quantity;
                $batch->update([
                    'quantity_remaining' => max(0, $remaining),
                    'status' => $remaining <= 0 ? 'depleted' : 'active',
                ]);
            } else {
                // FEFO: Consumir dos lotes ativos ordenados por vencimento (primeiro os que vencem mais cedo)
                // Lotes sem data de validade (expires_at null) são consumidos por último.
                $remainingToConsume = $quantity;
                $activeBatches = Batch::where('raw_material_id', $material->id)
                    ->where('status', 'active')
                    ->where('quantity_remaining', '>', 0)
                    ->orderByRaw('expires_at IS NULL, expires_at ASC')
                    ->get();

                foreach ($activeBatches as $batch) {
                    if ($remainingToConsume <= 0) {
                        break;
                    }

                    $toDebit = min($batch->quantity_remaining, $remainingToConsume);
                    $newRemaining = $batch->quantity_remaining - $toDebit;
                    $batch->update([
                        'quantity_remaining' => $newRemaining,
                        'status' => $newRemaining <= 0 ? 'depleted' : 'active',
                    ]);

                    $remainingToConsume -= $toDebit;
                }
            }

            return RawMaterialMovement::create([
                'raw_material_id'    => $material->id,
                'batch_id'           => $batchId,
                'user_id'            => $userId,
                'type'               => $type,
                'quantity'           => $quantity,
                'unit_cost'          => $unitCost,
                'total_cost'         => $totalCost,
                'stock_after'        => $newStock,
                'average_cost_after' => $unitCost, // custo médio não muda em saídas
                'reference_type'     => $referenceType,
                'reference_id'       => $referenceId,
                'notes'              => $notes,
            ]);
        });
    }

    /**
     * Cria lote e registra entrada.
     */
    public function receiveBatch(
        RawMaterial $material,
        array $batchData,
        ?int $userId = null
    ): array {
        return DB::transaction(function () use ($material, $batchData, $userId) {
            $batch = Batch::create([
                'raw_material_id'    => $material->id,
                'supplier_id'        => $batchData['supplier_id'] ?? $material->supplier_id,
                'batch_number'       => $batchData['batch_number'],
                'quantity_received'  => $batchData['quantity'],
                'quantity_remaining' => $batchData['quantity'],
                'unit_cost'          => $batchData['unit_cost'],
                'manufactured_at'    => $batchData['manufactured_at'] ?? null,
                'expires_at'         => $batchData['expires_at'] ?? null,
                'notes'              => $batchData['notes'] ?? null,
            ]);

            $movement = $this->registerEntry(
                material:      $material,
                quantity:      $batchData['quantity'],
                unitCost:      $batchData['unit_cost'],
                type:          'purchase',
                batchId:       $batch->id,
                userId:        $userId,
                notes:         "Recebimento lote: {$batch->internal_code}",
            );

            return compact('batch', 'movement');
        });
    }

    /**
     * Retorna alertas críticos de estoque.
     */
    public function getAlerts(): array
    {
        $lowStock = RawMaterial::where('is_active', true)
            ->whereRaw('stock_quantity <= min_stock_quantity')
            ->with('supplier')
            ->get();

        $expiringBatches = Batch::where('status', 'active')
            ->whereNotNull('expires_at')
            ->where('expires_at', '<=', now()->addDays(30))
            ->where('quantity_remaining', '>', 0)
            ->with('rawMaterial')
            ->orderBy('expires_at')
            ->get();

        $expiredBatches = Batch::where('status', 'active')
            ->whereNotNull('expires_at')
            ->where('expires_at', '<', now())
            ->with('rawMaterial')
            ->get();

        // Marcar vencidos automaticamente
        if ($expiredBatches->count()) {
            Batch::whereIn('id', $expiredBatches->pluck('id'))
                ->update(['status' => 'expired']);
        }

        return [
            'low_stock'        => $lowStock,
            'expiring_batches' => $expiringBatches,
            'expired_batches'  => $expiredBatches,
        ];
    }

    /**
     * Atualiza um lote existente e recalcula o custo médio e estoque total da matéria-prima correspondente.
     */
    public function updateBatch(Batch $batch, array $data, ?int $userId = null): Batch
    {
        return DB::transaction(function () use ($batch, $data, $userId) {
            $material = RawMaterial::findOrFail($batch->raw_material_id);

            // 1. Guardar valores antigos para calcular diferenças
            $oldQtyReceived = (float)$batch->quantity_received;

            // Se quantity foi enviada, é a nova quantity_received
            $newQtyReceived = isset($data['quantity']) ? (float)$data['quantity'] : $oldQtyReceived;
            $newUnitCost = isset($data['unit_cost']) ? (float)$data['unit_cost'] : (float)$batch->unit_cost;

            // Calcular diferença na quantidade recebida
            $qtyDifference = $newQtyReceived - $oldQtyReceived;

            // 2. Atualizar o lote
            $batch->update([
                'supplier_id'        => array_key_exists('supplier_id', $data) ? $data['supplier_id'] : $batch->supplier_id,
                'batch_number'       => $data['batch_number'] ?? $batch->batch_number,
                'quantity_received'  => $newQtyReceived,
                'quantity_remaining' => max(0, (float)$batch->quantity_remaining + $qtyDifference),
                'unit_cost'          => $newUnitCost,
                'manufactured_at'    => array_key_exists('manufactured_at', $data) ? $data['manufactured_at'] : $batch->manufactured_at,
                'expires_at'         => array_key_exists('expires_at', $data) ? $data['expires_at'] : $batch->expires_at,
                'notes'              => array_key_exists('notes', $data) ? $data['notes'] : $batch->notes,
                'status'             => $data['status'] ?? $batch->status,
            ]);

            // Ajustar o status se depleted
            if ($batch->quantity_remaining <= 0) {
                $batch->update(['status' => 'depleted']);
            } elseif ($batch->status === 'depleted' && $batch->quantity_remaining > 0) {
                $batch->update(['status' => 'active']);
            }

            // 3. Atualizar a movimentação de compra associada ao lote
            $movement = RawMaterialMovement::where('batch_id', $batch->id)
                ->where('type', 'purchase')
                ->first();

            if ($movement) {
                $movement->update([
                    'quantity'   => $newQtyReceived,
                    'unit_cost'  => $newUnitCost,
                    'total_cost' => $newQtyReceived * $newUnitCost,
                ]);
            }

            // 4. Recalcular o estoque total e o custo médio ponderado da matéria-prima
            $totalStock = Batch::where('raw_material_id', $material->id)->sum('quantity_remaining');

            // Recalcular Custo Médio Ponderado (CMP) com base nos lotes que ainda têm saldo
            $activeBatches = Batch::where('raw_material_id', $material->id)
                ->where('quantity_remaining', '>', 0)
                ->get();

            if ($activeBatches->count() > 0) {
                $totalValue = $activeBatches->sum(fn($b) => (float)$b->quantity_remaining * (float)$b->unit_cost);
                $newAverageCost = $totalStock > 0 ? $totalValue / $totalStock : $newUnitCost;
            } else {
                // Se o estoque estiver zerado, assume o custo do lote editado
                $newAverageCost = $newUnitCost;
            }

            $material->update([
                'stock_quantity' => $totalStock,
                'average_cost'   => round($newAverageCost, 4),
            ]);

            // Atualizar o saldo pós na movimentação por consistência
            if ($movement) {
                $movement->update([
                    'stock_after'        => $totalStock,
                    'average_cost_after' => round($newAverageCost, 4),
                ]);
            }

            return $batch;
        });
    }

    /**
     * Valor total do estoque de matéria-prima (patrimonial).
     */
    public function getTotalStockValue(): float
    {
        return round(
            RawMaterial::where('is_active', true)
                ->selectRaw('SUM(stock_quantity * average_cost) as total')
                ->value('total') ?? 0,
            2
        );
    }
}
