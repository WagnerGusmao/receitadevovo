<?php

use App\Modules\Newsletter\Controllers\NewsletterController;
use Illuminate\Support\Facades\Route;

Route::post('/subscribe', [NewsletterController::class, 'subscribe']);

Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    Route::get('/subscribers', [NewsletterController::class, 'adminIndex']);
    Route::post('/subscribers/{id}/toggle', [NewsletterController::class, 'adminToggle']);
    Route::delete('/subscribers/{id}', [NewsletterController::class, 'adminDestroy']);
    Route::post('/send', [NewsletterController::class, 'send']);
});
