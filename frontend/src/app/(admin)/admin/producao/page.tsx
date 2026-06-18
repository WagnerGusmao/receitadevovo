"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import {
  Factory, Plus, Play, CheckCircle2, XCircle, Clock, TrendingUp,
  AlertTriangle, PackageCheck, Layers, ChevronDown, ChevronUp,
  RefreshCw, BarChart3
} from "lucide-react";

type Recipe = { id: number; name: string; product?: { id: number; name: string }; effective_yield: number; yield_unit: string; unit_cost: number };
type OrderItem = {
  id: number; raw_material_id: number; planned_quantity: number;
  actual_quantity?: number; unit_cost: number; total_cost: number;
  raw_material: { name: string; unit: string; stock_quantity: number };
  batch?: { internal_code: string };
};
type ProductionOrder = {
  id: number; code: string; status: string; status_label: string;
  planned_batches: number; planned_yield: number; planned_cost: number;
  actual_yield?: number; actual_cost?: number; actual_unit_cost?: number;
  cost_variance?: number; yield_variance?: number; duration_minutes?: number;
  waste_quantity?: number; waste_notes?: string;
  started_at?: string; completed_at?: string; notes?: string;
  recipe: { name: string };
  product: { name: string; price: string };
  user?: { name: string };
  items: OrderItem[];
};
type Dashboard = {
  orders_this_month: number; units_produced: number; total_cost: number;
  total_waste: number; cost_variance: number; in_progress_count: number;
  in_progress_orders: ProductionOrder[]; recent_orders: ProductionOrder[];
};

const STATUS_CONFIG: Record<string, { label: string; badge: string; icon: React.ElementType }> = {
  draft:       { label: "Rascunho",    badge: "bg-zinc-100 text-zinc-500 border-none",    icon: Clock },
  in_progress: { label: "Em Produção", badge: "bg-blue-100 text-blue-700 border-none",    icon: Factory },
  completed:   { label: "Concluída",   badge: "bg-emerald-100 text-emerald-700 border-none", icon: CheckCircle2 },
  cancelled:   { label: "Cancelada",   badge: "bg-red-100 text-red-600 border-none",      icon: XCircle },
};

const emptyCompleteForm = { actual_yield: "", waste_quantity: "", waste_notes: "", notes: "" };

export default function ProducaoPage() {
  const [orders, setOrders] = useState<ProductionOrder[]>([]);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [dashboard, setDashboard] = useState<Dashboard | null>(null);
  const [loading, setLoading] = useState(true);
  const [expandedId, setExpandedId] = useState<number | null>(null);
  const [statusFilter, setStatusFilter] = useState("all");

  // Modals
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isCompleteOpen, setIsCompleteOpen] = useState(false);
  const [isCancelOpen, setIsCancelOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<ProductionOrder | null>(null);

  // Forms
  const [createForm, setCreateForm] = useState({ recipe_id: "", batches: "1", notes: "" });
  const [completeForm, setCompleteForm] = useState(emptyCompleteForm);
  const [actualItems, setActualItems] = useState<Record<number, string>>({});
  const [variantOutputs, setVariantOutputs] = useState<Record<number, string>>({});
  const [cancelReason, setCancelReason] = useState("");

  // Multiple and dynamic outputs / size packaging
  const [useMultipleOutputs, setUseMultipleOutputs] = useState(false);
  const [outputsList, setOutputsList] = useState<any[]>([]);

  const enableMultipleOutputs = () => {
    setUseMultipleOutputs(true);
    setOutputsList([
      {
        id: Date.now(),
        itemable_id: null,
        itemable_type: 'App\\Modules\\Ecommerce\\Models\\ProductVariant',
        name: "",
        price: "",
        volume: "",
        volume_unit: 'ml',
        quantity: ""
      }
    ]);
  };

  const disableMultipleOutputs = () => {
    setUseMultipleOutputs(false);
    setOutputsList([]);
    if (selectedOrder) {
      setCompleteForm(prev => ({ ...prev, actual_yield: String(selectedOrder.planned_yield) }));
    }
  };

  const addOutputRow = () => {
    setOutputsList([
      ...outputsList,
      {
        id: Date.now() + Math.random(),
        itemable_id: null,
        itemable_type: 'App\\Modules\\Ecommerce\\Models\\ProductVariant',
        name: "",
        price: "",
        volume: "",
        volume_unit: 'ml',
        quantity: ""
      }
    ]);
  };

  const removeOutputRow = (tempId: number) => {
    if (outputsList.length > 1) {
      setOutputsList(outputsList.filter(o => o.id !== tempId));
    } else {
      toast.error("Você precisa manter pelo menos um tamanho/variante.");
    }
  };

  useEffect(() => { loadAll(); }, []);

  async function loadAll() {
    setLoading(true);
    try {
      const [ordRes, recRes, dashRes] = await Promise.all([
        apiFetch("/inventory/production"),
        apiFetch("/inventory/recipes"),
        apiFetch("/inventory/production/dashboard"),
      ]);
      setOrders(ordRes.data.data ?? ordRes.data);
      setRecipes(recRes.data);
      setDashboard(dashRes.data);
    } catch {
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  }

  const selectedRecipe = recipes.find(r => r.id === parseInt(createForm.recipe_id));
  const previewYield = selectedRecipe
    ? Math.floor(selectedRecipe.effective_yield * parseInt(createForm.batches || "1"))
    : null;

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch("/inventory/production", {
        method: "POST",
        body: JSON.stringify({ ...createForm, batches: parseInt(createForm.batches) }),
      });
      toast.success("Ordem de produção criada");
      setIsCreateOpen(false);
      setCreateForm({ recipe_id: "", batches: "1", notes: "" });
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao criar ordem");
    }
  };

  const handleStart = async (order: ProductionOrder) => {
    if (!confirm(`Iniciar produção da ordem ${order.code}?`)) return;
    try {
      await apiFetch(`/inventory/production/${order.id}/start`, { method: "POST" });
      toast.success("Produção iniciada!");
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Não foi possível iniciar");
    }
  };

  const openComplete = (order: ProductionOrder) => {
    setSelectedOrder(order);
    setCompleteForm({ ...emptyCompleteForm, actual_yield: String(order.planned_yield) });
    const itemMap: Record<number, string> = {};
    (order.items || []).forEach(item => { itemMap[item.id] = String(item.planned_quantity); });
    setActualItems(itemMap);

    const productVariants = (order.product as any)?.variants || [];
    if (productVariants.length > 0) {
      setUseMultipleOutputs(true);
      setOutputsList(productVariants.map((v: any) => ({
        id: v.id,
        itemable_id: v.id,
        itemable_type: 'App\\Modules\\Ecommerce\\Models\\ProductVariant',
        name: v.name,
        price: String(v.price),
        volume: String(v.volume),
        volume_unit: v.volume_unit || 'ml',
        quantity: ""
      })));
    } else {
      setUseMultipleOutputs(false);
      setOutputsList([]);
    }

    setIsCompleteOpen(true);
  };

  const handleComplete = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedOrder) return;
    const items = Object.entries(actualItems).map(([itemId, qty]) => ({
      item_id: parseInt(itemId),
      actual_quantity: parseFloat(qty),
    }));

    let outputs: any[] = [];
    if (useMultipleOutputs) {
      for (const row of outputsList) {
        const qty = parseFloat(row.quantity || "0");
        if (qty <= 0) continue;

        if (row.itemable_id === null) {
          if (!row.name.trim() || !row.price || !row.volume) {
            toast.error("Para novos tamanhos/variantes, preencha Nome, Preço e Volume.");
            return;
          }
        }

        outputs.push({
          itemable_type: row.itemable_type,
          itemable_id: row.itemable_id,
          quantity: qty,
          name: row.name,
          price: parseFloat(row.price),
          volume: parseFloat(row.volume),
          volume_unit: row.volume_unit
        });
      }

      if (outputs.length === 0) {
        toast.error("Por favor, insira a quantidade produzida de pelo menos um tamanho/variante.");
        return;
      }
    }

    try {
      const payload: any = { 
        ...completeForm, 
        actual_items: items 
      };

      if (useMultipleOutputs) {
        payload.outputs = outputs;
      } else {
        payload.actual_yield = parseFloat(completeForm.actual_yield);
      }

      await apiFetch(`/inventory/production/${selectedOrder.id}/complete`, {
        method: "POST",
        body: JSON.stringify(payload),
      });
      toast.success("Produção finalizada! Estoque atualizado.");
      setIsCompleteOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao finalizar");
    }
  };

  const openCancel = (order: ProductionOrder) => {
    setSelectedOrder(order);
    setCancelReason("");
    setIsCancelOpen(true);
  };

  const handleCancel = async () => {
    if (!selectedOrder) return;
    try {
      await apiFetch(`/inventory/production/${selectedOrder.id}/cancel`, {
        method: "POST",
        body: JSON.stringify({ reason: cancelReason }),
      });
      toast.success("Ordem cancelada");
      setIsCancelOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao cancelar");
    }
  };

  const filteredOrders = statusFilter === "all"
    ? orders
    : orders.filter(o => o.status === statusFilter);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Ordens de Produção</h1>
          <p className="text-sm text-zinc-500">Gerencie o ciclo completo de produção artesanal.</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" onClick={loadAll} className="gap-2 text-zinc-500 h-9">
            <RefreshCw className="w-4 h-4" />
          </Button>
          <Button className="bg-primary hover:bg-olive gap-2" onClick={() => setIsCreateOpen(true)}>
            <Plus className="w-4 h-4" /> Nova Ordem
          </Button>
        </div>
      </div>

      {/* KPIs do mês */}
      {dashboard && (
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
          {[
            { label: "Ordens no Mês",   value: String(dashboard.orders_this_month), icon: BarChart3, color: "blue" },
            { label: "Em Produção",     value: String(dashboard.in_progress_count), icon: Factory, color: "amber" },
            { label: "Unidades Prod.",  value: String(dashboard.units_produced),    icon: PackageCheck, color: "emerald" },
            { label: "Custo Total",     value: `R$ ${dashboard.total_cost.toFixed(2)}`, icon: TrendingUp, color: "zinc" },
            {
              label: "Var. Custo",
              value: `${dashboard.cost_variance >= 0 ? "+" : ""}R$ ${dashboard.cost_variance.toFixed(2)}`,
              icon: AlertTriangle,
              color: dashboard.cost_variance > 0 ? "red" : "emerald"
            },
          ].map(kpi => (
            <div key={kpi.label} className="bg-white rounded-xl border border-zinc-100 shadow-sm p-4 flex items-center gap-3">
              <div className={`w-9 h-9 rounded-full flex items-center justify-center bg-${kpi.color}-50`}>
                <kpi.icon className={`w-4 h-4 text-${kpi.color}-600`} />
              </div>
              <div>
                <p className="text-[10px] text-zinc-400 uppercase tracking-wider">{kpi.label}</p>
                <p className="text-base font-bold text-zinc-900">{kpi.value}</p>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Filtros de status */}
      <div className="flex gap-2 flex-wrap">
        {["all", "draft", "in_progress", "completed", "cancelled"].map(s => (
          <button key={s}
            onClick={() => setStatusFilter(s)}
            className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-colors ${
              statusFilter === s
                ? "bg-primary text-white border-primary"
                : "bg-white text-zinc-500 border-zinc-200 hover:border-zinc-300"
            }`}>
            {s === "all" ? "Todas" : STATUS_CONFIG[s]?.label ?? s}
          </button>
        ))}
      </div>

      {/* Lista de Ordens */}
      {loading ? (
        <div className="text-center py-20 text-zinc-400">Carregando...</div>
      ) : filteredOrders.length === 0 ? (
        <div className="text-center py-20 bg-white rounded-xl border border-dashed border-zinc-200">
          <Factory className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
          <p className="text-zinc-400">Nenhuma ordem encontrada.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filteredOrders.map(order => {
            const cfg = STATUS_CONFIG[order.status];
            const Icon = cfg.icon;
            const isExpanded = expandedId === order.id;

            return (
              <div key={order.id} className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
                {/* Card Principal */}
                <div className="p-5">
                  <div className="flex items-start gap-4">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0
                      ${order.status === 'completed' ? 'bg-emerald-50' :
                        order.status === 'in_progress' ? 'bg-blue-50' :
                        order.status === 'cancelled' ? 'bg-red-50' : 'bg-zinc-100'}`}>
                      <Icon className={`w-5 h-5
                        ${order.status === 'completed' ? 'text-emerald-600' :
                          order.status === 'in_progress' ? 'text-blue-600' :
                          order.status === 'cancelled' ? 'text-red-500' : 'text-zinc-400'}`} />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-mono text-xs bg-zinc-100 px-2 py-0.5 rounded text-zinc-600 font-semibold">{order.code}</span>
                        <span className="font-semibold text-zinc-900">{order.recipe?.name}</span>
                        <Badge className={cfg.badge + " text-xs"}>{cfg.label}</Badge>
                      </div>
                      <p className="text-xs text-zinc-400 mt-0.5">{order.product?.name}</p>

                      {/* Métricas da ordem */}
                      <div className="flex flex-wrap gap-4 mt-3 text-sm">
                        <span className="text-zinc-500">
                          Lotes: <strong className="text-zinc-800">{order.planned_batches}</strong>
                        </span>
                        <span className="text-zinc-500">
                          Rendimento planejado: <strong className="text-zinc-800">{order.planned_yield} un</strong>
                        </span>
                        <span className="text-zinc-500">
                          Custo planejado: <strong className="text-zinc-800">R$ {order.planned_cost.toFixed(2)}</strong>
                        </span>

                        {order.status === 'completed' && (
                          <>
                            <span className="text-emerald-600 font-semibold">
                              Produzido: {order.actual_yield} un
                            </span>
                            <span className="text-zinc-500">
                              Custo real: <strong className="text-zinc-800">R$ {order.actual_cost?.toFixed(2)}</strong>
                            </span>
                            {order.actual_unit_cost && (
                              <span className="text-zinc-500">
                                Custo/un: <strong className="text-zinc-800">R$ {order.actual_unit_cost.toFixed(4)}</strong>
                              </span>
                            )}
                            {order.cost_variance !== undefined && order.cost_variance !== null && (
                              <span className={order.cost_variance > 0 ? "text-red-600 font-semibold" : "text-emerald-600 font-semibold"}>
                                Var. custo: {order.cost_variance > 0 ? "+" : ""}R$ {order.cost_variance.toFixed(2)}
                              </span>
                            )}
                            {order.duration_minutes !== null && order.duration_minutes !== undefined && (
                              <span className="text-zinc-400 flex items-center gap-1">
                                <Clock className="w-3 h-3" /> {order.duration_minutes} min
                              </span>
                            )}
                          </>
                        )}

                        {order.status === 'in_progress' && order.started_at && (
                          <span className="text-blue-600 flex items-center gap-1">
                            <Clock className="w-3 h-3" />
                            Iniciada em {new Date(order.started_at).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Ações */}
                    <div className="flex items-center gap-1 shrink-0 flex-wrap justify-end">
                      {order.status === 'draft' && (
                        <>
                          <Button size="sm" className="bg-blue-600 hover:bg-blue-700 gap-1 h-8 text-xs"
                            onClick={() => handleStart(order)}>
                            <Play className="w-3 h-3" /> Iniciar
                          </Button>
                          <Button size="sm" variant="outline" className="h-8 text-xs text-red-500 border-red-200 hover:bg-red-50"
                            onClick={() => openCancel(order)}>
                            Cancelar
                          </Button>
                        </>
                      )}
                      {order.status === 'in_progress' && (
                        <>
                          <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 gap-1 h-8 text-xs"
                            onClick={() => openComplete(order)}>
                            <CheckCircle2 className="w-3 h-3" /> Finalizar
                          </Button>
                          <Button size="sm" variant="outline" className="h-8 text-xs text-red-500 border-red-200 hover:bg-red-50"
                            onClick={() => openCancel(order)}>
                            Cancelar
                          </Button>
                        </>
                      )}
                      <Button size="sm" variant="ghost" className="h-8 w-8 p-0"
                        onClick={() => setExpandedId(isExpanded ? null : order.id)}>
                        {isExpanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                      </Button>
                    </div>
                  </div>
                </div>

                {/* Detalhes expandidos */}
                {isExpanded && (
                  <div className="border-t border-zinc-100 bg-zinc-50/50 px-5 py-4 space-y-3">
                    <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider">Ingredientes Consumidos</p>
                    <div className="rounded-lg border border-zinc-200 overflow-hidden bg-white">
                      {(order.items || []).map((item, i) => (
                        <div key={i} className="flex items-center justify-between px-4 py-3 border-b border-zinc-100 last:border-0 text-sm">
                          <div>
                            <p className="font-medium text-zinc-800">{item.raw_material?.name}</p>
                            <p className="text-xs text-zinc-400">
                              Planejado: {item.planned_quantity} {item.raw_material?.unit}
                              {item.actual_quantity !== null && item.actual_quantity !== undefined && (
                                <> | Real: <strong>{item.actual_quantity} {item.raw_material?.unit}</strong></>
                              )}
                              {item.batch && (
                                <> | Lote: <span className="font-mono">{item.batch.internal_code}</span></>
                              )}
                            </p>
                          </div>
                          <div className="text-right">
                            <p className="font-mono text-zinc-600">R$ {item.total_cost.toFixed(4)}</p>
                            <p className="text-xs text-zinc-400">@ R$ {item.unit_cost.toFixed(4)}/{item.raw_material?.unit}</p>
                          </div>
                        </div>
                      ))}
                    </div>

                    {order.waste_quantity && (
                      <div className="flex items-start gap-2 text-sm text-amber-700 bg-amber-50 px-4 py-3 rounded-lg">
                        <AlertTriangle className="w-4 h-4 mt-0.5 shrink-0" />
                        <div>
                          <strong>Perda registrada: {order.waste_quantity} un</strong>
                          {order.waste_notes && <p className="text-xs mt-0.5">{order.waste_notes}</p>}
                        </div>
                      </div>
                    )}

                    {order.notes && (
                      <p className="text-sm text-zinc-500 italic">Obs: {order.notes}</p>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* Modal Nova Ordem */}
      <Dialog open={isCreateOpen} onOpenChange={setIsCreateOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <form onSubmit={handleCreate}>
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2"><Factory className="w-5 h-5 text-primary" /> Nova Ordem de Produção</DialogTitle>
              <DialogDescription>Selecione a receita e defina quantos lotes produzir.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label>Receita *</Label>
                <Select value={createForm.recipe_id} onValueChange={v => setCreateForm({ ...createForm, recipe_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Selecionar receita..." /></SelectTrigger>
                  <SelectContent>
                    {recipes.map(r => (
                      <SelectItem key={r.id} value={String(r.id)} disabled={!r.product}>
                        {r.name} {!r.product && "(sem produto)"}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {selectedRecipe && !selectedRecipe.product && (
                  <p className="text-xs text-amber-600">Esta receita não está vinculada a um produto.</p>
                )}
              </div>
              <div className="grid gap-2">
                <Label>Número de Lotes *</Label>
                <Input type="number" min="1" max="1000" required
                  value={createForm.batches} onChange={e => setCreateForm({ ...createForm, batches: e.target.value })} />
              </div>

              {selectedRecipe && previewYield !== null && (
                <div className="rounded-lg bg-blue-50 border border-blue-100 p-3 grid grid-cols-3 gap-2 text-sm">
                  <div>
                    <p className="text-xs text-zinc-400">Rendimento</p>
                    <p className="font-bold text-zinc-800">{previewYield} {selectedRecipe.yield_unit}</p>
                  </div>
                  <div>
                    <p className="text-xs text-zinc-400">Custo/un</p>
                    <p className="font-bold text-zinc-800">R$ {selectedRecipe.unit_cost.toFixed(4)}</p>
                  </div>
                  <div>
                    <p className="text-xs text-zinc-400">Custo Total</p>
                    <p className="font-bold text-blue-700">
                      R$ {(selectedRecipe.unit_cost * previewYield).toFixed(2)}
                    </p>
                  </div>
                </div>
              )}

              <div className="grid gap-2">
                <Label>Observações</Label>
                <Textarea rows={2} value={createForm.notes}
                  onChange={e => setCreateForm({ ...createForm, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsCreateOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">Criar Ordem</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal Finalizar Produção */}
      <Dialog open={isCompleteOpen} onOpenChange={setIsCompleteOpen}>
        <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleComplete}>
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <CheckCircle2 className="w-5 h-5 text-emerald-600" /> Finalizar Produção
              </DialogTitle>
              <DialogDescription>
                {selectedOrder?.code} — {selectedOrder?.recipe?.name}
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-5 py-4">
              {/* Confirmação de consumo por ingrediente */}
              <div>
                <p className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Quantidade Real Consumida</p>
                <p className="text-xs text-zinc-400 mb-3">Ajuste se o consumo real diferir do planejado.</p>
                <div className="space-y-2">
                  {(selectedOrder?.items || []).map(item => (
                    <div key={item.id} className="grid grid-cols-12 gap-2 items-center py-2 border-b border-zinc-100 last:border-0">
                      <div className="col-span-7">
                        <p className="text-sm font-medium text-zinc-800">{item.raw_material?.name}</p>
                        <p className="text-xs text-zinc-400">Planejado: {item.planned_quantity} {item.raw_material?.unit}</p>
                        <p className="text-xs text-zinc-400">Estoque: {item.raw_material?.stock_quantity} {item.raw_material?.unit}</p>
                      </div>
                      <div className="col-span-5">
                        <Input type="number" step="0.001" min="0" className="h-8 text-sm"
                          value={actualItems[item.id] ?? item.planned_quantity}
                          onChange={e => setActualItems({ ...actualItems, [item.id]: e.target.value })} />
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Rendimento real */}
              {useMultipleOutputs ? (
                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between items-center mb-2">
                      <p className="text-xs font-bold text-zinc-500 uppercase tracking-wider">Rendimento Real por Tamanho/Variante</p>
                      {(!selectedOrder?.product || !(selectedOrder.product as any).variants || (selectedOrder.product as any).variants.length === 0) && (
                        <Button 
                          type="button" 
                          variant="ghost" 
                          className="h-7 text-xs text-zinc-500 hover:text-zinc-700" 
                          onClick={disableMultipleOutputs}
                        >
                          Voltar para rendimento simples
                        </Button>
                      )}
                    </div>
                    <p className="text-xs text-zinc-400 mb-3">
                      Insira as unidades produzidas para cada frasco/tamanho. Você pode criar novas variantes digitando as informações delas.
                    </p>
                    
                    <div className="space-y-3">
                      {outputsList.map((row, index) => (
                        <div key={row.id} className="border border-zinc-150 p-3 rounded-lg bg-zinc-50/50 space-y-2">
                          <div className="flex items-center justify-between">
                            <span className="text-xs font-semibold text-zinc-600">
                              {row.itemable_id ? `Tamanho Existente: ${row.name}` : `Novo Tamanho #${index + 1}`}
                            </span>
                            {/* Allow deleting row if it's dynamic/new, or if we have multiples */}
                            {(row.itemable_id === null || outputsList.length > 1) && (
                              <Button 
                                type="button" 
                                variant="ghost" 
                                className="h-6 px-2 text-[10px] text-red-500 hover:text-red-700"
                                onClick={() => removeOutputRow(row.id)}
                              >
                                Remover
                              </Button>
                            )}
                          </div>
                          
                          <div className="grid grid-cols-12 gap-2">
                            {row.itemable_id ? (
                              // Pre-existing variant
                              <>
                                <div className="col-span-8 flex flex-col justify-center">
                                  <p className="text-sm font-medium text-zinc-800">{row.name}</p>
                                  <p className="text-xs text-zinc-400">Preço: R$ {row.price} | Volume: {row.volume} {row.volume_unit}</p>
                                </div>
                                <div className="col-span-4">
                                  <Label className="text-[10px] text-zinc-400">Quantidade (un)</Label>
                                  <Input 
                                    type="number" 
                                    min="0" 
                                    step="1"
                                    placeholder="0"
                                    className="h-8 text-xs"
                                    value={row.quantity}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].quantity = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                  />
                                </div>
                              </>
                            ) : (
                              // New variant
                              <>
                                <div className="col-span-3">
                                  <Label className="text-[10px] text-zinc-400">Nome (ex: 50ml)</Label>
                                  <Input 
                                    placeholder="50ml"
                                    required
                                    className="h-8 text-xs"
                                    value={row.name}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].name = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                  />
                                </div>
                                <div className="col-span-2">
                                  <Label className="text-[10px] text-zinc-400">Preço (R$)</Label>
                                  <Input 
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    placeholder="20.00"
                                    required
                                    className="h-8 text-xs"
                                    value={row.price}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].price = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                  />
                                </div>
                                <div className="col-span-2">
                                  <Label className="text-[10px] text-zinc-400">Vol. (ex: 50)</Label>
                                  <Input 
                                    type="number"
                                    step="0.001"
                                    min="0"
                                    placeholder="50"
                                    required
                                    className="h-8 text-xs"
                                    value={row.volume}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].volume = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                  />
                                </div>
                                <div className="col-span-2">
                                  <Label className="text-[10px] text-zinc-400">Unidade</Label>
                                  <select
                                    value={row.volume_unit}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].volume_unit = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                    className="flex h-8 w-full rounded-md border border-zinc-200 bg-white px-2 py-1 text-xs focus-visible:outline-none"
                                  >
                                    <option value="ml">ml</option>
                                    <option value="g">g</option>
                                    <option value="un">un</option>
                                  </select>
                                </div>
                                <div className="col-span-3">
                                  <Label className="text-[10px] text-zinc-400">Qtd (un)</Label>
                                  <Input 
                                    type="number" 
                                    min="0" 
                                    step="1"
                                    placeholder="0"
                                    required
                                    className="h-8 text-xs"
                                    value={row.quantity}
                                    onChange={e => {
                                      const newList = [...outputsList];
                                      newList[index].quantity = e.target.value;
                                      setOutputsList(newList);
                                    }}
                                  />
                                </div>
                              </>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                    
                    <div className="mt-3">
                      <Button 
                        type="button" 
                        variant="outline" 
                        size="sm" 
                        className="w-full border-dashed text-primary hover:bg-primary/5 gap-1.5"
                        onClick={addOutputRow}
                      >
                        <Plus className="w-3.5 h-3.5" /> Adicionar Outro Tamanho / Variante
                      </Button>
                    </div>
                  </div>
                  
                  <div className="grid gap-2">
                    <Label>Perda (unidades)</Label>
                    <Input type="number" step="0.001" min="0"
                      value={completeForm.waste_quantity}
                      onChange={e => setCompleteForm({ ...completeForm, waste_quantity: e.target.value })} />
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="grid gap-2">
                      <Label>Rendimento Real (unidades) *</Label>
                      <Input type="number" step="0.001" min="0.001" required
                        value={completeForm.actual_yield}
                        onChange={e => setCompleteForm({ ...completeForm, actual_yield: e.target.value })} />
                      <p className="text-xs text-zinc-400">Planejado: {selectedOrder?.planned_yield} un</p>
                    </div>
                    <div className="grid gap-2">
                      <Label>Perda (unidades)</Label>
                      <Input type="number" step="0.001" min="0"
                        value={completeForm.waste_quantity}
                        onChange={e => setCompleteForm({ ...completeForm, waste_quantity: e.target.value })} />
                    </div>
                  </div>
                  
                  <div className="pt-1">
                    <Button 
                      type="button" 
                      variant="outline" 
                      size="sm" 
                      className="border-primary text-primary hover:bg-primary/5 gap-1.5"
                      onClick={enableMultipleOutputs}
                    >
                      🌿 Envasar em múltiplos tamanhos/variantes
                    </Button>
                  </div>
                </div>
              )}
              {completeForm.waste_quantity && parseFloat(completeForm.waste_quantity) > 0 && (
                <div className="grid gap-2">
                  <Label>Motivo da Perda</Label>
                  <Input value={completeForm.waste_notes}
                    onChange={e => setCompleteForm({ ...completeForm, waste_notes: e.target.value })} />
                </div>
              )}
              <div className="grid gap-2">
                <Label>Observações finais</Label>
                <Textarea rows={2} value={completeForm.notes}
                  onChange={e => setCompleteForm({ ...completeForm, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsCompleteOpen(false)}>Voltar</Button>
              <Button type="submit" className="bg-emerald-600 hover:bg-emerald-700">
                Confirmar e Baixar Estoque
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal Cancelar */}
      <Dialog open={isCancelOpen} onOpenChange={setIsCancelOpen}>
        <DialogContent className="sm:max-w-[420px]">
          <DialogHeader>
            <DialogTitle>Cancelar Ordem {selectedOrder?.code}?</DialogTitle>
            <DialogDescription>Esta ação não pode ser desfeita.</DialogDescription>
          </DialogHeader>
          <div className="py-3 grid gap-2">
            <Label>Motivo (opcional)</Label>
            <Textarea rows={3} value={cancelReason}
              onChange={e => setCancelReason(e.target.value)}
              placeholder="Informe o motivo do cancelamento..." />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsCancelOpen(false)}>Voltar</Button>
            <Button variant="destructive" onClick={handleCancel}>Confirmar Cancelamento</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
