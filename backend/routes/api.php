<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Core\Controllers\UploadController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->post('/upload', [UploadController::class, 'upload']);
