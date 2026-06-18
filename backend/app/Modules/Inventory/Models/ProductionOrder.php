<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Product;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ProductionOrder extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'recipe_id',
        'product_id',
        'user_id',
        'status',
        'planned_batches',
        'planned_yield',
        'planned_cost',
        'actual_batches',
        'actual_yield',
        'actual_cost',
        'waste_quantity',
        'waste_notes',
        'started_at',
        'completed_at',
        'notes',
    ];

    protected $casts = [
        'planned_batches'  => 'integer',
        'actual_batches'   => 'integer',
        'planned_yield'    => 'float',
        'actual_yield'     => 'float',
        'planned_cost'     => 'float',
        'actual_cost'      => 'float',
        'waste_quantity'   => 'float',
        'started_at'       => 'datetime',
        'completed_at'     => 'datetime',
    ];

    protected $appends = [
        'status_label',
        'duration_minutes',
        'cost_variance',
        'yield_variance',
        'actual_unit_cost',
    ];

    const STATUS_LABELS = [
        'draft'       => 'Rascunho',
        'in_progress' => 'Em Produção',
        'completed'   => 'Concluída',
        'cancelled'   => 'Cancelada',
    ];

    const STATUS_COLORS = [
        'draft'       => 'zinc',
        'in_progress' => 'blue',
        'completed'   => 'emerald',
        'cancelled'   => 'red',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($order) {
            if (!$order->code) {
                $year  = now()->year;
                $count = static::whereYear('created_at', $year)->count() + 1;
                $order->code = sprintf('OP-%d-%04d', $year, $count);
            }
        });
    }

    /* ── Relacionamentos ─────────────────────────────── */

    public function recipe(): BelongsTo
    {
        return $this->belongsTo(Recipe::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(ProductionOrderItem::class)->with('rawMaterial', 'batch');
    }

    public function outputs(): HasMany
    {
        return $this->hasMany(ProductionOrderOutput::class)->with('itemable');
    }

    /* ── Accessors ───────────────────────────────────── */

    public function getStatusLabelAttribute(): string
    {
        return self::STATUS_LABELS[$this->attributes['status']] ?? $this->attributes['status'];
    }

    /** Duração em minutos (apenas ordens concluídas ou em andamento) */
    public function getDurationMinutesAttribute(): ?int
    {
        if (!$this->started_at) {
            return null;
        }
        $end = $this->completed_at ?? now();
        return (int) $this->started_at->diffInMinutes($end);
    }

    /** Variação de custo real vs planejado (positivo = gastou mais) */
    public function getCostVarianceAttribute(): ?float
    {
        if ($this->actual_cost === null) {
            return null;
        }
        return round($this->actual_cost - $this->planned_cost, 2);
    }

    /** Variação de rendimento real vs planejado (positivo = produziu mais) */
    public function getYieldVarianceAttribute(): ?float
    {
        if ($this->actual_yield === null) {
            return null;
        }
        return round($this->actual_yield - $this->planned_yield, 3);
    }

    /** Custo unitário real (custo real ÷ yield real) */
    public function getActualUnitCostAttribute(): ?float
    {
        if ($this->actual_cost === null || !$this->actual_yield || $this->actual_yield <= 0) {
            return null;
        }
        return round($this->actual_cost / $this->actual_yield, 4);
    }
}
