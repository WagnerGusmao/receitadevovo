<?php

namespace App\Modules\Wellness\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Str;

class Emotion extends Model
{
    protected $fillable = ['name', 'slug', 'description'];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($emotion) {
            $emotion->slug = $emotion->slug ?? Str::slug($emotion->name);
        });
    }

    public function herbs(): BelongsToMany
    {
        return $this->belongsToMany(Herb::class);
    }
}
