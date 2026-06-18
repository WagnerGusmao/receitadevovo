<?php

namespace App\Modules\Wellness\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Str;

class Herb extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'scientific_name',
        'aliases',
        'description',
        'contraindications',
        'how_to_use',
        'bath_instructions',
        'incense_usage',
        'image_path',
        'source_type',
        'sources'
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($herb) {
            $herb->slug = $herb->slug ?? Str::slug($herb->name);
        });
    }

    public function benefits(): BelongsToMany
    {
        return $this->belongsToMany(Benefit::class);
    }

    public function emotions(): BelongsToMany
    {
        return $this->belongsToMany(Emotion::class);
    }
}
