<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Kit;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::with(['herbs', 'category', 'variants'])->orderBy('name', 'asc')->get();
        $kits = Kit::with(['products'])->orderBy('name', 'asc')->get();

        return $this->success([
            'products' => $products,
            'kits' => $kits,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric',
            'old_price' => 'nullable|numeric',
            'stock' => 'required|integer',
            'slug' => 'required|string|unique:products',
            'featured_image' => 'nullable|string',
            'images' => 'nullable|array',
            'category_id' => 'nullable|exists:categories,id',
            'is_on_demand' => 'nullable|boolean',
            'lead_time_days' => 'nullable|integer|min:0',
            'variants' => 'nullable|array',
            'variants.*.name' => 'required|string|max:255',
            'variants.*.price' => 'required|numeric',
            'variants.*.old_price' => 'nullable|numeric',
            'variants.*.stock' => 'required|integer',
            'variants.*.sku' => 'nullable|string',
            'variants.*.volume' => 'required|numeric',
            'variants.*.volume_unit' => 'nullable|string',
        ]);

        $product = Product::create($request->all());

        if ($request->has('herb_ids')) {
            $product->herbs()->sync($request->herb_ids);
        }

        if ($request->has('variants')) {
            foreach ($request->variants as $variantData) {
                $product->variants()->create($variantData);
            }
        }

        return $this->success($product->load(['herbs', 'category', 'variants']), 'Produto criado com sucesso', 201);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);
        
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'price' => 'sometimes|numeric',
            'old_price' => 'nullable|numeric',
            'stock' => 'sometimes|integer',
            'slug' => 'sometimes|string|unique:products,slug,' . $id,
            'featured_image' => 'nullable|string',
            'images' => 'nullable|array',
            'category_id' => 'nullable|exists:categories,id',
            'is_on_demand' => 'nullable|boolean',
            'lead_time_days' => 'nullable|integer|min:0',
            'variants' => 'nullable|array',
            'variants.*.id' => 'nullable|integer|exists:product_variants,id',
            'variants.*.name' => 'required|string|max:255',
            'variants.*.price' => 'required|numeric',
            'variants.*.old_price' => 'nullable|numeric',
            'variants.*.stock' => 'required|integer',
            'variants.*.sku' => 'nullable|string',
            'variants.*.volume' => 'required|numeric',
            'variants.*.volume_unit' => 'nullable|string',
        ]);

        $product->update($request->all());

        if ($request->has('herb_ids')) {
            $product->herbs()->sync($request->herb_ids);
        }

        if ($request->has('variants')) {
            $incomingVariantIds = [];
            foreach ($request->variants as $variantData) {
                if (isset($variantData['id'])) {
                    $variant = $product->variants()->findOrFail($variantData['id']);
                    $variant->update($variantData);
                    $incomingVariantIds[] = $variant->id;
                } else {
                    $newVariant = $product->variants()->create($variantData);
                    $incomingVariantIds[] = $newVariant->id;
                }
            }
            // Deletar variantes que não foram enviadas na requisição
            $product->variants()->whereNotIn('id', $incomingVariantIds)->delete();
        }

        return $this->success($product->load(['herbs', 'category', 'variants']), 'Produto atualizado com sucesso');
    }

    public function destroy($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return $this->success([], 'Produto excluído com sucesso');
    }

    public function show($slug)
    {
        $product = Product::with(['herbs', 'category', 'variants'])
            ->where('slug', $slug)
            ->firstOrFail();

        return $this->success($product);
    }
}
