<?php

namespace App\Modules\Wellness\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Str;

class Benefit extends Model
{
    protected $fillable = ['name', 'slug', 'description', 'icon'];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($benefit) {
            $benefit->slug = $benefit->slug ?? Str::slug($benefit->name);
        });
    }

    public function herbs(): BelongsToMany
    {
        return $this->belongsToMany(Herb::class);
    }
}
