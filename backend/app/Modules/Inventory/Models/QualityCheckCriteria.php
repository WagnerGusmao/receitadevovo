<?php

namespace App\Modules\Inventory\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class QualityCheckCriteria extends Model
{
    protected $table = 'quality_check_criteria';

    protected $fillable = [
        'quality_check_id',
        'criterion',
        'criterion_label',
        'result',
        'measured_value',
        'notes',
    ];

    protected $appends = ['result_icon'];

    public function qualityCheck(): BelongsTo
    {
        return $this->belongsTo(QualityCheck::class);
    }

    public function getResultIconAttribute(): string
    {
        return match ($this->result) {
            'pass'        => '✅',
            'fail'        => '❌',
            'conditional' => '⚠️',
            default       => '—',
        };
    }
}
