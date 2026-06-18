<?php

namespace App\Modules\Ecommerce\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use App\Infrastructure\Casts\SafeEncrypted;
use App\Modules\Auth\Models\User;

class Address extends Model
{
    protected $fillable = [
        'user_id',
        'label',
        'recipient_name',
        'cpf',
        'phone',
        'zipcode',
        'cep', // Manter compatibilidade
        'street',
        'number',
        'complement',
        'neighborhood',
        'city',
        'state',
        'reference',
        'is_default',
    ];

    protected $casts = [
        'is_default' => 'boolean',
        'recipient_name' => SafeEncrypted::class,
        'cpf' => SafeEncrypted::class,
        'phone' => SafeEncrypted::class,
        'street' => SafeEncrypted::class,
        'number' => SafeEncrypted::class,
        'complement' => SafeEncrypted::class,
        'neighborhood' => SafeEncrypted::class,
        'reference' => SafeEncrypted::class,
    ];

    protected $appends = [
        'formatted_zipcode',
        'formatted_cpf',
        'formatted_phone',
        'full_address',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the formatted full address string.
     */
    public function getFullAddressAttribute(): string
    {
        $parts = [
            $this->street,
            $this->number,
            $this->complement,
            $this->neighborhood,
            "{$this->city} - {$this->state}",
            "CEP: {$this->formatted_cep}"
        ];

        return implode(', ', array_filter($parts));
    }

    /**
     * Get the formatted CEP (00000-000).
     */
    public function getFormattedCepAttribute(): string
    {
        $cep = preg_replace('/\D/', '', $this->cep ?? $this->zipcode);
        return preg_replace('/^(\d{5})(\d{3})$/', '$1-$2', $cep);
    }

    /**
     * Get the formatted zipcode (00000-000).
     */
    public function getFormattedZipcodeAttribute(): string
    {
        $zipcode = preg_replace('/\D/', '', $this->zipcode ?? $this->cep);
        return preg_replace('/^(\d{5})(\d{3})$/', '$1-$2', $zipcode);
    }

    /**
     * Get the formatted CPF (000.000.000-00).
     */
    public function getFormattedCpfAttribute(): ?string
    {
        if (!$this->cpf) {
            return null;
        }
        
        $cpf = preg_replace('/\D/', '', $this->cpf);
        return preg_replace('/^(\d{3})(\d{3})(\d{3})(\d{2})$/', '$1.$2.$3-$4', $cpf);
    }

    /**
     * Get the formatted phone.
     */
    public function getFormattedPhoneAttribute(): ?string
    {
        if (!$this->phone) {
            return null;
        }
        
        $phone = preg_replace('/\D/', '', $this->phone);
        
        // Celular (11 dígitos): (00) 00000-0000
        if (strlen($phone) === 11) {
            return preg_replace('/^(\d{2})(\d{5})(\d{4})$/', '($1) $2-$3', $phone);
        }
        
        // Fixo (10 dígitos): (00) 0000-0000
        if (strlen($phone) === 10) {
            return preg_replace('/^(\d{2})(\d{4})(\d{4})$/', '($1) $2-$3', $phone);
        }
        
        return $phone;
    }

    /**
     * Boot the model to handle default address logic.
     */
    protected static function booted()
    {
        static::saving(function (Address $address) {
            // Garantir que zipcode e cep estejam sincronizados
            if ($address->zipcode && !$address->cep) {
                $address->cep = $address->zipcode;
            } elseif ($address->cep && !$address->zipcode) {
                $address->zipcode = $address->cep;
            }
            
            // If this is set as default, unset all other addresses for this user as default
            if ($address->is_default) {
                static::where('user_id', $address->user_id)
                    ->where('id', '!=', $address->id)
                    ->update(['is_default' => false]);
            }
        });
    }
}
