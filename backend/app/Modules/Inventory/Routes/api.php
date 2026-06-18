<?php

use App\Modules\Inventory\Controllers\SupplierController;
use App\Modules\Inventory\Controllers\RawMaterialController;
use App\Modules\Inventory\Controllers\BatchController;
use App\Modules\Inventory\Controllers\RecipeController;
use App\Modules\Inventory\Controllers\ProductionController;
use App\Modules\Inventory\Controllers\AnalyticsController;
use App\Modules\Inventory\Controllers\PurchaseController;
use App\Modules\Inventory\Controllers\FinancialController;
use App\Modules\Inventory\Controllers\QualityController;
use App\Modules\Inventory\Controllers\ComodatoController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {

    // Fornecedores
    Route::get('/suppliers', [SupplierController::class, 'index']);
    Route::post('/suppliers', [SupplierController::class, 'store']);
    Route::get('/suppliers/{id}', [SupplierController::class, 'show']);
    Route::put('/suppliers/{id}', [SupplierController::class, 'update']);
    Route::delete('/suppliers/{id}', [SupplierController::class, 'destroy']);

    // Matérias-Primas
    Route::get('/raw-materials', [RawMaterialController::class, 'index']);
    Route::post('/raw-materials', [RawMaterialController::class, 'store']);
    Route::get('/raw-materials/alerts', [RawMaterialController::class, 'alerts']);
    Route::get('/raw-materials/{id}', [RawMaterialController::class, 'show']);
    Route::put('/raw-materials/{id}', [RawMaterialController::class, 'update']);
    Route::delete('/raw-materials/{id}', [RawMaterialController::class, 'destroy']);
    Route::post('/raw-materials/{id}/entry', [RawMaterialController::class, 'adjustEntry']);
    Route::post('/raw-materials/{id}/exit', [RawMaterialController::class, 'adjustExit']);

    // Lotes
    Route::get('/batches', [BatchController::class, 'index']);
    Route::post('/batches/receive', [BatchController::class, 'receive']);
    Route::get('/batches/{id}', [BatchController::class, 'show']);
    Route::match(['PUT', 'PATCH'], '/batches/{id}', [BatchController::class, 'update']);

    // Receitas / Fórmulas
    Route::get('/recipes', [RecipeController::class, 'index']);
    Route::post('/recipes', [RecipeController::class, 'store']);
    Route::get('/recipes/producible', [RecipeController::class, 'producible']);
    Route::get('/recipes/{id}', [RecipeController::class, 'show']);
    Route::put('/recipes/{id}', [RecipeController::class, 'update']);
    Route::delete('/recipes/{id}', [RecipeController::class, 'destroy']);
    Route::get('/recipes/{id}/simulate', [RecipeController::class, 'simulate']);

    // Ordens de Produção
    Route::get('/production/dashboard', [ProductionController::class, 'dashboard']);
    Route::get('/production', [ProductionController::class, 'index']);
    Route::post('/production', [ProductionController::class, 'store']);
    Route::get('/production/{id}', [ProductionController::class, 'show']);
    Route::post('/production/{id}/start', [ProductionController::class, 'start']);
    Route::post('/production/{id}/complete', [ProductionController::class, 'complete']);
    Route::post('/production/{id}/cancel', [ProductionController::class, 'cancel']);

    // Ordens de Compra
    Route::get('/purchases/dashboard',       [PurchaseController::class, 'dashboard']);
    Route::post('/purchases/generate-alerts', [PurchaseController::class, 'generateFromAlerts']);
    Route::get('/purchases',                 [PurchaseController::class, 'index']);
    Route::post('/purchases',                [PurchaseController::class, 'store']);
    Route::get('/purchases/{id}',            [PurchaseController::class, 'show']);
    Route::post('/purchases/{id}/send',      [PurchaseController::class, 'send']);
    Route::post('/purchases/{id}/receive',   [PurchaseController::class, 'receive']);
    Route::post('/purchases/{id}/cancel',    [PurchaseController::class, 'cancel']);

    // Controle de Qualidade
    Route::get('/quality/dashboard',        [QualityController::class, 'dashboard']);
    Route::get('/quality/non-conformities', [QualityController::class, 'nonConformities']);
    Route::get('/quality',                  [QualityController::class, 'index']);
    Route::post('/quality',                 [QualityController::class, 'store']);
    Route::get('/quality/{id}',             [QualityController::class, 'show']);
    Route::post('/quality/{id}/evaluate',   [QualityController::class, 'evaluate']);

    // Dashboard Financeiro (DRE)
    Route::prefix('financial')->group(function () {
        Route::get('/dre',             [FinancialController::class, 'dre']);
        Route::get('/monthly-series',  [FinancialController::class, 'monthlySeries']);
        Route::get('/product-margins', [FinancialController::class, 'productMargins']);
        Route::get('/top-products',    [FinancialController::class, 'topProducts']);
    });

    // Analytics Operacional
    Route::prefix('analytics')->group(function () {
        Route::get('/overview',             [AnalyticsController::class, 'overview']);
        Route::get('/cost-time-series',     [AnalyticsController::class, 'costTimeSeries']);
        Route::get('/recipe-profitability', [AnalyticsController::class, 'recipeProfitability']);
        Route::get('/top-materials',        [AnalyticsController::class, 'topMaterials']);
        Route::get('/waste',                [AnalyticsController::class, 'waste']);
        Route::get('/efficiency',           [AnalyticsController::class, 'efficiency']);
    });

    // Comodato / Consignação
    Route::prefix('comodato')->group(function () {
        Route::get('/partners', [ComodatoController::class, 'index']);
        Route::post('/partners', [ComodatoController::class, 'store']);
        Route::get('/partners/{id}', [ComodatoController::class, 'show']);
        Route::put('/partners/{id}', [ComodatoController::class, 'update']);
        Route::delete('/partners/{id}', [ComodatoController::class, 'destroy']);
        Route::post('/dispatch', [ComodatoController::class, 'dispatchStock']);
        Route::post('/sale', [ComodatoController::class, 'recordSale']);
        Route::post('/return', [ComodatoController::class, 'recordReturn']);
        Route::post('/loss', [ComodatoController::class, 'recordLoss']);
        Route::post('/audit', [ComodatoController::class, 'reconcileAudit']);
        Route::get('/movements', [ComodatoController::class, 'movements']);
    });
});
