<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\ComodatoPartner;
use App\Modules\Inventory\Models\ComodatoStock;
use App\Modules\Inventory\Models\ComodatoMovement;
use App\Modules\Inventory\Models\ComodatoAudit;
use App\Modules\Inventory\Models\ComodatoAuditItem;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\ProductVariant;
use App\Modules\Ecommerce\Models\Kit;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Models\InventoryMovement;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ComodatoService
{
    /**
     * Auxiliar para instanciar o modelo correspondente ao tipo de item.
     */
    protected function resolveModel(string $type, int $id)
    {
        if (str_contains($type, 'ProductVariant') || $type === 'variant') {
            return ProductVariant::findOrFail($id);
        } elseif (str_contains($type, 'Kit') || $type === 'kit') {
            return Kit::findOrFail($id);
        } else {
            return Product::findOrFail($id);
        }
    }

    /**
     * Auxiliar para obter o nome da classe cheia do modelo.
     */
    protected function resolveClass(string $type): string
    {
        if (str_contains($type, 'ProductVariant') || $type === 'variant') {
            return ProductVariant::class;
        } elseif (str_contains($type, 'Kit') || $type === 'kit') {
            return Kit::class;
        } else {
            return Product::class;
        }
    }

    /**
     * Envia mercadoria do estoque principal para o estoque em comodato do parceiro.
     */
    public function dispatchStock(int $partnerId, string $type, int $id, int $quantity, ?string $notes = null): ComodatoMovement
    {
        return DB::transaction(function () use ($partnerId, $type, $id, $quantity, $notes) {
            $partner = ComodatoPartner::findOrFail($partnerId);
            $model = $this->resolveModel($type, $id);
            $class = $this->resolveClass($type);

            // 1. Validar e retirar do estoque principal
            if ($model->stock < $quantity) {
                throw new \Exception("Estoque principal insuficiente para '{$model->name}'. Disponível: {$model->stock}. Solicitado: {$quantity}.");
            }
            $model->decrement('stock', $quantity);

            // 2. Registrar movimentação de saída do estoque principal
            InventoryMovement::create([
                'itemable_type' => $class,
                'itemable_id' => $model->id,
                'type' => 'out',
                'quantity' => $quantity,
                'reason' => 'comodato_dispatch',
                'notes' => "Enviado para comodato em: {$partner->name}. " . $notes,
            ]);

            // 3. Atualizar estoque em comodato do parceiro
            $comodatoStock = ComodatoStock::firstOrCreate(
                [
                    'partner_id' => $partner->id,
                    'itemable_type' => $class,
                    'itemable_id' => $model->id,
                ],
                ['quantity' => 0]
            );
            $comodatoStock->increment('quantity', $quantity);

            // 4. Registrar movimentação de comodato
            return ComodatoMovement::create([
                'partner_id' => $partner->id,
                'itemable_type' => $class,
                'itemable_id' => $model->id,
                'type' => 'dispatch',
                'quantity' => $quantity,
                'notes' => $notes,
            ]);
        });
    }

    /**
     * Registra vendas de mercadorias que estavam em comodato no parceiro.
     * Cria um pedido de venda padrão no ecommerce e baixa o estoque do parceiro.
     */
    public function recordSale(int $partnerId, array $items, string $paymentMethod, ?int $userId = null, ?string $customerName = null, ?string $customerPhone = null, ?float $discountAmount = null, ?string $notes = null): Order
    {
        return DB::transaction(function () use ($partnerId, $items, $paymentMethod, $userId, $customerName, $customerPhone, $discountAmount, $notes) {
            $partner = ComodatoPartner::findOrFail($partnerId);
            $total = 0;
            $orderItemsData = [];

            foreach ($items as $item) {
                $class = $this->resolveClass($item['type']);
                $model = $this->resolveModel($item['type'], $item['id']);

                // Buscar o estoque do parceiro
                $comodatoStock = ComodatoStock::where('partner_id', $partner->id)
                    ->where('itemable_type', $class)
                    ->where('itemable_id', $model->id)
                    ->first();

                if (!$comodatoStock || $comodatoStock->quantity < $item['quantity']) {
                    $available = $comodatoStock ? $comodatoStock->quantity : 0;
                    throw new \Exception("Estoque em comodato insuficiente para '{$model->name}' no parceiro {$partner->name}. Disponível: {$available}. Solicitado: {$item['quantity']}.");
                }

                // Deduzir estoque do parceiro
                $comodatoStock->decrement('quantity', $item['quantity']);

                $subtotal = $model->price * $item['quantity'];
                $total += $subtotal;

                $orderItemsData[] = [
                    'itemable_id' => $model->id,
                    'itemable_type' => $class,
                    'quantity' => $item['quantity'],
                    'price' => $model->price,
                ];
            }

            // Aplicar desconto se houver
            $discount = (float)($discountAmount ?? 0);
            $finalTotal = max(0, $total - $discount);

            // Criar pedido
            $order = Order::create([
                'user_id' => $userId,
                'customer_name' => $customerName ?? "Venda Comodato - {$partner->name}",
                'customer_phone' => $customerPhone,
                'order_number' => 'COM-' . strtoupper(Str::random(8)),
                'total' => $finalTotal,
                'discount_amount' => $discount > 0 ? $discount : null,
                'status' => 'delivered', // Venda de comodato já é considerada entregue
                'source' => 'comodato',
                'payment_method' => $paymentMethod,
                'notes' => "Parceiro: {$partner->name}. " . $notes,
            ]);

            // Salvar itens e gerar histórico de comodato
            foreach ($orderItemsData as $itemData) {
                $itemData['order_id'] = $order->id;
                OrderItem::create($itemData);

                ComodatoMovement::create([
                    'partner_id' => $partner->id,
                    'itemable_type' => $itemData['itemable_type'],
                    'itemable_id' => $itemData['itemable_id'],
                    'type' => 'sale',
                    'quantity' => $itemData['quantity'],
                    'order_id' => $order->id,
                ]);
            }

            // Conceder pontos de fidelidade se houver cliente cadastrado vinculado
            if ($order->user_id) {
                try {
                    app(\App\Modules\Rewards\Services\LoyaltyService::class)->awardPointsForOrder($order);
                } catch (\Exception $e) {
                    // Ignora falhas secundárias no sistema de fidelidade para não quebrar a transação de venda
                }
            }

            return $order;
        });
    }

    /**
     * Retorna mercadorias do estoque de comodato do parceiro para o estoque central.
     */
    public function recordReturn(int $partnerId, string $type, int $id, int $quantity, ?string $notes = null): ComodatoMovement
    {
        return DB::transaction(function () use ($partnerId, $type, $id, $quantity, $notes) {
            $partner = ComodatoPartner::findOrFail($partnerId);
            $model = $this->resolveModel($type, $id);
            $class = $this->resolveClass($type);

            // 1. Validar e retirar do estoque do parceiro
            $comodatoStock = ComodatoStock::where('partner_id', $partner->id)
                ->where('itemable_type', $class)
                ->where('itemable_id', $model->id)
                ->first();

            if (!$comodatoStock || $comodatoStock->quantity < $quantity) {
                $available = $comodatoStock ? $comodatoStock->quantity : 0;
                throw new \Exception("Estoque em comodato insuficiente para devolução de '{$model->name}'. Disponível: {$available}. Solicitado: {$quantity}.");
            }
            $comodatoStock->decrement('quantity', $quantity);

            // 2. Devolver ao estoque principal
            $model->increment('stock', $quantity);

            // 3. Registrar movimentação de entrada no estoque principal
            InventoryMovement::create([
                'itemable_type' => $class,
                'itemable_id' => $model->id,
                'type' => 'in',
                'quantity' => $quantity,
                'reason' => 'comodato_return',
                'notes' => "Retorno de comodato do parceiro: {$partner->name}. " . $notes,
            ]);

            // 4. Registrar movimentação de comodato
            return ComodatoMovement::create([
                'partner_id' => $partner->id,
                'itemable_type' => $class,
                'itemable_id' => $model->id,
                'type' => 'return',
                'quantity' => $quantity,
                'notes' => $notes,
            ]);
        });
    }

    /**
     * Registra perda de mercadorias no estoque em comodato do parceiro.
     */
    public function recordLoss(int $partnerId, string $type, int $id, int $quantity, ?string $notes = null): ComodatoMovement
    {
        return DB::transaction(function () use ($partnerId, $type, $id, $quantity, $notes) {
            $partner = ComodatoPartner::findOrFail($partnerId);
            $model = $this->resolveModel($type, $id);
            $class = $this->resolveClass($type);

            // 1. Validar e retirar do estoque do parceiro
            $comodatoStock = ComodatoStock::where('partner_id', $partner->id)
                ->where('itemable_type', $class)
                ->where('itemable_id', $model->id)
                ->first();

            if (!$comodatoStock || $comodatoStock->quantity < $quantity) {
                $available = $comodatoStock ? $comodatoStock->quantity : 0;
                throw new \Exception("Estoque em comodato insuficiente para lançar perda de '{$model->name}'. Disponível: {$available}. Solicitado: {$quantity}.");
            }
            $comodatoStock->decrement('quantity', $quantity);

            // 2. Registrar movimentação de perda (comodato)
            return ComodatoMovement::create([
                'partner_id' => $partner->id,
                'itemable_type' => $class,
                'itemable_id' => $model->id,
                'type' => 'loss',
                'quantity' => $quantity,
                'notes' => $notes ?? "Perda registrada no comodato.",
            ]);
        });
    }

    /**
     * Registra uma auditoria de contagem física no parceiro.
     * Compara a contagem física com o estoque esperado e resolve as discrepâncias.
     */
    public function reconcileAudit(int $partnerId, array $countedItems, ?string $notes = null): ComodatoAudit
    {
        return DB::transaction(function () use ($partnerId, $countedItems, $notes) {
            $partner = ComodatoPartner::findOrFail($partnerId);
            
            $audit = ComodatoAudit::create([
                'partner_id' => $partner->id,
                'audited_at' => now(),
                'status' => 'completed',
                'notes' => $notes,
            ]);

            $discrepancyFound = false;

            foreach ($countedItems as $counted) {
                $class = $this->resolveClass($counted['type']);
                $model = $this->resolveModel($counted['type'], $counted['id']);
                $actual = (int)$counted['quantity'];

                // Buscar estoque esperado
                $comodatoStock = ComodatoStock::where('partner_id', $partner->id)
                    ->where('itemable_type', $class)
                    ->where('itemable_id', $model->id)
                    ->first();

                $expected = $comodatoStock ? $comodatoStock->quantity : 0;
                $difference = $actual - $expected;
                $actionTaken = 'none';

                if ($difference !== 0) {
                    $discrepancyFound = true;

                    if ($difference < 0) {
                        // Perda: Faltando estoque físico
                        $lossQty = abs($difference);
                        $this->recordLoss($partner->id, $counted['type'], $model->id, $lossQty, "Ajuste automático via auditoria #{$audit->id}");
                        $actionTaken = 'loss_registered';
                    } else {
                        // Sobra: Estoque físico é maior (raro, mas ajustável)
                        // Lançar um envio manual (dispatch) do estoque principal ou simplesmente ajustar
                        $surplusQty = $difference;
                        
                        // Atualiza o estoque local para bater com a contagem real
                        if ($comodatoStock) {
                            $comodatoStock->update(['quantity' => $actual]);
                        } else {
                            ComodatoStock::create([
                                'partner_id' => $partner->id,
                                'itemable_type' => $class,
                                'itemable_id' => $model->id,
                                'quantity' => $actual,
                            ]);
                        }

                        // Criar movimentação de comodato correspondente
                        ComodatoMovement::create([
                            'partner_id' => $partner->id,
                            'itemable_type' => $class,
                            'itemable_id' => $model->id,
                            'type' => 'dispatch',
                            'quantity' => $surplusQty,
                            'notes' => "Ajuste automático (sobra) via auditoria #{$audit->id}",
                        ]);
                        $actionTaken = 'adjusted_up';
                    }
                }

                ComodatoAuditItem::create([
                    'comodato_audit_id' => $audit->id,
                    'itemable_type' => $class,
                    'itemable_id' => $model->id,
                    'expected_quantity' => $expected,
                    'actual_quantity' => $actual,
                    'difference' => $difference,
                    'action_taken' => $actionTaken,
                ]);
            }

            if ($discrepancyFound) {
                $audit->update(['status' => 'discrepancy_found']);
            }

            return $audit;
        });
    }
}
