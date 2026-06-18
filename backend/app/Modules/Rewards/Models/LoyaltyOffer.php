<?php

namespace App\Modules\Rewards\Models;

use App\Modules\Ecommerce\Models\Product;
use Illuminate\Database\Eloquent\Model;

class LoyaltyOffer extends Model
{
    protected $fillable = ['product_id', 'loyalty_level_id', 'special_price', 'description', 'is_active'];

    protected $casts = [
        'special_price' => 'decimal:2',
        'is_active' => 'boolean',
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function level()
    {
        return $this->belongsTo(LoyaltyLevel::class, 'loyalty_level_id');
    }
}
