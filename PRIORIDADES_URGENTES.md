# PRIORIDADES URGENTES - RECEITA DE VOVÓ

**Data**: 15/05/2026  
**Objetivo**: Definir o que é CRÍTICO implementar agora

---

## 🎯 STATUS ATUAL

### ✅ **O QUE JÁ FUNCIONA:**
- [x] Fase 1: Design System completo (14 componentes UI)
- [x] Fase 2A: WhatsApp no cadastro
- [x] Autenticação básica (login/registro)
- [x] Navbar e layout
- [x] Estrutura de páginas

### ❌ **O QUE NÃO FUNCIONA:**
- [ ] **Não há produtos no banco** (catálogo vazio)
- [ ] **Não há checkout funcional** (não dá para comprar)
- [ ] **Carrinho não salva** (só visual)
- [ ] **Páginas de produto vazias**
- [ ] **Admin não cria produtos** (falta backend)

---

## 🚨 BLOQUEADORES CRÍTICOS

### **1. NÃO DÁ PARA COMPRAR NADA** 🛒
**Problema**: Sistema e-commerce não funciona  
**Impacto**: Negócio não pode operar  
**Prioridade**: 🔴 **URGENTÍSSIMO**

**O que falta:**
- Produtos no banco de dados
- Checkout com CPF + Endereço (Fase 2B)
- Integração de pagamento
- Cálculo de frete
- Confirmação de pedido

---

### **2. ADMIN NÃO CONSEGUE GERENCIAR** 👨‍💼
**Problema**: Páginas admin são só visual  
**Impacto**: Não dá para cadastrar produtos/ervas/posts  
**Prioridade**: 🔴 **URGENTÍSSIMO**

**O que falta:**
- CRUD completo de Produtos
- CRUD completo de Ervas
- CRUD completo de Kits
- CRUD completo de Posts
- Upload de imagens

---

### **3. CATÁLOGO VAZIO** 📦
**Problema**: Não há produtos para mostrar  
**Impacto**: Site sem conteúdo  
**Prioridade**: 🔴 **URGENTÍSSIMO**

**O que falta:**
- Seeders de produtos
- Seeders de ervas
- Seeders de kits
- Imagens dos produtos
- Dados completos (descrição, preço, etc)

---

## 🎯 PLANO DE AÇÃO - 3 FASES

### **FASE A: CATÁLOGO FUNCIONAL** (1-2 dias)
**Objetivo**: Ter produtos para mostrar

**Tarefas:**
1. ✅ Criar seeders de produtos (10-15 produtos)
2. ✅ Criar seeders de ervas (20+ ervas)
3. ✅ Criar seeders de kits (5-10 kits)
4. ✅ Popular benefícios e emoções
5. ✅ Adicionar imagens placeholder
6. ✅ Testar exibição no frontend

**Entregável**: Catálogo navegável com produtos reais

---

### **FASE B: CHECKOUT COMPLETO** (2-3 dias)
**Objetivo**: Permitir compras end-to-end

**Tarefas:**
1. ✅ Migration de Addresses (Fase 2B)
2. ✅ Formulário de endereço com CEP
3. ✅ Integração ViaCEP
4. ✅ Campo CPF obrigatório
5. ✅ Salvamento de endereços
6. ✅ Seleção de endereço no checkout
7. ✅ Cálculo de frete (básico)
8. ✅ Resumo do pedido
9. ✅ Criação do pedido no banco

**Entregável**: Usuário consegue finalizar compra até o pagamento

---

### **FASE C: ADMIN FUNCIONAL** (3-4 dias)
**Objetivo**: Admin consegue gerenciar tudo

**Tarefas:**
1. ✅ CRUD Produtos (backend + frontend)
2. ✅ CRUD Ervas (backend + frontend)
3. ✅ CRUD Kits (backend + frontend)
4. ✅ CRUD Posts (backend + frontend)
5. ✅ Upload de imagens (Cloudinary/S3)
6. ✅ Gestão de estoque básica
7. ✅ Gestão de pedidos

**Entregável**: Admin totalmente funcional

---

## 📋 ROADMAP DETALHADO

### **SEMANA 1: E-COMMERCE MÍNIMO VIÁVEL**

#### **Dia 1-2: Seeders e Dados** 🌱
- [ ] Seeder: 15 produtos de chás
- [ ] Seeder: 25 ervas medicinais
- [ ] Seeder: 8 kits de autocuidado
- [ ] Seeder: 30 benefícios
- [ ] Seeder: 15 emoções
- [ ] Relacionamentos: ervas ↔ benefícios
- [ ] Relacionamentos: ervas ↔ emoções
- [ ] Relacionamentos: produtos ↔ ervas
- [ ] Relacionamentos: kits ↔ produtos
- [ ] Imagens placeholder

**Resultado**: Catálogo com conteúdo real

---

#### **Dia 3-4: Checkout + Endereço** 🛒
- [ ] Migration: addresses
- [ ] Model: Address
- [ ] Controller: AddressController
- [ ] Rotas API de endereços
- [ ] Serviço ViaCEP
- [ ] Formulário de endereço frontend
- [ ] Busca de CEP automática
- [ ] Máscara de CEP
- [ ] Salvamento de múltiplos endereços
- [ ] Seleção de endereço padrão
- [ ] Integração no checkout

**Resultado**: Checkout funcional até pagamento

---

#### **Dia 5: CRUD Produtos Admin** 👨‍💼
- [ ] Backend: ProductController completo
- [ ] Validações de produtos
- [ ] Frontend: Formulário criar produto
- [ ] Frontend: Listagem produtos
- [ ] Frontend: Editar produto
- [ ] Frontend: Excluir produto
- [ ] Upload de imagem básico

**Resultado**: Admin cria/edita produtos

---

### **SEMANA 2: REFINAMENTO**

#### **Dia 6-7: CRUD Ervas + Kits Admin** 🌿
- [ ] CRUD Ervas completo
- [ ] CRUD Kits completo
- [ ] Relacionamentos no admin
- [ ] Seleção de ervas para produtos
- [ ] Seleção de produtos para kits

**Resultado**: Admin gerencia todo catálogo

---

#### **Dia 8-9: Upload de Imagens** 📸
- [ ] Configurar Cloudinary/S3
- [ ] Upload único
- [ ] Upload múltiplo
- [ ] Crop de imagens
- [ ] Otimização automática
- [ ] Galeria de imagens

**Resultado**: Produtos com imagens reais

---

#### **Dia 10: Gestão de Pedidos** 📦
- [ ] Listagem de pedidos admin
- [ ] Detalhes do pedido
- [ ] Atualizar status
- [ ] Cancelar pedido
- [ ] Exportar pedidos
- [ ] Notificações de novos pedidos

**Resultado**: Admin gerencia pedidos

---

## 🎯 APÓS ISSO (PRÓXIMAS PRIORIDADES)

### **Curto Prazo (2-3 semanas):**
1. ✅ Integração de pagamento (Stripe/MercadoPago)
2. ✅ Cálculo de frete real (Correios/Melhor Envio)
3. ✅ Sistema de cupons
4. ✅ Reviews de produtos
5. ✅ Sistema de busca

### **Médio Prazo (1-2 meses):**
1. ✅ Wellness Engine (recomendações)
2. ✅ Blog completo com SEO
3. ✅ CRM básico
4. ✅ Automação WhatsApp
5. ✅ Analytics

### **Longo Prazo (3+ meses):**
1. ✅ Sistema de gamificação
2. ✅ Módulo de produção
3. ✅ Módulo de inventário
4. ✅ IA avançada
5. ✅ Assinaturas

---

## 🚀 DECISÃO: O QUE FAZER AGORA?

### **OPÇÃO 1: CATÁLOGO PRIMEIRO** (Recomendado)
**Tempo**: 1-2 dias  
**Benefício**: Site fica apresentável rapidamente

**Passos:**
1. Criar seeders de produtos
2. Criar seeders de ervas
3. Criar seeders de kits
4. Testar frontend

**Resultado**: Site com conteúdo real para mostrar

---

### **OPÇÃO 2: CHECKOUT PRIMEIRO**
**Tempo**: 2-3 dias  
**Benefício**: E-commerce funcional

**Passos:**
1. Implementar Fase 2B (endereço + CPF)
2. Finalizar checkout
3. Criar alguns produtos manualmente
4. Testar fluxo completo

**Resultado**: Dá para fazer vendas (mesmo sem admin)

---

### **OPÇÃO 3: ADMIN PRIMEIRO**
**Tempo**: 3-4 dias  
**Benefício**: Autonomia total

**Passos:**
1. CRUD completo de produtos
2. CRUD de ervas
3. Upload de imagens
4. Cadastrar produtos via admin

**Resultado**: Admin totalmente funcional

---

## 💡 MINHA RECOMENDAÇÃO

### **IMPLEMENTAR NESTA ORDEM:**

**1º - CATÁLOGO** (1-2 dias)
- Seeders de produtos/ervas/kits
- Testar frontend
- Site apresentável

**2º - CHECKOUT** (2-3 dias)
- Endereço + CPF
- Finalização de compra
- E-commerce funcional

**3º - ADMIN** (3-4 dias)
- CRUD completo
- Upload de imagens
- Autonomia total

**Total**: ~10 dias para MVP funcional completo

---

## 📊 COMPARAÇÃO

| Prioridade | Tempo | Impacto | Complexidade | ROI |
|------------|-------|---------|--------------|-----|
| **Catálogo** | 1-2d | Alto | Baixa | ⭐⭐⭐⭐⭐ |
| **Checkout** | 2-3d | Crítico | Média | ⭐⭐⭐⭐ |
| **Admin** | 3-4d | Alto | Média | ⭐⭐⭐⭐ |
| Pagamento | 1-2d | Crítico | Alta | ⭐⭐⭐⭐⭐ |
| Frete | 1d | Alto | Média | ⭐⭐⭐ |
| Cupons | 1d | Médio | Baixa | ⭐⭐⭐ |
| Reviews | 2d | Médio | Média | ⭐⭐⭐ |
| Busca | 1d | Médio | Baixa | ⭐⭐⭐ |
| Gamificação | 7d | Baixo | Alta | ⭐⭐ |

---

## ✅ DECISÃO FINAL

Começar por **OPÇÃO 1 - CATÁLOGO** porque:
- ✅ Rápido (1-2 dias)
- ✅ Alto impacto visual
- ✅ Baixa complexidade
- ✅ Fundação para o resto
- ✅ Já dá para mostrar o site

Depois seguir para **Checkout** e **Admin** em sequência.

---

**Quer que eu comece pelos seeders agora?** 🚀
