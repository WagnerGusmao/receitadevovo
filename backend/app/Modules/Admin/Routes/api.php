<?php

use App\Modules\Admin\Controllers\AdminController;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/stats', [AdminController::class, 'stats']);
});
