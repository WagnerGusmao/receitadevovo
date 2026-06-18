<?php

use App\Modules\Content\Controllers\PostController;
use App\Modules\Content\Controllers\BannerController;
use Illuminate\Support\Facades\Route;

Route::get('/posts', [PostController::class, 'index']);
Route::get('/posts/home', [PostController::class, 'home']);
Route::get('/posts/{slug}', [PostController::class, 'show']);

Route::get('/banners/active', [BannerController::class, 'activeBanners']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/posts', [PostController::class, 'store']);
    Route::put('/posts/{id}', [PostController::class, 'update']);
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);

    Route::apiResource('/banners', BannerController::class);
});
