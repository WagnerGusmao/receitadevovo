"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Edit, Trash2, Search, Leaf, ChevronDown, ChevronUp } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { ImageUpload } from "@/components/admin/ImageUpload";

export default function AdminWellness() {
  const [herbs, setHerbs] = useState<any[]>([]);
  const [allBenefits, setAllBenefits] = useState<{ id: number; name: string }[]>([]);
  const [loading, setLoading] = useState(true);

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const [perPage, setPerPage] = useState(25);
  const [totalItems, setTotalItems] = useState(0);
  const [lastPage, setLastPage] = useState(1);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [expandedId, setExpandedId] = useState<number | null>(null);
  const [formData, setFormData] = useState({
    name: "",
    scientific_name: "",
    description: "",
    how_to_use: "",
    bath_instructions: "",
    incense_usage: "",
    slug: "",
    image_path: "",
    benefit_ids: [] as number[],
    source_type: "popular",
    sources: ""
  });

  useEffect(() => {
    loadHerbs();
  }, [currentPage, perPage]);

  useEffect(() => {
    loadBenefits();
  }, []);

  async function loadHerbs() {
    setLoading(true);
    try {
      const response = await apiFetch(`/wellness/herbs?page=${currentPage}&per_page=${perPage}`);
      const responseData = response.data;
      if (Array.isArray(responseData)) {
        setHerbs(responseData);
        setTotalItems(responseData.length);
        setLastPage(1);
      } else if (responseData && Array.isArray(responseData.data)) {
        setHerbs(responseData.data);
        setTotalItems(responseData.total || 0);
        setLastPage(responseData.last_page || 1);
      }
    } catch (error) {
      console.error("Error loading herbs", error);
    } finally {
      setLoading(false);
    }
  }

  async function loadBenefits() {
    try {
      const response = await apiFetch("/wellness/benefits");
      setAllBenefits(response.data || []);
    } catch (error) {
      console.error("Error loading benefits", error);
    }
  }

  const resetForm = () => {
    setFormData({
      name: "",
      scientific_name: "",
      description: "",
      how_to_use: "",
      bath_instructions: "",
      incense_usage: "",
      slug: "",
      image_path: "",
      benefit_ids: [],
      source_type: "popular",
      sources: ""
    });
    setEditingId(null);
  };

  const handleEdit = (herb: any) => {
    setFormData({
      name: herb.name,
      scientific_name: herb.scientific_name || "",
      description: herb.description || "",
      how_to_use: herb.how_to_use || "",
      bath_instructions: herb.bath_instructions || "",
      incense_usage: herb.incense_usage || "",
      slug: herb.slug,
      image_path: herb.image_path || "",
      benefit_ids: herb.benefits ? herb.benefits.map((b: any) => b.id) : [],
      source_type: herb.source_type || "popular",
      sources: herb.sources || ""
    });
    setEditingId(herb.id);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Tem certeza que deseja excluir esta erva?")) return;

    try {
      await apiFetch(`/wellness/herbs/${id}`, { method: "DELETE" });
      loadHerbs();
      toast.success("Erva removida do catálogo");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir erva");
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/wellness/herbs/${editingId}` : "/wellness/herbs";
      const method = editingId ? "PUT" : "POST";

      await apiFetch(url, {
        method,
        body: JSON.stringify(formData)
      });
      
      setIsModalOpen(false);
      resetForm();
      loadHerbs();
      toast.success(editingId ? "Sabedoria atualizada" : "Erva cadastrada com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar erva");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Catálogo Wellness</h1>
          <p className="text-sm text-zinc-500">Gerencie a biblioteca de ervas e sabedoria ancestral.</p>
        </div>

        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Nova Erva
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Erva" : "Nova Erva Medicinal"}</DialogTitle>
                <DialogDescription>
                  {editingId ? "Atualize as informações da planta selecionada." : "Cadastre uma nova planta e seus benefícios ancestrais."}
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label htmlFor="name">Nome da Erva *</Label>
                  <Input 
                    id="name" 
                    value={formData.name} 
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="scientific_name">Nome Científico</Label>
                  <Input 
                    id="scientific_name" 
                    placeholder="Rosmarinus officinalis"
                    value={formData.scientific_name} 
                    onChange={(e) => setFormData({...formData, scientific_name: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="slug">Slug (URL) *</Label>
                  <Input 
                    id="slug" 
                    placeholder="alecrim"
                    value={formData.slug} 
                    onChange={(e) => setFormData({...formData, slug: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="description">Uso Comum / Descrição *</Label>
                  <Textarea 
                    id="description" 
                    rows={3}
                    placeholder="ex: Estimulante mental, digestivo e cicatrizante..."
                    value={formData.description} 
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="how_to_use">Como Usar / Preparação</Label>
                  <Textarea 
                    id="how_to_use" 
                    rows={3}
                    placeholder="ex: Infusão de 1 colher de sopa de folhas para 1 xícara de água..."
                    value={formData.how_to_use} 
                    onChange={(e) => setFormData({...formData, how_to_use: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="bath_instructions">Instruções para Banho de Ervas</Label>
                  <Textarea 
                    id="bath_instructions" 
                    rows={3}
                    placeholder="ex: Ferva 1 litro de água com 3 ramos frescos..."
                    value={formData.bath_instructions} 
                    onChange={(e) => setFormData({...formData, bath_instructions: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="incense_usage">Uso como Incenso / Defumação</Label>
                  <Textarea 
                    id="incense_usage" 
                    rows={3}
                    placeholder="ex: A queima das folhas secas limpa a negatividade..."
                    value={formData.incense_usage} 
                    onChange={(e) => setFormData({...formData, incense_usage: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="source_type">Linhagem / Tipo de Fonte</Label>
                  <select
                    id="source_type"
                    value={formData.source_type}
                    onChange={(e) => setFormData({...formData, source_type: e.target.value})}
                    className="flex h-10 w-full rounded-md border border-zinc-200 bg-white px-3 py-2 text-sm ring-offset-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <option value="popular">📜 Sabedoria Popular / Ancestral</option>
                    <option value="scientific">🔬 Estudo Científico / Botânico</option>
                    <option value="integrative">🍃 Fonte Integrativa (Mista)</option>
                  </select>
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="sources">Fontes & Referências da Informação</Label>
                  <Textarea 
                    id="sources" 
                    rows={2}
                    placeholder="ex: Farmacopeia Brasileira (Ed. 6), Tradição Popular Oral, Monografia da OMS..."
                    value={formData.sources} 
                    onChange={(e) => setFormData({...formData, sources: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label>Benefícios Relacionados</Label>
                  <div className="flex flex-wrap gap-2 p-3 rounded-lg border border-zinc-200 bg-zinc-50/50">
                    {allBenefits.map((benefit) => {
                      const isSelected = formData.benefit_ids.includes(benefit.id);
                      return (
                        <button
                          key={benefit.id}
                          type="button"
                          onClick={() => {
                            const newIds = isSelected
                              ? formData.benefit_ids.filter(id => id !== benefit.id)
                              : [...formData.benefit_ids, benefit.id];
                            setFormData({ ...formData, benefit_ids: newIds });
                          }}
                          className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-all ${
                            isSelected
                              ? "bg-primary text-white border-primary"
                              : "bg-white text-zinc-600 border-zinc-200 hover:border-zinc-300"
                          }`}
                        >
                          {benefit.name}
                        </button>
                      );
                    })}
                    {allBenefits.length === 0 && (
                      <span className="text-xs text-zinc-400 italic">Carregando benefícios...</span>
                    )}
                  </div>
                </div>
                <div className="pt-2">
                  <Label className="mb-2 block">Imagem da Erva</Label>
                  <ImageUpload 
                    value={formData.image_path} 
                    onUpload={(url) => setFormData({...formData, image_path: url})} 
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit" className="bg-primary">
                  {editingId ? "Atualizar" : "Salvar Erva"}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <div className="p-4 border-b border-zinc-100 bg-zinc-50/50">
          <div className="relative max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
            <Input className="pl-10 bg-white border-zinc-200" placeholder="Buscar sabedoria..." />
          </div>
        </div>

        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Erva</TableHead>
              <TableHead>Benefícios</TableHead>
              <TableHead>Uso Comum</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
              </TableRow>
            ) : herbs.map((herb: any) => {
              const isExpanded = expandedId === herb.id;
              return (
                <tr key={herb.id} className="border-b border-zinc-200 last:border-0">
                  <td colSpan={4} className="p-0">
                    <Table>
                      <TableBody>
                        <TableRow className="hover:bg-zinc-50/50 border-0">
                          <TableCell className="w-[25%]">
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 rounded-lg bg-zinc-100 border border-zinc-200 overflow-hidden flex items-center justify-center shrink-0">
                                {herb.image_path ? (
                                  <img 
                                    src={herb.image_path} 
                                    alt={herb.name} 
                                    className="w-full h-full object-cover" 
                                  />
                                ) : (
                                  <div className="w-8 h-8 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600">
                                    <Leaf className="w-4 h-4" />
                                  </div>
                                )}
                              </div>
                              <div>
                                <div className="flex items-center gap-1.5 flex-wrap">
                                  <p className="font-medium text-zinc-900">{herb.name}</p>
                                  {herb.source_type && (
                                    <Badge 
                                      className={`text-[8px] px-1.5 py-0 border-none rounded-full shrink-0 font-bold uppercase tracking-wider ${
                                        herb.source_type === "popular" 
                                          ? "bg-amber-100 text-amber-800" 
                                          : herb.source_type === "scientific"
                                            ? "bg-blue-100 text-blue-800"
                                            : "bg-emerald-100 text-emerald-800"
                                      }`}
                                    >
                                      {herb.source_type === "popular" ? "📜 Popular" : herb.source_type === "scientific" ? "🔬 Científica" : "🍃 Mista"}
                                    </Badge>
                                  )}
                                </div>
                                {herb.scientific_name && <p className="text-xs italic text-zinc-400">{herb.scientific_name}</p>}
                              </div>
                            </div>
                          </TableCell>
                          <TableCell className="w-[35%]">
                            <div className="flex flex-wrap gap-1">
                              {herb.benefits?.map((benefit: any) => (
                                <Badge key={benefit.id} variant="secondary" className="bg-zinc-100 text-zinc-600 border-none text-[10px]">
                                  {benefit.name}
                                </Badge>
                              ))}
                              {(!herb.benefits || herb.benefits.length === 0) && (
                                <span className="text-xs text-zinc-400 italic">Nenhum vínculo</span>
                              )}
                            </div>
                          </TableCell>
                          <TableCell className="text-sm text-zinc-500 w-[25%]">
                            {herb.description ? herb.description.substring(0, 60) + '...' : '—'}
                          </TableCell>
                          <TableCell className="text-right w-[15%]">
                            <div className="flex justify-end gap-1.5 pr-2">
                              <Button 
                                variant="ghost" 
                                size="icon" 
                                className="h-8 w-8 text-zinc-400 hover:text-primary"
                                onClick={() => setExpandedId(isExpanded ? null : herb.id)}
                                title="Ver Detalhes"
                                type="button"
                              >
                                {isExpanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                              </Button>
                              <Button 
                                variant="ghost" 
                                size="icon" 
                                className="h-8 w-8 text-zinc-400 hover:text-primary"
                                onClick={() => handleEdit(herb)}
                                title="Editar Erva"
                                type="button"
                              >
                                <Edit className="w-4 h-4" />
                              </Button>
                              <Button 
                                variant="ghost" 
                                size="icon" 
                                className="h-8 w-8 text-zinc-400 hover:text-destructive"
                                onClick={() => handleDelete(herb.id)}
                                title="Excluir Erva"
                                type="button"
                              >
                                <Trash2 className="w-4 h-4" />
                              </Button>
                            </div>
                          </TableCell>
                        </TableRow>

                        {isExpanded && (
                          <TableRow className="bg-zinc-50/40 hover:bg-zinc-50/40 border-t border-zinc-100">
                            <TableCell colSpan={4} className="p-6 space-y-4">
                              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-sm">
                                <div className="space-y-3">
                                  <div>
                                    <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-1">Informações Botânicas</p>
                                    <p className="text-zinc-800">
                                      <strong>Nome Científico:</strong> <span className="italic text-zinc-600">{herb.scientific_name || "Não informado"}</span>
                                    </p>
                                  </div>
                                  <div>
                                    <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-1">Uso Comum & Descrição</p>
                                    <p className="text-zinc-600 leading-relaxed whitespace-pre-line text-xs">{herb.description}</p>
                                  </div>
                                  {herb.how_to_use && (
                                    <div>
                                      <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-1">🍵 Como Usar / Preparação</p>
                                      <p className="text-zinc-600 leading-relaxed whitespace-pre-line text-xs">{herb.how_to_use}</p>
                                    </div>
                                  )}
                                  {herb.sources && (
                                    <div>
                                      <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider mb-1">📚 Fontes & Referências de Apoio</p>
                                      <p className="text-zinc-500 leading-relaxed text-xs italic">{herb.sources}</p>
                                    </div>
                                  )}
                                </div>
                                <div className="space-y-4">
                                  {herb.bath_instructions && (
                                    <div className="bg-emerald-50/40 p-4 rounded-xl border border-emerald-100/60 shadow-sm">
                                      <p className="text-xs font-bold text-emerald-800 uppercase tracking-wider mb-1.5 flex items-center gap-1.5">
                                        <span>🛁</span> Banho de Ervas
                                      </p>
                                      <p className="text-zinc-700 leading-relaxed whitespace-pre-line text-[11px]">{herb.bath_instructions}</p>
                                    </div>
                                  )}
                                  {herb.incense_usage && (
                                    <div className="bg-amber-50/40 p-4 rounded-xl border border-amber-100/60 shadow-sm">
                                      <p className="text-xs font-bold text-amber-800 uppercase tracking-wider mb-1.5 flex items-center gap-1.5">
                                        <span>🔥</span> Uso como Incenso / Defumação
                                      </p>
                                      <p className="text-zinc-700 leading-relaxed whitespace-pre-line text-[11px]">{herb.incense_usage}</p>
                                    </div>
                                  )}
                                </div>
                              </div>
                            </TableCell>
                          </TableRow>
                        )}
                      </TableBody>
                    </Table>
                  </td>
                </tr>
              );
            })}
          </TableBody>
        </Table>

        {/* Pagination Controls */}
        {!loading && totalItems > 0 && (
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 p-4 border-t border-zinc-100 bg-zinc-50/50">
            {/* Per Page Selector */}
            <div className="flex items-center gap-2">
              <span className="text-xs text-zinc-500 font-medium">Itens por página:</span>
              <div className="flex bg-zinc-200/50 p-0.5 rounded-lg border border-zinc-200/60">
                {[25, 50, 100].map((size) => (
                  <button
                    key={size}
                    type="button"
                    onClick={() => {
                      setPerPage(size);
                      setCurrentPage(1);
                    }}
                    className={`px-2.5 py-1 text-xs font-semibold rounded-md transition-all duration-200 ${
                      perPage === size
                        ? "bg-white text-zinc-900 shadow-sm border border-zinc-200/40"
                        : "text-zinc-500 hover:text-zinc-900 hover:bg-zinc-100"
                    }`}
                  >
                    {size}
                  </button>
                ))}
              </div>
              <span className="text-xs text-zinc-400 ml-2">
                Mostrando {Math.min((currentPage - 1) * perPage + 1, totalItems)}-{Math.min(currentPage * perPage, totalItems)} de {totalItems}
              </span>
            </div>

            {/* Page Buttons */}
            {lastPage > 1 && (
              <div className="flex items-center gap-1.5">
                <Button
                  variant="outline"
                  size="sm"
                  type="button"
                  onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                  disabled={currentPage === 1}
                  className="border-zinc-200 text-zinc-600 text-xs px-2.5 h-8 rounded-lg bg-white hover:bg-zinc-50 disabled:opacity-40"
                >
                  Anterior
                </Button>

                <div className="flex items-center gap-1">
                  {Array.from({ length: lastPage }, (_, i) => i + 1).map((page) => (
                    <button
                      key={page}
                      type="button"
                      onClick={() => setCurrentPage(page)}
                      className={`w-8 h-8 text-xs font-bold rounded-lg transition-all duration-200 flex items-center justify-center ${
                        currentPage === page
                          ? "bg-zinc-900 text-white shadow-sm"
                          : "border border-transparent text-zinc-500 hover:border-zinc-200 hover:bg-zinc-100 hover:text-zinc-900"
                      }`}
                    >
                      {page}
                    </button>
                  ))}
                </div>

                <Button
                  variant="outline"
                  size="sm"
                  type="button"
                  onClick={() => setCurrentPage((prev) => Math.min(prev + 1, lastPage))}
                  disabled={currentPage === lastPage}
                  className="border-zinc-200 text-zinc-600 text-xs px-2.5 h-8 rounded-lg bg-white hover:bg-zinc-50 disabled:opacity-40"
                >
                  Próximo
                </Button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
