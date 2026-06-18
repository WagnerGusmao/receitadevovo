<?php

namespace App\Modules\Ecommerce\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Str;

class Kit extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'description',
        'short_description',
        'price',
        'old_price',
        'original_price',
        'discount_percent',
        'promo_start',
        'promo_end',
        'stock',
        'featured_image',
        'images',
        'is_active',
        'is_on_demand',
        'lead_time_days',
    ];

    protected $casts = [
        'images' => 'array',
        'price' => 'decimal:2',
        'old_price' => 'decimal:2',
        'original_price' => 'decimal:2',
        'discount_percent' => 'decimal:2',
        'promo_start' => 'datetime',
        'promo_end' => 'datetime',
        'is_active' => 'boolean',
        'is_on_demand' => 'boolean',
        'lead_time_days' => 'integer',
    ];

    protected $appends = [
        'is_on_sale',
        'discount_amount',
        'all_images',
        'calculated_discount_percent',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($kit) {
            $kit->slug = $kit->slug ?? Str::slug($kit->name);
        });
    }

    /**
     * Relacionamento com produtos
     */
    public function products(): BelongsToMany
    {
        return $this->belongsToMany(Product::class)->withPivot('quantity');
    }

    /**
     * Verifica se o kit está em promoção
     */
    public function getIsOnSaleAttribute(): bool
    {
        // Pega o preço antigo dos atributos diretos (sem accessor)
        $oldPrice = $this->attributes['old_price'] ?? $this->attributes['original_price'] ?? null;
        $currentPrice = $this->attributes['price'] ?? $this->price;
        
        if (!$oldPrice || $oldPrice <= $currentPrice) {
            return false;
        }

        // Se tem datas de promoção, verificar se está no período
        $promoStart = $this->attributes['promo_start'] ?? null;
        $promoEnd = $this->attributes['promo_end'] ?? null;
        
        if ($promoStart || $promoEnd) {
            $now = now();
            
            if ($promoStart && $now->lt($promoStart)) {
                return false;
            }
            
            if ($promoEnd && $now->gt($promoEnd)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Calcula o valor do desconto
     */
    public function getDiscountAmountAttribute(): ?float
    {
        if (!$this->is_on_sale) {
            return null;
        }

        $oldPrice = $this->attributes['old_price'] ?? $this->attributes['original_price'] ?? 0;
        $currentPrice = $this->attributes['price'] ?? $this->price;
        return round($oldPrice - $currentPrice, 2);
    }

    /**
     * Calcula o percentual de desconto
     */
    public function getCalculatedDiscountPercentAttribute(): ?float
    {
        if (!$this->is_on_sale) {
            return null;
        }

        $discountPercent = $this->attributes['discount_percent'] ?? null;
        if ($discountPercent) {
            return $discountPercent;
        }

        $oldPrice = $this->attributes['old_price'] ?? $this->attributes['original_price'] ?? 0;
        $currentPrice = $this->attributes['price'] ?? $this->price;
        
        if ($oldPrice <= 0) {
            return null;
        }
        
        return round((($oldPrice - $currentPrice) / $oldPrice) * 100, 0);
    }

    /**
     * Retorna todas as imagens (featured + gallery)
     */
    public function getAllImagesAttribute(): array
    {
        $images = [];
        
        if ($this->featured_image) {
            $images[] = $this->featured_image;
        }
        
        if ($this->images && is_array($this->images)) {
            $images = array_merge($images, $this->images);
        }
        
        return $images;
    }

    /**
     * Retorna o preço a ser exibido (com ou sem desconto)
     */
    public function getDisplayPriceAttribute(): float
    {
        return $this->price;
    }
}
