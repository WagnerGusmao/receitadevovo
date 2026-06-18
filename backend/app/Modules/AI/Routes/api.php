<?php

use App\Modules\AI\Controllers\AIController;
use Illuminate\Support\Facades\Route;

Route::post('/chat', [AIController::class, 'chat']);
