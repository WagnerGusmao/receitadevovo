<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class ProductionOrderOutput extends Model
{
    protected $fillable = [
        'production_order_id',
        'itemable_type',
        'itemable_id',
        'quantity',
        'unit_cost',
    ];

    protected $casts = [
        'quantity' => 'decimal:3',
        'unit_cost' => 'decimal:4',
    ];

    /**
     * Relacionamento polimórfico com Product ou ProductVariant
     */
    public function itemable(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * Relacionamento com a Ordem de Produção
     */
    public function productionOrder(): BelongsTo
    {
        return $this->belongsTo(ProductionOrder::class);
    }
}
