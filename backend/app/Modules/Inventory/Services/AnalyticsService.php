<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\ProductionOrder;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Models\RawMaterialMovement;
use App\Modules\Inventory\Models\Recipe;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AnalyticsService
{
    /* ─────────────────────────────────────────────────────────────
     | 1. VISÃO GERAL — KPIs do período
     ──────────────────────────────────────────────────────────── */
    public function getOverview(string $period = '30d'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        // Ordens de produção
        $orders = ProductionOrder::whereBetween('created_at', [$from, $to]);

        $totalOrders     = (clone $orders)->count();
        $completedOrders = (clone $orders)->where('status', 'completed')->count();
        $cancelledOrders = (clone $orders)->where('status', 'cancelled')->count();

        $completed = ProductionOrder::where('status', 'completed')
            ->whereBetween('completed_at', [$from, $to])
            ->selectRaw('
                SUM(actual_yield)  as total_units,
                SUM(actual_cost)   as total_cost,
                SUM(planned_cost)  as total_planned,
                SUM(waste_quantity) as total_waste,
                AVG(actual_cost / NULLIF(actual_yield, 0)) as avg_unit_cost
            ')
            ->first();

        $totalUnits   = (float) ($completed->total_units ?? 0);
        $totalCost    = (float) ($completed->total_cost ?? 0);
        $totalPlanned = (float) ($completed->total_planned ?? 0);
        $totalWaste   = (float) ($completed->total_waste ?? 0);
        $costVariance = round($totalCost - $totalPlanned, 2);
        $efficiency   = $totalPlanned > 0
            ? round((1 - ($costVariance / $totalPlanned)) * 100, 1)
            : null;

        // Valor atual em estoque
        $stockValue = round(
            RawMaterial::where('is_active', true)
                ->selectRaw('SUM(stock_quantity * average_cost) as total')
                ->value('total') ?? 0,
            2
        );

        // Custo de MP consumida no período (saídas via produção)
        $consumptionCost = RawMaterialMovement::where('type', 'consumed')
            ->whereBetween('created_at', [$from, $to])
            ->sum('total_cost');

        return [
            'period'           => ['from' => $from->toDateString(), 'to' => $to->toDateString()],
            'total_orders'     => $totalOrders,
            'completed_orders' => $completedOrders,
            'cancelled_orders' => $cancelledOrders,
            'total_units'      => round($totalUnits, 0),
            'total_cost'       => round($totalCost, 2),
            'cost_variance'    => $costVariance,
            'efficiency'       => $efficiency,
            'total_waste'      => round($totalWaste, 3),
            'stock_value'      => $stockValue,
            'consumption_cost' => round((float) $consumptionCost, 2),
        ];
    }

    /* ─────────────────────────────────────────────────────────────
     | 2. CUSTO DE PRODUÇÃO POR DIA/MÊS (série temporal)
     ──────────────────────────────────────────────────────────── */
    public function getCostTimeSeries(string $period = '30d', string $groupBy = 'day'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        $format   = $groupBy === 'month' ? '%Y-%m' : '%Y-%m-%d';
        $labelFmt = $groupBy === 'month' ? 'Y-m' : 'Y-m-d';

        $rows = ProductionOrder::where('status', 'completed')
            ->whereBetween('completed_at', [$from, $to])
            ->selectRaw("DATE_FORMAT(completed_at, ?) as period, SUM(actual_cost) as cost, SUM(planned_cost) as planned, SUM(actual_yield) as units, COUNT(*) as orders", [$format])
            ->groupBy('period')
            ->orderBy('period')
            ->get();

        // Preencher dias sem produção com zero
        $map = $rows->keyBy('period');
        $series = [];
        $cursor = $from->copy();
        while ($cursor->lte($to)) {
            $key    = $cursor->format($labelFmt);
            $row    = $map->get($key);
            $series[] = [
                'date'    => $key,
                'cost'    => $row ? round((float) $row->cost, 2) : 0,
                'planned' => $row ? round((float) $row->planned, 2) : 0,
                'units'   => $row ? (int) $row->units : 0,
                'orders'  => $row ? (int) $row->orders : 0,
            ];
            $groupBy === 'month' ? $cursor->addMonth() : $cursor->addDay();
        }

        return $series;
    }

    /* ─────────────────────────────────────────────────────────────
     | 3. RANKING DE RECEITAS — lucratividade e eficiência
     ──────────────────────────────────────────────────────────── */
    public function getRecipeProfitability(string $period = '90d'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        $rows = ProductionOrder::where('status', 'completed')
            ->whereBetween('completed_at', [$from, $to])
            ->with('recipe:id,name', 'product:id,name,price')
            ->selectRaw('
                recipe_id,
                product_id,
                COUNT(*)                                        as total_orders,
                SUM(actual_yield)                              as total_units,
                SUM(actual_cost)                               as total_cost,
                AVG(actual_cost / NULLIF(actual_yield, 0))     as avg_unit_cost,
                SUM(planned_cost)                              as total_planned,
                SUM(waste_quantity)                            as total_waste
            ')
            ->groupBy('recipe_id', 'product_id')
            ->get();

        return $rows->map(function ($row) {
            $price    = (float) ($row->product?->price ?? 0);
            $unitCost = (float) $row->avg_unit_cost;
            $margin   = ($price > 0 && $unitCost > 0)
                ? round((($price - $unitCost) / $price) * 100, 2)
                : null;
            $revenue  = $price * (float) $row->total_units;
            $profit   = $revenue - (float) $row->total_cost;

            return [
                'recipe_id'     => $row->recipe_id,
                'recipe_name'   => $row->recipe?->name,
                'product_name'  => $row->product?->name,
                'total_orders'  => (int) $row->total_orders,
                'total_units'   => round((float) $row->total_units, 0),
                'total_cost'    => round((float) $row->total_cost, 2),
                'avg_unit_cost' => round($unitCost, 4),
                'product_price' => $price,
                'revenue'       => round($revenue, 2),
                'profit'        => round($profit, 2),
                'margin_percent'=> $margin,
                'total_waste'   => round((float) $row->total_waste, 3),
                'cost_variance' => round((float) $row->total_cost - (float) $row->total_planned, 2),
            ];
        })
        ->sortByDesc('profit')
        ->values()
        ->toArray();
    }

    /* ─────────────────────────────────────────────────────────────
     | 4. TOP MATÉRIAS-PRIMAS — mais consumidas (volume e custo)
     ──────────────────────────────────────────────────────────── */
    public function getTopMaterials(string $period = '30d', int $limit = 10): array
    {
        [$from, $to] = $this->parsePeriod($period);

        return RawMaterialMovement::where('type', 'consumed')
            ->whereBetween('created_at', [$from, $to])
            ->with('rawMaterial:id,name,unit')
            ->selectRaw('
                raw_material_id,
                SUM(quantity)    as total_qty,
                SUM(total_cost)  as total_cost,
                COUNT(*)         as movements,
                AVG(unit_cost)   as avg_unit_cost
            ')
            ->groupBy('raw_material_id')
            ->orderByDesc('total_cost')
            ->limit($limit)
            ->get()
            ->map(fn($r) => [
                'raw_material_id' => $r->raw_material_id,
                'name'            => $r->rawMaterial?->name,
                'unit'            => $r->rawMaterial?->unit,
                'total_qty'       => round((float) $r->total_qty, 3),
                'total_cost'      => round((float) $r->total_cost, 2),
                'avg_unit_cost'   => round((float) $r->avg_unit_cost, 4),
                'movements'       => (int) $r->movements,
            ])
            ->toArray();
    }

    /* ─────────────────────────────────────────────────────────────
     | 5. ANÁLISE DE DESPERDÍCIO
     ──────────────────────────────────────────────────────────── */
    public function getWasteAnalysis(string $period = '30d'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        // Perdas de produção (waste_quantity nas ordens)
        $productionWaste = ProductionOrder::where('status', 'completed')
            ->whereBetween('completed_at', [$from, $to])
            ->whereNotNull('waste_quantity')
            ->where('waste_quantity', '>', 0)
            ->with('recipe:id,name', 'product:id,name')
            ->selectRaw('recipe_id, product_id, SUM(waste_quantity) as total_waste, COUNT(*) as occurrences')
            ->groupBy('recipe_id', 'product_id')
            ->orderByDesc('total_waste')
            ->get()
            ->map(fn($r) => [
                'recipe_name'  => $r->recipe?->name,
                'product_name' => $r->product?->name,
                'total_waste'  => round((float) $r->total_waste, 3),
                'occurrences'  => (int) $r->occurrences,
            ]);

        // Descarte de MP (tipo waste no raw_material_movements)
        $materialWaste = RawMaterialMovement::where('type', 'waste')
            ->whereBetween('created_at', [$from, $to])
            ->with('rawMaterial:id,name,unit')
            ->selectRaw('raw_material_id, SUM(quantity) as total_qty, SUM(total_cost) as total_cost, COUNT(*) as occurrences')
            ->groupBy('raw_material_id')
            ->orderByDesc('total_cost')
            ->get()
            ->map(fn($r) => [
                'name'        => $r->rawMaterial?->name,
                'unit'        => $r->rawMaterial?->unit,
                'total_qty'   => round((float) $r->total_qty, 3),
                'total_cost'  => round((float) $r->total_cost, 2),
                'occurrences' => (int) $r->occurrences,
            ]);

        $totalWasteCost = $materialWaste->sum('total_cost');

        return [
            'production_waste' => $productionWaste->values(),
            'material_waste'   => $materialWaste->values(),
            'total_waste_cost' => round($totalWasteCost, 2),
        ];
    }

    /* ─────────────────────────────────────────────────────────────
     | 6. EFICIÊNCIA DE PRODUÇÃO — planejado vs real por ordem
     ──────────────────────────────────────────────────────────── */
    public function getEfficiency(string $period = '30d'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        $orders = ProductionOrder::where('status', 'completed')
            ->whereBetween('completed_at', [$from, $to])
            ->with('recipe:id,name', 'product:id,name')
            ->orderBy('completed_at', 'desc')
            ->get(['id', 'code', 'recipe_id', 'product_id', 'planned_yield', 'actual_yield',
                   'planned_cost', 'actual_cost', 'planned_batches', 'started_at',
                   'completed_at', 'waste_quantity']);

        return $orders->map(function ($o) {
            $yieldEff = $o->planned_yield > 0
                ? round(($o->actual_yield / $o->planned_yield) * 100, 1)
                : null;
            $costEff  = $o->planned_cost > 0
                ? round((1 - (($o->actual_cost - $o->planned_cost) / $o->planned_cost)) * 100, 1)
                : null;

            return [
                'code'           => $o->code,
                'recipe'         => $o->recipe?->name,
                'product'        => $o->product?->name,
                'planned_yield'  => $o->planned_yield,
                'actual_yield'   => $o->actual_yield,
                'yield_eff'      => $yieldEff,
                'planned_cost'   => $o->planned_cost,
                'actual_cost'    => $o->actual_cost,
                'cost_eff'       => $costEff,
                'cost_variance'  => round($o->actual_cost - $o->planned_cost, 2),
                'waste'          => $o->waste_quantity,
                'completed_at'   => $o->completed_at?->toDateString(),
            ];
        })->toArray();
    }

    /* ─────────────────────────────────────────────────────────────
     | Helper — parsear período
     ──────────────────────────────────────────────────────────── */
    private function parsePeriod(string $period): array
    {
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
