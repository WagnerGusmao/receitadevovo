<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ComodatoPartner extends Model
{
    protected $table = 'comodato_partners';

    protected $fillable = [
        'name',
        'contact_name',
        'phone',
        'address',
        'commission_percentage',
        'is_active',
    ];

    protected $casts = [
        'commission_percentage' => 'decimal:2',
        'is_active' => 'boolean',
    ];

    public function stocks(): HasMany
    {
        return $this->hasMany(ComodatoStock::class, 'partner_id');
    }

    public function movements(): HasMany
    {
        return $this->hasMany(ComodatoMovement::class, 'partner_id');
    }

    public function audits(): HasMany
    {
        return $this->hasMany(ComodatoAudit::class, 'partner_id');
    }
}
