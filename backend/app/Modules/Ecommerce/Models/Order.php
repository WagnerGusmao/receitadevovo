<?php

namespace App\Modules\Ecommerce\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Order extends Model
{
    protected $fillable = [
        'user_id',
        'order_number',
        'total',
        'discount_amount',
        'status',
        'source',
        'payment_method',
        'payment_id',
        'payment_status',
        'payment_link',
        'payment_pix_qr',
        'payment_pix_code',
        'payment_pix_expiration',
        'shipping_address',
        'shipping_method',
        'customer_name',
        'customer_phone',
        'notes',
        'tracking_code',
        'shipped_at',
        'weight_kg',
        'box_dimensions',
        'freight_value',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function installments(): HasMany
    {
        return $this->hasMany(OrderInstallment::class);
    }
}
