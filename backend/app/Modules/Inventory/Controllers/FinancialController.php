<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Services\FinancialService;
use Illuminate\Http\Request;

class FinancialController extends Controller
{
    public function __construct(private readonly FinancialService $financialService) {}

    /** DRE simplificada do período. ?period=7d|30d|90d|6m|1y|month|custom&from=YYYY-MM-DD&to=YYYY-MM-DD */
    public function dre(Request $request)
    {
        $period = $request->query('period', '30d');
        $from   = $request->query('from');
        $to     = $request->query('to');
        return $this->success($this->financialService->getDRE($period, $from, $to));
    }

    /** Série mensal de receita, CMV e lucro. ?months=6 */
    public function monthlySeries(Request $request)
    {
        $months = min((int) $request->query('months', 6), 24);
        return $this->success($this->financialService->getMonthlySeries($months));
    }

    /** Margem por produto. ?period=30d|custom&from=... */
    public function productMargins(Request $request)
    {
        $period = $request->query('period', '30d');
        $from   = $request->query('from');
        $to     = $request->query('to');
        return $this->success($this->financialService->getProductMargins($period, $from, $to));
    }

    /** Top produtos por receita. ?period=30d|custom&limit=10&from=... */
    public function topProducts(Request $request)
    {
        $period = $request->query('period', '30d');
        $limit  = min((int) $request->query('limit', 10), 20);
        $from   = $request->query('from');
        $to     = $request->query('to');
        return $this->success($this->financialService->getTopProducts($period, $limit, $from, $to));
    }
}
