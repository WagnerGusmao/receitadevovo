<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductionOrderItem extends Model
{
    protected $fillable = [
        'production_order_id',
        'raw_material_id',
        'batch_id',
        'planned_quantity',
        'actual_quantity',
        'unit_cost',
        'total_cost',
        'notes',
    ];

    protected $casts = [
        'planned_quantity' => 'float',
        'actual_quantity'  => 'float',
        'unit_cost'        => 'float',
        'total_cost'       => 'float',
    ];

    public function productionOrder(): BelongsTo
    {
        return $this->belongsTo(ProductionOrder::class);
    }

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    public function batch(): BelongsTo
    {
        return $this->belongsTo(Batch::class);
    }
}
