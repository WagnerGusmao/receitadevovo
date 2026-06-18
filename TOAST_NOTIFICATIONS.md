# TOAST/NOTIFICATIONS - FASE 1

**Data**: 15/05/2026  
**Status**: ✅ Implementado com Paleta Oficial

---

## 🔔 SISTEMA DE NOTIFICAÇÕES

Sistema completo de Toast/Notifications usando **Sonner** com a paleta da Receita de Vovó.

---

## 📦 ARQUIVOS CRIADOS

```
frontend/src/
├── components/ui/
│   └── sonner.tsx              ✅ Componente Toaster
├── lib/
│   └── toast.ts                ✅ Helpers de toast
└── app/
    ├── layout.tsx              ✅ Toaster adicionado
    └── (shop)/exemplos/
        └── page.tsx            ✅ Página de testes
```

---

## 🎨 TIPOS DE TOAST

### 1. **Success** (Sucesso) ✅

**Uso**: Ações bem-sucedidas
**Cor**: Verde (success)
**Ícone**: CheckCircle2

```tsx
import { toast } from '@/lib/toast';

toast.success("Ação concluída!", "Seu produto foi adicionado ao carrinho.");
```

**Exemplo visual**:
```
┌─────────────────────────────────────┐
│ ✓  Ação concluída!                  │
│    Seu produto foi adicionado       │
│                               5s    │
└─────────────────────────────────────┘
```

---

### 2. **Error** (Erro) ❌

**Uso**: Erros e problemas
**Cor**: Vermelho (error)
**Ícone**: XCircle

```tsx
toast.error("Erro ao processar", "Não foi possível salvar. Tente novamente.");
```

**Exemplo visual**:
```
┌─────────────────────────────────────┐
│ ✗  Erro ao processar                │
│    Não foi possível salvar...       │
│                               5s    │
└─────────────────────────────────────┘
```

---

### 3. **Warning** (Aviso) ⚠️

**Uso**: Alertas e avisos
**Cor**: Dourado (warning)
**Ícone**: AlertCircle

```tsx
toast.warning("Atenção!", "Seu estoque está acabando.");
```

**Exemplo visual**:
```
┌─────────────────────────────────────┐
│ ⚠  Atenção!                         │
│    Seu estoque está acabando        │
│                               5s    │
└─────────────────────────────────────┘
```

---

### 4. **Info** (Informação) ℹ️

**Uso**: Mensagens informativas
**Cor**: Sage (info)
**Ícone**: Info

```tsx
toast.info("Informação", "Você tem 3 novos pedidos.");
```

**Exemplo visual**:
```
┌─────────────────────────────────────┐
│ ℹ  Informação                       │
│    Você tem 3 novos pedidos         │
│                               5s    │
└─────────────────────────────────────┘
```

---

### 5. **Promise** (Loading/Async) ⏳

**Uso**: Operações assíncronas
**Estados**: Loading → Success/Error
**Ícones**: Loader → CheckCircle/XCircle

```tsx
const promise = fetch('/api/save');

toast.promise(promise, {
  loading: "Salvando dados...",
  success: "Dados salvos com sucesso!",
  error: "Erro ao salvar dados",
});
```

**Exemplo visual**:
```
// Estado: Loading
┌─────────────────────────────────────┐
│ ⏳ Salvando dados...                │
└─────────────────────────────────────┘

// Estado: Success
┌─────────────────────────────────────┐
│ ✓  Dados salvos com sucesso!        │
│                               5s    │
└─────────────────────────────────────┘
```

---

## 🎯 API COMPLETA

### **Helper Functions**

```tsx
import { toast } from '@/lib/toast';

// Success
toast.success(message: string, description?: string)

// Error
toast.error(message: string, description?: string)

// Warning
toast.warning(message: string, description?: string)

// Info
toast.info(message: string, description?: string)

// Promise
toast.promise(promise, {
  loading: string,
  success: string | ((data) => string),
  error: string | ((error) => string)
})

// Custom
toast.custom(message: string, options?: any)

// Dismiss
toast.dismiss(toastId?: string | number)
```

---

## 📋 EXEMPLOS PRÁTICOS

### **1. Adicionar ao Carrinho**

```tsx
"use client"

import { toast } from '@/lib/toast';
import { Button } from '@/components/ui/button';

export function AddToCartButton({ productId }: { productId: string }) {
  const handleAddToCart = async () => {
    const promise = fetch(`/api/cart/add`, {
      method: 'POST',
      body: JSON.stringify({ productId })
    });

    toast.promise(promise, {
      loading: "Adicionando ao carrinho...",
      success: "Produto adicionado com sucesso!",
      error: "Erro ao adicionar produto",
    });
  };

  return (
    <Button variant="sage" onClick={handleAddToCart}>
      Adicionar ao Carrinho
    </Button>
  );
}
```

---

### **2. Formulário de Contato**

```tsx
"use client"

import { toast } from '@/lib/toast';
import { useState } from 'react';

export function ContatoForm() {
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch('/api/contato', {
        method: 'POST',
        // ... dados do formulário
      });

      if (response.ok) {
        toast.success(
          "Mensagem enviada!",
          "Entraremos em contato em breve."
        );
      } else {
        throw new Error();
      }
    } catch (error) {
      toast.error(
        "Erro ao enviar",
        "Não foi possível enviar sua mensagem. Tente novamente."
      );
    } finally {
      setLoading(false);
    }
  };

  return <form onSubmit={handleSubmit}>...</form>;
}
```

---

### **3. Validação de Estoque**

```tsx
"use client"

import { toast } from '@/lib/toast';
import { useEffect } from 'react';

export function EstoqueMonitor({ quantidade }: { quantidade: number }) {
  useEffect(() => {
    if (quantidade < 10) {
      toast.warning(
        "Estoque baixo!",
        `Apenas ${quantidade} unidades restantes.`
      );
    }
  }, [quantidade]);

  return null;
}
```

---

### **4. Copiar para Área de Transferência**

```tsx
"use client"

import { toast } from '@/lib/toast';
import { Button } from '@/components/ui/button';

export function CopyButton({ text }: { text: string }) {
  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(text);
      toast.success("Copiado!", "Texto copiado para área de transferência.");
    } catch (error) {
      toast.error("Erro", "Não foi possível copiar o texto.");
    }
  };

  return <Button onClick={handleCopy}>Copiar</Button>;
}
```

---

## 🎨 CUSTOMIZAÇÃO

### **Posição**

O Toaster está configurado em `top-right` por padrão. Para mudar:

```tsx
// src/components/ui/sonner.tsx
<Sonner
  position="top-right"  // top-left, top-center, bottom-left, etc
  ...
/>
```

### **Duração**

```tsx
toast.success("Mensagem", {
  duration: 3000  // 3 segundos
});
```

### **Com Ação**

```tsx
toast.success("Produto removido", {
  action: {
    label: "Desfazer",
    onClick: () => {
      // Restaurar produto
    }
  }
});
```

---

## ✅ FEATURES IMPLEMENTADAS

- [x] 4 tipos de toast (success, error, warning, info)
- [x] Toast com promise (loading states)
- [x] Paleta oficial aplicada
- [x] Ícones lucide-react
- [x] Posição top-right
- [x] Animações suaves
- [x] Dismiss automático
- [x] Helpers tipados
- [x] Página de exemplos

---

## 📦 DEPENDÊNCIAS

**Necessário instalar**:

```bash
npm install sonner
```

**Já instaladas**:
- lucide-react
- tailwindcss

---

## 🧪 TESTAR

1. **Inicie o servidor**:
```bash
npm run dev
```

2. **Acesse a página de exemplos**:
```
http://localhost:3000/exemplos
```

3. **Clique nos botões** para ver cada tipo de toast!

---

## 📚 INTEGRAÇÃO

### **Adicionar ao seu componente**:

```tsx
"use client"

import { toast } from '@/lib/toast';

export function MeuComponente() {
  return (
    <button onClick={() => toast.success("Funcionou!")}>
      Clique aqui
    </button>
  );
}
```

### **Já está no layout**:

O `<Toaster />` já foi adicionado em `src/app/layout.tsx`, então funciona em **toda a aplicação**!

---

## 🎯 PRÓXIMOS PASSOS

**Opção 2 - Checkbox & Radio** (Próxima etapa)

---

**Status**: Toast/Notifications Completo ✅  
**Qualidade**: Produção pronta 🚀  
**Teste**: http://localhost:3000/exemplos 🧪

---

**Última atualização**: 15/05/2026
