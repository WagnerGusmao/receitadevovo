<?php

namespace App\Modules\Inventory\Services;

use App\Modules\Inventory\Models\QualityCheck;
use App\Modules\Inventory\Models\QualityCheckCriteria;
use App\Modules\Inventory\Models\Batch;
use App\Modules\Inventory\Models\ProductionOrder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class QualityService
{
    /* ─────────────────────────────────────────────────────────────
     | 1. CRIAR INSPEÇÃO
     |    Cria um QualityCheck com os critérios padrão para o tipo.
     ──────────────────────────────────────────────────────────── */
    public function createCheck(
        Model $checkable,
        string $checkType,       // 'receipt' | 'production'
        ?int $userId = null,
        ?string $notes = null
    ): QualityCheck {
        return DB::transaction(function () use ($checkable, $checkType, $userId, $notes) {
            // Impedir duplicata de inspeção pendente para o mesmo objeto
            $exists = QualityCheck::where('checkable_type', get_class($checkable))
                ->where('checkable_id', $checkable->id)
                ->where('status', 'pending')
                ->exists();

            if ($exists) {
                throw new \DomainException('Já existe uma inspeção pendente para este item.');
            }

            $check = QualityCheck::create([
                'checkable_type' => get_class($checkable),
                'checkable_id'   => $checkable->id,
                'user_id'        => $userId,
                'check_type'     => $checkType,
                'status'         => 'pending',
                'notes'          => $notes,
            ]);

            // Criar critérios padrão
            $defaults = QualityCheck::CRITERIA_DEFAULTS[$checkType] ?? [];
            foreach ($defaults as $def) {
                QualityCheckCriteria::create([
                    'quality_check_id' => $check->id,
                    'criterion'        => $def['criterion'],
                    'criterion_label'  => $def['criterion_label'],
                ]);
            }

            return $check->load('criteria', 'checkable');
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 2. AVALIAR INSPEÇÃO (aprovar, reprovar ou quarentena)
     |    $criteriaData: [['id', 'result', 'measured_value?', 'notes?'], ...]
     ──────────────────────────────────────────────────────────── */
    public function evaluate(
        QualityCheck $check,
        string $decision,         // 'approved' | 'rejected' | 'quarantine'
        array $criteriaData,
        ?string $notes = null,
        ?string $rejectionReason = null
    ): QualityCheck {
        if ($check->status !== 'pending') {
            throw new \DomainException('Esta inspeção já foi avaliada.');
        }

        if (!in_array($decision, ['approved', 'rejected', 'quarantine'])) {
            throw new \DomainException('Decisão inválida.');
        }

        return DB::transaction(function () use ($check, $decision, $criteriaData, $notes, $rejectionReason) {
            // Atualizar cada critério
            foreach ($criteriaData as $cd) {
                QualityCheckCriteria::where('id', $cd['id'])
                    ->where('quality_check_id', $check->id)
                    ->update([
                        'result'         => $cd['result'] ?? null,
                        'measured_value' => $cd['measured_value'] ?? null,
                        'notes'          => $cd['notes'] ?? null,
                    ]);
            }

            $check->update([
                'status'           => $decision,
                'checked_at'       => now(),
                'notes'            => $notes ?? $check->notes,
                'rejection_reason' => $rejectionReason,
            ]);

            return $check->fresh(['criteria', 'checkable', 'user']);
        });
    }

    /* ─────────────────────────────────────────────────────────────
     | 3. DASHBOARD
     ──────────────────────────────────────────────────────────── */
    public function getDashboard(): array
    {
        $pending   = QualityCheck::where('status', 'pending')
            ->with([
                'user',
                'checkable' => function ($morphTo) {
                    $morphTo->morphWith([
                        \App\Modules\Inventory\Models\ProductionOrder::class => ['product', 'outputs', 'outputs.itemable'],
                        \App\Modules\Inventory\Models\Batch::class => ['rawMaterial', 'supplier'],
                        \App\Modules\Inventory\Models\PurchaseOrder::class => ['supplier'],
                    ]);
                }
            ])
            ->latest()
            ->get();

        $month     = Carbon::now()->startOfMonth();

        $thisMonth = QualityCheck::where('checked_at', '>=', $month)->get(['status']);
        $approved  = $thisMonth->where('status', 'approved')->count();
        $rejected  = $thisMonth->where('status', 'rejected')->count();
        $quarantine= $thisMonth->where('status', 'quarantine')->count();
        $total     = $thisMonth->whereIn('status', ['approved', 'rejected', 'quarantine'])->count();

        $approvalRate = $total > 0 ? round(($approved / $total) * 100, 1) : null;

        // Critérios com maior taxa de falha
        $topFailures = QualityCheckCriteria::where('result', 'fail')
            ->where('created_at', '>=', $month)
            ->selectRaw('criterion_label, COUNT(*) as fail_count')
            ->groupBy('criterion_label')
            ->orderByDesc('fail_count')
            ->limit(5)
            ->get();

        return [
            'pending_count'   => $pending->count(),
            'approved_month'  => $approved,
            'rejected_month'  => $rejected,
            'quarantine_month'=> $quarantine,
            'approval_rate'   => $approvalRate,
            'top_failures'    => $topFailures,
            'pending_list'    => $pending,
        ];
    }

    /* ─────────────────────────────────────────────────────────────
     | 4. RELATÓRIO DE NÃO-CONFORMIDADES
     ──────────────────────────────────────────────────────────── */
    public function getNonConformities(string $period = '30d'): array
    {
        [$from, $to] = $this->parsePeriod($period);

        $checks = QualityCheck::whereIn('status', ['rejected', 'quarantine'])
            ->whereBetween('checked_at', [$from, $to])
            ->with([
                'criteria',
                'user',
                'checkable' => function ($morphTo) {
                    $morphTo->morphWith([
                        \App\Modules\Inventory\Models\ProductionOrder::class => ['product', 'outputs', 'outputs.itemable'],
                        \App\Modules\Inventory\Models\Batch::class => ['rawMaterial', 'supplier'],
                        \App\Modules\Inventory\Models\PurchaseOrder::class => ['supplier'],
                    ]);
                }
            ])
            ->latest('checked_at')
            ->get();

        // Critérios com mais falhas no período
        $criteriaStats = QualityCheckCriteria::where('result', 'fail')
            ->whereBetween('created_at', [$from, $to])
            ->selectRaw('criterion_label, COUNT(*) as fail_count')
            ->groupBy('criterion_label')
            ->orderByDesc('fail_count')
            ->get();

        return [
            'period'        => ['from' => $from->toDateString(), 'to' => $to->toDateString()],
            'total'         => $checks->count(),
            'rejected'      => $checks->where('status', 'rejected')->count(),
            'quarantine'    => $checks->where('status', 'quarantine')->count(),
            'checks'        => $checks,
            'criteria_stats'=> $criteriaStats,
        ];
    }

    /* ─────────────────────────────────────────────────────────────
     | Helper
     ──────────────────────────────────────────────────────────── */
    private function parsePeriod(string $period): array
    {
        $to   = Carbon::now()->endOfDay();
        $from = match ($period) {
            '7d'    => Carbon::now()->subDays(7)->startOfDay(),
            '30d'   => Carbon::now()->subDays(30)->startOfDay(),
            '90d'   => Carbon::now()->subDays(90)->startOfDay(),
            '6m'    => Carbon::now()->subMonths(6)->startOfDay(),
            '1y'    => Carbon::now()->subYear()->startOfDay(),
            'month' => Carbon::now()->startOfMonth(),
            default => Carbon::now()->subDays(30)->startOfDay(),
        };
        return [$from, $to];
    }
}
