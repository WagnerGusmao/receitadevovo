<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PurchaseOrderItem extends Model
{
    protected $fillable = [
        'purchase_order_id',
        'raw_material_id',
        'quantity_ordered',
        'quantity_received',
        'unit_price',
        'actual_unit_price',
        'total_planned',
        'total_actual',
        'notes',
    ];

    protected $casts = [
        'quantity_ordered'   => 'float',
        'quantity_received'  => 'float',
        'unit_price'         => 'float',
        'actual_unit_price'  => 'float',
        'total_planned'      => 'float',
        'total_actual'       => 'float',
    ];

    protected $appends = ['receipt_status'];

    public function purchaseOrder(): BelongsTo
    {
        return $this->belongsTo(PurchaseOrder::class);
    }

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    /** Situação de recebimento do item */
    public function getReceiptStatusAttribute(): string
    {
        if ($this->quantity_received === null) {
            return 'pending';
        }
        if ($this->quantity_received >= $this->quantity_ordered) {
            return 'complete';
        }
        if ($this->quantity_received > 0) {
            return 'partial';
        }
        return 'pending';
    }
}
