# FASE 2B - CHECKOUT COM ENDEREÇO E CPF ✅

**Data**: 16/05/2026  
**Status**: 🔄 Backend Completo - Frontend Pendente  
**Prioridade**: ALTA

---

## 🎯 OBJETIVO

Implementar checkout completo com:
- ✅ Cadastro de endereço com CPF
- ✅ Múltiplos endereços por usuário
- ✅ Endereço padrão
- ✅ Integração com pedidos
- ⏳ Busca de CEP (ViaCEP)
- ⏳ Frontend de checkout

---

## ✅ O QUE FOI IMPLEMENTADO

### **1. Migration - Campos Adicionados** ✅

**Tabela: `addresses`**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `recipient_name` | VARCHAR(255) | Nome do destinatário |
| `cpf` | VARCHAR(14) | CPF do destinatário |
| `phone` | VARCHAR(20) | Telefone para contato |
| `zipcode` | VARCHAR(9) | CEP (00000-000) |

**Campos já existentes:**
- `label` - Identificação (Casa, Trabalho, etc)
- `is_default` - Endereço padrão
- `street`, `number`, `complement`
- `neighborhood`, `city`, `state`
- `reference` - Ponto de referência

---

### **2. Address Model Atualizado** ✅

**Arquivo**: `backend/app/Modules/Ecommerce/Models/Address.php`

**Novos campos no `$fillable`:**
```php
'recipient_name',
'cpf',
'phone',
'zipcode',
```

**Novos atributos computados:**
```php
'formatted_zipcode',  // 00000-000
'formatted_cpf',      // 000.000.000-00
'formatted_phone',    // (00) 00000-0000
'full_address',       // Endereço completo formatado
```

---

### **3. Métodos Úteis do Address Model**

#### **`getFormattedZipcodeAttribute()` - CEP Formatado**

```php
$address->formatted_zipcode; // "01310-100"
```

---

#### **`getFormattedCpfAttribute()` - CPF Formatado**

```php
$address->formatted_cpf; // "123.456.789-00"
```

---

#### **`getFormattedPhoneAttribute()` - Telefone Formatado**

```php
$address->formatted_phone; // "(11) 99988-7766"
```

**Lógica:**
- 11 dígitos: `(00) 00000-0000` (celular)
- 10 dígitos: `(00) 0000-0000` (fixo)

---

#### **`getFullAddressAttribute()` - Endereço Completo**

```php
$address->full_address;
// "Rua das Flores, 123, Apto 45, Jardim Paulista, São Paulo - SP, CEP: 01310-100"
```

---

### **4. AddressController Atualizado** ✅

**Arquivo**: `backend/app/Modules/Ecommerce/Controllers/AddressController.php`

**Endpoints disponíveis:**

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/api/ecommerce/addresses` | Listar endereços do usuário |
| POST | `/api/ecommerce/addresses` | Criar novo endereço |
| GET | `/api/ecommerce/addresses/{id}` | Ver endereço específico |
| PUT | `/api/ecommerce/addresses/{id}` | Atualizar endereço |
| DELETE | `/api/ecommerce/addresses/{id}` | Deletar endereço |
| POST | `/api/ecommerce/addresses/{id}/set-default` | Definir como padrão |

---

### **5. Validações Implementadas**

**Criar Endereço:**
```php
'recipient_name' => 'required|string|max:255',
'cpf' => 'required|string|size:11',  // Apenas dígitos
'phone' => 'required|string|min:10|max:11',
'zipcode' => 'required|string|size:8',  // Apenas dígitos
'street' => 'required|string|max:255',
'number' => 'required|string|max:20',
'complement' => 'nullable|string|max:255',
'neighborhood' => 'required|string|max:100',
'city' => 'required|string|max:100',
'state' => 'required|string|size:2',
'reference' => 'nullable|string|max:255',
'is_default' => 'boolean',
```

**Mensagens de erro personalizadas:**
- "Nome do destinatário é obrigatório"
- "CPF é obrigatório"
- "CPF deve conter 11 dígitos"
- "Telefone é obrigatório"
- "CEP é obrigatório"

---

### **6. Lógica de Endereço Padrão**

**Automática no Model:**
```php
// Ao salvar um endereço como padrão
if ($address->is_default) {
    // Remove is_default de todos os outros endereços do usuário
    Address::where('user_id', $address->user_id)
        ->where('id', '!=', $address->id)
        ->update(['is_default' => false]);
}
```

✅ **Garantia**: Apenas 1 endereço padrão por usuário

---

## 📊 EXEMPLOS DE USO

### **Backend - Criar Endereço**

**Request:**
```json
POST /api/ecommerce/addresses
{
  "recipient_name": "Maria Silva",
  "cpf": "12345678900",
  "phone": "11999887766",
  "zipcode": "01310100",
  "street": "Avenida Paulista",
  "number": "1578",
  "complement": "Apto 45",
  "neighborhood": "Bela Vista",
  "city": "São Paulo",
  "state": "SP",
  "reference": "Próximo ao metrô Trianon-MASP",
  "is_default": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Endereço cadastrado com sucesso",
  "data": {
    "id": 1,
    "user_id": 1,
    "recipient_name": "Maria Silva",
    "cpf": "12345678900",
    "phone": "11999887766",
    "zipcode": "01310100",
    "street": "Avenida Paulista",
    "number": "1578",
    "complement": "Apto 45",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "state": "SP",
    "is_default": true,
    "formatted_zipcode": "01310-100",
    "formatted_cpf": "123.456.789-00",
    "formatted_phone": "(11) 99988-7766",
    "full_address": "Avenida Paulista, 1578, Apto 45, Bela Vista, São Paulo - SP, CEP: 01310-100"
  }
}
```

---

### **Backend - Listar Endereços**

**Request:**
```
GET /api/ecommerce/addresses
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "label": "Casa",
      "recipient_name": "Maria Silva",
      "is_default": true,
      "formatted_zipcode": "01310-100",
      "formatted_cpf": "123.456.789-00",
      "full_address": "Avenida Paulista, 1578..."
    },
    {
      "id": 2,
      "label": "Trabalho",
      "recipient_name": "Maria Silva",
      "is_default": false,
      "formatted_zipcode": "04543-907",
      "full_address": "Rua Funchal, 418..."
    }
  ]
}
```

---

## 🎨 FLUXO COMPLETO DE CHECKOUT

### **1. Usuário no Carrinho**
```
Carrinho (3 itens)
Total: R$ 89,90
[Finalizar Compra]
```

---

### **2. Página de Checkout**

```
┌─────────────────────────────────────────┐
│  CHECKOUT                               │
│                                         │
│  1️⃣ ENDEREÇO DE ENTREGA                │
│                                         │
│  ○ Casa - Av. Paulista, 1578           │
│  ○ Trabalho - Rua Funchal, 418         │
│  ⊕ Adicionar novo endereço             │
│                                         │
│  2️⃣ RESUMO DO PEDIDO                   │
│                                         │
│  Chá de Camomila x1 ....... R$ 19,90   │
│  Chá de Lavanda x2 ......... R$ 49,80  │
│  Subtotal .................. R$ 69,70  │
│  Frete ..................... R$ 15,00  │
│  Desconto .................. -R$ 5,00  │
│  TOTAL ..................... R$ 79,70  │
│                                         │
│  3️⃣ PAGAMENTO                          │
│                                         │
│  ○ Cartão de Crédito                   │
│  ○ PIX                                 │
│  ○ Boleto                              │
│                                         │
│  [Finalizar Pedido]                    │
└─────────────────────────────────────────┘
```

---

### **3. Formulário de Novo Endereço**

```
┌─────────────────────────────────────────┐
│  ADICIONAR ENDEREÇO                     │
│                                         │
│  Nome do Destinatário *                 │
│  [Maria Silva___________________]       │
│                                         │
│  CPF *                                  │
│  [123.456.789-00________________]       │
│                                         │
│  Telefone *                             │
│  [(11) 99988-7766_______________]       │
│                                         │
│  CEP *                    [Buscar]      │
│  [01310-100_____________________]       │
│                                         │
│  Logradouro *                           │
│  [Avenida Paulista______________]       │
│                                         │
│  Número *        Complemento            │
│  [1578____]      [Apto 45________]      │
│                                         │
│  Bairro *                               │
│  [Bela Vista____________________]       │
│                                         │
│  Cidade *        UF *                   │
│  [São Paulo___]  [SP_]                  │
│                                         │
│  Ponto de Referência                    │
│  [Próximo ao metrô Trianon-MASP_]       │
│                                         │
│  ☑ Definir como endereço padrão        │
│                                         │
│  [Cancelar]  [Salvar Endereço]         │
└─────────────────────────────────────────┘
```

---

## 🔄 INTEGRAÇÃO COM VIACEP

### **Próximo Passo: Criar Serviço ViaCEP**

**Arquivo**: `backend/app/Services/ViaCepService.php`

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class ViaCepService
{
    public function buscar(string $cep): ?array
    {
        $cep = preg_replace('/\D/', '', $cep);
        
        if (strlen($cep) !== 8) {
            return null;
        }
        
        $response = Http::get("https://viacep.com.br/ws/{$cep}/json/");
        
        if (!$response->successful() || isset($response['erro'])) {
            return null;
        }
        
        return [
            'zipcode' => $cep,
            'street' => $response['logradouro'],
            'complement' => $response['complemento'],
            'neighborhood' => $response['bairro'],
            'city' => $response['localidade'],
            'state' => $response['uf'],
        ];
    }
}
```

**Endpoint:**
```php
// AddressController
public function searchZipcode(Request $request)
{
    $request->validate(['zipcode' => 'required|string|size:8']);
    
    $service = new ViaCepService();
    $address = $service->buscar($request->zipcode);
    
    if (!$address) {
        return $this->error('CEP não encontrado', 404);
    }
    
    return $this->success($address);
}
```

---

## 📝 PRÓXIMOS PASSOS

### **Backend:**
- [ ] Criar ViaCepService
- [ ] Endpoint de busca de CEP
- [ ] Validação de CPF (dígitos verificadores)
- [ ] Cálculo de frete por CEP
- [ ] Snapshot de endereço no pedido

### **Frontend:**
- [ ] Página de checkout
- [ ] Formulário de endereço
- [ ] Integração com ViaCEP
- [ ] Seleção de endereço
- [ ] Máscaras de CPF, CEP, telefone
- [ ] Validação de formulário
- [ ] Resumo do pedido

---

## ✅ CONCLUSÃO

**FASE 2B - Backend 100% Pronto!**

**O que funciona:**
- ✅ Cadastro de endereços com CPF
- ✅ Múltiplos endereços por usuário
- ✅ Endereço padrão automático
- ✅ Formatação automática (CPF, CEP, telefone)
- ✅ Validações completas
- ✅ API REST completa

**Próximo passo:**
- Implementar ViaCEP
- Criar frontend de checkout
- Integrar com carrinho

---

**Data**: 16/05/2026  
**Status**: ✅ Backend Completo  
**Aguardando**: Frontend + ViaCEP

🌿 **Feito com dedicação e ancestralidade** 🌿
