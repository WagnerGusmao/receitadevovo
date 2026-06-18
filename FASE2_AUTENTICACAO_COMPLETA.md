# FASE 2 - AUTENTICAÇÃO & CHECKOUT COMPLETO

**Data de Início**: 15/05/2026  
**Prioridade**: ALTA  
**Status**: Planejado

---

## 🎯 OBJETIVO

Implementar sistema completo de autenticação e checkout com:
- ✅ WhatsApp no cadastro (marketing e comunicação)
- ✅ Dados completos para entrega
- ✅ CPF para emissão de NFe
- ✅ Múltiplos endereços salvos
- ✅ Integração com ViaCEP

---

## 📊 ANÁLISE DO NEGÓCIO

### **Por que WhatsApp no Cadastro?**

1. **Marketing Direto** 📱
   - Campanhas via WhatsApp Business
   - Taxa de abertura 98% vs 20% email
   - Comunicação instantânea

2. **Experiência do Cliente** 💬
   - Notificações de pedido em tempo real
   - Suporte rápido
   - Recuperação de carrinho
   - Confirmações de entrega

3. **Conversão** 🎯
   - Reduz abandono de carrinho
   - Follow-up personalizado
   - Promoções exclusivas

### **Por que 2 Etapas (Cadastro + Checkout)?**

**✅ Vantagens:**
- Reduz fricção inicial (3 campos → 4 campos vs 12 campos)
- Captura lead cedo (email + WhatsApp)
- Usuário pode navegar sem compromisso
- Pede dados sensíveis só quando necessário
- Melhor taxa de conversão

**❌ Evita:**
- Abandono de cadastro
- Formulário intimidador
- Perda de leads

---

## 🗄️ ESTRUTURA DE DADOS

### **1. Users (Atualizado)**

```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    whatsapp VARCHAR(20) NOT NULL,           -- ⭐ NOVO
    phone VARCHAR(20) NULL,                   -- ⭐ NOVO (opcional)
    cpf VARCHAR(14) NULL,                     -- ⭐ NOVO (obrigatório no checkout)
    email_verified_at TIMESTAMP NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_whatsapp (whatsapp),
    INDEX idx_cpf (cpf)
);
```

---

### **2. Addresses (Nova Tabela)**

```sql
CREATE TABLE addresses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    label VARCHAR(50) NOT NULL,              -- "Casa", "Trabalho", etc
    cep VARCHAR(9) NOT NULL,
    street VARCHAR(255) NOT NULL,
    number VARCHAR(20) NOT NULL,
    complement VARCHAR(255) NULL,
    neighborhood VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    reference VARCHAR(255) NULL,             -- Ponto de referência
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_cep (cep),
    INDEX idx_is_default (is_default)
);
```

---

### **3. Orders (Snapshot de Dados)**

```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    
    -- Snapshot dos dados do cliente (momento da compra)
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_whatsapp VARCHAR(20) NOT NULL,
    customer_cpf VARCHAR(14) NOT NULL,
    
    -- Snapshot do endereço de entrega
    delivery_cep VARCHAR(9) NOT NULL,
    delivery_street VARCHAR(255) NOT NULL,
    delivery_number VARCHAR(20) NOT NULL,
    delivery_complement VARCHAR(255) NULL,
    delivery_neighborhood VARCHAR(100) NOT NULL,
    delivery_city VARCHAR(100) NOT NULL,
    delivery_state VARCHAR(2) NOT NULL,
    delivery_reference VARCHAR(255) NULL,
    
    -- Dados do pedido
    subtotal DECIMAL(10, 2) NOT NULL,
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    
    status ENUM('pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    payment_method VARCHAR(50) NULL,
    payment_status ENUM('pending', 'approved', 'rejected', 'refunded') DEFAULT 'pending',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

---

## 🔧 IMPLEMENTAÇÃO BACKEND

### **Migration 1: Adicionar Campos ao User**

```php
<?php
// database/migrations/2026_05_15_add_personal_data_to_users.php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('whatsapp', 20)->after('email');
            $table->string('phone', 20)->nullable()->after('whatsapp');
            $table->string('cpf', 14)->nullable()->after('phone');
            
            $table->index('whatsapp');
            $table->index('cpf');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['whatsapp']);
            $table->dropIndex(['cpf']);
            $table->dropColumn(['whatsapp', 'phone', 'cpf']);
        });
    }
};
```

---

### **Migration 2: Criar Tabela Addresses**

```php
<?php
// database/migrations/2026_05_15_create_addresses_table.php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('addresses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('label', 50);
            $table->string('cep', 9);
            $table->string('street');
            $table->string('number', 20);
            $table->string('complement')->nullable();
            $table->string('neighborhood', 100);
            $table->string('city', 100);
            $table->string('state', 2);
            $table->string('reference')->nullable();
            $table->boolean('is_default')->default(false);
            $table->timestamps();
            
            $table->index(['user_id', 'is_default']);
            $table->index('cep');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('addresses');
    }
};
```

---

### **Atualizar User Model**

```php
<?php
// backend/app/Modules/Auth/Models/User.php

namespace App\Modules\Auth\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    protected $fillable = [
        'name',
        'email',
        'password',
        'whatsapp',    // ⭐ NOVO
        'phone',       // ⭐ NOVO
        'cpf',         // ⭐ NOVO
        'is_admin',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'is_admin' => 'boolean',
    ];

    // Relacionamento
    public function addresses()
    {
        return $this->hasMany(Address::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    // Acessor para WhatsApp formatado
    public function getFormattedWhatsappAttribute(): string
    {
        // (00) 00000-0000
        return preg_replace('/^(\d{2})(\d{5})(\d{4})$/', '($1) $2-$3', $this->whatsapp);
    }

    // Acessor para CPF formatado
    public function getFormattedCpfAttribute(): ?string
    {
        if (!$this->cpf) return null;
        // 000.000.000-00
        return preg_replace('/^(\d{3})(\d{3})(\d{3})(\d{2})$/', '$1.$2.$3-$4', $this->cpf);
    }
}
```

---

### **Criar Address Model**

```php
<?php
// backend/app/Modules/Ecommerce/Models/Address.php

namespace App\Modules\Ecommerce\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use App\Modules\Auth\Models\User;

class Address extends Model
{
    protected $fillable = [
        'user_id',
        'label',
        'cep',
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
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Formatar endereço completo
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

    // CEP formatado
    public function getFormattedCepAttribute(): string
    {
        return preg_replace('/^(\d{5})(\d{3})$/', '$1-$2', $this->cep);
    }

    // Ao criar/atualizar como padrão, desmarcar outros
    protected static function booted()
    {
        static::saving(function (Address $address) {
            if ($address->is_default) {
                static::where('user_id', $address->user_id)
                    ->where('id', '!=', $address->id)
                    ->update(['is_default' => false]);
            }
        });
    }
}
```

---

### **Atualizar AuthController**

```php
<?php
// backend/app/Modules/Auth/Controllers/AuthController.php

public function register(Request $request)
{
    $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'whatsapp' => [                                    // ⭐ NOVO
            'required',
            'string',
            'regex:/^\d{10,11}$/',                        // 10 ou 11 dígitos
            'unique:users'
        ],
        'password' => 'required|string|min:8|confirmed',
    ], [
        'whatsapp.regex' => 'WhatsApp deve conter 10 ou 11 dígitos (apenas números)',
        'whatsapp.unique' => 'Este WhatsApp já está cadastrado',
    ]);

    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'whatsapp' => preg_replace('/\D/', '', $request->whatsapp),  // Remove formatação
        'password' => Hash::make($request->password),
    ]);

    $token = $user->createToken('auth_token')->plainTextToken;

    return $this->success([
        'user' => $user,
        'access_token' => $token,
        'token_type' => 'Bearer',
    ], 'Usuário registrado com sucesso', 201);
}
```

---

## 🎨 IMPLEMENTAÇÃO FRONTEND

### **Página de Registro Atualizada**

```tsx
"use client"

import { useState } from 'react';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';
import { toast } from '@/lib/toast';

export default function RegisterPage() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    whatsapp: '',        // ⭐ NOVO
    password: '',
    password_confirmation: '',
  });

  // Máscara de WhatsApp
  const formatWhatsApp = (value: string) => {
    const cleaned = value.replace(/\D/g, '');
    if (cleaned.length <= 10) {
      return cleaned.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
    }
    return cleaned.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
  };

  const handleWhatsAppChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatWhatsApp(e.target.value);
    setFormData({ ...formData, whatsapp: formatted });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Remove formatação do WhatsApp
    const whatsappDigits = formData.whatsapp.replace(/\D/g, '');
    
    try {
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...formData,
          whatsapp: whatsappDigits
        })
      });

      const data = await response.json();

      if (response.ok) {
        toast.success('Cadastro realizado!', 'Bem-vindo à Receita de Vovó');
        // Redirecionar...
      } else {
        toast.error('Erro no cadastro', data.message);
      }
    } catch (error) {
      toast.error('Erro', 'Não foi possível completar o cadastro');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 max-w-md mx-auto">
      <div>
        <Label htmlFor="name" required>Nome Completo</Label>
        <Input 
          id="name"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          placeholder="Maria Silva"
        />
      </div>

      <div>
        <Label htmlFor="email" required>Email</Label>
        <Input 
          id="email"
          type="email"
          value={formData.email}
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          placeholder="maria@exemplo.com"
        />
      </div>

      <div>
        <Label htmlFor="whatsapp" required>WhatsApp</Label>
        <Input 
          id="whatsapp"
          value={formData.whatsapp}
          onChange={handleWhatsAppChange}
          placeholder="(00) 00000-0000"
          maxLength={15}
        />
        <p className="text-sm text-marrom-suave mt-1">
          Usado para notificações de pedidos e suporte
        </p>
      </div>

      <div>
        <Label htmlFor="password" required>Senha</Label>
        <Input 
          id="password"
          type="password"
          value={formData.password}
          onChange={(e) => setFormData({ ...formData, password: e.target.value })}
          placeholder="Mínimo 8 caracteres"
        />
      </div>

      <div>
        <Label htmlFor="password_confirmation" required>Confirmar Senha</Label>
        <Input 
          id="password_confirmation"
          type="password"
          value={formData.password_confirmation}
          onChange={(e) => setFormData({ ...formData, password_confirmation: e.target.value })}
        />
      </div>

      <Button type="submit" variant="sage" className="w-full">
        Criar Conta
      </Button>
    </form>
  );
}
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Backend:**
- [ ] Migration: Adicionar campos ao User
- [ ] Migration: Criar tabela Addresses
- [ ] Model: Atualizar User com novos campos
- [ ] Model: Criar Address
- [ ] Controller: Atualizar AuthController
- [ ] Controller: Criar AddressController
- [ ] Routes: Adicionar rotas de endereço
- [ ] Validação: CPF, WhatsApp, CEP

### **Frontend:**
- [ ] Página: Registro com WhatsApp
- [ ] Página: Checkout com endereço
- [ ] Página: Perfil - gerenciar endereços
- [ ] Componente: Máscara de WhatsApp
- [ ] Componente: Máscara de CPF
- [ ] Componente: Busca de CEP (ViaCEP)
- [ ] Componente: Formulário de endereço
- [ ] Validação: Todos os campos

---

## 🎯 PRIORIDADE DE IMPLEMENTAÇÃO

**Imediato (Fase 2A):**
1. ✅ WhatsApp no cadastro
2. ✅ Migration User
3. ✅ Atualizar frontend de registro

**Após (Fase 2B):**
4. ✅ Tabela Addresses
5. ✅ Formulário de checkout
6. ✅ Busca de CEP
7. ✅ Gerenciamento de endereços

---

**Quer que eu implemente isso agora?** 🚀
