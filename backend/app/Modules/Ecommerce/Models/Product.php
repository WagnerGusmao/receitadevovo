<?php

namespace App\Modules\Ecommerce\Models;

use App\Modules\Wellness\Models\Herb;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Product extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'description',
        'short_description',
        'price',
        'old_price',
        'discount_percent',
        'promo_start',
        'promo_end',
        'stock',
        'featured_image',
        'images',
        'is_active',
        'unit_cost',
        'category_id',
        'is_on_demand',
        'lead_time_days',
    ];

    protected $casts = [
        'images'     => 'array',
        'price'      => 'decimal:2',
        'unit_cost'  => 'decimal:4',
        'old_price' => 'decimal:2',
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
        'reviews_average',
        'reviews_count',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($product) {
            $product->slug = $product->slug ?? Str::slug($product->name);
        });
    }

    /**
     * Relacionamento com as variantes do produto
     */
    public function variants(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(ProductVariant::class);
    }

    /**
     * Relacionamento com ervas
     */
    public function herbs(): BelongsToMany
    {
        return $this->belongsToMany(Herb::class);
    }

    /**
     * Relacionamento com kits
     */
    public function kits(): BelongsToMany
    {
        return $this->belongsToMany(Kit::class);
    }

    /**
     * Relacionamento com categoria
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Verifica se o produto está em promoção
     */
    public function getIsOnSaleAttribute(): bool
    {
        $oldPrice = $this->attributes['old_price'] ?? null;
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

        return round($this->old_price - $this->price, 2);
    }

    /**
     * Calcula o percentual de desconto
     */
    public function getCalculatedDiscountPercentAttribute(): ?float
    {
        if (!$this->is_on_sale) {
            return null;
        }

        if ($this->discount_percent) {
            return $this->discount_percent;
        }

        return round((($this->old_price - $this->price) / $this->old_price) * 100, 0);
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

    /**
     * Retorna o preço original (se houver promoção)
     */
    public function getOriginalPriceAttribute(): ?float
    {
        return $this->is_on_sale ? $this->old_price : null;
    }

    /**
     * Relacionamento com avaliações
     */
    public function reviews(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(ProductReview::class)->where('is_approved', true);
    }

    /**
     * Média de avaliações do produto
     */
    public function getReviewsAverageAttribute(): float
    {
        return round($this->reviews()->avg('rating') ?? 5.0, 1);
    }

    /**
     * Total de avaliações do produto
     */
    public function getReviewsCountAttribute(): int
    {
        return $this->reviews()->count();
    }
}
