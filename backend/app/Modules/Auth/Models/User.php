<?php

namespace App\Modules\Auth\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

use App\Infrastructure\Casts\SafeEncrypted;

#[Fillable(['name', 'email', 'password', 'whatsapp', 'phone', 'cpf', 'is_admin', 'is_active', 'avatar_path', 'google_id', 'consent_accepted_at', 'privacy_policy_version'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    protected $appends = [
        'formatted_whatsapp',
        'formatted_cpf',
        'formatted_phone',
        'loyalty_points_balance',
        'loyalty_lifetime_points',
        'loyalty_level'
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string|object>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_admin' => 'boolean',
            'is_active' => 'boolean',
            'cpf' => SafeEncrypted::class,
            'whatsapp' => SafeEncrypted::class,
            'phone' => SafeEncrypted::class,
            'consent_accepted_at' => 'datetime',
        ];
    }

    /**
     * Get formatted WhatsApp number.
     * Format: (00) 00000-0000
     */
    public function getFormattedWhatsappAttribute(): string
    {
        if (!$this->whatsapp) {
            return '';
        }
        
        $cleaned = preg_replace('/\D/', '', $this->whatsapp);
        
        if (strlen($cleaned) === 11) {
            return preg_replace('/^(\d{2})(\d{5})(\d{4})$/', '($1) $2-$3', $cleaned);
        } elseif (strlen($cleaned) === 10) {
            return preg_replace('/^(\d{2})(\d{4})(\d{4})$/', '($1) $2-$3', $cleaned);
        }
        
        return $this->whatsapp;
    }

    /**
     * Get formatted CPF.
     * Format: 000.000.000-00
     */
    public function getFormattedCpfAttribute(): ?string
    {
        if (!$this->cpf) {
            return null;
        }
        
        $cleaned = preg_replace('/\D/', '', $this->cpf);
        
        if (strlen($cleaned) === 11) {
            return preg_replace('/^(\d{3})(\d{3})(\d{3})(\d{2})$/', '$1.$2.$3-$4', $cleaned);
        }
        
        return $this->cpf;
    }

    /**
     * Get formatted phone number.
     * Format: (00) 0000-0000
     */
    public function getFormattedPhoneAttribute(): ?string
    {
        if (!$this->phone) {
            return null;
        }
        
        $cleaned = preg_replace('/\D/', '', $this->phone);
        
        if (strlen($cleaned) === 10) {
            return preg_replace('/^(\d{2})(\d{4})(\d{4})$/', '($1) $2-$3', $cleaned);
        }
        
        return $this->phone;
    }

    /**
     * Get user addresses.
     */
    public function addresses()
    {
        return $this->hasMany(\App\Modules\Ecommerce\Models\Address::class);
    }

    /**
     * Get user orders.
     */
    public function orders()
    {
        return $this->hasMany(\App\Modules\Ecommerce\Models\Order::class);
    }

    /**
     * Get loyalty transactions.
     */
    public function loyaltyTransactions()
    {
        return $this->hasMany(\App\Modules\Rewards\Models\LoyaltyTransaction::class);
    }

    /**
     * Get loyalty redemptions.
     */
    public function loyaltyRedemptions()
    {
        return $this->hasMany(\App\Modules\Rewards\Models\LoyaltyRedemption::class);
    }

    /**
     * Get active loyalty points balance.
     */
    public function getLoyaltyPointsBalanceAttribute(): int
    {
        return (int) $this->loyaltyTransactions()->sum('points');
    }

    /**
     * Get lifetime loyalty points earned.
     */
    public function getLoyaltyLifetimePointsAttribute(): int
    {
        return (int) $this->loyaltyTransactions()->where('points', '>', 0)->sum('points');
    }

    /**
     * Get current loyalty level.
     */
    public function getLoyaltyLevelAttribute()
    {
        $lifetimePoints = $this->loyalty_lifetime_points;
        return \App\Modules\Rewards\Models\LoyaltyLevel::where('min_points', '<=', $lifetimePoints)
            ->orderBy('min_points', 'desc')
            ->first();
    }
}
