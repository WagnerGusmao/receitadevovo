<?php

namespace App\Modules\Content\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Post extends Model
{
    protected $fillable = [
        'user_id', 'category_id', 'linked_product_id', 'title', 'slug', 'excerpt', 
        'content', 'featured_image', 'status', 'seo_metadata', 'show_on_home', 'home_order', 'published_at'
    ];

    protected $casts = [
        'seo_metadata' => 'array',
        'published_at' => 'datetime',
        'show_on_home' => 'boolean',
        'home_order'   => 'integer',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($post) {
            $post->slug = $post->slug ?? Str::slug($post->title);
        });
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(PostCategory::class, 'category_id');
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(\App\Modules\Ecommerce\Models\Product::class, 'linked_product_id');
    }
}
