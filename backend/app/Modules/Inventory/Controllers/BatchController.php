<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\Batch;
use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Services\InventoryService;
use Illuminate\Http\Request;

class BatchController extends Controller
{
    public function __construct(private readonly InventoryService $inventoryService) {}

    public function index(Request $request)
    {
        $query = Batch::with(['rawMaterial', 'supplier'])
            ->orderBy('created_at', 'desc');

        if ($request->raw_material_id) {
            $query->where('raw_material_id', $request->raw_material_id);
        }

        if ($request->status) {
            $query->where('status', $request->status);
        }

        return $this->success($query->paginate(50));
    }

    /**
     * Recebimento de novo lote — cria lote e registra entrada com CMP
     */
    public function receive(Request $request)
    {
        $validated = $request->validate([
            'raw_material_id'  => 'required|exists:raw_materials,id',
            'supplier_id'      => 'nullable|exists:suppliers,id',
            'batch_number'     => 'required|string|max:100',
            'quantity'         => 'required|numeric|min:0.001',
            'unit_cost'        => 'required|numeric|min:0',
            'manufactured_at'  => 'nullable|date',
            'expires_at'       => 'nullable|date|after:today',
            'notes'            => 'nullable|string',
        ], [
            'raw_material_id.required' => 'Selecione a matéria-prima',
            'batch_number.required'    => 'Número do lote é obrigatório',
            'quantity.required'        => 'Quantidade é obrigatória',
            'unit_cost.required'       => 'Custo unitário é obrigatório',
            'expires_at.after'         => 'Data de validade deve ser futura',
        ]);

        $material = RawMaterial::findOrFail($validated['raw_material_id']);

        try {
            $result = $this->inventoryService->receiveBatch(
                material:  $material,
                batchData: $validated,
                userId:    $request->user()->id,
            );

            return $this->success([
                'batch'    => $result['batch']->load('rawMaterial', 'supplier'),
                'movement' => $result['movement'],
                'material' => $material->fresh(),
            ], 'Lote recebido e estoque atualizado com sucesso', 201);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    public function show($id)
    {
        $batch = Batch::with(['rawMaterial', 'supplier', 'movements.user'])
            ->findOrFail($id);

        return $this->success($batch);
    }

    public function update(Request $request, $id)
    {
        $batch = Batch::findOrFail($id);

        $validated = $request->validate([
            'supplier_id'     => 'nullable|exists:suppliers,id',
            'batch_number'    => 'sometimes|required|string|max:100',
            'quantity'        => 'sometimes|required|numeric|min:0.001',
            'unit_cost'       => 'sometimes|required|numeric|min:0',
            'manufactured_at' => 'nullable|date',
            'expires_at'      => 'nullable|date',
            'notes'           => 'nullable|string',
            'status'          => 'sometimes|required|in:active,depleted,expired,quarantine',
        ], [
            'batch_number.required' => 'Número do lote é obrigatório',
            'quantity.required'     => 'Quantidade é obrigatória',
            'quantity.min'          => 'A quantidade deve ser de pelo menos 0.001',
            'unit_cost.required'    => 'Custo unitário é obrigatório',
        ]);

        try {
            $updatedBatch = $this->inventoryService->updateBatch(
                batch:  $batch,
                data:   $validated,
                userId: $request->user()?->id
            );

            return $this->success($updatedBatch->load('rawMaterial', 'supplier'), 'Lote atualizado com sucesso');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
}
