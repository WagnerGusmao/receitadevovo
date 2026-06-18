<?php

use App\Modules\Wellness\Controllers\WellnessController;
use Illuminate\Support\Facades\Route;

Route::get('/herbs', [WellnessController::class, 'index']);
Route::get('/benefits', [WellnessController::class, 'benefits']);
Route::get('/emotions', [WellnessController::class, 'emotions']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/herbs', [WellnessController::class, 'store']);
    Route::put('/herbs/{id}', [WellnessController::class, 'update']);
    Route::delete('/herbs/{id}', [WellnessController::class, 'destroy']);
});
