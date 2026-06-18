<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ComodatoAudit extends Model
{
    protected $table = 'comodato_audits';

    protected $fillable = [
        'partner_id',
        'audited_at',
        'status', // completed, discrepancy_found
        'notes',
    ];

    protected $casts = [
        'audited_at' => 'datetime',
    ];

    public function partner(): BelongsTo
    {
        return $this->belongsTo(ComodatoPartner::class, 'partner_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(ComodatoAuditItem::class, 'comodato_audit_id');
    }
}
