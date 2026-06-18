"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription,
} from "@/components/ui/dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import {
  ShoppingCart, Plus, Send, PackageCheck, XCircle, Clock, Zap,
  RefreshCw, Trash2, ChevronDown, ChevronUp, AlertTriangle, TrendingUp,
} from "lucide-react";

type Supplier   = { id: number; name: string };
type Material   = { id: number; name: string; unit: string; average_cost: number; stock_quantity: number; min_stock: number };
type OrderItem  = {
  id: number; raw_material_id: number; quantity_ordered: number;
  quantity_received: number | null; unit_price: number;
  actual_unit_price: number | null; total_planned: number; total_actual: number | null;
  receipt_status: 'pending' | 'partial' | 'complete';
  raw_material: { name: string; unit: string };
};
type PurchaseOrder = {
  id: number; code: string; status: string; status_label: string;
  total_planned: number; total_actual: number | null; price_variance: number | null;
  expected_at: string | null; sent_at: string | null; received_at: string | null;
  is_overdue: boolean; notes: string | null;
  supplier: { id: number; name: string };
  user?: { name: string };
  items: OrderItem[];
  items_count?: number;
};
type Dashboard = {
  pending_orders: number; overdue_count: number; received_month: number;
  total_spent: number; price_variance: number; alert_count: number;
  pending_list: PurchaseOrder[];
};

const STATUS_CONFIG: Record<string, { label: string; badge: string; icon: React.ElementType }> = {
  draft:    { label: "Rascunho",     badge: "bg-zinc-100 text-zinc-500 border-none",       icon: Clock },
  sent:     { label: "Enviada",      badge: "bg-blue-100 text-blue-700 border-none",        icon: Send },
  partial:  { label: "Parcial",      badge: "bg-amber-100 text-amber-700 border-none",      icon: PackageCheck },
  received: { label: "Recebida",     badge: "bg-emerald-100 text-emerald-700 border-none",  icon: PackageCheck },
  cancelled:{ label: "Cancelada",    badge: "bg-red-100 text-red-600 border-none",          icon: XCircle },
};

const currency = (v: number) =>
  v.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });

type ItemForm = {
  raw_material_id: string; quantity_ordered: string; unit_price: string; notes: string;
};
const emptyItemForm = (): ItemForm => ({
  raw_material_id: "", quantity_ordered: "", unit_price: "", notes: "",
});

export default function ComprasPage() {
  const [orders, setOrders]         = useState<PurchaseOrder[]>([]);
  const [suppliers, setSuppliers]   = useState<Supplier[]>([]);
  const [materials, setMaterials]   = useState<Material[]>([]);
  const [dashboard, setDashboard]   = useState<Dashboard | null>(null);
  const [loading, setLoading]       = useState(true);
  const [statusFilter, setStatusFilter] = useState("all");
  const [expandedId, setExpandedId] = useState<number | null>(null);

  // Modals
  const [isCreateOpen, setIsCreateOpen]   = useState(false);
  const [isReceiveOpen, setIsReceiveOpen] = useState(false);
  const [isCancelOpen, setIsCancelOpen]   = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<PurchaseOrder | null>(null);

  // Create form
  const [createForm, setCreateForm] = useState({
    supplier_id: "", expected_at: "", notes: "",
  });
  const [itemForms, setItemForms] = useState<ItemForm[]>([emptyItemForm()]);

  // Receive form: { [itemId]: { quantity_received, actual_unit_price } }
  const [receiveData, setReceiveData] = useState<Record<number, { qty: string; price: string }>>({});
  const [cancelReason, setCancelReason] = useState("");

  const loadAll = useCallback(async () => {
    setLoading(true);
    try {
      const [ordRes, supRes, matRes, dashRes] = await Promise.all([
        apiFetch("/inventory/purchases"),
        apiFetch("/inventory/suppliers"),
        apiFetch("/inventory/raw-materials"),
        apiFetch("/inventory/purchases/dashboard"),
      ]);
      setOrders(ordRes.data.data ?? ordRes.data);
      setSuppliers(supRes.data);
      setMaterials(matRes.data);
      setDashboard(dashRes.data);
    } catch {
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadAll(); }, [loadAll]);

  /* ── Create ───────────────────────────────────────── */
  const addItemRow    = () => setItemForms(f => [...f, emptyItemForm()]);
  const removeItemRow = (i: number) => setItemForms(f => f.filter((_, idx) => idx !== i));
  const updateItem    = (i: number, field: keyof ItemForm, val: string) => {
    setItemForms(f => {
      const next = [...f];
      next[i] = { ...next[i], [field]: val };
      // Auto-preencher preço com CMP da MP
      if (field === 'raw_material_id') {
        const mat = materials.find(m => m.id === parseInt(val));
        if (mat) next[i].unit_price = String(mat.average_cost);
      }
      return next;
    });
  };

  const totalPreview = itemForms.reduce((acc, item) => {
    const qty   = parseFloat(item.quantity_ordered) || 0;
    const price = parseFloat(item.unit_price) || 0;
    return acc + qty * price;
  }, 0);

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    const validItems = itemForms.filter(i => i.raw_material_id && i.quantity_ordered && i.unit_price);
    if (validItems.length === 0) { toast.error("Adicione pelo menos um item"); return; }

    try {
      await apiFetch("/inventory/purchases", {
        method: "POST",
        body: JSON.stringify({
          ...createForm,
          items: validItems.map(i => ({
            raw_material_id:  parseInt(i.raw_material_id),
            quantity_ordered: parseFloat(i.quantity_ordered),
            unit_price:       parseFloat(i.unit_price),
            notes:            i.notes || null,
          })),
        }),
      });
      toast.success("Ordem de compra criada");
      setIsCreateOpen(false);
      setCreateForm({ supplier_id: "", expected_at: "", notes: "" });
      setItemForms([emptyItemForm()]);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao criar ordem");
    }
  };

  /* ── Generate from alerts ─────────────────────────── */
  const handleGenerateAlerts = async () => {
    try {
      const res = await apiFetch("/inventory/purchases/generate-alerts", { method: "POST" });
      toast.success(res.message || "Ordens geradas");
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao gerar ordens");
    }
  };

  /* ── Send ─────────────────────────────────────────── */
  const handleSend = async (order: PurchaseOrder) => {
    if (!confirm(`Marcar ${order.code} como enviada ao fornecedor ${order.supplier.name}?`)) return;
    try {
      await apiFetch(`/inventory/purchases/${order.id}/send`, { method: "POST" });
      toast.success("Ordem marcada como enviada");
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro");
    }
  };

  /* ── Receive ──────────────────────────────────────── */
  const openReceive = async (order: PurchaseOrder) => {
    const detail = await apiFetch(`/inventory/purchases/${order.id}`);
    const full: PurchaseOrder = detail.data;
    setSelectedOrder(full);
    const init: Record<number, { qty: string; price: string }> = {};
    full.items.forEach(item => {
      const remaining = item.quantity_ordered - (item.quantity_received ?? 0);
      init[item.id] = {
        qty:   String(remaining > 0 ? remaining : 0),
        price: String(item.actual_unit_price ?? item.unit_price),
      };
    });
    setReceiveData(init);
    setIsReceiveOpen(true);
  };

  const handleReceive = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedOrder) return;
    const items = Object.entries(receiveData)
      .map(([itemId, d]) => ({
        item_id:           parseInt(itemId),
        quantity_received: parseFloat(d.qty) || 0,
        actual_unit_price: parseFloat(d.price) || undefined,
      }))
      .filter(i => i.quantity_received > 0);

    if (items.length === 0) { toast.error("Informe pelo menos uma quantidade recebida"); return; }

    try {
      await apiFetch(`/inventory/purchases/${selectedOrder.id}/receive`, {
        method: "POST",
        body: JSON.stringify({ items }),
      });
      toast.success("Recebimento registrado! Estoque atualizado.");
      setIsReceiveOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao registrar recebimento");
    }
  };

  /* ── Cancel ───────────────────────────────────────── */
  const openCancel = (order: PurchaseOrder) => { setSelectedOrder(order); setCancelReason(""); setIsCancelOpen(true); };
  const handleCancel = async () => {
    if (!selectedOrder) return;
    try {
      await apiFetch(`/inventory/purchases/${selectedOrder.id}/cancel`, {
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

  const filtered = statusFilter === "all"
    ? orders
    : orders.filter(o => o.status === statusFilter);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Ordens de Compra</h1>
          <p className="text-sm text-zinc-500">Gerencie compras de matérias-primas e reposição de estoque.</p>
        </div>
        <div className="flex gap-2 flex-wrap">
          <Button variant="outline" size="sm" onClick={loadAll} className="h-9 gap-1 text-zinc-400">
            <RefreshCw className="w-4 h-4" />
          </Button>
          {dashboard && dashboard.alert_count > 0 && (
            <Button variant="outline" size="sm"
              className="h-9 gap-1.5 border-amber-300 text-amber-700 hover:bg-amber-50"
              onClick={handleGenerateAlerts}>
              <Zap className="w-3.5 h-3.5" />
              Gerar de Alertas ({dashboard.alert_count})
            </Button>
          )}
          <Button className="bg-primary hover:bg-olive gap-2 h-9" onClick={() => setIsCreateOpen(true)}>
            <Plus className="w-4 h-4" /> Nova Ordem
          </Button>
        </div>
      </div>

      {/* KPIs */}
      {dashboard && (
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
          {[
            { label: "Pendentes",        value: String(dashboard.pending_orders),    icon: ShoppingCart, color: "blue" },
            { label: "Atrasadas",        value: String(dashboard.overdue_count),     icon: AlertTriangle, color: dashboard.overdue_count > 0 ? "red" : "zinc" },
            { label: "Recebidas/Mês",    value: String(dashboard.received_month),    icon: PackageCheck, color: "emerald" },
            { label: "Gasto no Mês",     value: currency(dashboard.total_spent),     icon: TrendingUp, color: "zinc" },
            {
              label: "Var. Preço/Mês",
              value: `${dashboard.price_variance >= 0 ? "+" : ""}${currency(dashboard.price_variance)}`,
              icon: TrendingUp,
              color: dashboard.price_variance > 0 ? "red" : "emerald",
            },
          ].map(kpi => (
            <div key={kpi.label} className="bg-white rounded-xl border border-zinc-100 shadow-sm p-4 flex items-center gap-3">
              <div className={`w-9 h-9 rounded-full shrink-0 flex items-center justify-center bg-${kpi.color}-50`}>
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

      {/* Filtros */}
      <div className="flex gap-2 flex-wrap">
        {["all", "draft", "sent", "partial", "received", "cancelled"].map(s => (
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

      {/* Lista */}
      {loading ? (
        <div className="text-center py-20 text-zinc-400">Carregando...</div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-20 bg-white rounded-xl border border-dashed border-zinc-200">
          <ShoppingCart className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
          <p className="text-zinc-400">Nenhuma ordem encontrada.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map(order => {
            const cfg       = STATUS_CONFIG[order.status];
            const Icon      = cfg.icon;
            const isExp     = expandedId === order.id;
            const isOverdue = order.is_overdue;

            return (
              <div key={order.id} className={`bg-white rounded-xl border shadow-sm overflow-hidden
                ${isOverdue ? "border-red-200" : "border-zinc-200"}`}>
                <div className="p-5">
                  <div className="flex items-start gap-4">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0
                      ${order.status === 'received' ? 'bg-emerald-50' :
                        order.status === 'sent' || order.status === 'partial' ? 'bg-blue-50' :
                        order.status === 'cancelled' ? 'bg-red-50' : 'bg-zinc-100'}`}>
                      <Icon className={`w-5 h-5
                        ${order.status === 'received' ? 'text-emerald-600' :
                          order.status === 'sent' || order.status === 'partial' ? 'text-blue-600' :
                          order.status === 'cancelled' ? 'text-red-500' : 'text-zinc-400'}`} />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-mono text-xs bg-zinc-100 px-2 py-0.5 rounded font-semibold text-zinc-600">
                          {order.code}
                        </span>
                        <span className="font-semibold text-zinc-900">{order.supplier?.name}</span>
                        <Badge className={cfg.badge + " text-xs"}>{cfg.label}</Badge>
                        {isOverdue && (
                          <Badge className="bg-red-100 text-red-700 border-none text-xs">
                            <AlertTriangle className="w-3 h-3 mr-1" /> Atrasada
                          </Badge>
                        )}
                      </div>

                      <div className="flex flex-wrap gap-4 mt-2 text-sm">
                        <span className="text-zinc-500">
                          Itens: <strong className="text-zinc-800">{order.items_count ?? order.items?.length ?? "—"}</strong>
                        </span>
                        <span className="text-zinc-500">
                          Planejado: <strong className="text-zinc-800">{currency(order.total_planned)}</strong>
                        </span>
                        {order.total_actual !== null && (
                          <span className="text-zinc-500">
                            Real: <strong className="text-zinc-800">{currency(order.total_actual)}</strong>
                          </span>
                        )}
                        {order.price_variance !== null && order.price_variance !== undefined && (
                          <span className={order.price_variance > 0 ? "text-red-600 font-semibold" : "text-emerald-600 font-semibold"}>
                            Var: {order.price_variance > 0 ? "+" : ""}{currency(order.price_variance)}
                          </span>
                        )}
                        {order.expected_at && (
                          <span className={`text-xs ${isOverdue ? "text-red-500 font-semibold" : "text-zinc-400"}`}>
                            Prazo: {new Date(order.expected_at + 'T12:00:00').toLocaleDateString('pt-BR')}
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Ações */}
                    <div className="flex items-center gap-1 flex-wrap justify-end shrink-0">
                      {order.status === 'draft' && (
                        <>
                          <Button size="sm" className="bg-blue-600 hover:bg-blue-700 gap-1 h-8 text-xs"
                            onClick={() => handleSend(order)}>
                            <Send className="w-3 h-3" /> Enviar
                          </Button>
                          <Button size="sm" variant="outline" className="h-8 text-xs text-red-500 border-red-200 hover:bg-red-50"
                            onClick={() => openCancel(order)}>
                            Cancelar
                          </Button>
                        </>
                      )}
                      {(order.status === 'sent' || order.status === 'partial') && (
                        <>
                          <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 gap-1 h-8 text-xs"
                            onClick={() => openReceive(order)}>
                            <PackageCheck className="w-3 h-3" /> Receber
                          </Button>
                          <Button size="sm" variant="outline" className="h-8 text-xs text-red-500 border-red-200 hover:bg-red-50"
                            onClick={() => openCancel(order)}>
                            Cancelar
                          </Button>
                        </>
                      )}
                      <Button size="sm" variant="ghost" className="h-8 w-8 p-0"
                        onClick={() => setExpandedId(isExp ? null : order.id)}>
                        {isExp ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                      </Button>
                    </div>
                  </div>
                </div>

                {/* Expandido */}
                {isExp && (
                  <div className="border-t border-zinc-100 bg-zinc-50/50 px-5 py-4">
                    <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-3">Itens da Ordem</p>
                    <div className="rounded-lg border border-zinc-200 overflow-hidden bg-white">
                      {(order.items ?? []).map((item, i) => (
                        <div key={i} className="flex items-center justify-between px-4 py-3 border-b border-zinc-100 last:border-0 text-sm">
                          <div>
                            <p className="font-medium text-zinc-800">{item.raw_material?.name}</p>
                            <p className="text-xs text-zinc-400">
                              Pedido: {item.quantity_ordered} {item.raw_material?.unit}
                              {item.quantity_received !== null && item.quantity_received !== undefined && (
                                <> · Recebido: <strong className="text-emerald-600">
                                  {item.quantity_received} {item.raw_material?.unit}
                                </strong></>
                              )}
                            </p>
                          </div>
                          <div className="text-right">
                            <p className="font-mono text-zinc-700">
                              {item.total_actual !== null ? currency(item.total_actual) : currency(item.total_planned)}
                            </p>
                            <p className="text-xs text-zinc-400">
                              @ {currency(item.actual_unit_price ?? item.unit_price)}/{item.raw_material?.unit}
                            </p>
                            <Badge className={`text-[10px] mt-0.5 border-none ${
                              item.receipt_status === 'complete' ? 'bg-emerald-100 text-emerald-700' :
                              item.receipt_status === 'partial'  ? 'bg-amber-100 text-amber-700' :
                              'bg-zinc-100 text-zinc-500'
                            }`}>
                              {item.receipt_status === 'complete' ? 'Completo' :
                               item.receipt_status === 'partial'  ? 'Parcial' : 'Pendente'}
                            </Badge>
                          </div>
                        </div>
                      ))}
                    </div>
                    {order.notes && (
                      <p className="text-sm text-zinc-400 italic mt-3">Obs: {order.notes}</p>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* ── Modal Nova Ordem ────────────────────────────── */}
      <Dialog open={isCreateOpen} onOpenChange={setIsCreateOpen}>
        <DialogContent className="sm:max-w-[640px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleCreate}>
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <ShoppingCart className="w-5 h-5 text-primary" /> Nova Ordem de Compra
              </DialogTitle>
              <DialogDescription>Adicione os itens e o fornecedor.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-5 py-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Fornecedor *</Label>
                  <Select value={createForm.supplier_id} onValueChange={v => setCreateForm({ ...createForm, supplier_id: v })}>
                    <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                    <SelectContent>
                      {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
                <div className="grid gap-2">
                  <Label>Prazo de Entrega</Label>
                  <Input type="date" value={createForm.expected_at}
                    onChange={e => setCreateForm({ ...createForm, expected_at: e.target.value })} />
                </div>
              </div>

              {/* Itens */}
              <div>
                <div className="flex items-center justify-between mb-2">
                  <Label>Itens *</Label>
                  <Button type="button" size="sm" variant="outline" className="h-7 gap-1 text-xs"
                    onClick={addItemRow}>
                    <Plus className="w-3 h-3" /> Item
                  </Button>
                </div>

                <div className="space-y-2">
                  {itemForms.map((item, idx) => {
                    const mat = materials.find(m => m.id === parseInt(item.raw_material_id));
                    return (
                      <div key={idx} className="grid grid-cols-12 gap-2 items-center p-3 bg-zinc-50 rounded-lg">
                        <div className="col-span-5">
                          <Select value={item.raw_material_id}
                            onValueChange={v => updateItem(idx, 'raw_material_id', v)}>
                            <SelectTrigger className="h-8 text-xs">
                              <SelectValue placeholder="Matéria-prima..." />
                            </SelectTrigger>
                            <SelectContent>
                              {materials.map(m => (
                                <SelectItem key={m.id} value={String(m.id)}>
                                  {m.name} ({m.unit})
                                </SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                          {mat && (
                            <p className="text-[10px] text-zinc-400 mt-0.5">
                              Estoque: {mat.stock_quantity} · Mín: {mat.min_stock}
                            </p>
                          )}
                        </div>
                        <div className="col-span-3">
                          <Input className="h-8 text-xs" type="number" step="0.001" min="0"
                            placeholder="Qtd"
                            value={item.quantity_ordered}
                            onChange={e => updateItem(idx, 'quantity_ordered', e.target.value)} />
                          {mat && <p className="text-[10px] text-zinc-400 mt-0.5">{mat.unit}</p>}
                        </div>
                        <div className="col-span-3">
                          <Input className="h-8 text-xs" type="number" step="0.0001" min="0"
                            placeholder="Preço/un"
                            value={item.unit_price}
                            onChange={e => updateItem(idx, 'unit_price', e.target.value)} />
                          {item.quantity_ordered && item.unit_price && (
                            <p className="text-[10px] text-zinc-400 mt-0.5">
                              = {currency(parseFloat(item.quantity_ordered) * parseFloat(item.unit_price))}
                            </p>
                          )}
                        </div>
                        <div className="col-span-1 flex justify-end">
                          {itemForms.length > 1 && (
                            <Button type="button" size="sm" variant="ghost"
                              className="h-8 w-8 p-0 text-zinc-400 hover:text-red-500"
                              onClick={() => removeItemRow(idx)}>
                              <Trash2 className="w-3.5 h-3.5" />
                            </Button>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>

                {totalPreview > 0 && (
                  <div className="mt-2 text-right text-sm">
                    <span className="text-zinc-400">Total estimado: </span>
                    <strong className="text-primary">{currency(totalPreview)}</strong>
                  </div>
                )}
              </div>

              <div className="grid gap-2">
                <Label>Observações</Label>
                <Textarea rows={2} value={createForm.notes}
                  onChange={e => setCreateForm({ ...createForm, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsCreateOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary" disabled={!createForm.supplier_id}>Criar Ordem</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* ── Modal Receber ───────────────────────────────── */}
      <Dialog open={isReceiveOpen} onOpenChange={setIsReceiveOpen}>
        <DialogContent className="sm:max-w-[560px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleReceive}>
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <PackageCheck className="w-5 h-5 text-emerald-600" /> Registrar Recebimento
              </DialogTitle>
              <DialogDescription>
                {selectedOrder?.code} — {selectedOrder?.supplier?.name}
              </DialogDescription>
            </DialogHeader>
            <div className="py-4 space-y-2">
              <p className="text-xs text-zinc-400 mb-3">
                Informe a quantidade e o preço real de cada item recebido.
              </p>
              {selectedOrder?.items.map(item => {
                const d       = receiveData[item.id] ?? { qty: "0", price: String(item.unit_price) };
                const pending = item.quantity_ordered - (item.quantity_received ?? 0);
                return (
                  <div key={item.id} className="grid grid-cols-12 gap-2 items-start py-3 border-b border-zinc-100 last:border-0">
                    <div className="col-span-5">
                      <p className="text-sm font-medium text-zinc-800">{item.raw_material?.name}</p>
                      <p className="text-xs text-zinc-400">
                        Pedido: {item.quantity_ordered} {item.raw_material?.unit}
                      </p>
                      {item.quantity_received !== null && item.quantity_received > 0 && (
                        <p className="text-xs text-emerald-600">
                          Já recebido: {item.quantity_received}
                        </p>
                      )}
                      <p className="text-xs text-blue-600">Pendente: {pending}</p>
                    </div>
                    <div className="col-span-3 grid gap-1">
                      <Input type="number" step="0.001" min="0" className="h-8 text-xs"
                        placeholder="Qtd recebida"
                        value={d.qty}
                        onChange={e => setReceiveData(r => ({
                          ...r, [item.id]: { ...r[item.id], qty: e.target.value }
                        }))} />
                      <p className="text-[10px] text-zinc-400">{item.raw_material?.unit}</p>
                    </div>
                    <div className="col-span-4 grid gap-1">
                      <Input type="number" step="0.0001" min="0" className="h-8 text-xs"
                        placeholder="Preço real/un"
                        value={d.price}
                        onChange={e => setReceiveData(r => ({
                          ...r, [item.id]: { ...r[item.id], price: e.target.value }
                        }))} />
                      <p className="text-[10px] text-zinc-400">
                        Estimado: {currency(item.unit_price)}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsReceiveOpen(false)}>Voltar</Button>
              <Button type="submit" className="bg-emerald-600 hover:bg-emerald-700">
                Confirmar e Atualizar Estoque
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* ── Modal Cancelar ──────────────────────────────── */}
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
              placeholder="Informe o motivo..." />
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
