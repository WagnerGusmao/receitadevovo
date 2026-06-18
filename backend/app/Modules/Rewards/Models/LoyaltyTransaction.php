<?php

namespace App\Modules\Rewards\Models;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Order;
use Illuminate\Database\Eloquent\Model;

class LoyaltyTransaction extends Model
{
    protected $fillable = ['user_id', 'order_id', 'points', 'description'];

    protected $casts = [
        'points' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
