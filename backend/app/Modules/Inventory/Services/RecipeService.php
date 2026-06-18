<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\Recipe;
use App\Modules\Inventory\Models\RecipeIngredient;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Ecommerce\Models\Product;
use Illuminate\Support\Facades\DB;

class RecipeService
{
    /**
     * Cria ou atualiza uma receita com seus ingredientes atomicamente.
     */
    public function saveRecipe(array $data, ?Recipe $existing = null): Recipe
    {
        return DB::transaction(function () use ($data, $existing) {
            $recipeData = collect($data)->except('ingredients')->toArray();

            if ($existing) {
                $existing->update($recipeData);
                $recipe = $existing->fresh();
            } else {
                $recipe = Recipe::create($recipeData);
            }

            // Sincronizar ingredientes
            if (isset($data['ingredients'])) {
                $recipe->ingredients()->delete();

                foreach ($data['ingredients'] as $ing) {
                    RecipeIngredient::create([
                        'recipe_id'       => $recipe->id,
                        'raw_material_id' => $ing['raw_material_id'],
                        'quantity'        => $ing['quantity'],
                        'waste_percent'   => $ing['waste_percent'] ?? 0,
                        'notes'           => $ing['notes'] ?? null,
                    ]);
                }
            }

            $recipe = $recipe->load('ingredients.rawMaterial', 'product');

            // Propagar unit_cost calculado para o produto vinculado
            if ($recipe->product_id && $recipe->unit_cost > 0) {
                Product::where('id', $recipe->product_id)
                    ->update(['unit_cost' => $recipe->unit_cost]);
            }

            return $recipe;
        });
    }

    /**
     * Calcula custo e viabilidade para N lotes sem persistir nada.
     * Útil para simulações antes de produzir.
     */
    public function simulate(Recipe $recipe, int $batches = 1): array
    {
        $recipe->load('ingredients.rawMaterial', 'product');

        $ingredients = $recipe->ingredients->map(function ($ing) use ($batches) {
            $neededTotal = $ing->quantity_with_waste * $batches;
            $stock       = (float) $ing->rawMaterial->stock_quantity;
            $unitCost    = (float) $ing->rawMaterial->average_cost;

            return [
                'raw_material'   => $ing->rawMaterial->name,
                'unit'           => $ing->rawMaterial->unit,
                'per_batch'      => $ing->quantity_with_waste,
                'total_needed'   => round($neededTotal, 4),
                'available'      => $stock,
                'unit_cost'      => $unitCost,
                'total_cost'     => round($neededTotal * $unitCost, 4),
                'is_sufficient'  => $stock >= $neededTotal,
                'missing'        => $stock < $neededTotal
                    ? round($neededTotal - $stock, 4)
                    : 0,
            ];
        });

        $batchCost      = $ingredients->sum('total_cost');
        $totalUnits     = round($recipe->effective_yield * $batches, 0);
        $unitCost       = $totalUnits > 0 ? round($batchCost / $totalUnits, 4) : 0;
        $productPrice   = (float) ($recipe->product->price ?? 0);
        $marginPercent  = ($productPrice > 0 && $unitCost > 0)
            ? round((($productPrice - $unitCost) / $productPrice) * 100, 2)
            : null;
        $revenue        = $productPrice * $totalUnits;
        $profit         = $revenue - $batchCost;

        return [
            'batches'        => $batches,
            'ingredients'    => $ingredients,
            'can_produce'    => $ingredients->every(fn($i) => $i['is_sufficient']),
            'batch_cost'     => round($batchCost, 2),
            'effective_yield'=> $recipe->effective_yield,
            'total_units'    => $totalUnits,
            'unit_cost'      => $unitCost,
            'product_price'  => $productPrice,
            'revenue'        => round($revenue, 2),
            'profit'         => round($profit, 2),
            'margin_percent' => $marginPercent,
        ];
    }

    /**
     * Retorna quais receitas podem ser produzidas com o estoque atual.
     */
    public function getProducibleRecipes(): array
    {
        return Recipe::where('is_active', true)
            ->with('ingredients.rawMaterial', 'product')
            ->get()
            ->map(fn($r) => [
                'id'              => $r->id,
                'name'            => $r->name,
                'product'         => $r->product?->name,
                'feasibility'     => $r->feasibility,
                'unit_cost'       => $r->unit_cost,
                'margin_percent'  => $r->margin_percent,
            ])
            ->values()
            ->toArray();
    }
}
