<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Services\InventoryService;
use Illuminate\Http\Request;

class RawMaterialController extends Controller
{
    public function __construct(private readonly InventoryService $inventoryService) {}

    public function index()
    {
        $materials = RawMaterial::with('supplier')
            ->withCount('batches')
            ->orderBy('name')
            ->get();

        return $this->success($materials);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'              => 'required|string|max:255',
            'description'       => 'nullable|string',
            'unit'              => 'required|string|in:g,kg,ml,L,un,oz',
            'category'          => 'nullable|string|max:100',
            'min_stock_quantity' => 'nullable|numeric|min:0',
            'shelf_life_days'   => 'nullable|integer|min:1',
            'supplier_id'       => 'nullable|exists:suppliers,id',
            'image_path'        => 'nullable|string|max:255',
        ]);

        $material = RawMaterial::create($validated);

        return $this->success(
            $material->load('supplier'),
            'Matéria-prima cadastrada com sucesso',
            201
        );
    }

    public function show($id)
    {
        $material = RawMaterial::with([
                'supplier',
                'activeBatches',
                'movements' => fn($q) => $q->latest()->limit(50),
            ])
            ->findOrFail($id);

        return $this->success($material);
    }

    public function update(Request $request, $id)
    {
        $material = RawMaterial::findOrFail($id);

        $validated = $request->validate([
            'name'               => 'sometimes|string|max:255',
            'description'        => 'nullable|string',
            'unit'               => 'sometimes|string|in:g,kg,ml,L,un,oz',
            'category'           => 'nullable|string|max:100',
            'min_stock_quantity'  => 'nullable|numeric|min:0',
            'shelf_life_days'    => 'nullable|integer|min:1',
            'supplier_id'        => 'nullable|exists:suppliers,id',
            'image_path'         => 'nullable|string|max:255',
            'is_active'          => 'boolean',
        ]);

        $material->update($validated);

        return $this->success(
            $material->load('supplier'),
            'Matéria-prima atualizada com sucesso'
        );
    }

    public function destroy($id)
    {
        $material = RawMaterial::findOrFail($id);
        $material->delete();

        return $this->success([], 'Matéria-prima removida');
    }

    /**
     * Registra entrada (compra avulsa sem lote formal)
     */
    public function adjustEntry(Request $request, $id)
    {
        $material = RawMaterial::findOrFail($id);

        $validated = $request->validate([
            'quantity'  => 'required|numeric|min:0.001',
            'unit_cost' => 'required|numeric|min:0',
            'type'      => 'required|in:adjustment_in,return',
            'notes'     => 'nullable|string',
        ]);

        $movement = $this->inventoryService->registerEntry(
            material:  $material,
            quantity:  $validated['quantity'],
            unitCost:  $validated['unit_cost'],
            type:      $validated['type'],
            userId:    $request->user()->id,
            notes:     $validated['notes'] ?? null,
        );

        return $this->success($movement, 'Entrada registrada com sucesso');
    }

    /**
     * Registra saída (ajuste manual, perda/descarte)
     */
    public function adjustExit(Request $request, $id)
    {
        $material = RawMaterial::findOrFail($id);

        $validated = $request->validate([
            'quantity' => 'required|numeric|min:0.001',
            'type'     => 'required|in:adjustment_out,waste',
            'notes'    => 'nullable|string',
        ]);

        try {
            $movement = $this->inventoryService->registerExit(
                material: $material,
                quantity: $validated['quantity'],
                type:     $validated['type'],
                userId:   $request->user()->id,
                notes:    $validated['notes'] ?? null,
            );

            return $this->success($movement, 'Saída registrada com sucesso');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Alertas: estoque baixo e validade próxima
     */
    public function alerts()
    {
        $alerts = $this->inventoryService->getAlerts();
        $stockValue = $this->inventoryService->getTotalStockValue();

        return $this->success([
            ...$alerts,
            'total_stock_value' => $stockValue,
        ]);
    }
}
