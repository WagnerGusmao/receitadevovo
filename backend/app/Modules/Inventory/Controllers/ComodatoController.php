<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\ComodatoPartner;
use App\Modules\Inventory\Models\ComodatoStock;
use App\Modules\Inventory\Models\ComodatoMovement;
use App\Modules\Inventory\Services\ComodatoService;
use Illuminate\Http\Request;

class ComodatoController extends Controller
{
    protected ComodatoService $comodatoService;

    public function __construct(ComodatoService $comodatoService)
    {
        $this->comodatoService = $comodatoService;
    }

    /**
     * Lista todos os parceiros de comodato.
     */
    public function index()
    {
        $partners = ComodatoPartner::withCount(['stocks' => function ($query) {
            $query->where('quantity', '>', 0);
        }])->orderBy('name')->get();

        return $this->success($partners);
    }

    /**
     * Cadastra um novo parceiro.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'contact_name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:30',
            'address' => 'nullable|string',
            'commission_percentage' => 'nullable|numeric|min:0|max:100',
            'is_active' => 'boolean',
        ]);

        $partner = ComodatoPartner::create($validated);

        return $this->success($partner, 'Parceiro cadastrado com sucesso!', 201);
    }

    /**
     * Exibe detalhes do parceiro, incluindo estoque atual e histórico.
     */
    public function show($id)
    {
        $partner = ComodatoPartner::with([
            'stocks.itemable',
            'movements.itemable',
            'audits.items.itemable'
        ])->findOrFail($id);

        return $this->success($partner);
    }

    /**
     * Atualiza dados de um parceiro.
     */
    public function update(Request $request, $id)
    {
        $partner = ComodatoPartner::findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'contact_name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:30',
            'address' => 'nullable|string',
            'commission_percentage' => 'nullable|numeric|min:0|max:100',
            'is_active' => 'boolean',
        ]);

        $partner->update($validated);

        return $this->success($partner, 'Dados do parceiro atualizados com sucesso!');
    }

    /**
     * Remove um parceiro.
     */
    public function destroy($id)
    {
        $partner = ComodatoPartner::findOrFail($id);
        $partner->delete();

        return $this->success([], 'Parceiro removido com sucesso!');
    }

    /**
     * Envia mercadoria para comodato.
     */
    public function dispatchStock(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|exists:comodato_partners,id',
            'type' => 'required|in:product,variant,kit',
            'id' => 'required|integer',
            'quantity' => 'required|integer|min:1',
            'notes' => 'nullable|string',
        ]);

        try {
            $movement = $this->comodatoService->dispatchStock(
                $request->partner_id,
                $request->type,
                $request->id,
                $request->quantity,
                $request->notes
            );

            return $this->success($movement, 'Mercadoria enviada com sucesso!');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Registra venda de mercadorias no parceiro.
     */
    public function recordSale(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|exists:comodato_partners,id',
            'items' => 'required|array|min:1',
            'items.*.id' => 'required|integer',
            'items.*.type' => 'required|in:product,variant,kit',
            'items.*.quantity' => 'required|integer|min:1',
            'payment_method' => 'required|string',
            'user_id' => 'nullable|exists:users,id',
            'customer_name' => 'nullable|string|max:255',
            'customer_phone' => 'nullable|string|max:50',
            'discount_amount' => 'nullable|numeric|min:0',
            'notes' => 'nullable|string',
        ]);

        try {
            $order = $this->comodatoService->recordSale(
                $request->partner_id,
                $request->items,
                $request->payment_method,
                $request->user_id,
                $request->customer_name,
                $request->customer_phone,
                $request->discount_amount,
                $request->notes
            );

            return $this->success($order, 'Venda registrada e estoque atualizado!', 201);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Registra retorno de mercadoria para o estoque central.
     */
    public function recordReturn(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|exists:comodato_partners,id',
            'type' => 'required|in:product,variant,kit',
            'id' => 'required|integer',
            'quantity' => 'required|integer|min:1',
            'notes' => 'nullable|string',
        ]);

        try {
            $movement = $this->comodatoService->recordReturn(
                $request->partner_id,
                $request->type,
                $request->id,
                $request->quantity,
                $request->notes
            );

            return $this->success($movement, 'Devolução registrada e estoque principal restabelecido!');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Registra perda de mercadoria no parceiro.
     */
    public function recordLoss(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|exists:comodato_partners,id',
            'type' => 'required|in:product,variant,kit',
            'id' => 'required|integer',
            'quantity' => 'required|integer|min:1',
            'notes' => 'nullable|string',
        ]);

        try {
            $movement = $this->comodatoService->recordLoss(
                $request->partner_id,
                $request->type,
                $request->id,
                $request->quantity,
                $request->notes
            );

            return $this->success($movement, 'Perda registrada no sistema.');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Registra uma auditoria de estoque físico.
     */
    public function reconcileAudit(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|exists:comodato_partners,id',
            'items' => 'required|array',
            'items.*.id' => 'required|integer',
            'items.*.type' => 'required|in:product,variant,kit',
            'items.*.quantity' => 'required|integer|min:0',
            'notes' => 'nullable|string',
        ]);

        try {
            $audit = $this->comodatoService->reconcileAudit(
                $request->partner_id,
                $request->items,
                $request->notes
            );

            return $this->success($audit, 'Auditoria de estoque finalizada com sucesso!');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Lista todos os movimentos de comodato.
     */
    public function movements(Request $request)
    {
        $query = ComodatoMovement::with(['partner', 'itemable', 'order'])
            ->orderBy('created_at', 'desc');

        if ($request->has('partner_id')) {
            $query->where('partner_id', $request->partner_id);
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        $movements = $query->paginate($request->get('per_page', 20));

        return $this->success($movements);
    }
}
