<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class ComodatoAuditItem extends Model
{
    protected $table = 'comodato_audit_items';

    protected $fillable = [
        'comodato_audit_id',
        'itemable_type',
        'itemable_id',
        'expected_quantity',
        'actual_quantity',
        'difference',
        'action_taken', // loss_registered, sale_registered, adjusted
    ];

    public function audit(): BelongsTo
    {
        return $this->belongsTo(ComodatoAudit::class, 'comodato_audit_id');
    }

    /**
     * Get the owning itemable model (Product, Variant, Kit).
     */
    public function itemable(): MorphTo
    {
        return $this->morphTo();
    }
}
