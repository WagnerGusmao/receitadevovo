<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class ComodatoStock extends Model
{
    protected $table = 'comodato_stocks';

    protected $fillable = [
        'partner_id',
        'itemable_type',
        'itemable_id',
        'quantity',
    ];

    public function partner(): BelongsTo
    {
        return $this->belongsTo(ComodatoPartner::class, 'partner_id');
    }

    /**
     * Get the owning itemable model (Product, Variant, Kit).
     */
    public function itemable(): MorphTo
    {
        return $this->morphTo();
    }
}
