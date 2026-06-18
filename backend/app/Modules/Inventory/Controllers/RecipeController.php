<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\Recipe;
use App\Modules\Inventory\Services\RecipeService;
use Illuminate\Http\Request;

class RecipeController extends Controller
{
    public function __construct(private readonly RecipeService $recipeService) {}

    public function index()
    {
        $recipes = Recipe::with(['product', 'ingredients.rawMaterial'])
            ->where('is_active', true)
            ->orderBy('name')
            ->get();

        return $this->success($recipes);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'product_id'         => 'nullable|exists:products,id',
            'name'               => 'required|string|max:255',
            'description'        => 'nullable|string',
            'instructions'       => 'nullable|string',
            'yield_quantity'     => 'required|numeric|min:0.001',
            'yield_unit'         => 'required|string|in:un,g,kg,ml,L',
            'waste_percent'      => 'nullable|numeric|min:0|max:100',
            'prep_time_minutes'  => 'nullable|integer|min:1',
            'ingredients'        => 'required|array|min:1',
            'ingredients.*.raw_material_id' => 'required|exists:raw_materials,id',
            'ingredients.*.quantity'        => 'required|numeric|min:0.0001',
            'ingredients.*.waste_percent'   => 'nullable|numeric|min:0|max:100',
            'ingredients.*.notes'           => 'nullable|string',
        ], [
            'ingredients.required' => 'A receita deve ter pelo menos um ingrediente.',
            'ingredients.min'      => 'A receita deve ter pelo menos um ingrediente.',
        ]);

        $recipe = $this->recipeService->saveRecipe($validated);

        return $this->success($recipe, 'Receita criada com sucesso', 201);
    }

    public function show($id)
    {
        $recipe = Recipe::with(['product', 'ingredients.rawMaterial'])
            ->findOrFail($id);

        return $this->success($recipe);
    }

    public function update(Request $request, $id)
    {
        $recipe = Recipe::findOrFail($id);

        $validated = $request->validate([
            'product_id'         => 'nullable|exists:products,id',
            'name'               => 'sometimes|string|max:255',
            'description'        => 'nullable|string',
            'instructions'       => 'nullable|string',
            'yield_quantity'     => 'sometimes|numeric|min:0.001',
            'yield_unit'         => 'sometimes|string|in:un,g,kg,ml,L',
            'waste_percent'      => 'nullable|numeric|min:0|max:100',
            'prep_time_minutes'  => 'nullable|integer|min:1',
            'is_active'          => 'boolean',
            'ingredients'        => 'sometimes|array|min:1',
            'ingredients.*.raw_material_id' => 'required_with:ingredients|exists:raw_materials,id',
            'ingredients.*.quantity'        => 'required_with:ingredients|numeric|min:0.0001',
            'ingredients.*.waste_percent'   => 'nullable|numeric|min:0|max:100',
            'ingredients.*.notes'           => 'nullable|string',
        ]);

        $recipe = $this->recipeService->saveRecipe($validated, $recipe);

        return $this->success($recipe, 'Receita atualizada com sucesso');
    }

    public function destroy($id)
    {
        $recipe = Recipe::findOrFail($id);
        $recipe->delete();

        return $this->success([], 'Receita removida');
    }

    /**
     * Simulação de custo/viabilidade para N lotes.
     */
    public function simulate(Request $request, $id)
    {
        $recipe = Recipe::with(['ingredients.rawMaterial', 'product'])->findOrFail($id);

        $batches = (int) $request->query('batches', 1);
        $batches = max(1, min($batches, 1000));

        $result = $this->recipeService->simulate($recipe, $batches);

        return $this->success($result);
    }

    /**
     * Lista todas as receitas com viabilidade de produção atual.
     */
    public function producible()
    {
        $recipes = $this->recipeService->getProducibleRecipes();

        return $this->success($recipes);
    }
}
