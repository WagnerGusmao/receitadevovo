"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Progress } from "@/components/ui/progress";
import { toast } from "sonner";
import { Plus, PackageCheck, AlertTriangle, Calendar, Edit } from "lucide-react";

type Batch = {
  id: number;
  internal_code: string;
  batch_number: string;
  quantity_received: number;
  quantity_remaining: number;
  unit_cost: number;
  manufactured_at?: string;
  expires_at?: string;
  status: string;
  consumption_percent: number;
  days_to_expire?: number;
  is_expiring_soon: boolean;
  raw_material: { id: number; name: string; unit: string };
  supplier?: { id: number; name: string };
};

type RawMaterial = { id: number; name: string; unit: string };
type Supplier = { id: number; name: string };

const STATUS_CONFIG: Record<string, { label: string; class: string }> = {
  active:     { label: "Ativo",       class: "bg-emerald-100 text-emerald-700 border-none" },
  depleted:   { label: "Esgotado",    class: "bg-zinc-100 text-zinc-500 border-none" },
  expired:    { label: "Vencido",     class: "bg-red-100 text-red-700 border-none" },
  quarantine: { label: "Quarentena",  class: "bg-amber-100 text-amber-700 border-none" },
};

const emptyForm = {
  raw_material_id: "", supplier_id: "", batch_number: "",
  quantity: "", unit_cost: "", manufactured_at: "", expires_at: "", notes: ""
};

export default function LotesPage() {
  const [batches, setBatches] = useState<Batch[]>([]);
  const [materials, setMaterials] = useState<RawMaterial[]>([]);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [filterStatus, setFilterStatus] = useState("all");

  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingBatch, setEditingBatch] = useState<Batch | null>(null);
  const [editForm, setEditForm] = useState({
    supplier_id: "",
    batch_number: "",
    quantity: "",
    unit_cost: "",
    manufactured_at: "",
    expires_at: "",
    notes: "",
    status: ""
  });

  useEffect(() => { load(); }, []);

  async function load() {
    setLoading(true);
    try {
      const [batchRes, matRes, supRes] = await Promise.all([
        apiFetch("/inventory/batches"),
        apiFetch("/inventory/raw-materials"),
        apiFetch("/inventory/suppliers"),
      ]);
      setBatches(batchRes.data.data ?? batchRes.data);
      setMaterials(matRes.data);
      setSuppliers(supRes.data);
    } catch {
      toast.error("Erro ao carregar lotes");
    } finally {
      setLoading(false);
    }
  }

  const handleReceive = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch("/inventory/batches/receive", {
        method: "POST",
        body: JSON.stringify({ ...form, supplier_id: form.supplier_id || null })
      });
      toast.success("Lote recebido e estoque atualizado!");
      setIsModalOpen(false);
      setForm(emptyForm);
      load();
    } catch (e: any) {
      toast.error(e.message || "Erro ao receber lote");
    }
  };

  const openEdit = (b: Batch) => {
    setEditingBatch(b);
    setEditForm({
      supplier_id: b.supplier?.id ? String(b.supplier.id) : "",
      batch_number: b.batch_number,
      quantity: String(b.quantity_received),
      unit_cost: String(b.unit_cost),
      manufactured_at: b.manufactured_at ? b.manufactured_at.substring(0, 10) : "",
      expires_at: b.expires_at ? b.expires_at.substring(0, 10) : "",
      notes: (b as any).notes ?? "",
      status: b.status
    });
    setIsEditModalOpen(true);
  };

  const handleUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingBatch) return;
    try {
      await apiFetch(`/inventory/batches/${editingBatch.id}`, {
        method: "PUT",
        body: JSON.stringify({
          supplier_id: editForm.supplier_id ? Number(editForm.supplier_id) : null,
          batch_number: editForm.batch_number,
          quantity: Number(editForm.quantity),
          unit_cost: Number(editForm.unit_cost),
          manufactured_at: editForm.manufactured_at || null,
          expires_at: editForm.expires_at || null,
          notes: editForm.notes || null,
          status: editForm.status
        })
      });
      toast.success("Lote atualizado com sucesso!");
      setIsEditModalOpen(false);
      load();
    } catch (e: any) {
      toast.error(e.message || "Erro ao atualizar lote");
    }
  };

  const filteredBatches = filterStatus === "all"
    ? batches
    : batches.filter(b => b.status === filterStatus);

  const expiringSoon = batches.filter(b => b.is_expiring_soon).length;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Lotes de Matéria-Prima</h1>
          <p className="text-sm text-zinc-500">Rastreabilidade e controle de validade por lote.</p>
        </div>
        <Button className="bg-primary hover:bg-olive gap-2" onClick={() => { setForm(emptyForm); setIsModalOpen(true); }}>
          <Plus className="w-4 h-4" /> Receber Lote
        </Button>
      </div>

      {expiringSoon > 0 && (
        <div className="flex items-center gap-3 bg-amber-50 border border-amber-200 rounded-xl p-4">
          <AlertTriangle className="w-5 h-5 text-amber-500 shrink-0" />
          <p className="text-sm text-amber-800">
            <strong>{expiringSoon} {expiringSoon === 1 ? "lote vence" : "lotes vencem"}</strong> nos próximos 30 dias. Verifique os lotes marcados em amarelo.
          </p>
        </div>
      )}

      {/* Filtros */}
      <div className="flex gap-2 flex-wrap">
        {["all", "active", "expiring", "depleted", "expired", "quarantine"].map(s => (
          <button key={s}
            onClick={() => setFilterStatus(s)}
            className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-colors ${
              filterStatus === s
                ? "bg-primary text-white border-primary"
                : "bg-white text-zinc-500 border-zinc-200 hover:border-zinc-300"
            }`}>
            {s === "all" ? "Todos" : s === "expiring" ? "Vencendo em Breve" : STATUS_CONFIG[s]?.label ?? s}
          </button>
        ))}
      </div>

      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Código Interno</TableHead>
              <TableHead>Matéria-Prima</TableHead>
              <TableHead>Lote Fornecedor</TableHead>
              <TableHead className="text-right">Qtd. Restante</TableHead>
              <TableHead className="text-right">Custo/Un.</TableHead>
              <TableHead>Consumo</TableHead>
              <TableHead>Validade</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-center">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={9} className="text-center py-10 text-zinc-400">Carregando...</TableCell></TableRow>
            ) : filteredBatches.length === 0 ? (
              <TableRow>
                <TableCell colSpan={9} className="text-center py-16">
                  <PackageCheck className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
                  <p className="text-zinc-400">Nenhum lote encontrado.</p>
                </TableCell>
              </TableRow>
            ) : filteredBatches.map((b) => (
              <TableRow key={b.id} className={b.is_expiring_soon ? "bg-amber-50/40" : ""}>
                <TableCell>
                  <span className="font-mono text-xs bg-zinc-100 px-2 py-1 rounded text-zinc-600">
                    {b.internal_code}
                  </span>
                </TableCell>
                <TableCell>
                  <div>
                    <p className="font-medium text-zinc-900">{b.raw_material?.name}</p>
                    {b.supplier && <p className="text-xs text-zinc-400">{b.supplier.name}</p>}
                  </div>
                </TableCell>
                <TableCell className="font-mono text-sm text-zinc-500">{b.batch_number}</TableCell>
                <TableCell className="text-right font-semibold">
                  {b.quantity_remaining.toLocaleString('pt-BR', { maximumFractionDigits: 3 })}
                  <span className="text-xs text-zinc-400 ml-1">{b.raw_material?.unit}</span>
                </TableCell>
                <TableCell className="text-right text-sm font-mono">
                  R$ {b.unit_cost.toFixed(4)}
                </TableCell>
                <TableCell className="w-36">
                  <div className="space-y-1">
                    <Progress value={b.consumption_percent} className="h-1.5" />
                    <p className="text-[10px] text-zinc-400">{b.consumption_percent}% consumido</p>
                  </div>
                </TableCell>
                <TableCell>
                  {b.expires_at ? (
                    <div className={`flex items-center gap-1 text-xs ${b.is_expiring_soon ? "text-amber-700 font-semibold" : "text-zinc-500"}`}>
                      <Calendar className="w-3 h-3" />
                      {new Date(b.expires_at).toLocaleDateString('pt-BR')}
                      {b.days_to_expire !== undefined && b.days_to_expire !== null && (
                        <span className="ml-1">({b.days_to_expire}d)</span>
                      )}
                    </div>
                  ) : (
                    <span className="text-zinc-300 text-xs">—</span>
                  )}
                </TableCell>
                <TableCell>
                  <Badge className={STATUS_CONFIG[b.status]?.class ?? ""}>
                    {STATUS_CONFIG[b.status]?.label ?? b.status}
                  </Badge>
                </TableCell>
                <TableCell>
                  <div className="flex items-center justify-center">
                    <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => openEdit(b)}>
                      <Edit className="w-3.5 h-3.5 text-zinc-500" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Modal Recebimento */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-[560px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleReceive}>
            <DialogHeader>
              <DialogTitle>Receber Novo Lote</DialogTitle>
              <DialogDescription>
                O custo médio ponderado será recalculado automaticamente.
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label>Matéria-Prima *</Label>
                <Select value={form.raw_material_id} onValueChange={v => setForm({ ...form, raw_material_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                  <SelectContent>
                    {materials.map(m => <SelectItem key={m.id} value={String(m.id)}>{m.name} ({m.unit})</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Nº Lote do Fornecedor *</Label>
                  <Input required value={form.batch_number} onChange={e => setForm({ ...form, batch_number: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Fornecedor</Label>
                  <Select value={form.supplier_id} onValueChange={v => setForm({ ...form, supplier_id: v })}>
                    <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                    <SelectContent>
                      {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Quantidade *</Label>
                  <Input type="number" step="0.001" min="0.001" required
                    value={form.quantity} onChange={e => setForm({ ...form, quantity: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Custo Unitário (R$) *</Label>
                  <Input type="number" step="0.0001" min="0" required
                    value={form.unit_cost} onChange={e => setForm({ ...form, unit_cost: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Data Fabricação</Label>
                  <Input type="date" value={form.manufactured_at} onChange={e => setForm({ ...form, manufactured_at: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Validade</Label>
                  <Input type="date" value={form.expires_at} onChange={e => setForm({ ...form, expires_at: e.target.value })} />
                </div>
              </div>
              {form.quantity && form.unit_cost && (
                <div className="rounded-lg bg-emerald-50 border border-emerald-100 p-3 text-sm space-y-1">
                  <p className="text-emerald-800 font-semibold">
                    Valor total do lote:{" "}
                    {(parseFloat(form.quantity) * parseFloat(form.unit_cost)).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                  <p className="text-emerald-600 text-xs">O custo médio ponderado será recalculado automaticamente.</p>
                </div>
              )}
              <div className="grid gap-2">
                <Label>Observações</Label>
                <Input value={form.notes} onChange={e => setForm({ ...form, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">Confirmar Recebimento</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal Edição */}
      <Dialog open={isEditModalOpen} onOpenChange={setIsEditModalOpen}>
        <DialogContent className="sm:max-w-[560px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleUpdate}>
            <DialogHeader>
              <DialogTitle>Editar Lote</DialogTitle>
              <DialogDescription>
                Ajuste os dados do lote. O estoque total e o custo médio ponderado da matéria-prima serão recalculados.
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label>Matéria-Prima</Label>
                <Input disabled value={editingBatch?.raw_material?.name || ""} />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Nº Lote do Fornecedor *</Label>
                  <Input required value={editForm.batch_number} onChange={e => setEditForm({ ...editForm, batch_number: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Fornecedor</Label>
                  <Select value={editForm.supplier_id} onValueChange={v => setEditForm({ ...editForm, supplier_id: v })}>
                    <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                    <SelectContent>
                      {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Quantidade Recebida *</Label>
                  <Input type="number" step="0.001" min="0.001" required
                    value={editForm.quantity} onChange={e => setEditForm({ ...editForm, quantity: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Custo Unitário (R$) *</Label>
                  <Input type="number" step="0.0001" min="0" required
                    value={editForm.unit_cost} onChange={e => setEditForm({ ...editForm, unit_cost: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Data Fabricação</Label>
                  <Input type="date" value={editForm.manufactured_at} onChange={e => setEditForm({ ...editForm, manufactured_at: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Validade</Label>
                  <Input type="date" value={editForm.expires_at} onChange={e => setEditForm({ ...editForm, expires_at: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Status *</Label>
                  <Select value={editForm.status} onValueChange={v => setEditForm({ ...editForm, status: v })}>
                    <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="active">Ativo</SelectItem>
                      <SelectItem value="depleted">Esgotado</SelectItem>
                      <SelectItem value="expired">Vencido</SelectItem>
                      <SelectItem value="quarantine">Quarentena</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                {editForm.quantity && editForm.unit_cost && (
                  <div className="rounded-lg bg-emerald-50 border border-emerald-100 p-3 text-sm flex flex-col justify-center">
                    <p className="text-emerald-800 font-semibold">
                      Novo total:{" "}
                      {(parseFloat(editForm.quantity) * parseFloat(editForm.unit_cost)).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                    </p>
                  </div>
                )}
              </div>
              <div className="grid gap-2">
                <Label>Observações</Label>
                <Input value={editForm.notes} onChange={e => setEditForm({ ...editForm, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsEditModalOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">Salvar Alterações</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
