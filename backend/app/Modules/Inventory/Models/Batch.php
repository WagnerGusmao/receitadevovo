<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class Batch extends Model
{
    protected $fillable = [
        'raw_material_id',
        'supplier_id',
        'batch_number',
        'internal_code',
        'quantity_received',
        'quantity_remaining',
        'unit_cost',
        'manufactured_at',
        'expires_at',
        'status',
        'notes',
    ];

    protected $casts = [
        'quantity_received'  => 'float',
        'quantity_remaining' => 'float',
        'unit_cost'          => 'float',
        'manufactured_at'    => 'date',
        'expires_at'         => 'date',
    ];

    protected $appends = [
        'consumption_percent',
        'days_to_expire',
        'is_expiring_soon',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($batch) {
            if (!$batch->internal_code) {
                $batch->internal_code = 'LOT-' . strtoupper(Str::random(8));
            }
        });
    }

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function movements(): HasMany
    {
        return $this->hasMany(RawMaterialMovement::class);
    }

    /**
     * Percentual consumido do lote
     */
    public function getConsumptionPercentAttribute(): float
    {
        if ($this->quantity_received <= 0) {
            return 0;
        }
        $consumed = $this->quantity_received - $this->quantity_remaining;
        return round(($consumed / $this->quantity_received) * 100, 1);
    }

    /**
     * Dias até vencer (negativo = já venceu)
     */
    public function getDaysToExpireAttribute(): ?int
    {
        if (!$this->expires_at) {
            return null;
        }
        return now()->diffInDays($this->expires_at, false);
    }

    /**
     * Vence em menos de 30 dias?
     */
    public function getIsExpiringSoonAttribute(): bool
    {
        $days = $this->days_to_expire;
        return $days !== null && $days <= 30 && $days >= 0;
    }
}
