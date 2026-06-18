# 🎨 PALETA DE CORES E LOGOS - RECEITA DE VOVÓ

**Baseado na análise dos logos oficiais**  
**Data**: 15/05/2026

---

## 📊 RESUMO EXECUTIVO

Analisamos os 4 logos da marca e extraímos uma paleta de cores oficial que transmite:
- ✨ **Natureza ancestral** - verdes e marrons terrosos
- 🤲 **Acolhimento** - tons quentes e convidativos  
- 🌿 **Elegância orgânica** - dourados suaves e beges naturais
- 💚 **Bem-estar natural** - cores calmantes e equilibradas

---

## 🎨 PALETA OFICIAL

### Cores Primárias (Do Logo)

| Cor | Hex | HSL | Uso Principal |
|-----|-----|-----|---------------|
| **Sage** | `#6B8E6F` | `hsl(127, 14%, 49%)` | Botões primários, destaques |
| **Terra** | `#4A1E1C` | `hsl(3, 45%, 20%)` | Texto principal, estrutura |
| **Dourado** | `#D4A574` | `hsl(31, 53%, 64%)` | CTAs especiais, acentos |

### Cores Secundárias

| Cor | Hex | HSL | Uso |
|-----|-----|-----|-----|
| **Folha** | `#7FA786` | `hsl(131, 18%, 58%)` | Backgrounds, cards |
| **Terracota** | `#A8614A` | `hsl(15, 39%, 47%)` | Alertas, badges |
| **Creme** | `#F5F1E8` | `hsl(42, 42%, 93%)` | Cards, seções |

### Neutros

| Cor | Hex | HSL | Uso |
|-----|-----|-----|-----|
| **Bege Light** | `#FAF8F3` | `hsl(43, 54%, 97%)` | Background geral |
| **Bege** | `#E8E2D5` | `hsl(41, 29%, 87%)` | Borders, divisores |
| **Marrom Suave** | `#8B6F47` | `hsl(35, 32%, 41%)` | Texto secundário |
| **Marrom Dark** | `#2C1810` | `hsl(17, 47%, 12%)` | Títulos importantes |

### Funcionais

| Cor | Nome | Hex | Uso |
|-----|------|-----|-----|
| 🟢 | Success | `#5A8F5E` | Confirmações |
| 🟡 | Warning | `#DAA520` | Avisos |
| 🔴 | Error | `#B34D3A` | Erros |
| 🔵 | Info | `#7BA3A0` | Informações |

---

## 🖼️ LOGOS ORGANIZADOS

Os 4 logos foram copiados e renomeados para uso otimizado:

### Estrutura de Arquivos

```
frontend/public/logos/
├── logo-icon.png        (favicon, ícones)
├── logo-badge.png       (selo circular completo)
├── logo-vertical.png    (rodapé, emails)
└── logo-horizontal.png  (navbar, hero)
```

### Quando Usar Cada Logo

#### 1️⃣ Logo Icon
- **Arquivo**: `logo-icon.png`
- **Contexto**: Favicon, app icons, avatares
- **Dimensões**: 1024x1024px (quadrado)

#### 2️⃣ Logo Badge  
- **Arquivo**: `logo-badge.png`
- **Contexto**: Selo de qualidade, certificações
- **Dimensões**: Circular com texto

#### 3️⃣ Logo Vertical
- **Arquivo**: `logo-vertical.png`
- **Contexto**: Rodapé, páginas internas, emails
- **Dimensões**: Retrato

#### 4️⃣ Logo Horizontal ⭐ (Mais usado)
- **Arquivo**: `logo-horizontal.png`
- **Contexto**: **Header, navbar, hero sections**
- **Dimensões**: Paisagem

---

## ✅ IMPLEMENTAÇÕES CONCLUÍDAS

### 1. Paleta no TailwindCSS
✅ Arquivo atualizado: `frontend/src/app/globals.css`

**Você pode usar no código:**
```tsx
// Classes Tailwind
<div className="bg-sage text-bege-light">
<button className="bg-dourado hover:bg-terra">
<p className="text-marrom-suave">

// Cores de sistema
<button className="bg-primary"> {/* Sage */}
<div className="bg-secondary">  {/* Folha */}
<span className="bg-accent">    {/* Dourado */}
```

### 2. Logos Organizados
✅ Copiados para: `frontend/public/logos/`
✅ Documentação criada: `frontend/public/logos/README.md`

### 3. Componente Logo
✅ Criado: `frontend/src/components/Logo.tsx`

**Como usar:**
```tsx
import { Logo } from '@/components/Logo';

// Navbar
<Logo variant="horizontal" size="md" />

// Favicon
<Logo variant="icon" size="sm" />

// Rodapé
<Logo variant="vertical" size="lg" />

// Selo
<Logo variant="badge" size="md" />
```

### 4. Documentação Completa
✅ Design System: `DESIGN_SYSTEM.md`
✅ Este resumo: `PALETA_E_LOGOS.md`

---

## 🎯 COMO USAR NO PROJETO

### No CSS/Tailwind
```css
/* Variáveis CSS disponíveis */
var(--sage)
var(--terra)
var(--dourado)
var(--folha)
var(--terracota)
var(--creme)
var(--bege-light)
var(--bege)
var(--marrom-suave)
var(--marrom-dark)

/* Classes Tailwind */
bg-sage
text-terra
border-dourado
hover:bg-folha
```

### No Next.js/React
```tsx
// Usar o componente Logo
import { Logo } from '@/components/Logo';

<Logo variant="horizontal" size="md" />

// Ou diretamente com Image
import Image from 'next/image';

<Image 
  src="/logos/logo-horizontal.png" 
  alt="Receita de Vovó" 
  width={400}
  height={120}
  className="h-12 w-auto"
/>
```

---

## 🎨 EXEMPLOS VISUAIS

### Combinações Recomendadas

#### Para Buttons (CTAs)
```tsx
// Primário (destaque)
<button className="bg-sage text-bege-light hover:bg-folha">

// Secundário
<button className="bg-dourado text-terra hover:bg-warning">

// Ghost
<button className="text-sage border-sage hover:bg-sage/10">
```

#### Para Cards
```tsx
// Card claro
<div className="bg-creme border-bege">

// Card destaque
<div className="bg-sage/5 border-sage/20">
```

#### Para Texto
```tsx
// Título
<h1 className="text-terra font-semibold">

// Texto normal
<p className="text-marrom-suave">

// Destaque
<span className="text-sage font-medium">
```

---

## 📐 PRÓXIMOS PASSOS (FASE 1)

### Agora você deve:

1. **Testar a paleta** ✅ PRONTO
   - As cores já estão configuradas no projeto
   - Pode usar imediatamente

2. **Implementar no Navbar**
   ```tsx
   import { Logo } from '@/components/Logo';
   
   <nav className="bg-bege-light border-b border-bege">
     <Logo variant="horizontal" size="md" />
   </nav>
   ```

3. **Criar componentes base** (próxima tarefa)
   - Buttons com a paleta
   - Cards
   - Inputs
   - Badges

4. **Configurar favicon**
   ```tsx
   // app/layout.tsx
   export const metadata = {
     icons: {
       icon: '/logos/logo-icon.png',
       apple: '/logos/logo-icon.png',
     },
   }
   ```

---

## 🚨 AVISOS IMPORTANTES

### Sobre os Warnings CSS
Você pode ver warnings no editor sobre `@custom-variant`, `@theme`, e `@apply`.

**Isso é NORMAL!** ✅

São diretivas específicas do Tailwind v4 que o linter CSS padrão não reconhece. O projeto funcionará perfeitamente.

### Sobre o Modo Dark
✅ Já configurado!  
As cores no modo dark mantêm a identidade natural da marca.

Para ativar:
```tsx
// Adicionar classe 'dark' no html
<html className="dark">
```

---

## 📚 DOCUMENTAÇÃO COMPLETA

- **Design System Completo**: `/DESIGN_SYSTEM.md`
- **Guia de Logos**: `/frontend/public/logos/README.md`
- **Análise Implementação**: `/ANALISE_IMPLEMENTACAO.md`

---

## ✨ CONCLUSÃO

Você agora tem:
- ✅ Paleta oficial implementada no TailwindCSS
- ✅ 4 logos organizados e otimizados
- ✅ Componente Logo reutilizável
- ✅ Documentação completa
- ✅ Modo dark configurado
- ✅ Pronto para começar a desenvolver componentes

**A base do Design System está completa! 🎉**

---

**Última atualização**: 15/05/2026
