<?php

namespace App\Modules\Ecommerce\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class InventoryMovement extends Model
{
    protected $fillable = [
        'itemable_type',
        'itemable_id',
        'type',
        'quantity',
        'reason',
        'order_id',
        'user_id',
        'notes',
    ];

    /**
     * Get the parent itemable model (Product or Kit).
     */
    public function itemable(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * Get the associated order, if any.
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the user who made the manual adjustment, if any.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
