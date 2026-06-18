<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class RawMaterial extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'unit',
        'category',
        'stock_quantity',
        'min_stock_quantity',
        'average_cost',
        'shelf_life_days',
        'supplier_id',
        'image_path',
        'is_active',
    ];

    protected $casts = [
        'stock_quantity'     => 'float',
        'min_stock_quantity' => 'float',
        'average_cost'       => 'float',
        'is_active'          => 'boolean',
    ];

    protected $appends = [
        'is_low_stock',
        'stock_value',
        'is_expired_risk',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            $model->slug = $model->slug ?? Str::slug($model->name);
        });
    }

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function batches(): HasMany
    {
        return $this->hasMany(Batch::class);
    }

    public function movements(): HasMany
    {
        return $this->hasMany(RawMaterialMovement::class);
    }

    public function activeBatches(): HasMany
    {
        return $this->hasMany(Batch::class)->where('status', 'active')->orderBy('expires_at');
    }

    /**
     * Estoque abaixo do mínimo?
     */
    public function getIsLowStockAttribute(): bool
    {
        return $this->stock_quantity <= $this->min_stock_quantity;
    }

    /**
     * Valor total em estoque (qtd × custo médio)
     */
    public function getStockValueAttribute(): float
    {
        return round($this->stock_quantity * $this->average_cost, 2);
    }

    /**
     * Tem lote vencendo em menos de 30 dias?
     */
    public function getIsExpiredRiskAttribute(): bool
    {
        return $this->batches()
            ->where('status', 'active')
            ->whereNotNull('expires_at')
            ->where('expires_at', '<=', now()->addDays(30))
            ->exists();
    }
}
