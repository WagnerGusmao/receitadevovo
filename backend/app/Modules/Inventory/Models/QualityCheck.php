<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class QualityCheck extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'checkable_type',
        'checkable_id',
        'user_id',
        'check_type',
        'status',
        'checked_at',
        'notes',
        'rejection_reason',
    ];

    protected $casts = [
        'checked_at' => 'datetime',
    ];

    protected $appends = ['status_label', 'pass_rate', 'has_failures'];

    const STATUS_LABELS = [
        'pending'    => 'Pendente',
        'approved'   => 'Aprovado',
        'rejected'   => 'Reprovado',
        'quarantine' => 'Quarentena',
    ];

    const CRITERIA_DEFAULTS = [
        'receipt' => [
            ['criterion' => 'appearance',  'criterion_label' => 'Aparência Visual'],
            ['criterion' => 'smell',       'criterion_label' => 'Odor'],
            ['criterion' => 'packaging',   'criterion_label' => 'Embalagem/Lacre'],
            ['criterion' => 'weight',      'criterion_label' => 'Peso/Quantidade'],
            ['criterion' => 'expiry',      'criterion_label' => 'Validade'],
            ['criterion' => 'certificate', 'criterion_label' => 'Certificado/NF'],
        ],
        'production' => [
            ['criterion' => 'appearance',  'criterion_label' => 'Aparência'],
            ['criterion' => 'smell',       'criterion_label' => 'Odor'],
            ['criterion' => 'taste',       'criterion_label' => 'Sabor'],
            ['criterion' => 'texture',     'criterion_label' => 'Textura/Consistência'],
            ['criterion' => 'weight',      'criterion_label' => 'Peso Líquido'],
            ['criterion' => 'packaging',   'criterion_label' => 'Embalagem Final'],
        ],
    ];

    /* ── Relacionamentos ─────────────────────────────── */

    public function checkable(): MorphTo
    {
        return $this->morphTo();
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function criteria(): HasMany
    {
        return $this->hasMany(QualityCheckCriteria::class, 'quality_check_id');
    }

    /* ── Accessors ───────────────────────────────────── */

    public function getStatusLabelAttribute(): string
    {
        return self::STATUS_LABELS[$this->attributes['status']] ?? $this->attributes['status'];
    }

    /** Percentual de critérios aprovados */
    public function getPassRateAttribute(): ?float
    {
        $criteria = $this->criteria;
        $evaluated = $criteria->whereNotNull('result');
        if ($evaluated->isEmpty()) {
            return null;
        }
        $passed = $evaluated->where('result', 'pass')->count();
        return round(($passed / $evaluated->count()) * 100, 1);
    }

    /** Indica se há algum critério reprovado */
    public function getHasFailuresAttribute(): bool
    {
        return $this->criteria->contains('result', 'fail');
    }
}
