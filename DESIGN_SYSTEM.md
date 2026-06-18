# DESIGN SYSTEM - RECEITA DE VOVÓ

**Versão**: 1.0  
**Data**: 15/05/2026

---

## 🎨 PALETA DE CORES OFICIAL

Baseada no logo da marca, a paleta transmite:
- Natureza ancestral
- Acolhimento terroso
- Elegância orgânica
- Bem-estar natural

---

### CORES PRIMÁRIAS

#### Sage (Verde Principal)
```
Nome: sage
Hex: #6B8E6F
RGB: rgb(107, 142, 111)
HSL: hsl(127, 14%, 49%)

Uso: Elementos principais, botões primários, destaques
```

#### Terra (Marrom)
```
Nome: terra
Hex: #4A1E1C
RGB: rgb(74, 30, 28)
HSL: hsl(3, 45%, 20%)

Uso: Texto principal, contornos, elementos estruturais
```

#### Dourado (Mostarda Suave)
```
Nome: dourado
Hex: #D4A574
RGB: rgb(212, 165, 116)
HSL: hsl(31, 53%, 64%)

Uso: Destaques especiais, CTAs secundários, acentos
```

---

### CORES SECUNDÁRIAS

#### Verde Médio
```
Nome: folha
Hex: #7FA786
RGB: rgb(127, 167, 134)
HSL: hsl(131, 18%, 58%)

Uso: Backgrounds suaves, cards, seções alternadas
```

#### Terracota
```
Nome: terracota
Hex: #A8614A
RGB: rgb(168, 97, 74)
HSL: hsl(15, 39%, 47%)

Uso: Alertas suaves, elementos secundários, badges
```

#### Creme
```
Nome: creme
Hex: #F5F1E8
RGB: rgb(245, 241, 232)
HSL: hsl(42, 42%, 93%)

Uso: Backgrounds principais, cards claros
```

---

### CORES NEUTRAS

#### Bege Claro
```
Nome: bege-light
Hex: #FAF8F3
RGB: rgb(250, 248, 243)
HSL: hsl(43, 54%, 97%)

Uso: Background geral, seções claras
```

#### Bege Natural
```
Nome: bege
Hex: #E8E2D5
RGB: rgb(232, 226, 213)
HSL: hsl(41, 29%, 87%)

Uso: Borders, divisores, fundos suaves
```

#### Marrom Suave
```
Nome: marrom-suave
Hex: #8B6F47
RGB: rgb(139, 111, 71)
HSL: hsl(35, 32%, 41%)

Uso: Texto secundário, legendas
```

#### Marrom Escuro
```
Nome: marrom-dark
Hex: #2C1810
RGB: rgb(44, 24, 16)
HSL: hsl(17, 47%, 12%)

Uso: Texto principal escuro, títulos importantes
```

---

### CORES FUNCIONAIS

#### Sucesso (Verde Natural)
```
Nome: success
Hex: #5A8F5E
RGB: rgb(90, 143, 94)
HSL: hsl(125, 23%, 46%)

Uso: Mensagens de sucesso, confirmações
```

#### Atenção (Mostarda)
```
Nome: warning
Hex: #DAA520
RGB: rgb(218, 165, 32)
HSL: hsl(43, 74%, 49%)

Uso: Avisos, alertas neutros
```

#### Erro (Terracota Escuro)
```
Nome: error
Hex: #B34D3A
RGB: rgb(179, 77, 58)
HSL: hsl(9, 51%, 46%)

Uso: Erros, validações negativas
```

#### Info (Azul Natural)
```
Nome: info
Hex: #7BA3A0
RGB: rgb(123, 163, 160)
HSL: hsl(175, 18%, 56%)

Uso: Informações, dicas
```

---

## 🖼️ USO DOS LOGOS

### Logo Icon (`logo-icon.png`)
- **Uso**: Favicon, app icons, emblemas
- **Contexto**: Mobile, redes sociais (perfil)
- **Dimensões**: Quadrado, 1024x1024px

### Logo Badge (`logo-badge.png`)
- **Uso**: Selo de qualidade, certificações, emblemas especiais
- **Contexto**: Produtos, certificados, materiais impressos
- **Dimensões**: Circular completo

### Logo Vertical (`logo-vertical.png`)
- **Uso**: Páginas internas, rodapé, materiais verticais
- **Contexto**: Landing pages, emails, banners verticais
- **Dimensões**: Retrato

### Logo Horizontal (`logo-horizontal.png`)
- **Uso**: Header principal, navbar, hero sections
- **Contexto**: Desktop, web, materiais horizontais
- **Dimensões**: Paisagem, ideal para headers

---

## 📐 TIPOGRAFIA

### Família Principal
```
Font Family: 'Inter', system-ui, sans-serif
Uso: UI, textos gerais, navegação
```

### Família Display (Títulos)
```
Font Family: 'Playfair Display', serif
OU
Font Family: 'Crimson Pro', serif
Uso: Títulos principais, hero sections, destaque emocional
```

### Família Manuscrita (Detalhes)
```
Font Family: 'Caveat', cursive
OU
Font Family: 'Dancing Script', cursive
Uso: Detalhes especiais, assinaturas, elementos humanizados
```

---

## 🎯 ESCALA TIPOGRÁFICA

```
Display XL: 72px / 4.5rem (Hero principal)
Display L:  60px / 3.75rem (Hero secundário)
Display M:  48px / 3rem (Títulos páginas)

H1: 40px / 2.5rem
H2: 32px / 2rem
H3: 28px / 1.75rem
H4: 24px / 1.5rem
H5: 20px / 1.25rem
H6: 18px / 1.125rem

Body Large:  18px / 1.125rem
Body:        16px / 1rem
Body Small:  14px / 0.875rem
Caption:     12px / 0.75rem
Tiny:        10px / 0.625rem
```

---

## 📏 ESPAÇAMENTO

Sistema baseado em múltiplos de 4px (0.25rem):

```
spacing: {
  0: '0',
  1: '0.25rem',  // 4px
  2: '0.5rem',   // 8px
  3: '0.75rem',  // 12px
  4: '1rem',     // 16px
  5: '1.25rem',  // 20px
  6: '1.5rem',   // 24px
  8: '2rem',     // 32px
  10: '2.5rem',  // 40px
  12: '3rem',    // 48px
  16: '4rem',    // 64px
  20: '5rem',    // 80px
  24: '6rem',    // 96px
}
```

---

## 🔘 BORDAS & SOMBRAS

### Border Radius
```
rounded-sm: 4px
rounded-md: 8px
rounded-lg: 12px
rounded-xl: 16px
rounded-2xl: 24px
rounded-full: 9999px
```

### Shadows
```
shadow-sm:  0 1px 2px rgba(74, 30, 28, 0.05)
shadow:     0 2px 8px rgba(74, 30, 28, 0.08)
shadow-md:  0 4px 12px rgba(74, 30, 28, 0.12)
shadow-lg:  0 8px 24px rgba(74, 30, 28, 0.15)
shadow-xl:  0 16px 48px rgba(74, 30, 28, 0.18)
```

---

## 🎭 ANIMAÇÕES

### Transições
```
transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1)
transition-base: 250ms cubic-bezier(0.4, 0, 0.2, 1)
transition-slow: 350ms cubic-bezier(0.4, 0, 0.2, 1)
```

### Easing
```
ease-natural: cubic-bezier(0.4, 0, 0.2, 1)
ease-smooth: cubic-bezier(0.25, 0.1, 0.25, 1)
ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55)
```

---

## 🌿 PRINCÍPIOS DE DESIGN

### Natureza Premium
- Espaçamentos generosos
- Imagens naturais de alta qualidade
- Texturas orgânicas sutis
- Bordas suaves e arredondadas

### Ancestralidade Moderna
- Tipografia elegante e legível
- Equilíbrio entre tradição e modernidade
- Elementos artesanais com design limpo

### Acolhimento Emocional
- Cores terrosas e calorosas
- Micro-interações humanizadas
- Feedbacks visuais suaves
- Mensagens empáticas

### Elegância Orgânica
- Hierarquia visual clara
- Whitespace abundante
- Componentes consistentes
- Grid fluido e responsivo

---

## 📱 BREAKPOINTS

```
mobile:  0px     (até 640px)
sm:      640px   (tablet pequeno)
md:      768px   (tablet)
lg:      1024px  (desktop)
xl:      1280px  (desktop grande)
2xl:     1536px  (desktop extra grande)
```

---

## 🎨 GRADIENTES ESPECIAIS

### Gradiente Principal (Herbal)
```
linear-gradient(135deg, #6B8E6F 0%, #7FA786 100%)
```

### Gradiente Dourado
```
linear-gradient(135deg, #D4A574 0%, #DAA520 100%)
```

### Gradiente Terra
```
linear-gradient(135deg, #A8614A 0%, #4A1E1C 100%)
```

### Gradiente Suave (Backgrounds)
```
linear-gradient(180deg, #FAF8F3 0%, #F5F1E8 100%)
```

---

## 🖼️ DIRETRIZES DE IMAGENS

### Fotografia
- Alta qualidade (mínimo 1920px largura)
- Natural, orgânica, com iluminação suave
- Cores terrosas e naturais
- Foco em texturas, ingredientes, natureza

### Ícones
- Estilo: Line icons ou filled (consistente)
- Peso: Regular (1.5-2px)
- Cor: Sage ou Terra
- Tamanho: 20px, 24px, 32px (múltiplos de 4)

### Ilustrações
- Estilo artesanal, hand-drawn
- Cores da paleta oficial
- Elementos naturais: folhas, ervas, flores

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### Fase 1 - Base
- [ ] Configurar paleta no TailwindCSS
- [ ] Importar fontes (Google Fonts)
- [ ] Configurar logos no projeto
- [ ] Criar favicon
- [ ] Setup Framer Motion

### Fase 2 - Componentes
- [ ] Botões (primary, secondary, ghost, outline)
- [ ] Cards
- [ ] Inputs & Forms
- [ ] Navigation
- [ ] Modals
- [ ] Toasts/Notifications

### Fase 3 - Animações
- [ ] Page transitions
- [ ] Hover effects
- [ ] Scroll animations
- [ ] Loading states

---

## 📚 REFERÊNCIAS DE INSPIRAÇÃO

- **Natura**: Identidade natural brasileira
- **Aesop**: Minimalismo premium
- **Ritual**: Wellness moderno
- **Apple**: Clareza e elegância
- **Organifi**: Wellness digital
- **Notion**: UI limpa e funcional

---

**Última atualização**: 15/05/2026
