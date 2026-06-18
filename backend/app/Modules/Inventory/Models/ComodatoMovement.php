<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Ecommerce\Models\Order;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class ComodatoMovement extends Model
{
    protected $table = 'comodato_movements';

    protected $fillable = [
        'partner_id',
        'itemable_type',
        'itemable_id',
        'type', // dispatch, sale, return, loss
        'quantity',
        'order_id',
        'notes',
    ];

    public function partner(): BelongsTo
    {
        return $this->belongsTo(ComodatoPartner::class, 'partner_id');
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class, 'order_id');
    }

    /**
     * Get the owning itemable model (Product, Variant, Kit).
     */
    public function itemable(): MorphTo
    {
        return $this->morphTo();
    }
}
