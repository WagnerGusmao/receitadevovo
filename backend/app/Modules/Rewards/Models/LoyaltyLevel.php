<?php

namespace App\Modules\Rewards\Models;

use Illuminate\Database\Eloquent\Model;

class LoyaltyLevel extends Model
{
    protected $fillable = ['name', 'min_points', 'discount_percentage', 'badge_icon', 'description'];

    protected $casts = [
        'min_points' => 'integer',
        'discount_percentage' => 'decimal:2',
    ];
}
