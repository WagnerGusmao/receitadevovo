<?php

use App\Modules\SmartInventory\Controllers\SmartInputController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/dashboard',                        [SmartInputController::class, 'dashboard']);
    Route::get('/sessions',                         [SmartInputController::class, 'index']);
    Route::get('/sessions/{id}',                    [SmartInputController::class, 'show']);
    Route::post('/sessions/upload',                 [SmartInputController::class, 'upload']);
    Route::post('/sessions/manual',                 [SmartInputController::class, 'manual']);
    Route::patch('/sessions/{sessionId}',           [SmartInputController::class, 'updateSession']);
    Route::post('/sessions/{sessionId}/confirm',    [SmartInputController::class, 'confirm']);
    Route::post('/sessions/{sessionId}/reprocess',  [SmartInputController::class, 'reprocess']);
    Route::delete('/sessions/{sessionId}',          [SmartInputController::class, 'cancel']);
    Route::patch('/sessions/{sessionId}/items/{itemId}', [SmartInputController::class, 'updateItem']);
});
