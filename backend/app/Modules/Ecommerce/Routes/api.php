<?php

use App\Modules\Ecommerce\Controllers\ProductController;
use App\Modules\Ecommerce\Controllers\CategoryController;
use App\Modules\Ecommerce\Controllers\OrderController;
use App\Modules\Ecommerce\Controllers\AddressController;
use App\Modules\Ecommerce\Controllers\KitController;
use App\Modules\Ecommerce\Controllers\InventoryController;
use App\Modules\Ecommerce\Controllers\DashboardController;
use App\Modules\Ecommerce\Controllers\ProductReviewController;
use Illuminate\Support\Facades\Route;

Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{slug}', [ProductController::class, 'show']);
Route::get('/products/{id}/reviews', [ProductReviewController::class, 'index']);
Route::get('/reviews/home', [ProductReviewController::class, 'homeReviews']);
Route::get('/categories', [CategoryController::class, 'index']);

// Webhook Mercado Pago
Route::post('/payments/webhook', [\App\Modules\Ecommerce\Controllers\PaymentController::class, 'webhook']);

Route::middleware('auth:sanctum')->group(function () {
    // Shipping Calculation
    Route::post('/shipping/calculate', [\App\Modules\Ecommerce\Controllers\ShippingController::class, 'calculateRates']);

    // Reviews
    Route::post('/products/{id}/reviews', [ProductReviewController::class, 'store']);
    // Orders (Clients view/create their orders, admin can manage)
    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders', [OrderController::class, 'store'])->middleware('throttle:checkout');

    // Kits listing (For shop/clients)
    Route::get('/kits', [KitController::class, 'index']);
    Route::get('/kits/{id}', [KitController::class, 'show']);

    // Addresses (User specific)
    Route::get('/addresses', [AddressController::class, 'index']);
    Route::post('/addresses', [AddressController::class, 'store']);
    Route::get('/addresses/{id}', [AddressController::class, 'show']);
    Route::put('/addresses/{id}', [AddressController::class, 'update']);
    Route::delete('/addresses/{id}', [AddressController::class, 'destroy']);
    Route::patch('/addresses/{id}/default', [AddressController::class, 'setDefault']);
    Route::get('/addresses/zipcode/{cep}', [AddressController::class, 'lookupZipcode']);

    // Admin-Only Routes
    Route::middleware('admin')->group(function () {
        // Product Management
        Route::post('/products', [ProductController::class, 'store']);
        Route::put('/products/{id}', [ProductController::class, 'update']);
        Route::delete('/products/{id}', [ProductController::class, 'destroy']);

        // Category Management
        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{id}', [CategoryController::class, 'update']);
        Route::delete('/categories/{id}', [CategoryController::class, 'destroy']);

        // Kit Management
        Route::post('/kits', [KitController::class, 'store']);
        Route::put('/kits/{id}', [KitController::class, 'update']);
        Route::delete('/kits/{id}', [KitController::class, 'destroy']);

        // Order Status & Counter Orders
        Route::get('/orders/pending-fulfillment', [OrderController::class, 'pendingForFulfillment']);
        Route::patch('/orders/{id}/status', [OrderController::class, 'updateStatus']);
        Route::patch('/orders/{id}/ship', [OrderController::class, 'markAsShipped']);
        Route::post('/counter-orders', [OrderController::class, 'storeCounter'])->middleware('throttle:checkout');
        Route::put('/orders/{id}', [OrderController::class, 'updateOrder']);
        Route::get('/installments', [OrderController::class, 'listInstallments']);
        Route::patch('/orders/{orderId}/installments/{installmentId}/pay', [OrderController::class, 'payInstallment']);

        // Dashboard Metrics
        Route::get('/dashboard/metrics', [DashboardController::class, 'metrics']);

        // Inventory Management
        Route::get('/inventory/movements', [InventoryController::class, 'movements']);
        Route::get('/inventory/low-stock', [InventoryController::class, 'lowStock']);
        Route::post('/inventory/adjust', [InventoryController::class, 'adjust']);
    });
});
