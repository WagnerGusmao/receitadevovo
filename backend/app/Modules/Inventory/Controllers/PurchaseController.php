<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\PurchaseOrder;
use App\Modules\Inventory\Services\PurchaseService;
use Illuminate\Http\Request;

class PurchaseController extends Controller
{
    public function __construct(private readonly PurchaseService $purchaseService) {}

    /**
     * Lista ordens de compra com filtros de status.
     */
    public function index(Request $request)
    {
        $query = PurchaseOrder::with(['supplier', 'user'])
            ->withCount('items')
            ->latest();

        if ($request->status) {
            $query->where('status', $request->status);
        }

        if ($request->supplier_id) {
            $query->where('supplier_id', $request->supplier_id);
        }

        return $this->success($query->paginate(20));
    }

    /**
     * Dashboard de compras.
     */
    public function dashboard()
    {
        return $this->success($this->purchaseService->getDashboard());
    }

    /**
     * Detalhe completo de uma ordem.
     */
    public function show($id)
    {
        $order = PurchaseOrder::with(['supplier', 'user', 'items.rawMaterial'])
            ->findOrFail($id);

        return $this->success($order);
    }

    /**
     * Criar nova ordem de compra.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'supplier_id'              => 'required|exists:suppliers,id',
            'expected_at'              => 'nullable|date|after_or_equal:today',
            'notes'                    => 'nullable|string',
            'items'                    => 'required|array|min:1',
            'items.*.raw_material_id'  => 'required|exists:raw_materials,id',
            'items.*.quantity_ordered' => 'required|numeric|min:0.001',
            'items.*.unit_price'       => 'required|numeric|min:0',
            'items.*.notes'            => 'nullable|string',
        ]);

        try {
            $order = $this->purchaseService->createOrder(
                supplierId: $validated['supplier_id'],
                items:      $validated['items'],
                expectedAt: $validated['expected_at'] ?? null,
                notes:      $validated['notes'] ?? null,
                userId:     $request->user()->id,
            );

            return $this->success($order, 'Ordem de compra criada', 201);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Gerar ordens automaticamente a partir de alertas de estoque mínimo.
     */
    public function generateFromAlerts(Request $request)
    {
        try {
            $orders = $this->purchaseService->generateFromAlerts($request->user()->id);

            if (empty($orders)) {
                return $this->success([], 'Nenhuma matéria-prima abaixo do estoque mínimo com fornecedor cadastrado.');
            }

            return $this->success($orders, count($orders) . ' ordem(ns) gerada(s) automaticamente.');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Marcar ordem como enviada ao fornecedor.
     */
    public function send($id)
    {
        $order = PurchaseOrder::findOrFail($id);

        try {
            $order = $this->purchaseService->sendOrder($order);
            return $this->success($order, 'Ordem marcada como enviada ao fornecedor');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Registrar recebimento de itens (total ou parcial).
     */
    public function receive(Request $request, $id)
    {
        $order = PurchaseOrder::with('items.rawMaterial')->findOrFail($id);

        $validated = $request->validate([
            'items'                           => 'required|array|min:1',
            'items.*.item_id'                 => 'required|integer',
            'items.*.quantity_received'       => 'required|numeric|min:0',
            'items.*.actual_unit_price'       => 'nullable|numeric|min:0',
        ]);

        try {
            $order = $this->purchaseService->receiveItems($order, $validated['items']);
            return $this->success($order, 'Recebimento registrado. Estoque atualizado!');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        } catch (\Exception $e) {
            return $this->error('Erro interno ao registrar recebimento: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Cancelar ordem de compra.
     */
    public function cancel(Request $request, $id)
    {
        $order = PurchaseOrder::findOrFail($id);

        $validated = $request->validate([
            'reason' => 'nullable|string',
        ]);

        try {
            $order = $this->purchaseService->cancelOrder($order, $validated['reason'] ?? null);
            return $this->success($order, 'Ordem cancelada');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
}
