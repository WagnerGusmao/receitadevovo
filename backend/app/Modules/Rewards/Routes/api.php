<?php

use App\Modules\Rewards\Controllers\UserLoyaltyController;
use App\Modules\Rewards\Controllers\AdminLoyaltyController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    // User Loyalty Endpoints (Prefix: /api/rewards)
    Route::get('/profile', [UserLoyaltyController::class, 'profile']);
    Route::get('/history', [UserLoyaltyController::class, 'history']);
    Route::get('/catalog', [UserLoyaltyController::class, 'catalog']);
    Route::post('/redeem/{rewardId}', [UserLoyaltyController::class, 'redeem']);
    Route::get('/offers', [UserLoyaltyController::class, 'offers']);

    // Admin Loyalty Endpoints (Prefix: /api/rewards/admin)
    Route::middleware('admin')->prefix('admin')->group(function () {
        // Levels CRUD
        Route::get('/levels', [AdminLoyaltyController::class, 'listLevels']);
        Route::post('/levels', [AdminLoyaltyController::class, 'storeLevel']);
        Route::put('/levels/{id}', [AdminLoyaltyController::class, 'updateLevel']);
        Route::delete('/levels/{id}', [AdminLoyaltyController::class, 'destroyLevel']);

        // Catalog CRUD
        Route::get('/catalog', [AdminLoyaltyController::class, 'listRewards']);
        Route::post('/catalog', [AdminLoyaltyController::class, 'storeReward']);
        Route::put('/catalog/{id}', [AdminLoyaltyController::class, 'updateReward']);
        Route::delete('/catalog/{id}', [AdminLoyaltyController::class, 'destroyReward']);

        // Offers CRUD
        Route::get('/offers', [AdminLoyaltyController::class, 'listOffers']);
        Route::post('/offers', [AdminLoyaltyController::class, 'storeOffer']);
        Route::put('/offers/{id}', [AdminLoyaltyController::class, 'updateOffer']);
        Route::delete('/offers/{id}', [AdminLoyaltyController::class, 'destroyOffer']);
    });
});
