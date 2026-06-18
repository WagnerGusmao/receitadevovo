<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class RawMaterialMovement extends Model
{
    protected $fillable = [
        'raw_material_id',
        'batch_id',
        'user_id',
        'type',
        'quantity',
        'unit_cost',
        'total_cost',
        'stock_after',
        'average_cost_after',
        'reference_type',
        'reference_id',
        'notes',
    ];

    protected $casts = [
        'quantity'           => 'float',
        'unit_cost'          => 'float',
        'total_cost'         => 'float',
        'stock_after'        => 'float',
        'average_cost_after' => 'float',
    ];

    const TYPE_LABELS = [
        'purchase'       => 'Compra',
        'adjustment_in'  => 'Ajuste Entrada',
        'adjustment_out' => 'Ajuste Saída',
        'consumed'       => 'Consumo Produção',
        'waste'          => 'Perda/Descarte',
        'return'         => 'Devolução',
    ];

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    public function batch(): BelongsTo
    {
        return $this->belongsTo(Batch::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function reference(): MorphTo
    {
        return $this->morphTo('reference');
    }

    public function getTypeLabelAttribute(): string
    {
        return self::TYPE_LABELS[$this->type] ?? $this->type;
    }

    public function getIsEntryAttribute(): bool
    {
        return in_array($this->type, ['purchase', 'adjustment_in', 'return']);
    }
}
