<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\ProductionOrder;
use App\Modules\Inventory\Models\Recipe;
use App\Modules\Inventory\Services\ProductionService;
use Illuminate\Http\Request;

class ProductionController extends Controller
{
    public function __construct(private readonly ProductionService $productionService) {}

    /**
     * Lista todas as ordens de produção.
     */
    public function index(Request $request)
    {
        $query = ProductionOrder::with(['recipe', 'product.variants', 'user', 'items'])
            ->latest();

        if ($request->status) {
            $query->where('status', $request->status);
        }

        return $this->success($query->paginate(20));
    }

    /**
     * Dashboard de produção com métricas operacionais.
     */
    public function dashboard()
    {
        return $this->success($this->productionService->getDashboard());
    }

    /**
     * Detalhe completo de uma ordem.
     */
    public function show($id)
    {
        $order = ProductionOrder::with(['recipe.ingredients.rawMaterial', 'product.variants', 'user', 'items.rawMaterial', 'items.batch'])
            ->findOrFail($id);

        return $this->success($order);
    }

    /**
     * Cria uma nova ordem de produção (rascunho).
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'recipe_id' => 'required|exists:recipes,id',
            'batches'   => 'required|integer|min:1|max:1000',
            'notes'     => 'nullable|string',
        ]);

        $recipe = Recipe::with('ingredients.rawMaterial', 'product')->findOrFail($validated['recipe_id']);

        if (!$recipe->product_id) {
            return $this->error('Esta receita não está vinculada a um produto.', 422);
        }

        try {
            $order = $this->productionService->createOrder(
                recipe:  $recipe,
                batches: $validated['batches'],
                userId:  $request->user()->id,
                notes:   $validated['notes'] ?? null,
            );

            return $this->success($order, 'Ordem de produção criada', 201);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Inicia a produção — valida estoque.
     */
    public function start($id)
    {
        $order = ProductionOrder::with('items.rawMaterial')->findOrFail($id);

        try {
            $order = $this->productionService->startOrder($order);
            return $this->success($order, 'Produção iniciada');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Finaliza a produção — baixa MP, cria produto, rastreabilidade.
     */
    public function complete(Request $request, $id)
    {
        $order = ProductionOrder::with('items.rawMaterial', 'product')->findOrFail($id);

        $validated = $request->validate([
            'actual_yield'      => 'required_without:outputs|numeric|min:0.001',
            'waste_quantity'    => 'nullable|numeric|min:0',
            'waste_notes'       => 'nullable|string',
            'notes'             => 'nullable|string',
            'actual_items'      => 'nullable|array',
            'actual_items.*.item_id'         => 'required|integer',
            'actual_items.*.actual_quantity' => 'required|numeric|min:0',
            'outputs'                        => 'nullable|array',
            'outputs.*.itemable_type'        => 'required|string',
            'outputs.*.itemable_id'          => 'nullable',
            'outputs.*.quantity'             => 'required|numeric|min:0.001',
            'outputs.*.name'                 => 'nullable|string',
            'outputs.*.price'                => 'nullable|numeric|min:0',
            'outputs.*.volume'               => 'nullable|numeric|min:0',
            'outputs.*.volume_unit'          => 'nullable|string',
        ]);

        try {
            $order = $this->productionService->completeOrder(
                order:         $order,
                actualYield:   $validated['actual_yield'] ?? 0,
                actualItems:   $validated['actual_items'] ?? [],
                wasteQuantity: $validated['waste_quantity'] ?? null,
                wasteNotes:    $validated['waste_notes'] ?? null,
                notes:         $validated['notes'] ?? null,
                outputs:       $validated['outputs'] ?? [],
            );

            return $this->success($order, 'Produção finalizada com sucesso!');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        } catch (\Exception $e) {
            return $this->error('Erro interno ao finalizar produção: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Cancela a ordem.
     */
    public function cancel(Request $request, $id)
    {
        $order = ProductionOrder::with('items')->findOrFail($id);

        $validated = $request->validate([
            'reason' => 'nullable|string',
        ]);

        try {
            $order = $this->productionService->cancelOrder($order, $validated['reason'] ?? null);
            return $this->success($order, 'Ordem cancelada');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
}
