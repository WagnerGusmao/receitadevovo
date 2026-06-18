<?php

namespace App\Modules\Inventory\Models;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PurchaseOrder extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'supplier_id',
        'user_id',
        'status',
        'total_planned',
        'total_actual',
        'expected_at',
        'sent_at',
        'received_at',
        'notes',
    ];

    protected $casts = [
        'total_planned'  => 'float',
        'total_actual'   => 'float',
        'expected_at'    => 'date',
        'sent_at'        => 'datetime',
        'received_at'    => 'datetime',
    ];

    protected $appends = ['status_label', 'price_variance', 'is_overdue'];

    const STATUS_LABELS = [
        'draft'     => 'Rascunho',
        'sent'      => 'Enviada',
        'partial'   => 'Parcialmente Recebida',
        'received'  => 'Recebida',
        'cancelled' => 'Cancelada',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($order) {
            if (!$order->code) {
                $year  = now()->year;
                $count = static::whereYear('created_at', $year)->count() + 1;
                $order->code = sprintf('OC-%d-%04d', $year, $count);
            }
        });
    }

    /* ── Relacionamentos ─────────────────────────────── */

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(PurchaseOrderItem::class)->with('rawMaterial');
    }

    /* ── Accessors ───────────────────────────────────── */

    public function getStatusLabelAttribute(): string
    {
        return self::STATUS_LABELS[$this->attributes['status']] ?? $this->attributes['status'];
    }

    /** Variação de preço real vs planejado */
    public function getPriceVarianceAttribute(): ?float
    {
        if ($this->total_actual === null) {
            return null;
        }
        return round($this->total_actual - $this->total_planned, 2);
    }

    /** Indica se passou do prazo esperado sem ser recebida */
    public function getIsOverdueAttribute(): bool
    {
        if (!$this->expected_at || in_array($this->status, ['received', 'cancelled'])) {
            return false;
        }
        return $this->expected_at->isPast();
    }
}
