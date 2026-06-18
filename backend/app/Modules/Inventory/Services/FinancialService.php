<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Inventory\Models\ProductionOrder;
use App\Modules\Inventory\Models\PurchaseOrder;
use App\Modules\Inventory\Models\RawMaterial;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class FinancialService
{
    // Statuses de pedido que geram receita real
    const REVENUE_STATUSES = ['processing', 'shipped', 'delivered'];

    /* ─────────────────────────────────────────────────────────────
     | 1. DRE SIMPLIFICADA — resultado do período
     ──────────────────────────────────────────────────────────── */
    public function getDRE(string $period = '30d', ?string $fromStr = null, ?string $toStr = null): array
    {
        [$from, $to] = $this->parsePeriod($period, $fromStr, $toStr);

        // Receita Bruta
        $grossRevenue = round(
            Order::whereIn('status', self::REVENUE_STATUSES)
                ->whereBetween('created_at', [$from, $to])
                ->sum('total'),
            2
        );

        // Total de pedidos
        $orderCount = Order::whereIn('status', self::REVENUE_STATUSES)
            ->whereBetween('created_at', [$from, $to])
            ->count();

        $cancelledCount = Order::where('status', 'cancelled')
            ->whereBetween('created_at', [$from, $to])
            ->count();

        // CMV — custo dos produtos vendidos
        // Calcula: SUM(order_items.quantity × products.unit_cost) para pedidos com receita
        $cmv = round(
            OrderItem::whereHas('order', fn($q) =>
                $q->whereIn('status', self::REVENUE_STATUSES)
                  ->whereBetween('created_at', [$from, $to])
            )
            ->where('itemable_type', 'LIKE', '%Product%')
            ->join('products', 'products.id', '=', 'order_items.itemable_id')
            ->whereNotNull('products.unit_cost')
            ->selectRaw('SUM(order_items.quantity * products.unit_cost) as cmv')
            ->value('cmv') ?? 0,
            2
        );

        // Custo de compras no período (OCs recebidas)
        $purchaseCost = round(
            PurchaseOrder::where('status', 'received')
                ->whereBetween('received_at', [$from, $to])
                ->sum('total_actual'),
            2
        );

        // Custo de produção no período
        $productionCost = round(
            ProductionOrder::where('status', 'completed')
                ->whereBetween('completed_at', [$from, $to])
                ->sum('actual_cost'),
            2
        );

        // Valor atual em estoque
        $stockValue = round(
            RawMaterial::where('is_active', true)
                ->selectRaw('SUM(stock_quantity * average_cost) as total')
                ->value('total') ?? 0,
            2
        );

        // Indicadores derivados
        $grossProfit  = round($grossRevenue - $cmv, 2);
        $grossMargin  = $grossRevenue > 0
            ? round(($grossProfit / $grossRevenue) * 100, 2)
            : null;

        return [
            'period'          => ['from' => $from->toDateString(), 'to' => $to->toDateString()],
            'gross_revenue'   => $grossRevenue,
            'order_count'     => $orderCount,
            'cancelled_count' => $cancelledCount,
            'cmv'             => $cmv,
            'gross_profit'    => $grossProfit,
            'gross_margin'    => $grossMargin,
            'purchase_cost'   => $purchaseCost,
            'production_cost' => $productionCost,
            'stock_value'     => $stockValue,
        ];
    }

    /* ─────────────────────────────────────────────────────────────
     | 2. DRE MENSAL — série temporal para gráfico
     ──────────────────────────────────────────────────────────── */
    public function getMonthlySeries(int $months = 6): array
    {
        $series = [];

        for ($i = $months - 1; $i >= 0; $i--) {
            $from = Carbon::now()->subMonths($i)->startOfMonth();
            $to   = Carbon::now()->subMonths($i)->endOfMonth();
            $key  = $from->format('Y-m');

            $revenue = round(
                Order::whereIn('status', self::REVENUE_STATUSES)
                    ->whereBetween('created_at', [$from, $to])
                    ->sum('total'),
                2
            );

            $cmv = round(
                OrderItem::whereHas('order', fn($q) =>
                    $q->whereIn('status', self::REVENUE_STATUSES)
                      ->whereBetween('created_at', [$from, $to])
                )
                ->where('itemable_type', 'LIKE', '%Product%')
                ->join('products', 'products.id', '=', 'order_items.itemable_id')
                ->whereNotNull('products.unit_cost')
                ->selectRaw('SUM(order_items.quantity * products.unit_cost) as cmv')
                ->value('cmv') ?? 0,
                2
            );

            $purchaseCost = round(
                PurchaseOrder::where('status', 'received')
                    ->whereBetween('received_at', [$from, $to])
                    ->sum('total_actual'),
                2
            );

            $productionCost = round(
                ProductionOrder::where('status', 'completed')
                    ->whereBetween('completed_at', [$from, $to])
                    ->sum('actual_cost'),
                2
            );

            $series[] = [
                'month'          => $key,
                'label'          => $from->translatedFormat('M/y'),
                'revenue'        => $revenue,
                'cmv'            => $cmv,
                'gross_profit'   => round($revenue - $cmv, 2),
                'purchase_cost'  => $purchaseCost,
                'production_cost'=> $productionCost,
            ];
        }

        return $series;
    }

    /* ─────────────────────────────────────────────────────────────
     | 3. MARGEM POR PRODUTO — ranking de lucratividade
     ──────────────────────────────────────────────────────────── */
    public function getProductMargins(string $period = '30d', ?string $fromStr = null, ?string $toStr = null): array
    {
        [$from, $to] = $this->parsePeriod($period, $fromStr, $toStr);

        $rows = OrderItem::whereHas('order', fn($q) =>
                $q->whereIn('status', self::REVENUE_STATUSES)
                  ->whereBetween('created_at', [$from, $to])
            )
            ->where('itemable_type', 'LIKE', '%Product%')
            ->join('products', 'products.id', '=', 'order_items.itemable_id')
            ->selectRaw('
                order_items.itemable_id              as product_id,
                products.name                        as product_name,
                products.price                       as current_price,
                products.unit_cost                   as unit_cost,
                SUM(order_items.quantity)            as units_sold,
                SUM(order_items.quantity * order_items.price) as revenue,
                SUM(order_items.quantity * COALESCE(products.unit_cost, 0)) as total_cmv
            ')
            ->groupBy('order_items.itemable_id', 'products.name', 'products.price', 'products.unit_cost')
            ->orderByDesc('revenue')
            ->get();

        return $rows->map(function ($r) {
            $revenue   = (float) $r->revenue;
            $cmv       = (float) $r->total_cmv;
            $profit    = $revenue - $cmv;
            $margin    = $revenue > 0 ? round(($profit / $revenue) * 100, 2) : null;
            $unitCost  = (float) ($r->unit_cost ?? 0);
            $unitPrice = (float) $r->current_price;
            $unitMargin = $unitPrice > 0 && $unitCost > 0
                ? round((($unitPrice - $unitCost) / $unitPrice) * 100, 2)
                : null;

            return [
                'product_id'    => $r->product_id,
                'product_name'  => $r->product_name,
                'units_sold'    => (int) $r->units_sold,
                'unit_price'    => $unitPrice,
                'unit_cost'     => $unitCost,
                'unit_margin'   => $unitMargin,
                'revenue'       => round($revenue, 2),
                'cmv'           => round($cmv, 2),
                'gross_profit'  => round($profit, 2),
                'margin_pct'    => $margin,
                'has_cost_data' => $unitCost > 0,
            ];
        })->toArray();
    }

    /* ─────────────────────────────────────────────────────────────
     | 4. TOP PRODUTOS POR RECEITA — ranking de vendas
     ──────────────────────────────────────────────────────────── */
    public function getTopProducts(string $period = '30d', int $limit = 10, ?string $fromStr = null, ?string $toStr = null): array
    {
        [$from, $to] = $this->parsePeriod($period, $fromStr, $toStr);

        return OrderItem::whereHas('order', fn($q) =>
                $q->whereIn('status', self::REVENUE_STATUSES)
                  ->whereBetween('created_at', [$from, $to])
            )
            ->where('itemable_type', 'LIKE', '%Product%')
            ->join('products', 'products.id', '=', 'order_items.itemable_id')
            ->selectRaw('
                order_items.itemable_id             as product_id,
                products.name                       as name,
                SUM(order_items.quantity)           as units,
                SUM(order_items.quantity * order_items.price) as revenue
            ')
            ->groupBy('order_items.itemable_id', 'products.name')
            ->orderByDesc('revenue')
            ->limit($limit)
            ->get()
            ->map(fn($r) => [
                'product_id' => $r->product_id,
                'name'       => $r->name,
                'units'      => (int) $r->units,
                'revenue'    => round((float) $r->revenue, 2),
            ])
            ->toArray();
    }

    /* ─────────────────────────────────────────────────────────────
     | Helper
     ──────────────────────────────────────────────────────────── */
    private function parsePeriod(string $period, ?string $fromStr = null, ?string $toStr = null): array
    {
        if ($period === 'custom' && $fromStr && $toStr) {
            try {
                $from = Carbon::parse($fromStr)->startOfDay();
                $to   = Carbon::parse($toStr)->endOfDay();
                return [$from, $to];
            } catch (\Exception $e) {
                // fallback below if parsing fails
            }
        }

        $to   = Carbon::now()->endOfDay();
        $from = match ($period) {
            '7d'    => Carbon::now()->subDays(7)->startOfDay(),
            '30d'   => Carbon::now()->subDays(30)->startOfDay(),
            '90d'   => Carbon::now()->subDays(90)->startOfDay(),
            '6m'    => Carbon::now()->subMonths(6)->startOfDay(),
            '1y'    => Carbon::now()->subYear()->startOfDay(),
            'month' => Carbon::now()->startOfMonth(),
            default => Carbon::now()->subDays(30)->startOfDay(),
        };
        return [$from, $to];
    }
}
