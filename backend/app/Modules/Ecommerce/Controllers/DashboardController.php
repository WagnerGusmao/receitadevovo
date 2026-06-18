<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Auth\Models\User;
use App\Modules\Inventory\Models\RawMaterial;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Retorna métricas do painel de vendas.
     */
    public function metrics(Request $request)
    {
        $now = Carbon::now();
        $startOfMonth = $now->copy()->startOfMonth();
        $startOfLastMonth = $now->copy()->subMonth()->startOfMonth();
        $endOfLastMonth = $now->copy()->subMonth()->endOfMonth();

        // 1. Faturamento Total (Apenas pedidos pagos/enviados/entregues)
        $validStatuses = ['processing', 'shipped', 'delivered'];
        
        $currentMonthRevenue = Order::whereIn('status', $validStatuses)
            ->where('created_at', '>=', $startOfMonth)
            ->sum('total');
            
        $lastMonthRevenue = Order::whereIn('status', $validStatuses)
            ->whereBetween('created_at', [$startOfLastMonth, $endOfLastMonth])
            ->sum('total');

        // 2. Total de Pedidos do mês
        $currentMonthOrders = Order::where('created_at', '>=', $startOfMonth)->count();
        $lastMonthOrders = Order::whereBetween('created_at', [$startOfLastMonth, $endOfLastMonth])->count();

        // 3. Ticket Médio (Mês Atual)
        $ticketMedio = $currentMonthOrders > 0 ? $currentMonthRevenue / $currentMonthOrders : 0;

        // 4. Pedidos por Status
        $ordersByStatus = Order::select('status', DB::raw('count(*) as total'))
            ->groupBy('status')
            ->get();

        // 5. Produtos mais vendidos (Top 5)
        $topProducts = OrderItem::select('itemable_type', 'itemable_id', DB::raw('SUM(quantity) as total_sold'))
            ->with('itemable')
            ->join('orders', 'order_items.order_id', '=', 'orders.id')
            ->whereIn('orders.status', $validStatuses)
            ->groupBy('itemable_type', 'itemable_id')
            ->orderByDesc('total_sold')
            ->limit(5)
            ->get();

        // 6. Total de Clientes
        $currentMonthUsers = User::where('created_at', '>=', $startOfMonth)->count();
        $lastMonthUsers = User::whereBetween('created_at', [$startOfLastMonth, $endOfLastMonth])->count();
        
        // 7. Top Clientes (Maior valor gasto)
        $topCustomers = User::select('users.id', 'users.name', 'users.email', DB::raw('SUM(orders.total) as total_spent'))
            ->join('orders', 'users.id', '=', 'orders.user_id')
            ->whereIn('orders.status', $validStatuses)
            ->groupBy('users.id', 'users.name', 'users.email')
            ->orderByDesc('total_spent')
            ->limit(5)
            ->get();

        // 8. Valor do estoque de produtos finais (preço de venda × quantidade)
        $stockValueSale = Product::where('is_active', true)
            ->selectRaw('SUM(stock * price) as total')
            ->value('total') ?? 0;

        // 9. Valor do estoque de produtos finais a custo (unit_cost × quantidade)
        $stockValueCost = Product::where('is_active', true)
            ->whereNotNull('unit_cost')
            ->where('unit_cost', '>', 0)
            ->selectRaw('SUM(stock * unit_cost) as total')
            ->value('total') ?? 0;

        // 10. Lucro potencial (soma: stock × (price - unit_cost) onde unit_cost > 0)
        $profitPotential = Product::where('is_active', true)
            ->whereNotNull('unit_cost')
            ->where('unit_cost', '>', 0)
            ->selectRaw('SUM(stock * (price - unit_cost)) as total')
            ->value('total') ?? 0;

        // 11. Valor total em matéria-prima (stock_quantity × average_cost)
        $rawMaterialValue = RawMaterial::where('is_active', true)
            ->selectRaw('SUM(stock_quantity * average_cost) as total')
            ->value('total') ?? 0;

        // 12. Produtos com custo cadastrado vs total
        $productsWithCost  = Product::where('is_active', true)->where('unit_cost', '>', 0)->count();
        $productsTotal     = Product::where('is_active', true)->count();

        return $this->success([
            'revenue' => [
                'current' => $currentMonthRevenue,
                'previous' => $lastMonthRevenue,
                'growth' => $this->calculateGrowth($currentMonthRevenue, $lastMonthRevenue)
            ],
            'orders' => [
                'current' => $currentMonthOrders,
                'previous' => $lastMonthOrders,
                'growth' => $this->calculateGrowth($currentMonthOrders, $lastMonthOrders)
            ],
            'customers' => [
                'current' => $currentMonthUsers,
                'previous' => $lastMonthUsers,
                'growth' => $this->calculateGrowth($currentMonthUsers, $lastMonthUsers)
            ],
            'ticket_medio' => round($ticketMedio, 2),
            'orders_by_status' => $ordersByStatus,
            'top_products' => $topProducts,
            'top_customers' => $topCustomers,
            'inventory' => [
                'stock_value_sale'     => round((float) $stockValueSale, 2),
                'stock_value_cost'     => round((float) $stockValueCost, 2),
                'profit_potential'     => round((float) $profitPotential, 2),
                'raw_material_value'   => round((float) $rawMaterialValue, 2),
                'products_with_cost'   => $productsWithCost,
                'products_total'       => $productsTotal,
            ],
        ]);

    }

    private function calculateGrowth($current, $previous)
    {
        if ($previous == 0) {
            return $current > 0 ? 100 : 0;
        }
        return round((($current - $previous) / $previous) * 100, 2);
    }
}
