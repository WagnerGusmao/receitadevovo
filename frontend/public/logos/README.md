# Logos - Receita de Vovó

## Arquivos Disponíveis

### 🎯 Logo Icon (`logo-icon.png`)
**Dimensões**: 1024x1024px (quadrado)  
**Uso recomendado**:
- Favicon (16x16, 32x32, 180x180)
- App icons (mobile)
- Avatar/perfil redes sociais
- Emblemas e ícones pequenos

**Onde usar no código**:
```tsx
// Favicon
<link rel="icon" href="/logos/logo-icon.png" />

// Avatar
<img src="/logos/logo-icon.png" alt="Receita de Vovó" className="w-12 h-12" />
```

---

### 🎖️ Logo Badge (`logo-badge.png`)
**Dimensões**: Circular completo com texto  
**Uso recomendado**:
- Selo de qualidade
- Certificações
- Materiais impressos (etiquetas, tags)
- Embalagens
- Carimbos digitais

**Onde usar no código**:
```tsx
// Selo de produto
<img 
  src="/logos/logo-badge.png" 
  alt="Receita de Vovó - Ervas Medicinais" 
  className="w-32 h-32"
/>
```

---

### 📐 Logo Vertical (`logo-vertical.png`)
**Dimensões**: Layout retrato (vertical)  
**Uso recomendado**:
- Páginas internas
- Rodapé
- Emails (header)
- Banners verticais
- Stories (Instagram, WhatsApp)
- Materiais verticais

**Onde usar no código**:
```tsx
// Rodapé
<img 
  src="/logos/logo-vertical.png" 
  alt="Receita de Vovó" 
  className="w-48 mx-auto"
/>

// Email header
<img 
  src="/logos/logo-vertical.png" 
  alt="Receita de Vovó" 
  width="200"
/>
```

---

### 📏 Logo Horizontal (`logo-horizontal.png`)
**Dimensões**: Layout paisagem (horizontal)  
**Uso recomendado**:
- **Header principal (Navbar)**
- Hero sections
- Desktop
- Banners horizontais
- Apresentações
- Materiais impressos horizontais

**Onde usar no código**:
```tsx
// Navbar (recomendado)
<img 
  src="/logos/logo-horizontal.png" 
  alt="Receita de Vovó" 
  className="h-12 w-auto"
/>

// Hero section
<img 
  src="/logos/logo-horizontal.png" 
  alt="Receita de Vovó - Ervas Medicinais" 
  className="h-16 md:h-20 w-auto"
/>
```

---

## 🎨 Diretrizes de Uso

### ✅ Permitido
- Usar em fundos claros (bege, creme, branco)
- Usar em fundos terrosos escuros com contraste adequado
- Redimensionar proporcionalmente
- Adicionar sombras sutis para melhor contraste

### ❌ Não permitido
- Distorcer ou esticar
- Mudar as cores do logo
- Adicionar efeitos excessivos (brilho, gradientes, etc)
- Usar em fundos que não proporcionem contraste adequado
- Rotacionar ou inclinar

---

## 📱 Tamanhos Recomendados

### Mobile
- Navbar: `h-10` (40px)
- Footer: `h-12` (48px)
- Icon: `w-8 h-8` (32px)

### Tablet
- Navbar: `h-12` (48px)
- Footer: `h-14` (56px)
- Icon: `w-10 h-10` (40px)

### Desktop
- Navbar: `h-14` ou `h-16` (56px-64px)
- Footer: `h-16` ou `h-20` (64px-80px)
- Icon: `w-12 h-12` (48px)

---

## 🌐 Favicon Setup

Adicione no `app/layout.tsx`:

```tsx
export const metadata = {
  icons: {
    icon: [
      { url: '/logos/logo-icon.png' },
      { url: '/logos/logo-icon.png', sizes: '16x16', type: 'image/png' },
      { url: '/logos/logo-icon.png', sizes: '32x32', type: 'image/png' },
    ],
    apple: [
      { url: '/logos/logo-icon.png', sizes: '180x180', type: 'image/png' },
    ],
  },
}
```

---

## 🎯 Exemplos de Uso

### Componente Logo (recomendado)

```tsx
// components/Logo.tsx
import Image from 'next/image';

interface LogoProps {
  variant?: 'icon' | 'badge' | 'vertical' | 'horizontal';
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

export function Logo({ 
  variant = 'horizontal', 
  size = 'md',
  className 
}: LogoProps) {
  const sizeClasses = {
    sm: variant === 'icon' ? 'w-8 h-8' : 'h-8',
    md: variant === 'icon' ? 'w-12 h-12' : 'h-12',
    lg: variant === 'icon' ? 'w-16 h-16' : 'h-16',
    xl: variant === 'icon' ? 'w-20 h-20' : 'h-20',
  };

  return (
    <Image
      src={`/logos/logo-${variant}.png`}
      alt="Receita de Vovó"
      width={variant === 'icon' ? 120 : 400}
      height={120}
      className={`${sizeClasses[size]} w-auto ${className}`}
      priority
    />
  );
}

// Uso:
<Logo variant="horizontal" size="md" />
<Logo variant="icon" size="sm" />
```

---

**Última atualização**: 15/05/2026
