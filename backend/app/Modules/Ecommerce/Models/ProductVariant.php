<?php

namespace App\Modules\Ecommerce\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductVariant extends Model
{
    protected $fillable = [
        'product_id',
        'name',
        'price',
        'old_price',
        'stock',
        'unit_cost',
        'sku',
        'volume',
        'volume_unit',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'old_price' => 'decimal:2',
        'unit_cost' => 'decimal:4',
        'volume' => 'decimal:3',
        'stock' => 'integer',
    ];

    /**
     * Relacionamento com o produto pai
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    /**
     * Accessor dinâmico para retornar o nome concatenado.
     * Ex: se o produto é "Body Splash" e o tamanho é "220ml", retorna "Body Splash - 220ml".
     * Isso mantém compatibilidade transparente com listagens de pedidos, notas, etc.
     */
    public function getNameAttribute($value): string
    {
        return $this->product ? ($this->product->name . ' - ' . $value) : $value;
    }
}
