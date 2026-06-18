<?php

namespace App\Modules\Rewards\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;

class LoyaltyRedemption extends Model
{
    public $timestamps = false;

    protected $fillable = ['user_id', 'loyalty_reward_id', 'reward_code', 'created_at'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reward()
    {
        return $this->belongsTo(LoyaltyReward::class, 'loyalty_reward_id');
    }
}
