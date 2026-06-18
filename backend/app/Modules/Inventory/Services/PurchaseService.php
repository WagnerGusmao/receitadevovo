<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\PurchaseOrder;
use App\Modules\Inventory\Models\PurchaseOrderItem;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Models\Supplier;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PurchaseService
{
    public function __construct(
        private readonly InventoryService $inventoryService,
        private readonly QualityService   $qualityService,
    ) {}

    /* ─────────────────────────────────────────────────────────────
     | 1. CRIAR ORDEM MANUAL
     ──────────────────────────────────────────────────────────── */
    public function createOrder(
        int $supplierId,
        array $items,           // [['raw_material_id', 'quantity_ordered', 'unit_price', 'notes?'], ...]
        ?string $expectedAt = null,
        ?string $notes = null,
        ?int $userId = null
    ): PurchaseOrder {
        return DB::transaction(function () use ($supplierId, $items, $expectedAt, $notes, $userId) {
            $order = PurchaseOrder::create([
                'supplier_id' => $supplierId,
                'user_id'     => $userId,
                'status'      => 'draft',
                'expected_at' => $expectedAt,
                'notes'       => $notes,
            ]);

            $total = 0;
            foreach ($items as $item) {
                $planned = round(
                    floatval($item['quantity_ordered']) * floatval($item['unit_price']),
                    4
                );
                PurchaseOrderItem::create([
                    'purchase_order_id' => $order->id,
                    'raw_material_id'   => $item['raw_material_id'],
                    'quantity_ordered'  => $item['quantity_ordered'],
                    'unit_price'        => $item['unit_price'],
                    'total_planned'     => $planned,
                    'notes'             => $item['notes'] ?? null,
                ]);
                $total += $planned;
            }

            $order->update(['total_planned' => round($total, 2)]);

            return $order->load('items.rawMaterial', 'supplier', 'user');
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 2. GERAR AUTOMATICAMENTE A PARTIR DE ALERTAS DE ESTOQUE
     |    Cria uma OC por fornecedor com as MPs abaixo do mínimo
     ──────────────────────────────────────────────────────────── */
    public function generateFromAlerts(?int $userId = null): array
    {
        // MPs abaixo do mínimo com fornecedor cadastrado
        $materials = RawMaterial::where('is_active', true)
            ->whereNotNull('supplier_id')
            ->whereColumn('stock_quantity', '<=', 'min_stock_quantity')
            ->with('supplier')
            ->get();

        if ($materials->isEmpty()) {
            return [];
        }

        // Agrupar por fornecedor
        $bySupplier = $materials->groupBy('supplier_id');
        $orders     = [];

        foreach ($bySupplier as $supplierId => $group) {
            $items = $group->map(function ($m) {
                // Quantidade sugerida = reposição até max_stock (ou dobro do mínimo se sem max)
                $target  = $m->min_stock_quantity * 2;
                $needed  = max($target - $m->stock_quantity, $m->min_stock_quantity);
                return [
                    'raw_material_id'  => $m->id,
                    'quantity_ordered' => round($needed, 4),
                    'unit_price'       => $m->average_cost > 0 ? $m->average_cost : 0,
                    'notes'            => "Gerado automaticamente por alerta de estoque mínimo",
                ];
            })->toArray();

            $orders[] = $this->createOrder(
                supplierId: $supplierId,
                items:      $items,
                notes:      "Ordem gerada automaticamente pelo sistema",
                userId:     $userId
            );
        }

        return $orders;
    }

    /* ─────────────────────────────────────────────────────────────
     | 3. MARCAR COMO ENVIADA AO FORNECEDOR
     ──────────────────────────────────────────────────────────── */
    public function sendOrder(PurchaseOrder $order): PurchaseOrder
    {
        if ($order->status !== 'draft') {
            throw new \DomainException("Apenas rascunhos podem ser enviados.");
        }

        if ($order->items()->count() === 0) {
            throw new \DomainException("A ordem não possui itens.");
        }

        $order->update([
            'status'  => 'sent',
            'sent_at' => now(),
        ]);

        return $order->fresh(['items.rawMaterial', 'supplier']);
    }

    /* ─────────────────────────────────────────────────────────────
     | 4. RECEBER ITENS — atualiza estoque e CMP
     |    $receivedItems: [['item_id', 'quantity_received', 'actual_unit_price'], ...]
     ──────────────────────────────────────────────────────────── */
    public function receiveItems(PurchaseOrder $order, array $receivedItems): PurchaseOrder
    {
        if (!in_array($order->status, ['sent', 'partial'])) {
            throw new \DomainException("Apenas ordens enviadas ou parcialmente recebidas podem ser recebidas.");
        }

        $order->load('items.rawMaterial');

        return DB::transaction(function () use ($order, $receivedItems) {
            $itemMap   = collect($receivedItems)->keyBy('item_id');
            $totalReal = 0;

            foreach ($order->items as $item) {
                $incoming = $itemMap->get($item->id);
                if (!$incoming) {
                    continue;
                }

                $qtyReceived   = floatval($incoming['quantity_received']);
                $actualPrice   = floatval($incoming['actual_unit_price'] ?? $item->unit_price);
                $lineTotal     = round($qtyReceived * $actualPrice, 4);

                if ($qtyReceived <= 0) {
                    continue;
                }

                // Atualizar item
                $item->update([
                    'quantity_received'  => ($item->quantity_received ?? 0) + $qtyReceived,
                    'actual_unit_price'  => $actualPrice,
                    'total_actual'       => ($item->total_actual ?? 0) + $lineTotal,
                ]);

                $totalReal += $lineTotal;

                // Dar entrada no estoque via InventoryService (atualiza CMP)
                $material = RawMaterial::lockForUpdate()->findOrFail($item->raw_material_id);
                $this->inventoryService->registerEntry(
                    material:      $material,
                    quantity:      $qtyReceived,
                    unitCost:      $actualPrice,
                    type:          'purchase',
                    userId:        $order->user_id,
                    notes:         "OC: {$order->code}",
                    referenceType: PurchaseOrder::class,
                    referenceId:   $order->id,
                );
            }

            // Recalcular total real da ordem
            $newTotal = $order->total_actual + $totalReal;

            // Determinar novo status
            $order->load('items');
            $allComplete = $order->items->every(
                fn($i) => $i->quantity_received !== null
                    && $i->quantity_received >= $i->quantity_ordered
            );
            $anyReceived = $order->items->some(fn($i) => ($i->quantity_received ?? 0) > 0);

            $newStatus = $allComplete ? 'received' : ($anyReceived ? 'partial' : $order->status);

            $order->update([
                'status'       => $newStatus,
                'total_actual' => round($newTotal, 2),
                'received_at'  => $allComplete ? now() : null,
            ]);

            Log::info("Recebimento OC", [
                'order'      => $order->code,
                'status'     => $newStatus,
                'total_real' => $newTotal,
            ]);

            $fresh = $order->fresh(['items.rawMaterial', 'supplier', 'user']);

            // Criar inspeção de qualidade automaticamente ao receber completamente
            if ($newStatus === 'received') {
                try {
                    $this->qualityService->createCheck(
                        checkable: $fresh,
                        checkType: 'receipt',
                        userId:    $fresh->user_id,
                        notes:     "Gerado automaticamente ao receber OC {$fresh->code}",
                    );
                } catch (\DomainException $e) {
                    Log::warning("QualityCheck não criado para OC {$fresh->code}: " . $e->getMessage());
                }
            }

            return $fresh;
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 5. CANCELAR ORDEM
     ──────────────────────────────────────────────────────────── */
    public function cancelOrder(PurchaseOrder $order, ?string $reason = null): PurchaseOrder
    {
        if (in_array($order->status, ['received', 'cancelled'])) {
            throw new \DomainException("Esta ordem não pode ser cancelada.");
        }

        if ($order->status === 'partial') {
            throw new \DomainException(
                "Ordem parcialmente recebida: finalize o recebimento ou ajuste o estoque manualmente antes de cancelar."
            );
        }

        $order->update([
            'status' => 'cancelled',
            'notes'  => $reason
                ? ($order->notes ? $order->notes . "\nCancelamento: $reason" : "Cancelamento: $reason")
                : $order->notes,
        ]);

        return $order->fresh();
    }

    /* ─────────────────────────────────────────────────────────────
     | 6. DASHBOARD DE COMPRAS
     ──────────────────────────────────────────────────────────── */
    public function getDashboard(): array
    {
        $now   = now();
        $month = $now->copy()->startOfMonth();

        $pending = PurchaseOrder::whereIn('status', ['draft', 'sent', 'partial'])
            ->with(['supplier', 'items'])
            ->orderBy('expected_at')
            ->get();

        $overdueCount = $pending->filter(fn($o) => $o->is_overdue)->count();

        $thisMonth = PurchaseOrder::where('status', 'received')
            ->where('received_at', '>=', $month)
            ->get(['total_planned', 'total_actual']);

        $totalSpent    = round($thisMonth->sum('total_actual'), 2);
        $totalPlanned  = round($thisMonth->sum('total_planned'), 2);
        $priceVariance = round($totalSpent - $totalPlanned, 2);

        // MPs ainda abaixo do mínimo
        $alertCount = RawMaterial::where('is_active', true)
            ->whereColumn('stock_quantity', '<=', 'min_stock_quantity')
            ->count();

        return [
            'pending_orders'   => $pending->count(),
            'overdue_count'    => $overdueCount,
            'received_month'   => $thisMonth->count(),
            'total_spent'      => $totalSpent,
            'price_variance'   => $priceVariance,
            'alert_count'      => $alertCount,
            'pending_list'     => $pending,
        ];
    }
}
