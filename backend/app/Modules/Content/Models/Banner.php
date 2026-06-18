<?php

namespace App\Modules\Content\Models;

use Illuminate\Database\Eloquent\Model;

class Banner extends Model
{
    protected $fillable = [
        'title',
        'subtitle',
        'description',
        'image_desktop',
        'image_mobile',
        'image_fit',
        'image_position',
        'button_text',
        'button_url',
        'page_target',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'is_active'  => 'boolean',
        'sort_order' => 'integer',
    ];
}
