<?php

namespace App\Modules\Admin\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Wellness\Models\Herb;
use App\Modules\Content\Models\Post;
use App\Modules\Auth\Models\User;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function stats()
    {
        return $this->success([
            'total_sales' => Order::where('status', 'paid')->sum('total'),
            'pending_orders' => Order::where('status', 'pending')->count(),
            'total_products' => Product::count(),
            'total_herbs' => Herb::count(),
            'total_posts' => Post::count(),
            'total_users' => User::count(),
            'recent_orders' => Order::with('user')->latest()->take(5)->get(),
        ]);
    }
}
