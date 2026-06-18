<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Ecommerce\Models\Product;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class Recipe extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'product_id',
        'name',
        'slug',
        'description',
        'instructions',
        'yield_quantity',
        'yield_unit',
        'waste_percent',
        'prep_time_minutes',
        'is_active',
    ];

    protected $casts = [
        'yield_quantity'     => 'float',
        'waste_percent'      => 'float',
        'prep_time_minutes'  => 'integer',
        'is_active'          => 'boolean',
    ];

    protected $appends = [
        'batch_cost',
        'unit_cost',
        'effective_yield',
        'margin_percent',
        'feasibility',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($recipe) {
            $recipe->slug = $recipe->slug ?? Str::slug($recipe->name);
        });
        static::updating(function ($recipe) {
            if ($recipe->isDirty('name')) {
                $recipe->slug = Str::slug($recipe->name);
            }
        });
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function ingredients(): HasMany
    {
        return $this->hasMany(RecipeIngredient::class)->with('rawMaterial');
    }

    /**
     * Custo total do lote (soma de todos os ingredientes com perdas).
     */
    public function getBatchCostAttribute(): float
    {
        return round(
            $this->ingredients->sum(fn($i) => $i->total_cost),
            2
        );
    }

    /**
     * Custo por unidade produzida (custo lote ÷ rendimento efetivo).
     */
    public function getUnitCostAttribute(): float
    {
        $yield = $this->effective_yield;
        if ($yield <= 0) {
            return 0;
        }
        return round($this->batch_cost / $yield, 4);
    }

    /**
     * Rendimento real após desconto da perda geral da receita.
     * Ex: rendimento 100 un, perda 5% → 95 un efetivas.
     */
    public function getEffectiveYieldAttribute(): float
    {
        return round($this->yield_quantity * (1 - $this->waste_percent / 100), 3);
    }

    /**
     * Margem de lucro com base no preço de venda do produto vinculado.
     * Retorna null se não houver produto vinculado.
     */
    public function getMarginPercentAttribute(): ?float
    {
        if (!$this->product || !$this->product->price || $this->unit_cost <= 0) {
            return null;
        }
        $price = (float) $this->product->price;
        return round((($price - $this->unit_cost) / $price) * 100, 2);
    }

    /**
     * Viabilidade de produção com base no estoque atual.
     * Retorna quantos lotes é possível produzir agora.
     */
    public function getFeasibilityAttribute(): array
    {
        $maxBatches = PHP_INT_MAX;
        $shortages   = [];

        foreach ($this->ingredients as $ingredient) {
            $needed  = $ingredient->quantity_with_waste;
            $stock   = (float) ($ingredient->rawMaterial->stock_quantity ?? 0);
            $unit    = $ingredient->rawMaterial->unit ?? '';

            if ($needed <= 0) {
                continue;
            }

            $possible = floor($stock / $needed);
            $maxBatches = min($maxBatches, $possible);

            if ($stock < $needed) {
                $shortages[] = [
                    'material'  => $ingredient->rawMaterial->name,
                    'unit'      => $unit,
                    'needed'    => $needed,
                    'available' => $stock,
                    'missing'   => round($needed - $stock, 4),
                ];
            }
        }

        $batchesPossible = $this->ingredients->isEmpty()
            ? 0
            : (int) ($maxBatches === PHP_INT_MAX ? 0 : $maxBatches);

        return [
            'batches_possible'  => $batchesPossible,
            'units_possible'    => round($batchesPossible * $this->effective_yield, 0),
            'can_produce'       => $batchesPossible >= 1,
            'shortages'         => $shortages,
        ];
    }
}
