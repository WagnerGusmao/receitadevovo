<?php

use App\Modules\Auth\Controllers\AuthController;
use App\Modules\Auth\Controllers\AdminController;
use App\Modules\Auth\Controllers\UserController;

Route::middleware('throttle:auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
});

// Google OAuth Routes
Route::get('/auth/google/redirect', [AuthController::class, 'googleRedirect']);
Route::post('/auth/google/callback', [AuthController::class, 'googleCallback']);
Route::post('/auth/google/register', [AuthController::class, 'googleRegister']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    
    // Rotas administrativas protegidas por autenticação e privilégios de Admin
    Route::middleware('admin')->group(function () {
        Route::get('/admin/stats', [AdminController::class, 'stats']);
        
        // Gestão de Usuários
        Route::get('/admin/users', [UserController::class, 'index']);
        Route::get('/admin/users/{id}', [UserController::class, 'show']);
        Route::put('/admin/users/{id}', [UserController::class, 'update']);
        Route::post('/admin/users/{id}/reset-password', [UserController::class, 'resetPassword']);
        Route::delete('/admin/users/{id}', [UserController::class, 'destroy']);

        // Balcão — busca e cadastro rápido de clientes
        Route::get('/admin/counter/search-customer', [UserController::class, 'searchForCounter']);
        Route::post('/admin/counter/quick-register', [UserController::class, 'quickRegister']);
    });
});
