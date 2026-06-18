<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Kit;
use App\Modules\Ecommerce\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class KitController extends Controller
{
    /**
     * List all kits.
     */
    public function index()
    {
        $kits = Kit::with('products')->get();
        return $this->success($kits);
    }

    /**
     * Store a new kit.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric',
            'slug' => 'sometimes|string|unique:kits,slug',
            'is_on_demand' => 'nullable|boolean',
            'lead_time_days' => 'nullable|integer|min:0',
            'products' => 'required|array',
            'products.*.id' => 'required|exists:products,id',
            'products.*.quantity' => 'required|integer|min:1',
        ]);

        return DB::transaction(function () use ($request) {
            $kit = Kit::create($request->only(['name', 'description', 'price', 'slug', 'featured_image', 'is_on_demand', 'lead_time_days']));

            foreach ($request->products as $product) {
                $kit->products()->attach($product['id'], ['quantity' => $product['quantity']]);
            }

            return $this->success($kit->load('products'), 'Kit criado com sucesso', 201);
        });
    }

    /**
     * Show a specific kit.
     */
    public function show($id)
    {
        $kit = Kit::with('products')->findOrFail($id);
        return $this->success($kit);
    }

    /**
     * Update a kit.
     */
    public function update(Request $request, $id)
    {
        $kit = Kit::findOrFail($id);

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'price' => 'sometimes|numeric',
            'is_on_demand' => 'nullable|boolean',
            'lead_time_days' => 'nullable|integer|min:0',
            'products' => 'sometimes|array',
            'products.*.id' => 'required|exists:products,id',
            'products.*.quantity' => 'required|integer|min:1',
        ]);

        return DB::transaction(function () use ($request, $kit) {
            $kit->update($request->only(['name', 'description', 'price', 'slug', 'featured_image', 'is_on_demand', 'lead_time_days']));

            if ($request->has('products')) {
                $syncData = [];
                foreach ($request->products as $product) {
                    $syncData[$product['id']] = ['quantity' => $product['quantity']];
                }
                $kit->products()->sync($syncData);
            }

            return $this->success($kit->load('products'), 'Kit atualizado com sucesso');
        });
    }

    /**
     * Remove a kit.
     */
    public function destroy($id)
    {
        $kit = Kit::findOrFail($id);
        $kit->delete();

        return $this->success([], 'Kit removido com sucesso');
    }
}
