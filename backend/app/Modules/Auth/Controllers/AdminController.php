<?php

namespace App\Modules\Auth\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Wellness\Models\Herb;
use App\Modules\Content\Models\Post;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function stats()
    {
        $totalSales = Order::where('status', '!=', 'cancelled')->sum('total');
        $totalOrders = Order::count();
        $totalProducts = Product::count();
        $totalHerbs = Herb::count();
        $totalPosts = Post::count();

        // Recent Activity
        $recentOrders = Order::with('user')->orderBy('created_at', 'desc')->limit(5)->get();

        return $this->success([
            'metrics' => [
                'total_sales' => $totalSales,
                'total_orders' => $totalOrders,
                'total_products' => $totalProducts,
                'total_herbs' => $totalHerbs,
                'total_posts' => $totalPosts,
            ],
            'recent_orders' => $recentOrders
        ]);
    }
}
