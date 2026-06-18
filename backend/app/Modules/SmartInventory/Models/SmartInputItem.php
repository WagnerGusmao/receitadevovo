<?php

namespace App\Modules\SmartInventory\Models;

use App\Modules\Inventory\Models\RawMaterial;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SmartInputItem extends Model
{
    protected $fillable = [
        'session_id',
        'description_raw',
        'quantity',
        'unit_raw',
        'unit_normalized',
        'unit_price',
        'total_price',
        'raw_material_id',
        'match_confidence',
        'match_suggestions',
        'batch_number',
        'expires_at',
        'manufactured_at',
        'is_confirmed',
        'is_skipped',
        'is_new_material',
        'new_material_category',
        'notes',
    ];

    protected $casts = [
        'quantity'          => 'float',
        'unit_price'        => 'float',
        'total_price'       => 'float',
        'match_confidence'  => 'float',
        'match_suggestions' => 'array',
        'expires_at'        => 'date',
        'manufactured_at'   => 'date',
        'is_confirmed'      => 'boolean',
        'is_skipped'        => 'boolean',
        'is_new_material'   => 'boolean',
    ];

    protected $appends = ['confidence_level'];

    public function session(): BelongsTo
    {
        return $this->belongsTo(SmartInputSession::class, 'session_id');
    }

    public function rawMaterial(): BelongsTo
    {
        return $this->belongsTo(RawMaterial::class);
    }

    /**
     * Nível de confiança do matching: high / medium / low / none
     */
    public function getConfidenceLevelAttribute(): string
    {
        if ($this->match_confidence === null) {
            return 'none';
        }
        if ($this->match_confidence >= 0.75) {
            return 'high';
        }
        if ($this->match_confidence >= 0.45) {
            return 'medium';
        }
        return 'low';
    }

    public function isResolved(): bool
    {
        return $this->is_confirmed || $this->is_skipped;
    }
}
