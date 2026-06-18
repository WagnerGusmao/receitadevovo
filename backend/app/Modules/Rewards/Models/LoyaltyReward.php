<?php

namespace App\Modules\Rewards\Models;

use Illuminate\Database\Eloquent\Model;

class LoyaltyReward extends Model
{
    protected $fillable = ['title', 'description', 'points_cost', 'reward_code', 'is_active'];

    protected $casts = [
        'points_cost' => 'integer',
        'is_active' => 'boolean',
    ];
}
