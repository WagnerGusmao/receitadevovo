<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\QualityCheck;
use App\Modules\Inventory\Models\Batch;
use App\Modules\Inventory\Models\ProductionOrder;
use App\Modules\Inventory\Models\PurchaseOrder;
use App\Modules\Inventory\Services\QualityService;
use Illuminate\Http\Request;

class QualityController extends Controller
{
    public function __construct(private readonly QualityService $qualityService) {}

    /** Lista inspeções com filtros. */
    public function index(Request $request)
    {
        $query = QualityCheck::with([
            'user',
            'checkable' => function ($morphTo) {
                $morphTo->morphWith([
                    \App\Modules\Inventory\Models\ProductionOrder::class => ['product', 'outputs', 'outputs.itemable'],
                    \App\Modules\Inventory\Models\Batch::class => ['rawMaterial', 'supplier'],
                    \App\Modules\Inventory\Models\PurchaseOrder::class => ['supplier'],
                ]);
            }
        ])
            ->withCount('criteria')
            ->latest();

        if ($request->status) {
            $query->where('status', $request->status);
        }
        if ($request->check_type) {
            $query->where('check_type', $request->check_type);
        }

        return $this->success($query->paginate(20));
    }

    /** Dashboard de qualidade. */
    public function dashboard()
    {
        return $this->success($this->qualityService->getDashboard());
    }

    /** Detalhe de uma inspeção com critérios. */
    public function show($id)
    {
        $check = QualityCheck::with([
            'criteria',
            'user',
            'checkable' => function ($morphTo) {
                $morphTo->morphWith([
                    \App\Modules\Inventory\Models\ProductionOrder::class => ['product', 'outputs', 'outputs.itemable'],
                    \App\Modules\Inventory\Models\Batch::class => ['rawMaterial', 'supplier'],
                    \App\Modules\Inventory\Models\PurchaseOrder::class => ['supplier'],
                ]);
            }
        ])->findOrFail($id);
        return $this->success($check);
    }

    /** Criar inspeção manualmente para um Batch ou ProductionOrder. */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'checkable_type' => 'required|in:batch,production_order,purchase_order',
            'checkable_id'   => 'required|integer',
            'notes'          => 'nullable|string',
        ]);

        $checkable = match ($validated['checkable_type']) {
            'batch'            => Batch::findOrFail($validated['checkable_id']),
            'production_order' => ProductionOrder::findOrFail($validated['checkable_id']),
            'purchase_order'   => PurchaseOrder::findOrFail($validated['checkable_id']),
        };

        $checkType = $validated['checkable_type'] === 'production_order' ? 'production' : 'receipt';

        try {
            $check = $this->qualityService->createCheck(
                checkable: $checkable,
                checkType: $checkType,
                userId:    $request->user()->id,
                notes:     $validated['notes'] ?? null,
            );
            return $this->success($check, 'Inspeção criada', 201);
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /** Avaliar uma inspeção (aprovar, reprovar, quarentena). */
    public function evaluate(Request $request, $id)
    {
        $check = QualityCheck::with('criteria')->findOrFail($id);

        $validated = $request->validate([
            'decision'                       => 'required|in:approved,rejected,quarantine',
            'notes'                          => 'nullable|string',
            'rejection_reason'               => 'nullable|string',
            'criteria'                       => 'nullable|array',
            'criteria.*.id'                  => 'required|integer',
            'criteria.*.result'              => 'nullable|in:pass,fail,conditional,na',
            'criteria.*.measured_value'      => 'nullable|string|max:100',
            'criteria.*.notes'               => 'nullable|string',
        ]);

        try {
            $check = $this->qualityService->evaluate(
                check:            $check,
                decision:         $validated['decision'],
                criteriaData:     $validated['criteria'] ?? [],
                notes:            $validated['notes'] ?? null,
                rejectionReason:  $validated['rejection_reason'] ?? null,
            );

            $msg = match ($validated['decision']) {
                'approved'   => 'Inspeção aprovada!',
                'rejected'   => 'Inspeção reprovada.',
                'quarantine' => 'Item enviado para quarentena.',
            };

            return $this->success($check, $msg);
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /** Relatório de não-conformidades. */
    public function nonConformities(Request $request)
    {
        $period = $request->query('period', '30d');
        return $this->success($this->qualityService->getNonConformities($period));
    }
}
