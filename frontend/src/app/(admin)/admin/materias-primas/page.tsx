"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import { Plus, AlertTriangle, PackageSearch, ArrowUp, ArrowDown, RefreshCw, Edit, Trash2, TrendingUp, ImageIcon, Search, X } from "lucide-react";
import { ImageUpload } from "@/components/admin/ImageUpload";

const UNITS = ["g", "kg", "ml", "L", "un", "oz"];
const UNIT_LABELS: Record<string, string> = { g: "g", kg: "kg", ml: "ml", L: "L", un: "unidade(s)", oz: "oz" };

type RawMaterial = {
  id: number;
  name: string;
  description?: string;
  unit: string;
  category: string;
  stock_quantity: number;
  min_stock_quantity: number;
  average_cost: number;
  stock_value: number;
  is_low_stock: boolean;
  is_expired_risk: boolean;
  image_path?: string;
  supplier?: { id: number; name: string };
};

type Supplier = { id: number; name: string };

const emptyForm = {
  name: "", description: "", unit: "g", category: "",
  min_stock_quantity: "0", shelf_life_days: "", supplier_id: "",
  image_path: ""
};

const emptyMovement = { quantity: "", unit_cost: "", type: "adjustment_in" as string, notes: "" };

export default function MateriaPrimaPage() {
  const [materials, setMaterials] = useState<RawMaterial[]>([]);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isMovModal, setIsMovModal] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [selectedMaterial, setSelectedMaterial] = useState<RawMaterial | null>(null);
  const [movType, setMovType] = useState<"entry" | "exit">("entry");
  const [form, setForm] = useState(emptyForm);
  const [movForm, setMovForm] = useState(emptyMovement);
  const [alerts, setAlerts] = useState<{ low_stock: RawMaterial[]; total_stock_value: number }>({ low_stock: [], total_stock_value: 0 });

  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("all");

  const categories = Array.from(new Set(materials.map(m => m.category).filter(Boolean)));

  const filteredMaterials = materials.filter(m => {
    const query = searchQuery.toLowerCase().trim();
    const matchesSearch = !query || 
      m.name.toLowerCase().includes(query) ||
      (m.category && m.category.toLowerCase().includes(query)) ||
      (m.supplier?.name && m.supplier.name.toLowerCase().includes(query)) ||
      (m.description && m.description.toLowerCase().includes(query));

    const matchesCategory = selectedCategory === "all" || m.category === selectedCategory;

    return matchesSearch && matchesCategory;
  });

  useEffect(() => { loadAll(); }, []);

  async function loadAll() {
    setLoading(true);
    try {
      const [matRes, supRes, alertRes] = await Promise.all([
        apiFetch("/inventory/raw-materials"),
        apiFetch("/inventory/suppliers"),
        apiFetch("/inventory/raw-materials/alerts"),
      ]);
      setMaterials(matRes.data);
      setSuppliers(supRes.data);
      setAlerts(alertRes.data);
    } catch (e) {
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  }

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm);
    setIsModalOpen(true);
  }

  function openEdit(m: RawMaterial) {
    setEditingId(m.id);
    setForm({
      name: m.name,
      description: m.description ?? "",
      unit: m.unit,
      category: m.category ?? "",
      min_stock_quantity: String(m.min_stock_quantity),
      shelf_life_days: "",
      supplier_id: m.supplier?.id ? String(m.supplier.id) : "",
      image_path: m.image_path ?? ""
    });
    setIsModalOpen(true);
  }

  function openMovement(m: RawMaterial, type: "entry" | "exit") {
    setSelectedMaterial(m);
    setMovType(type);
    setMovForm({ ...emptyMovement, type: type === "entry" ? "adjustment_in" : "adjustment_out" });
    setIsMovModal(true);
  }

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const payload = { ...form, supplier_id: form.supplier_id || null };
      if (editingId) {
        await apiFetch(`/inventory/raw-materials/${editingId}`, { method: "PUT", body: JSON.stringify(payload) });
        toast.success("Matéria-prima atualizada");
      } else {
        await apiFetch("/inventory/raw-materials", { method: "POST", body: JSON.stringify(payload) });
        toast.success("Matéria-prima cadastrada");
      }
      setIsModalOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao salvar");
    }
  };

  const handleMovement = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedMaterial) return;
    const endpoint = movType === "entry"
      ? `/inventory/raw-materials/${selectedMaterial.id}/entry`
      : `/inventory/raw-materials/${selectedMaterial.id}/exit`;
    try {
      await apiFetch(endpoint, { method: "POST", body: JSON.stringify(movForm) });
      toast.success(movType === "entry" ? "Entrada registrada" : "Saída registrada");
      setIsMovModal(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao registrar movimentação");
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Remover esta matéria-prima?")) return;
    try {
      await apiFetch(`/inventory/raw-materials/${id}`, { method: "DELETE" });
      toast.success("Removida");
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao remover");
    }
  };

  const totalStockValue = alerts.total_stock_value ?? 0;
  const lowStockCount = alerts.low_stock?.length ?? 0;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Matérias-Primas</h1>
          <p className="text-sm text-zinc-500">Controle de insumos e custo médio ponderado.</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" onClick={loadAll} className="gap-2 text-zinc-600">
            <RefreshCw className="w-4 h-4" /> Atualizar
          </Button>
          <Button className="bg-primary hover:bg-olive gap-2" onClick={openCreate}>
            <Plus className="w-4 h-4" /> Nova Matéria-Prima
          </Button>
        </div>
      </div>

      {/* KPIs */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white rounded-xl border border-zinc-100 shadow-sm p-5 flex items-center gap-4">
          <div className="w-11 h-11 rounded-full bg-emerald-50 flex items-center justify-center">
            <TrendingUp className="w-5 h-5 text-emerald-600" />
          </div>
          <div>
            <p className="text-xs text-zinc-400 uppercase tracking-wider">Valor em Estoque</p>
            <p className="text-xl font-bold text-zinc-900">
              {totalStockValue.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
            </p>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-zinc-100 shadow-sm p-5 flex items-center gap-4">
          <div className="w-11 h-11 rounded-full bg-blue-50 flex items-center justify-center">
            <PackageSearch className="w-5 h-5 text-blue-600" />
          </div>
          <div>
            <p className="text-xs text-zinc-400 uppercase tracking-wider">Total de Insumos</p>
            <p className="text-xl font-bold text-zinc-900">{materials.length}</p>
          </div>
        </div>
        <div className={`bg-white rounded-xl border shadow-sm p-5 flex items-center gap-4 ${lowStockCount > 0 ? 'border-red-200 bg-red-50/30' : 'border-zinc-100'}`}>
          <div className={`w-11 h-11 rounded-full flex items-center justify-center ${lowStockCount > 0 ? 'bg-red-100' : 'bg-zinc-50'}`}>
            <AlertTriangle className={`w-5 h-5 ${lowStockCount > 0 ? 'text-red-500' : 'text-zinc-400'}`} />
          </div>
          <div>
            <p className="text-xs text-zinc-400 uppercase tracking-wider">Estoque Crítico</p>
            <p className={`text-xl font-bold ${lowStockCount > 0 ? 'text-red-600' : 'text-zinc-900'}`}>
              {lowStockCount} {lowStockCount === 1 ? 'item' : 'itens'}
            </p>
          </div>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="flex flex-col sm:flex-row gap-3 bg-white p-4 rounded-xl border border-zinc-200 shadow-sm">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-zinc-400" />
          <Input
            placeholder="Buscar por nome, fornecedor ou categoria..."
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            className="pl-9 h-10 text-sm"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery("")}
              className="absolute right-3 top-2.5 h-4 w-4 text-zinc-400 hover:text-zinc-600 flex items-center justify-center"
              type="button"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>
        <div className="w-full sm:w-[220px]">
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="h-10 text-sm">
              <SelectValue placeholder="Todas as Categorias" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todas as Categorias</SelectItem>
              {categories.map(cat => (
                <SelectItem key={cat} value={cat}>{cat}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Nome</TableHead>
              <TableHead>Categoria</TableHead>
              <TableHead className="text-right">Estoque</TableHead>
              <TableHead className="text-right">Custo Médio</TableHead>
              <TableHead className="text-right">Valor Total</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-center">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={7} className="text-center py-12 text-zinc-400">Carregando...</TableCell></TableRow>
            ) : filteredMaterials.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-16">
                  <PackageSearch className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
                  <p className="text-zinc-400">
                    {materials.length === 0 
                      ? "Nenhuma matéria-prima cadastrada." 
                      : "Nenhum insumo encontrado com os filtros atuais."}
                  </p>
                  {materials.length > 0 ? (
                    <Button variant="link" onClick={() => { setSearchQuery(""); setSelectedCategory("all"); }} className="text-primary mt-2">
                      Limpar filtros
                    </Button>
                  ) : (
                    <Button variant="link" onClick={openCreate} className="text-primary mt-2">Cadastrar agora</Button>
                  )}
                </TableCell>
              </TableRow>
            ) : filteredMaterials.map((m) => (
              <TableRow key={m.id} className={m.is_low_stock ? "bg-red-50/40" : ""}>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-lg bg-zinc-100 border border-zinc-200 overflow-hidden flex items-center justify-center shrink-0">
                      {m.image_path ? (
                        <img 
                          src={m.image_path} 
                          alt={m.name} 
                          className="w-full h-full object-cover" 
                        />
                      ) : (
                        <PackageSearch className="w-5 h-5 text-zinc-400" />
                      )}
                    </div>
                    <div>
                      <p className="font-medium text-zinc-900">{m.name}</p>
                      {m.supplier && <p className="text-xs text-zinc-400">{m.supplier.name}</p>}
                    </div>
                  </div>
                </TableCell>
                <TableCell>
                  {m.category
                    ? <Badge variant="outline" className="text-xs">{m.category}</Badge>
                    : <span className="text-zinc-300">—</span>}
                </TableCell>
                <TableCell className="text-right font-mono font-semibold">
                  {m.stock_quantity.toLocaleString('pt-BR', { maximumFractionDigits: 3 })} {UNIT_LABELS[m.unit] ?? m.unit}
                </TableCell>
                <TableCell className="text-right font-mono text-sm">
                  {m.average_cost > 0
                    ? `R$ ${m.average_cost.toFixed(4)}/${m.unit}`
                    : <span className="text-zinc-300">—</span>}
                </TableCell>
                <TableCell className="text-right font-semibold text-emerald-700">
                  {m.stock_value > 0
                    ? m.stock_value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
                    : <span className="text-zinc-300 font-normal">—</span>}
                </TableCell>
                <TableCell>
                  <div className="flex flex-col gap-1">
                    {m.is_low_stock && (
                      <Badge className="bg-red-100 text-red-700 border-none text-[10px] gap-1 w-fit">
                        <AlertTriangle className="w-3 h-3" /> Estoque Baixo
                      </Badge>
                    )}
                    {m.is_expired_risk && (
                      <Badge className="bg-amber-100 text-amber-700 border-none text-[10px] w-fit">
                        Validade Próxima
                      </Badge>
                    )}
                    {!m.is_low_stock && !m.is_expired_risk && (
                      <Badge className="bg-emerald-100 text-emerald-700 border-none text-[10px] w-fit">OK</Badge>
                    )}
                  </div>
                </TableCell>
                <TableCell>
                  <div className="flex items-center justify-center gap-1">
                    <Button size="sm" variant="outline" className="h-8 gap-1 text-emerald-700 border-emerald-200 hover:bg-emerald-50 text-xs"
                      onClick={() => openMovement(m, "entry")}>
                      <ArrowUp className="w-3 h-3" /> Entrada
                    </Button>
                    <Button size="sm" variant="outline" className="h-8 gap-1 text-red-600 border-red-200 hover:bg-red-50 text-xs"
                      onClick={() => openMovement(m, "exit")}>
                      <ArrowDown className="w-3 h-3" /> Saída
                    </Button>
                    <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => openEdit(m)}>
                      <Edit className="w-3.5 h-3.5 text-zinc-500" />
                    </Button>
                    <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => handleDelete(m.id)}>
                      <Trash2 className="w-3.5 h-3.5 text-red-400" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Modal Cadastro */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-[550px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleSave}>
            <DialogHeader>
              <DialogTitle>{editingId ? "Editar Matéria-Prima" : "Nova Matéria-Prima"}</DialogTitle>
              <DialogDescription>Preencha as informações do insumo.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label>Nome *</Label>
                <Input value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} required />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Unidade *</Label>
                  <Select value={form.unit} onValueChange={v => setForm({ ...form, unit: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      {UNITS.map(u => <SelectItem key={u} value={u}>{u}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
                <div className="grid gap-2">
                  <Label>Categoria</Label>
                  <Input placeholder="ex: Óleo Essencial" list="categories-list" value={form.category} onChange={e => setForm({ ...form, category: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Estoque Mínimo</Label>
                  <Input type="number" step="0.001" min="0" value={form.min_stock_quantity}
                    onChange={e => setForm({ ...form, min_stock_quantity: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Validade (dias)</Label>
                  <Input type="number" min="1" placeholder="ex: 365" value={form.shelf_life_days}
                    onChange={e => setForm({ ...form, shelf_life_days: e.target.value })} />
                </div>
              </div>
              <div className="grid gap-2">
                <Label>Fornecedor Padrão</Label>
                <Select value={form.supplier_id} onValueChange={v => setForm({ ...form, supplier_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                  <SelectContent>
                    {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid gap-2 pt-2">
                <Label>Foto do Insumo (Opcional)</Label>
                <ImageUpload 
                  value={form.image_path} 
                  onUpload={url => setForm({ ...form, image_path: url })} 
                />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">{editingId ? "Atualizar" : "Cadastrar"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal Movimentação */}
      <Dialog open={isMovModal} onOpenChange={setIsMovModal}>
        <DialogContent className="sm:max-w-[420px]">
          <form onSubmit={handleMovement}>
            <DialogHeader>
              <DialogTitle>
                {movType === "entry" ? "Registrar Entrada" : "Registrar Saída"}
              </DialogTitle>
              <DialogDescription>
                {selectedMaterial?.name} — Estoque atual:{" "}
                <strong>{selectedMaterial?.stock_quantity} {selectedMaterial?.unit}</strong>
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Quantidade *</Label>
                  <Input type="number" step="0.001" min="0.001" required
                    value={movForm.quantity} onChange={e => setMovForm({ ...movForm, quantity: e.target.value })} />
                </div>
                {movType === "entry" && (
                  <div className="grid gap-2">
                    <Label>Custo Unitário (R$) *</Label>
                    <Input type="number" step="0.0001" min="0" required
                      value={movForm.unit_cost} onChange={e => setMovForm({ ...movForm, unit_cost: e.target.value })} />
                  </div>
                )}
              </div>
              <div className="grid gap-2">
                <Label>Tipo</Label>
                <Select value={movForm.type} onValueChange={v => setMovForm({ ...movForm, type: v })}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {movType === "entry" ? (
                      <>
                        <SelectItem value="adjustment_in">Ajuste de Entrada</SelectItem>
                        <SelectItem value="return">Devolução ao Estoque</SelectItem>
                      </>
                    ) : (
                      <>
                        <SelectItem value="adjustment_out">Ajuste de Saída</SelectItem>
                        <SelectItem value="waste">Perda / Descarte</SelectItem>
                      </>
                    )}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid gap-2">
                <Label>Observações</Label>
                <Input value={movForm.notes} onChange={e => setMovForm({ ...movForm, notes: e.target.value })} />
              </div>
              {movType === "entry" && movForm.quantity && movForm.unit_cost && (
                <div className="rounded-lg bg-emerald-50 border border-emerald-100 p-3 text-sm">
                  <p className="text-emerald-700">
                    Novo custo médio será recalculado automaticamente.
                  </p>
                  <p className="text-emerald-600 font-semibold mt-1">
                    Total: {(parseFloat(movForm.quantity || "0") * parseFloat(movForm.unit_cost || "0")).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                </div>
              )}
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsMovModal(false)}>Cancelar</Button>
              <Button type="submit" className={movType === "entry" ? "bg-emerald-600 hover:bg-emerald-700" : "bg-red-600 hover:bg-red-700"}>
                {movType === "entry" ? "Registrar Entrada" : "Registrar Saída"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <datalist id="categories-list">
        {categories.map(c => <option key={c} value={c} />)}
      </datalist>
    </div>
  );
}
