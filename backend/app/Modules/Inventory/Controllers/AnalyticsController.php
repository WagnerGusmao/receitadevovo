<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Services\AnalyticsService;
use Illuminate\Http\Request;

class AnalyticsController extends Controller
{
    public function __construct(private readonly AnalyticsService $analyticsService) {}

    /**
     * KPIs gerais do período.
     * ?period=7d|30d|90d|6m|1y|month
     */
    public function overview(Request $request)
    {
        $period = $request->query('period', '30d');
        return $this->success($this->analyticsService->getOverview($period));
    }

    /**
     * Série temporal de custo de produção.
     * ?period=30d&group_by=day|month
     */
    public function costTimeSeries(Request $request)
    {
        $period  = $request->query('period', '30d');
        $groupBy = $request->query('group_by', 'day');
        return $this->success($this->analyticsService->getCostTimeSeries($period, $groupBy));
    }

    /**
     * Ranking de receitas por lucratividade.
     * ?period=90d
     */
    public function recipeProfitability(Request $request)
    {
        $period = $request->query('period', '90d');
        return $this->success($this->analyticsService->getRecipeProfitability($period));
    }

    /**
     * Top matérias-primas mais consumidas.
     * ?period=30d&limit=10
     */
    public function topMaterials(Request $request)
    {
        $period = $request->query('period', '30d');
        $limit  = min((int) $request->query('limit', 10), 20);
        return $this->success($this->analyticsService->getTopMaterials($period, $limit));
    }

    /**
     * Análise de desperdício.
     * ?period=30d
     */
    public function waste(Request $request)
    {
        $period = $request->query('period', '30d');
        return $this->success($this->analyticsService->getWasteAnalysis($period));
    }

    /**
     * Eficiência de produção (planejado vs real).
     * ?period=30d
     */
    public function efficiency(Request $request)
    {
        $period = $request->query('period', '30d');
        return $this->success($this->analyticsService->getEfficiency($period));
    }
}
