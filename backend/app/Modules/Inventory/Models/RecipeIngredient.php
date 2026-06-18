<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class RecipeIngredient extends Model
{
    protected $fillable = [
        'recipe_id',
        'raw_material_id',
        'quantity',
        'waste_percent',
        'notes',
    ];

    protected $casts = [
        'quantity'      => 'float',
        'waste_percent' => 'float',
    ];

    protected $appends = ['quantity_with_waste', 'unit_cost', 'total_cost'];

    public function recipe(): BelongsTo
    {
        return $this->belongsTo(Recipe::class);
    }

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    /**
     * Quantidade real necessária considerando a perda do ingrediente.
     */
    public function getQuantityWithWasteAttribute(): float
    {
        $factor = 1 + ($this->waste_percent / 100);
        return round($this->quantity * $factor, 4);
    }

    /**
     * Custo unitário da matéria-prima (custo médio ponderado atual).
     */
    public function getUnitCostAttribute(): float
    {
        return (float) ($this->rawMaterial->average_cost ?? 0);
    }

    /**
     * Custo total deste ingrediente no lote (já com perda).
     */
    public function getTotalCostAttribute(): float
    {
        return round($this->quantity_with_waste * $this->unit_cost, 4);
    }
}
