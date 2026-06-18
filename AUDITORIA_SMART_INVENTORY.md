# Auditoria do Sistema — Receita de Vovó ERP
**Data:** 2026-05-19 | **Objetivo:** Implementação do módulo SmartInventoryInput

---

## 1. O QUE JÁ EXISTE

### Backend (Laravel 13.8 / PHP 8.3)

**Arquitetura:** Modular via `app/Modules/{Módulo}/`. O `ModuleServiceProvider` auto-descobre rotas e migrations de cada módulo. Rota base: `/api/{modulolowercase}/`.

**Módulo Inventory — totalmente estruturado:**

| Camada | Arquivos |
|---|---|
| Models | `RawMaterial`, `Batch`, `Supplier`, `RawMaterialMovement`, `PurchaseOrder`, `PurchaseOrderItem`, `Recipe`, `RecipeIngredient`, `ProductionOrder`, `ProductionOrderItem`, `QualityCheck`, `QualityCheckCriteria` |
| Services | `InventoryService`, `PurchaseService`, `QualityService`, `ProductionService`, `RecipeService`, `AnalyticsService`, `FinancialService` |
| Controllers | `RawMaterialController`, `BatchController`, `SupplierController`, `PurchaseController`, `ProductionController`, `RecipeController`, `QualityController`, `AnalyticsController`, `FinancialController` |
| Routes | 30+ endpoints sob `/api/inventory/` protegidos por `auth:sanctum` |

**Tabelas existentes:**
- `suppliers` — CNPJ, contato, email, telefone, is_active, softDeletes
- `raw_materials` — stock_quantity, min_stock_quantity, average_cost (CMP), unit, shelf_life_days, softDeletes
- `batches` — quantity_received/remaining, unit_cost, total_cost (stored), expires_at, status
- `raw_material_movements` — type (purchase/adjustment_in/out/consumed/waste/return), stock_after, average_cost_after, referência polimórfica
- `purchase_orders` — code, status lifecycle (draft→sent→partial→received→cancelled), total_planned/actual
- `purchase_order_items` — quantity_ordered/received, unit_price/actual_unit_price
- `recipes`, `recipe_ingredients`, `production_orders`, `production_order_items`
- `quality_checks`, `quality_check_criteria`

**Módulo AI — stub simulado, sem integração real:**
- `AIService` retorna respostas hardcoded (sem chamada Gemini real)
- `AIController` expõe `POST /api/ai/chat` (sem auth)

**Infraestrutura:**
- Queue configurada: `QUEUE_CONNECTION=database`
- Upload: `UploadController` para imagens (max 5MB, storage public)
- Filesystem: local (`FILESYSTEM_DISK=local`)
- Base Controller com helpers `success()` / `error()`

### Frontend (Next.js 16 / React 19 / TypeScript)

**Stack:** TailwindCSS v4, shadcn/ui (Radix), Recharts, Framer Motion, Sonner, Zustand, Lucide React

**Páginas admin existentes:**
- `/admin/materias-primas` — CRUD completo de RawMaterials + ajuste entrada/saída
- `/admin/lotes` — Gestão de lotes com FIFO/validade
- `/admin/compras` — Ordens de compra com ciclo de vida completo
- `/admin/fornecedores` — CRUD de fornecedores
- `/admin/producao` — Ordens de produção
- `/admin/receitas` — Receitas & fórmulas
- `/admin/qualidade` — Controle de qualidade
- `/admin/financeiro` — DRE
- `/admin/analytics` — Analytics operacional
- `/admin/estoque` — Estoque de produtos do e-commerce (módulo separado)

**Serviços frontend:** `apiFetch()` — wrapper fetch com token Bearer + JSON handling

---

## 2. O QUE PODE SER REAPROVEITADO

| Asset existente | Como reaproveitar |
|---|---|
| `InventoryService::receiveBatch()` | Chamada direta na confirmação do SmartInput — cria lote + movimento + atualiza CMP |
| `InventoryService::registerEntry()` | Fallback para entrada sem lote formal |
| `Supplier` model + endpoints | Buscar/criar fornecedor no fluxo inteligente |
| `RawMaterial` model + endpoints | Matching contra matérias cadastradas; criar novas se necessário |
| `Batch` model | Criado automaticamente via `receiveBatch()` |
| `RawMaterialMovement` referência polimórfica | `reference_type = SmartInputSession`, `reference_id = session_id` — auditoria completa |
| `ModuleServiceProvider` | Auto-descobre o novo módulo `SmartInventory` sem qualquer alteração |
| Queue database driver | Ready para `ProcessSmartInputJob` sem configuração adicional |
| `UploadController` pattern | Referência para implementar upload de imagens/PDFs no novo controller |
| `apiFetch()` frontend | Todas as chamadas REST do novo módulo |
| Design system (zinc, shadcn, Sonner) | Toda a UI do novo módulo segue o mesmo padrão visual |
| `auth:sanctum` middleware | Já aplicado; todos os novos endpoints ficam protegidos |
| `config/services.php` | Adicionar chave `gemini` sem criar novo arquivo |

---

## 3. O QUE PRECISA EVOLUIR

| O quê | Como evoluir |
|---|---|
| `AIService` | Não remover — manter simulação para o chat wellness; criar `GeminiOcrService` separado com chamada real |
| `UploadController` | Não alterar — criar upload dedicado no `SmartInputController` que aceita image + PDF (max 10MB) |
| `.env.example` | Adicionar `GEMINI_API_KEY=` |
| `config/services.php` | Adicionar bloco `gemini` |
| Layout admin | Adicionar item "Entrada Inteligente" no grupo "ERP Artesanal" |

---

## 4. O QUE PRECISA SER CRIADO

### Backend — Novo módulo `app/Modules/SmartInventory/`

```
SmartInventory/
├── Controllers/SmartInputController.php
├── Database/Migrations/2026_05_19_100000_create_smart_inventory_tables.php
├── DTOs/SmartInputSessionData.php
├── DTOs/SmartInputItemData.php
├── Events/SmartInputConfirmed.php
├── Jobs/ProcessSmartInputJob.php
├── Models/SmartInputSession.php
├── Models/SmartInputItem.php
├── Routes/api.php
└── Services/
    ├── GeminiOcrService.php
    ├── MaterialMatchingService.php
    └── SmartInputService.php
```

**Novas tabelas:**
- `smart_input_sessions` — ciclo de vida da sessão de importação (pending → processing → needs_review → completed / failed)
- `smart_input_items` — itens extraídos com matching e estado de confirmação

### Frontend — Nova página
- `src/app/(admin)/admin/entrada-inteligente/page.tsx` — fluxo híbrido manual + IA

---

## 5. O QUE PRECISA REFATORAR

**Nada destrutivo necessário.** As únicas alterações em arquivos existentes são:
1. `config/services.php` — adicionar bloco `gemini` (append, não altera existente)
2. `.env.example` — adicionar variável (append)
3. `layout.tsx` — adicionar um item no `menuGroups` array

---

## 6. RISCOS TÉCNICOS

| Risco | Severidade | Mitigação |
|---|---|---|
| Gemini API indisponível | Médio | `GeminiOcrService` captura exceções; sessão fica `failed` com mensagem; fluxo manual sempre disponível |
| OCR impreciso em notas de baixa qualidade | Médio | Validação humana obrigatória antes de qualquer movimentação |
| Estoque negativo em confirmação | Alto | `InventoryService::receiveBatch()` é entrada — nunca gera saldo negativo |
| Duplicidade de movimentação | Alto | Confirmação via DB transaction + status `completed` impede reprocessamento |
| Arquivo PDF muito grande (>20MB base64) | Baixo | Validação max:10240 no upload; Gemini 1.5 Flash suporta até ~4MB base64 inline |
| Queue não processada (worker parado) | Médio | Job dispara async; frontend faz polling do status |

---

## 7. ESTRATÉGIA EVOLUTIVA

1. **Módulo independente** — `SmartInventory` não altera o módulo `Inventory`; apenas consome seus services
2. **Não-disruptivo** — modo manual funciona 100% sem IA (sem GEMINI_API_KEY, sem internet)
3. **Rastreabilidade total** — toda movimentação gerada por SmartInput referencia `SmartInputSession` via FK polimórfica
4. **Custo médio preservado** — confirmação usa `InventoryService::receiveBatch()` que já recalcula CMP
5. **Qualidade automática** — `PurchaseService::receiveItems()` cria `QualityCheck` automaticamente ao receber; mesma lógica pode ser aplicada ao SmartInput
6. **Dados imutáveis** — após `completed`, a sessão é somente-leitura; o JSON bruto do OCR e a imagem original ficam preservados para auditoria

---
