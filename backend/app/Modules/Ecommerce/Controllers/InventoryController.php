<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\InventoryMovement;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Kit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InventoryController extends Controller
{
    /**
     * Lista o histórico de movimentações.
     */
    public function movements(Request $request)
    {
        $movements = InventoryMovement::with(['itemable', 'user', 'order'])
            ->orderBy('created_at', 'desc')
            ->paginate(50);
            
        return $this->success($movements);
    }

    /**
     * Lista produtos e kits com estoque baixo.
     */
    public function lowStock(Request $request)
    {
        $threshold = $request->query('threshold', 10);
        
        $products = Product::doesntHave('variants')
            ->where('stock', '<=', $threshold)
            ->where('is_active', true)
            ->get();
            
        $variants = \App\Modules\Ecommerce\Models\ProductVariant::where('stock', '<=', $threshold)
            ->with('product')
            ->get();
            
        $kits = Kit::where('stock', '<=', $threshold)->where('is_active', true)->get();
        
        return $this->success([
            'products' => $products,
            'variants' => $variants,
            'kits' => $kits,
        ]);
    }

    /**
     * Realiza um ajuste manual de estoque.
     */
    public function adjust(Request $request)
    {
        $request->validate([
            'item_id' => 'required|integer',
            'item_type' => 'required|in:product,kit,variant',
            'type' => 'required|in:in,out',
            'quantity' => 'required|integer|min:1',
            'reason' => 'required|string',
            'notes' => 'nullable|string',
        ]);

        try {
            $result = DB::transaction(function () use ($request) {
                if ($request->item_type === 'product') {
                    $model = Product::findOrFail($request->item_id);
                    $itemType = Product::class;
                } elseif ($request->item_type === 'variant') {
                    $model = \App\Modules\Ecommerce\Models\ProductVariant::findOrFail($request->item_id);
                    $itemType = \App\Modules\Ecommerce\Models\ProductVariant::class;
                } else {
                    $model = Kit::findOrFail($request->item_id);
                    $itemType = Kit::class;
                }

                if ($request->type === 'out') {
                    if ($model->stock < $request->quantity) {
                        throw new \Exception("Estoque insuficiente para a saída. Estoque atual: {$model->stock}");
                    }
                    $model->decrement('stock', $request->quantity);
                } else {
                    $model->increment('stock', $request->quantity);
                }

                $movement = InventoryMovement::create([
                    'itemable_type' => $itemType,
                    'itemable_id' => $model->id,
                    'type' => $request->type,
                    'quantity' => $request->quantity,
                    'reason' => $request->reason,
                    'user_id' => $request->user()->id,
                    'notes' => $request->notes,
                ]);

                return ['model' => $model, 'movement' => $movement];
            });

            return $this->success($result, 'Estoque ajustado com sucesso');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
}
