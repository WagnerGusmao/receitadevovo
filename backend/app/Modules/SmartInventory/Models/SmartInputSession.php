<?php

namespace App\Modules\SmartInventory\Models;

use App\Modules\Auth\Models\User;
use App\Modules\Inventory\Models\Supplier;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SmartInputSession extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'status',
        'document_type',
        'document_path',
        'document_original_name',
        'raw_ocr_text',
        'parsed_json',
        'supplier_id',
        'supplier_name_raw',
        'purchase_date',
        'document_number',
        'total_value',
        'error_message',
        'notes',
        'confirmed_at',
    ];

    protected $casts = [
        'parsed_json'   => 'array',
        'purchase_date' => 'date',
        'confirmed_at'  => 'datetime',
        'total_value'   => 'float',
    ];

    protected $appends = ['status_label', 'items_count', 'confirmed_items_count'];

    const STATUS_LABELS = [
        'pending'      => 'Aguardando',
        'processing'   => 'Processando IA',
        'needs_review' => 'Aguardando Revisão',
        'confirmed'    => 'Confirmado',
        'completed'    => 'Concluído',
        'failed'       => 'Falhou',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(SmartInputItem::class, 'session_id');
    }

    public function getStatusLabelAttribute(): string
    {
        return self::STATUS_LABELS[$this->status] ?? $this->status;
    }

    public function getItemsCountAttribute(): int
    {
        if (array_key_exists('items_count', $this->attributes)) {
            return (int) $this->attributes['items_count'];
        }
        return $this->items()->count();
    }

    public function getConfirmedItemsCountAttribute(): int
    {
        if (array_key_exists('confirmed_items_count', $this->attributes)) {
            return (int) $this->attributes['confirmed_items_count'];
        }
        return $this->items()->where('is_confirmed', true)->count();
    }

    public function canBeConfirmed(): bool
    {
        return $this->status === 'needs_review';
    }

    public function isProcessing(): bool
    {
        return in_array($this->status, ['pending', 'processing']);
    }
}
