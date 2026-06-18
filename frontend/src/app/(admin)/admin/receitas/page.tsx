"use client";

import { useEffect, useState, useCallback, useRef } from "react";
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
  FlaskConical, Plus, Trash2, Edit, ChevronDown, ChevronUp,
  CheckCircle2, XCircle, AlertTriangle, TrendingUp, Layers, Clock, Beaker, Search, X
} from "lucide-react";

type RawMaterial = { id: number; name: string; unit: string; average_cost: number; stock_quantity: number };
type Product = { id: number; name: string; price: string };
type Ingredient = { raw_material_id: string; quantity: string; waste_percent: string; notes: string };

type RecipeIngredientFull = {
  id: number;
  raw_material_id: number;
  quantity: number;
  waste_percent: number;
  quantity_with_waste: number;
  unit_cost: number;
  total_cost: number;
  notes?: string;
  raw_material: RawMaterial;
};

type Recipe = {
  id: number;
  name: string;
  product_id?: number;
  description?: string;
  instructions?: string;
  yield_quantity: number;
  yield_unit: string;
  waste_percent: number;
  prep_time_minutes?: number;
  is_active: boolean;
  batch_cost: number;
  unit_cost: number;
  effective_yield: number;
  margin_percent?: number;
  feasibility: {
    batches_possible: number;
    units_possible: number;
    can_produce: boolean;
    shortages: { material: string; unit: string; needed: number; available: number; missing: number }[];
  };
  product?: Product;
  ingredients: RecipeIngredientFull[];
};

type SimResult = {
  batches: number;
  can_produce: boolean;
  batch_cost: number;
  total_units: number;
  unit_cost: number;
  revenue: number;
  profit: number;
  margin_percent?: number;
  ingredients: {
    raw_material: string; unit: string;
    per_batch: number; total_needed: number;
    available: number; is_sufficient: boolean; missing: number;
    unit_cost: number; total_cost: number;
  }[];
};

const YIELD_UNITS = ["un", "g", "kg", "ml", "L"];

const emptyIngredient = (): Ingredient => ({ raw_material_id: "", quantity: "", waste_percent: "0", notes: "" });
const emptyForm = () => ({
  name: "", product_id: "", description: "", instructions: "",
  yield_quantity: "", yield_unit: "un", waste_percent: "0",
  prep_time_minutes: "", ingredients: [emptyIngredient()]
});

interface SearchableSelectProps<T> {
  value: string;
  onChange: (value: string) => void;
  onClear?: () => void;
  options: T[];
  getOptionLabel: (option: T) => string;
  getOptionSearchValue: (option: T) => string;
  getOptionId: (option: T) => string;
  renderOption?: (option: T, isSelected: boolean) => React.ReactNode;
  placeholder?: string;
}

function SearchableSelect<T extends unknown>({
  value,
  onChange,
  onClear,
  options,
  getOptionLabel,
  getOptionSearchValue,
  getOptionId,
  renderOption,
  placeholder = "Selecionar..."
}: SearchableSelectProps<T>) {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const selectedOption = options.find(o => getOptionId(o) === value);

  const filteredOptions = options.filter(o =>
    getOptionSearchValue(o).toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="relative w-full" ref={containerRef}>
      <button
        type="button"
        onClick={() => {
          setIsOpen(!isOpen);
          setSearchTerm("");
        }}
        className="flex min-h-9 h-auto w-full items-center justify-between rounded-lg border border-bege bg-white px-3 py-1.5 text-xs text-zinc-800 outline-none transition-all focus:ring-2 focus:ring-sage/20 text-left shadow-sm hover:border-sage"
      >
        <span className="whitespace-normal break-words leading-tight pr-2 flex-1">
          {selectedOption ? getOptionLabel(selectedOption) : placeholder}
        </span>
        <div className="flex items-center gap-1 shrink-0">
          {onClear && selectedOption && (
            <span
              onClick={(e) => {
                e.stopPropagation();
                onClear();
              }}
              className="p-0.5 rounded-full hover:bg-zinc-100 text-marrom-suave/75 hover:text-red-500 cursor-pointer"
            >
              <X className="h-3 w-3" />
            </span>
          )}
          <ChevronDown className="h-4 w-4 opacity-50 text-marrom-suave animate-none" />
        </div>
      </button>

      {isOpen && (
        <div className="absolute z-50 w-full sm:w-[130%] min-w-[320px] max-w-[500px] max-h-60 overflow-hidden rounded-xl border border-bege bg-bege-light shadow-lg mt-1 p-2 animate-in fade-in-50 zoom-in-95 left-0">
          <div className="flex items-center gap-2 border-b border-bege pb-2 mb-2 px-1">
            <Search className="h-4 w-4 shrink-0 text-marrom-suave" />
            <input
              type="text"
              placeholder="Buscar..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="flex h-8 w-full bg-white rounded-md border border-bege px-3 py-1 text-sm outline-none placeholder:text-zinc-400 focus:ring-2 focus:ring-sage/20 text-zinc-800"
              autoFocus
            />
          </div>
          <div className="overflow-y-auto max-h-40 space-y-1 pr-1">
            {filteredOptions.length === 0 ? (
              <div className="py-3 text-center text-xs text-marrom-suave font-medium">Nenhum resultado encontrado.</div>
            ) : (
              filteredOptions.map((o) => {
                const id = getOptionId(o);
                const isSelected = id === value;
                return (
                  <button
                    key={id}
                    type="button"
                    onClick={() => {
                      onChange(id);
                      setIsOpen(false);
                    }}
                    className={`flex w-full cursor-pointer items-center rounded-lg py-1.5 px-3 text-xs text-left transition-colors ${
                      isSelected
                        ? "bg-sage text-white font-medium shadow-sm"
                        : "text-zinc-700 hover:bg-sage/10 hover:text-terra"
                    }`}
                  >
                    {renderOption ? (
                      renderOption(o, isSelected)
                    ) : (
                      <span className="truncate">{getOptionLabel(o)}</span>
                    )}
                  </button>
                );
              })
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export default function ReceitasPage() {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [materials, setMaterials] = useState<RawMaterial[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSimOpen, setIsSimOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [expandedId, setExpandedId] = useState<number | null>(null);
  const [selectedRecipe, setSelectedRecipe] = useState<Recipe | null>(null);
  const [simBatches, setSimBatches] = useState("1");
  const [simResult, setSimResult] = useState<SimResult | null>(null);
  const [simLoading, setSimLoading] = useState(false);
  const [form, setForm] = useState(emptyForm());
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => { loadAll(); }, []);

  async function loadAll() {
    setLoading(true);
    try {
      const [recRes, matRes, prodRes] = await Promise.all([
        apiFetch("/inventory/recipes"),
        apiFetch("/inventory/raw-materials"),
        apiFetch("/ecommerce/products"),
      ]);
      setRecipes(recRes.data);
      setMaterials(matRes.data);
      setProducts(prodRes.data.products ?? []);
    } catch {
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  }

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm());
    setIsModalOpen(true);
  }

  function openEdit(r: Recipe) {
    setEditingId(r.id);
    setForm({
      name: r.name,
      product_id: r.product_id ? String(r.product_id) : "",
      description: r.description ?? "",
      instructions: r.instructions ?? "",
      yield_quantity: String(r.yield_quantity),
      yield_unit: r.yield_unit,
      waste_percent: String(r.waste_percent),
      prep_time_minutes: r.prep_time_minutes ? String(r.prep_time_minutes) : "",
      ingredients: r.ingredients.map(i => ({
        raw_material_id: String(i.raw_material_id),
        quantity: String(i.quantity),
        waste_percent: String(i.waste_percent),
        notes: i.notes ?? "",
      })),
    });
    setIsModalOpen(true);
  }

  function openSimulate(r: Recipe) {
    setSelectedRecipe(r);
    setSimBatches("1");
    setSimResult(null);
    setIsSimOpen(true);
  }

  const addIngredient = () => setForm(f => ({ ...f, ingredients: [emptyIngredient(), ...f.ingredients] }));
  const removeIngredient = (i: number) => setForm(f => ({ ...f, ingredients: f.ingredients.filter((_, idx) => idx !== i) }));
  const updateIngredient = (i: number, field: keyof Ingredient, value: string) =>
    setForm(f => ({ ...f, ingredients: f.ingredients.map((ing, idx) => idx === i ? { ...ing, [field]: value } : ing) }));

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    const payload = {
      ...form,
      product_id: form.product_id || null,
      prep_time_minutes: form.prep_time_minutes || null,
      ingredients: form.ingredients.filter(i => i.raw_material_id && i.quantity),
    };
    try {
      if (editingId) {
        await apiFetch(`/inventory/recipes/${editingId}`, { method: "PUT", body: JSON.stringify(payload) });
        toast.success("Receita atualizada");
      } else {
        await apiFetch("/inventory/recipes", { method: "POST", body: JSON.stringify(payload) });
        toast.success("Receita criada");
      }
      setIsModalOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao salvar receita");
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Remover esta receita?")) return;
    try {
      await apiFetch(`/inventory/recipes/${id}`, { method: "DELETE" });
      toast.success("Receita removida");
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao remover");
    }
  };

  const handleSimulate = async () => {
    if (!selectedRecipe) return;
    setSimLoading(true);
    try {
      const res = await apiFetch(`/inventory/recipes/${selectedRecipe.id}/simulate?batches=${simBatches}`);
      setSimResult(res.data);
    } catch (e: any) {
      toast.error(e.message || "Erro na simulação");
    } finally {
      setSimLoading(false);
    }
  };

  // Preview de custo no formulário
  const previewCost = useCallback(() => {
    return form.ingredients.reduce((total, ing) => {
      const mat = materials.find(m => m.id === parseInt(ing.raw_material_id));
      if (!mat || !ing.quantity) return total;
      const qty = parseFloat(ing.quantity) * (1 + parseFloat(ing.waste_percent || "0") / 100);
      return total + qty * mat.average_cost;
    }, 0);
  }, [form.ingredients, materials]);

  const previewUnitCost = useCallback(() => {
    const yield_ = parseFloat(form.yield_quantity || "0") * (1 - parseFloat(form.waste_percent || "0") / 100);
    if (yield_ <= 0) return 0;
    return previewCost() / yield_;
  }, [previewCost, form.yield_quantity, form.waste_percent]);

  const filteredRecipes = recipes.filter((recipe) => {
    const q = searchQuery.toLowerCase();
    return (
      recipe.name.toLowerCase().includes(q) ||
      (recipe.description && recipe.description.toLowerCase().includes(q)) ||
      (recipe.product && recipe.product.name.toLowerCase().includes(q))
    );
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Receitas & Fórmulas</h1>
          <p className="text-sm text-zinc-500">Gerencie fórmulas de produção com custo e viabilidade em tempo real.</p>
        </div>
        <Button className="bg-primary hover:bg-olive gap-2" onClick={openCreate}>
          <Plus className="w-4 h-4" /> Nova Receita
        </Button>
      </div>

      {/* Barra de Pesquisa */}
      {recipes.length > 0 && (
        <div className="relative">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-zinc-400" />
          <Input
            placeholder="Buscar receitas por nome, descrição ou produto vinculado..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-9 h-9 border-zinc-200 focus-visible:ring-sage/20 focus-visible:border-sage bg-white rounded-lg shadow-sm"
          />
        </div>
      )}

      {/* Lista de Receitas */}
      {loading ? (
        <div className="text-center py-20 text-zinc-400">Carregando receitas...</div>
      ) : recipes.length === 0 ? (
        <div className="text-center py-20 bg-white rounded-xl border border-dashed border-zinc-200">
          <Beaker className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
          <p className="text-zinc-400">Nenhuma receita cadastrada.</p>
          <Button variant="link" onClick={openCreate} className="text-primary mt-2">Criar primeira receita</Button>
        </div>
      ) : filteredRecipes.length === 0 ? (
        <div className="text-center py-20 bg-white rounded-xl border border-dashed border-zinc-200">
          <Search className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
          <p className="text-zinc-400">Nenhuma receita encontrada para a busca "{searchQuery}".</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filteredRecipes.map((recipe) => (
            <div key={recipe.id} className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
              {/* Card Header */}
              <div className="p-5 flex items-start gap-4">
                <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                  <FlaskConical className="w-5 h-5 text-primary" />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <h3 className="font-semibold text-zinc-900">{recipe.name}</h3>
                    {recipe.product && (
                      <Badge variant="outline" className="text-xs">{recipe.product.name}</Badge>
                    )}
                    {recipe.feasibility.can_produce
                      ? <Badge className="bg-emerald-100 text-emerald-700 border-none text-xs gap-1"><CheckCircle2 className="w-3 h-3" /> Pode Produzir</Badge>
                      : <Badge className="bg-red-100 text-red-700 border-none text-xs gap-1"><XCircle className="w-3 h-3" /> Estoque Insuficiente</Badge>
                    }
                  </div>
                  {recipe.description && <p className="text-sm text-zinc-500 mt-0.5 truncate">{recipe.description}</p>}

                  {/* KPIs rápidos */}
                  <div className="flex flex-wrap gap-4 mt-3 text-sm">
                    <div className="flex items-center gap-1.5 text-zinc-500">
                      <Layers className="w-3.5 h-3.5" />
                      <span>Rendimento: <strong className="text-zinc-800">{recipe.effective_yield} {recipe.yield_unit}</strong></span>
                    </div>
                    <div className="flex items-center gap-1.5 text-zinc-500">
                      <TrendingUp className="w-3.5 h-3.5" />
                      <span>Custo/un: <strong className="text-zinc-800">R$ {recipe.unit_cost.toFixed(4)}</strong></span>
                    </div>
                    <div className="flex items-center gap-1.5 text-zinc-500">
                      <span>Custo lote: <strong className="text-zinc-800">R$ {recipe.batch_cost.toFixed(2)}</strong></span>
                    </div>
                    {recipe.margin_percent !== null && recipe.margin_percent !== undefined && (
                      <div className={`flex items-center gap-1.5 font-semibold ${recipe.margin_percent >= 30 ? 'text-emerald-600' : recipe.margin_percent >= 0 ? 'text-amber-600' : 'text-red-600'}`}>
                        Margem: {recipe.margin_percent}%
                      </div>
                    )}
                    {recipe.prep_time_minutes && (
                      <div className="flex items-center gap-1.5 text-zinc-400">
                        <Clock className="w-3.5 h-3.5" />
                        {recipe.prep_time_minutes} min
                      </div>
                    )}
                    <div className="flex items-center gap-1.5 text-zinc-500">
                      <span>Produção possível: <strong className={recipe.feasibility.batches_possible >= 1 ? "text-emerald-700" : "text-red-600"}>{recipe.feasibility.batches_possible} lote(s) / {recipe.feasibility.units_possible} un</strong></span>
                    </div>
                  </div>

                  {/* Alertas de falta */}
                  {recipe.feasibility.shortages.length > 0 && (
                    <div className="mt-2 flex flex-wrap gap-2">
                      {recipe.feasibility.shortages.map((s, i) => (
                        <span key={i} className="text-xs bg-red-50 text-red-600 border border-red-100 px-2 py-0.5 rounded-full flex items-center gap-1">
                          <AlertTriangle className="w-3 h-3" />
                          {s.material}: faltam {s.missing} {s.unit}
                        </span>
                      ))}
                    </div>
                  )}
                </div>
                <div className="flex items-center gap-1 shrink-0">
                  <Button size="sm" variant="outline" className="text-xs gap-1 h-8" onClick={() => openSimulate(recipe)}>
                    <TrendingUp className="w-3 h-3" /> Simular
                  </Button>
                  <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => openEdit(recipe)}>
                    <Edit className="w-3.5 h-3.5 text-zinc-500" />
                  </Button>
                  <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => handleDelete(recipe.id)}>
                    <Trash2 className="w-3.5 h-3.5 text-red-400" />
                  </Button>
                  <Button size="sm" variant="ghost" className="h-8 w-8 p-0"
                    onClick={() => setExpandedId(expandedId === recipe.id ? null : recipe.id)}>
                    {expandedId === recipe.id ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                  </Button>
                </div>
              </div>

              {/* Ingredientes expandidos */}
              {expandedId === recipe.id && (
                <div className="border-t border-zinc-100 bg-zinc-50/50 px-5 py-4">
                  <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-3">Ingredientes</p>
                  <div className="space-y-2">
                    {recipe.ingredients.map((ing, i) => (
                      <div key={i} className="flex items-center justify-between text-sm py-2 border-b border-zinc-100 last:border-0">
                        <div className="flex items-center gap-3">
                          <span className="w-5 h-5 rounded-full bg-primary/10 text-primary text-[10px] flex items-center justify-center font-bold">{i + 1}</span>
                          <div>
                            <p className="font-medium text-zinc-800">{ing.raw_material?.name}</p>
                            <p className="text-xs text-zinc-400">
                              {ing.quantity} {ing.raw_material?.unit} base
                              {ing.waste_percent > 0 && ` + ${ing.waste_percent}% perda = ${ing.quantity_with_waste} ${ing.raw_material?.unit}`}
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="font-mono text-zinc-600">R$ {ing.total_cost.toFixed(4)}</p>
                          <p className="text-xs text-zinc-400">@ R$ {ing.unit_cost.toFixed(4)}/{ing.raw_material?.unit}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                  {recipe.instructions && (
                    <div className="mt-4">
                      <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-1">Modo de Preparo</p>
                      <p className="text-sm text-zinc-600 whitespace-pre-line">{recipe.instructions}</p>
                    </div>
                  )}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Modal Criar/Editar Receita */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-[850px] w-[95vw] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleSave}>
            <DialogHeader>
              <DialogTitle>{editingId ? "Editar Receita" : "Nova Receita"}</DialogTitle>
              <DialogDescription>Defina os ingredientes, quantidades e perdas esperadas.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-5 py-4">
              {/* Informações Gerais */}
              <div className="grid gap-3">
                <div className="grid gap-2">
                  <Label>Nome da Receita *</Label>
                  <Input required
                    key={`name-${editingId ?? 'new'}`}
                    defaultValue={form.name}
                    onBlur={e => setForm(f => ({ ...f, name: e.target.value }))}
                    placeholder="ex: Sabonete Lavanda 100g" />
                </div>
                <div className="grid gap-2">
                  <Label>Produto Vinculado</Label>
                  <SearchableSelect
                    value={form.product_id}
                    onChange={v => setForm({ ...form, product_id: v })}
                    onClear={() => setForm({ ...form, product_id: "" })}
                    options={products}
                    getOptionId={p => String(p.id)}
                    getOptionLabel={p => `${p.name} — R$ ${parseFloat(p.price).toFixed(2)}`}
                    getOptionSearchValue={p => p.name}
                    placeholder="Selecionar produto..."
                    renderOption={(p, isSelected) => (
                      <div className="flex-1 min-w-0 flex justify-between items-center w-full">
                        <span className="font-semibold whitespace-normal break-words text-left leading-tight pr-2">{p.name}</span>
                        <span className={`text-[10px] font-mono shrink-0 ml-2 ${isSelected ? "text-white/80" : "text-marrom-suave"}`}>
                          R$ {parseFloat(p.price).toFixed(2)}
                        </span>
                      </div>
                    )}
                  />
                </div>
                <div className="grid gap-2">
                  <Label>Descrição</Label>
                  <Input
                    key={`desc-${editingId ?? 'new'}`}
                    defaultValue={form.description}
                    onBlur={e => setForm(f => ({ ...f, description: e.target.value }))} />
                </div>
              </div>

              {/* Rendimento */}
              <div className="p-4 bg-zinc-50 rounded-lg border border-zinc-100">
                <p className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-3">Rendimento do Lote</p>
                <div className="grid grid-cols-3 gap-3">
                  <div className="grid gap-2">
                    <Label>Quantidade *</Label>
                    <Input type="number" step="0.001" min="0.001" required
                      value={form.yield_quantity} onChange={e => setForm({ ...form, yield_quantity: e.target.value })} placeholder="100" />
                  </div>
                  <div className="grid gap-2">
                    <Label>Unidade *</Label>
                    <Select value={form.yield_unit} onValueChange={v => setForm({ ...form, yield_unit: v })}>
                      <SelectTrigger><SelectValue /></SelectTrigger>
                      <SelectContent>{YIELD_UNITS.map(u => <SelectItem key={u} value={u}>{u}</SelectItem>)}</SelectContent>
                    </Select>
                  </div>
                  <div className="grid gap-2">
                    <Label>Perda Geral (%)</Label>
                    <Input type="number" step="0.1" min="0" max="100"
                      value={form.waste_percent} onChange={e => setForm({ ...form, waste_percent: e.target.value })} placeholder="5" />
                  </div>
                </div>
                <div className="mt-3 grid gap-2">
                  <Label>Tempo de Preparo (minutos)</Label>
                  <Input type="number" min="1" className="w-40"
                    value={form.prep_time_minutes} onChange={e => setForm({ ...form, prep_time_minutes: e.target.value })} placeholder="ex: 45" />
                </div>
              </div>

              {/* Ingredientes */}
              <div>
                <div className="flex items-center justify-between mb-3">
                  <p className="text-xs font-bold text-zinc-500 uppercase tracking-wider">Ingredientes</p>
                  <Button type="button" size="sm" variant="outline" onClick={addIngredient} className="h-7 text-xs gap-1">
                    <Plus className="w-3 h-3" /> Adicionar
                  </Button>
                </div>
                <div className="space-y-2">
                  {form.ingredients.map((ing, i) => (
                    <div key={i} className="grid grid-cols-12 gap-3 items-end p-3 bg-zinc-50 rounded-lg border border-zinc-100">
                      <div className="col-span-6 grid gap-1">
                        <Label className="text-xs font-semibold text-zinc-700">Matéria-Prima *</Label>
                        <SearchableSelect
                          value={ing.raw_material_id}
                          onChange={v => updateIngredient(i, "raw_material_id", v)}
                          options={materials}
                          getOptionId={m => String(m.id)}
                          getOptionLabel={m => `${m.name} (${m.unit}) — R$ ${m.average_cost.toFixed(4)}/${m.unit}`}
                          getOptionSearchValue={m => m.name}
                          placeholder="Selecionar..."
                          renderOption={(m, isSelected) => (
                            <>
                              <div className="flex-1 min-w-0">
                                <p className={`font-semibold whitespace-normal break-words pr-2 leading-tight ${isSelected ? "text-white" : "text-zinc-900"}`}>{m.name}</p>
                                <p className={`text-[10px] ${isSelected ? "text-white/80" : "text-marrom-suave"}`}>
                                  R$ {m.average_cost.toFixed(4)} / {m.unit}
                                </p>
                              </div>
                              <Badge variant="outline" className={`ml-2 text-[10px] shrink-0 ${isSelected ? "border-white text-white" : "border-bege text-marrom-suave"}`}>
                                {m.unit}
                              </Badge>
                            </>
                          )}
                        />
                      </div>
                      <div className="col-span-2 grid gap-1">
                        <Label className="text-xs font-semibold text-zinc-700">Quantidade *</Label>
                        <Input className="h-9" type="number" step="0.0001" min="0.0001"
                          value={ing.quantity} onChange={e => updateIngredient(i, "quantity", e.target.value)}
                          placeholder="0" />
                      </div>
                      <div className="col-span-2 grid gap-1">
                        <Label className="text-xs font-semibold text-zinc-700">Perda (%)</Label>
                        <Input className="h-9" type="number" step="0.1" min="0" max="100"
                          value={ing.waste_percent} onChange={e => updateIngredient(i, "waste_percent", e.target.value)}
                          placeholder="0" />
                      </div>
                      <div className="col-span-2 flex items-end gap-1 pb-0.5">
                        {ing.raw_material_id && ing.quantity && (() => {
                          const mat = materials.find(m => m.id === parseInt(ing.raw_material_id));
                          if (!mat) return null;
                          const qWithWaste = parseFloat(ing.quantity) * (1 + parseFloat(ing.waste_percent || "0") / 100);
                          const cost = qWithWaste * mat.average_cost;
                          return <span className="text-xs text-emerald-600 font-mono">R$ {cost.toFixed(3)}</span>;
                        })()}
                        <Button type="button" size="sm" variant="ghost" className="h-9 w-9 p-0 ml-auto"
                          onClick={() => removeIngredient(i)} disabled={form.ingredients.length === 1}>
                          <Trash2 className="w-3.5 h-3.5 text-red-400" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Preview de custo total */}
                {previewCost() > 0 && (
                  <div className="mt-3 p-3 rounded-lg bg-emerald-50 border border-emerald-100 grid grid-cols-3 gap-3 text-sm">
                    <div>
                      <p className="text-xs text-zinc-400">Custo do Lote</p>
                      <p className="font-bold text-zinc-800">R$ {previewCost().toFixed(2)}</p>
                    </div>
                    <div>
                      <p className="text-xs text-zinc-400">Rendimento Efetivo</p>
                      <p className="font-bold text-zinc-800">
                        {(parseFloat(form.yield_quantity || "0") * (1 - parseFloat(form.waste_percent || "0") / 100)).toFixed(2)} {form.yield_unit}
                      </p>
                    </div>
                    <div>
                      <p className="text-xs text-zinc-400">Custo por Unidade</p>
                      <p className="font-bold text-emerald-700">R$ {previewUnitCost().toFixed(4)}</p>
                    </div>
                  </div>
                )}
              </div>

              {/* Modo de Preparo */}
              <div className="grid gap-2">
                <Label>Modo de Preparo (opcional)</Label>
                <Textarea rows={4} placeholder="Descreva o passo a passo do processo de produção..."
                  key={`instructions-${editingId ?? 'new'}`}
                  defaultValue={form.instructions}
                  onBlur={e => setForm(f => ({ ...f, instructions: e.target.value }))} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">{editingId ? "Atualizar Receita" : "Criar Receita"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal Simulação */}
      <Dialog open={isSimOpen} onOpenChange={setIsSimOpen}>
        <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <TrendingUp className="w-5 h-5 text-primary" /> Simulação de Produção
            </DialogTitle>
            <DialogDescription>{selectedRecipe?.name}</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="flex items-end gap-3">
              <div className="grid gap-2 flex-1">
                <Label>Quantos lotes deseja simular?</Label>
                <Input type="number" min="1" max="1000" value={simBatches}
                  onChange={e => setSimBatches(e.target.value)} />
              </div>
              <Button onClick={handleSimulate} disabled={simLoading} className="bg-primary">
                {simLoading ? "Calculando..." : "Simular"}
              </Button>
            </div>

            {simResult && (
              <div className="space-y-4">
                {/* Resultado financeiro */}
                <div className={`p-4 rounded-xl border grid grid-cols-2 gap-3 ${simResult.can_produce ? 'bg-emerald-50 border-emerald-200' : 'bg-red-50 border-red-200'}`}>
                  <div className="col-span-2 flex items-center gap-2 mb-1">
                    {simResult.can_produce
                      ? <><CheckCircle2 className="w-5 h-5 text-emerald-600" /><span className="font-semibold text-emerald-700">Produção Viável</span></>
                      : <><XCircle className="w-5 h-5 text-red-600" /><span className="font-semibold text-red-700">Estoque Insuficiente</span></>
                    }
                  </div>
                  {[
                    { label: "Lotes", value: String(simResult.batches) },
                    { label: "Unidades Totais", value: String(simResult.total_units) },
                    { label: "Custo Total", value: `R$ ${simResult.batch_cost.toFixed(2)}` },
                    { label: "Custo/Un.", value: `R$ ${simResult.unit_cost.toFixed(4)}` },
                    { label: "Receita Esperada", value: simResult.revenue > 0 ? `R$ ${simResult.revenue.toFixed(2)}` : "—" },
                    { label: "Lucro Estimado", value: simResult.revenue > 0 ? `R$ ${simResult.profit.toFixed(2)}` : "—" },
                    ...(simResult.margin_percent != null ? [{ label: "Margem", value: `${simResult.margin_percent}%` }] : []),
                  ].map(kpi => (
                    <div key={kpi.label}>
                      <p className="text-xs text-zinc-500">{kpi.label}</p>
                      <p className="font-bold text-zinc-800">{kpi.value}</p>
                    </div>
                  ))}
                </div>

                {/* Tabela de ingredientes */}
                <div>
                  <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-2">Consumo de Matérias-Primas</p>
                  <div className="rounded-lg border border-zinc-200 overflow-hidden">
                    {simResult.ingredients.map((ing, i) => (
                      <div key={i} className={`flex items-center justify-between px-4 py-3 text-sm border-b border-zinc-100 last:border-0 ${!ing.is_sufficient ? 'bg-red-50' : ''}`}>
                        <div>
                          <p className="font-medium text-zinc-800">{ing.raw_material}</p>
                          <p className="text-xs text-zinc-400">Necessário: {ing.total_needed} {ing.unit} | Disponível: {ing.available} {ing.unit}</p>
                        </div>
                        <div className="text-right">
                          <p className="font-mono text-zinc-600">R$ {ing.total_cost.toFixed(2)}</p>
                          {!ing.is_sufficient && (
                            <p className="text-xs text-red-600 font-semibold">Faltam {ing.missing} {ing.unit}</p>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
