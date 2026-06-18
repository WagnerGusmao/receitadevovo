"use client";

import { useEffect, useState, useMemo } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Edit, Trash2, Search, Eye } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { ImageUpload } from "@/components/admin/ImageUpload";
import { MultiImageUpload } from "@/components/admin/MultiImageUpload";

export default function AdminProducts() {
  const [products, setProducts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    price: "",
    old_price: "",
    stock: "",
    slug: "",
    featured_image: "",
    images: [] as string[],
    category_id: "",
    is_on_demand: false,
    lead_time_days: "0",
    variants: [] as any[]
  });
  const [search, setSearch] = useState("");

  const filteredProducts = useMemo(() => {
    if (!search.trim()) return products;
    const query = search.toLowerCase();
    return products.filter((p: any) => 
      p.name.toLowerCase().includes(query) ||
      (p.category?.name && p.category.name.toLowerCase().includes(query))
    );
  }, [products, search]);

  useEffect(() => {
    loadProducts();
    loadCategories();
  }, []);

  async function loadProducts() {
    setLoading(true);
    try {
      const response = await apiFetch("/ecommerce/products"); 
      setProducts(response.data.products);
    } catch (error) {
      console.error("Error loading products", error);
    } finally {
      setLoading(false);
    }
  }

  async function loadCategories() {
    try {
      const response = await apiFetch("/ecommerce/categories");
      setCategories(response.data || []);
    } catch (error) {
      console.error("Error loading categories", error);
    }
  }

  const resetForm = () => {
    setFormData({ name: "", description: "", price: "", old_price: "", stock: "", slug: "", featured_image: "", images: [], category_id: "", is_on_demand: false, lead_time_days: "0", variants: [] });
    setEditingId(null);
  };

  const handleEdit = (product: any) => {
    setFormData({
      name: product.name,
      description: product.description,
      price: product.price.toString(),
      old_price: product.old_price ? product.old_price.toString() : "",
      stock: product.stock.toString(),
      slug: product.slug,
      featured_image: product.featured_image || "",
      images: product.images || [],
      category_id: product.category_id ? product.category_id.toString() : "",
      is_on_demand: !!product.is_on_demand,
      lead_time_days: product.lead_time_days ? product.lead_time_days.toString() : "0",
      variants: product.variants ? product.variants.map((v: any) => ({
        id: v.id,
        name: v.name,
        price: v.price.toString(),
        old_price: v.old_price ? v.old_price.toString() : "",
        stock: v.stock.toString(),
        sku: v.sku || "",
        volume: v.volume.toString(),
        volume_unit: v.volume_unit || "ml"
      })) : []
    });
    setEditingId(product.id);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Tem certeza que deseja excluir este produto?")) return;

    try {
      await apiFetch(`/ecommerce/products/${id}`, { method: "DELETE" });
      setProducts(products.filter((p: any) => p.id !== id));
      toast.success("Produto removido com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir produto");
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/ecommerce/products/${editingId}` : "/ecommerce/products";
      const method = editingId ? "PUT" : "POST";

      const dataToSave = {
        ...formData,
        category_id: formData.category_id ? parseInt(formData.category_id) : null,
        is_on_demand: !!formData.is_on_demand,
        lead_time_days: parseInt(formData.lead_time_days) || 0,
        variants: formData.variants.map((v: any) => ({
          id: v.id,
          name: v.name,
          price: parseFloat(v.price),
          old_price: v.old_price ? parseFloat(v.old_price) : null,
          stock: parseInt(v.stock),
          sku: v.sku || null,
          volume: parseFloat(v.volume),
          volume_unit: v.volume_unit || 'ml'
        }))
      };

      await apiFetch(url, {
        method,
        body: JSON.stringify(dataToSave)
      });
      
      setIsModalOpen(false);
      resetForm();
      loadProducts();
      toast.success(editingId ? "Produto atualizado" : "Produto criado com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar produto");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Produtos</h1>
          <p className="text-sm text-zinc-500">Adicione, edite ou remova produtos da sua loja.</p>
        </div>
        
        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Novo Produto
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[700px] max-h-[90vh] overflow-y-auto">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Produto" : "Novo Produto Artesanal"}</DialogTitle>
                <DialogDescription>
                  {editingId ? "Atualize as informações do produto selecionado." : "Preencha os dados abaixo para cadastrar um novo item na loja."}
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label htmlFor="name">Nome do Produto</Label>
                  <Input 
                    id="name" 
                    value={formData.name} 
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="old_price">Preço Original (R$)</Label>
                    <Input 
                      id="old_price" 
                      type="number" 
                      step="0.01"
                      placeholder="De: (opcional)"
                      value={formData.old_price} 
                      onChange={(e) => setFormData({...formData, old_price: e.target.value})}
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="price">Preço de Venda (R$)</Label>
                    <Input 
                      id="price" 
                      type="number" 
                      step="0.01"
                      placeholder="Por:"
                      value={formData.price} 
                      onChange={(e) => setFormData({...formData, price: e.target.value})}
                      required 
                    />
                  </div>
                </div>
                 <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="stock">Estoque</Label>
                    <Input 
                      id="stock" 
                      type="number" 
                      value={formData.stock} 
                      onChange={(e) => setFormData({...formData, stock: e.target.value})}
                      required 
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="slug">Slug (URL)</Label>
                    <Input 
                      id="slug" 
                      placeholder="sabonete-de-alecrim"
                      value={formData.slug} 
                      onChange={(e) => setFormData({...formData, slug: e.target.value})}
                      required 
                    />
                  </div>
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="category_id">Categoria</Label>
                  <select 
                    id="category_id"
                    value={formData.category_id}
                    onChange={(e) => setFormData({...formData, category_id: e.target.value})}
                    className="flex h-10 w-full rounded-md border border-zinc-200 bg-white px-3 py-2 text-sm ring-offset-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <option value="">Sem Categoria (Geral)</option>
                    {categories.map((cat: any) => (
                      <option key={cat.id} value={cat.id}>{cat.name}</option>
                    ))}
                  </select>
                </div>

                <div className="grid grid-cols-2 gap-4 border border-zinc-100 p-4 rounded-xl bg-zinc-50/20">
                  <div className="flex items-center space-x-2">
                    <input
                      id="is_on_demand"
                      type="checkbox"
                      checked={formData.is_on_demand}
                      onChange={(e) => setFormData({...formData, is_on_demand: e.target.checked})}
                      className="h-4 w-4 rounded border-zinc-300 text-primary focus:ring-primary"
                    />
                    <Label htmlFor="is_on_demand" className="text-sm font-medium cursor-pointer">
                      Vender sob encomenda (ignora estoque 0)
                    </Label>
                  </div>
                  {formData.is_on_demand && (
                    <div className="grid gap-2">
                      <Label htmlFor="lead_time_days">Prazo de Produção (Dias Úteis)</Label>
                      <Input 
                        id="lead_time_days" 
                        type="number" 
                        min="0"
                        value={formData.lead_time_days} 
                        onChange={(e) => setFormData({...formData, lead_time_days: e.target.value})}
                        required 
                      />
                    </div>
                  )}
                </div>

                <div className="border-t border-zinc-100 pt-4 space-y-4">
                  <div className="flex justify-between items-center">
                    <Label className="text-base font-bold text-zinc-900 font-outfit">Tamanhos / Variantes (Opcional)</Label>
                    <Button 
                      type="button" 
                      variant="outline" 
                      size="sm"
                      className="border-primary text-primary hover:bg-primary/5 rounded-full"
                      onClick={() => setFormData({
                        ...formData,
                        variants: [
                          ...formData.variants,
                          { name: "", price: "", old_price: "", stock: "0", sku: "", volume: "1", volume_unit: "ml" }
                        ]
                      })}
                    >
                      <Plus className="w-3.5 h-3.5 mr-1" /> Adicionar Tamanho
                    </Button>
                  </div>

                  {formData.variants.length > 0 ? (
                    <div className="space-y-3">
                      {formData.variants.map((v, index) => (
                        <div key={index} className="grid grid-cols-12 gap-2 items-end border border-zinc-150 p-3 rounded-xl bg-zinc-50/30">
                          <div className="col-span-3 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">Nome (ex: 220ml)</Label>
                            <Input 
                              value={v.name} 
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].name = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              required
                              placeholder="220ml"
                              className="h-9 text-xs"
                            />
                          </div>
                          <div className="col-span-2 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">Preço (R$)</Label>
                            <Input 
                              type="number"
                              step="0.01"
                              value={v.price} 
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].price = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              required
                              placeholder="45.00"
                              className="h-9 text-xs"
                            />
                          </div>
                          <div className="col-span-2 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">Vol. (ex: 220)</Label>
                            <Input 
                              type="number"
                              step="0.001"
                              value={v.volume} 
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].volume = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              required
                              placeholder="220"
                              className="h-9 text-xs"
                            />
                          </div>
                          <div className="col-span-1 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">Unidade</Label>
                            <select
                              value={v.volume_unit}
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].volume_unit = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              className="flex h-9 w-full rounded-md border border-zinc-200 bg-white px-2 py-1 text-xs focus-visible:outline-none"
                            >
                              <option value="ml">ml</option>
                              <option value="g">g</option>
                              <option value="un">un</option>
                            </select>
                          </div>
                          <div className="col-span-2 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">Estoque</Label>
                            <Input 
                              type="number"
                              value={v.stock} 
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].stock = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              required
                              className="h-9 text-xs"
                            />
                          </div>
                          <div className="col-span-1 grid gap-1">
                            <Label className="text-[10px] text-zinc-400">SKU</Label>
                            <Input 
                              value={v.sku} 
                              onChange={(e) => {
                                const newVariants = [...formData.variants];
                                newVariants[index].sku = e.target.value;
                                setFormData({ ...formData, variants: newVariants });
                              }}
                              placeholder="sku"
                              className="h-9 text-xs"
                            />
                          </div>
                          <div className="col-span-1 text-right">
                            <Button 
                              type="button" 
                              variant="ghost" 
                              size="icon" 
                              className="h-9 w-9 text-zinc-400 hover:text-destructive"
                              onClick={() => {
                                const newVariants = formData.variants.filter((_, i) => i !== index);
                                setFormData({ ...formData, variants: newVariants });
                              }}
                            >
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-xs text-zinc-400 italic">Este produto é de tamanho único (sem variantes adicionadas).</p>
                  )}
                </div>
                <div className="grid gap-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor="description">Descrição do Produto</Label>
                    <span className="text-[11px] text-zinc-400">Use linha em branco para separar parágrafos</span>
                  </div>
                  <Textarea 
                    id="description" 
                    value={formData.description} 
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    required
                    rows={8}
                    className="resize-y min-h-[180px] font-mono text-sm leading-relaxed"
                    placeholder={`Ex:\n\nNossas flores de camomila são colhidas ao amanhecer...\n\nIdeal para momentos de relaxamento após o dia.`}
                  />
                </div>
                <div className="grid grid-cols-1 gap-6 pt-2">
                  <ImageUpload 
                    value={formData.featured_image} 
                    onUpload={(url) => setFormData({...formData, featured_image: url})} 
                  />
                  <MultiImageUpload 
                    value={formData.images}
                    onUpload={(urls) => setFormData({...formData, images: urls})}
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit" className="bg-primary">
                  {editingId ? "Atualizar" : "Salvar Produto"}
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
            <Input 
              className="pl-10 bg-white border-zinc-200" 
              placeholder="Buscar produtos..." 
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
          </div>
        </div>

        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead className="w-[100px]">ID</TableHead>
              <TableHead>Produto</TableHead>
              <TableHead>Preço</TableHead>
              <TableHead>Estoque</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
              </TableRow>
            ) : filteredProducts.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Nenhum produto encontrado.</TableCell>
              </TableRow>
            ) : filteredProducts.map((product: any) => (
              <TableRow key={product.id}>
                <TableCell className="font-mono text-xs text-zinc-500">#{product.id}</TableCell>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-lg bg-zinc-100 border border-zinc-200 flex items-center justify-center text-zinc-400 overflow-hidden relative">
                      {product.featured_image ? (
                        <img 
                          src={product.featured_image} 
                          alt={product.name} 
                          className="w-full h-full object-cover" 
                        />
                      ) : (
                        <span>🌿</span>
                      )}
                    </div>
                    <div>
                      <p className="font-medium text-zinc-900">{product.name}</p>
                      <p className="text-xs text-zinc-500">{product.category?.name || 'Sem categoria'}</p>
                    </div>
                  </div>
                </TableCell>
                <TableCell className="font-medium">
                  {product.old_price && (
                    <span className="text-xs text-zinc-400 line-through mr-2">
                      R$ {parseFloat(product.old_price).toFixed(2)}
                    </span>
                  )}
                  <span className="text-primary font-bold">
                    R$ {parseFloat(product.price).toFixed(2)}
                  </span>
                </TableCell>
                <TableCell>
                  {product.variants && product.variants.length > 0 ? (
                    <div className="space-y-1 min-w-[120px]">
                      {product.variants.map((v: any) => (
                        <div key={v.id} className="text-xs flex items-center justify-between gap-4 border-b border-zinc-100 last:border-0 pb-1 last:pb-0">
                          <span className="text-zinc-500 font-medium">{v.name}</span>
                          <span className={v.stock > 10 ? 'text-zinc-700 font-semibold' : 'text-zinc-800 font-bold'}>
                            {v.stock} un.
                          </span>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <span className={product.stock > 10 ? 'text-zinc-600' : 'text-amber-600 font-bold'}>
                      {product.stock} un.
                    </span>
                  )}
                </TableCell>
                <TableCell>
                  <div className="flex flex-col gap-1 items-start">
                    <Badge variant="outline" className="bg-emerald-50 text-emerald-700 border-emerald-200">Ativo</Badge>
                    {product.is_on_demand && (
                      <Badge variant="outline" className="bg-amber-50 text-amber-700 border-amber-200">Encomenda</Badge>
                    )}
                  </div>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => window.open(`/produtos/${product.slug}`, '_blank')}
                    >
                      <Eye className="w-4 h-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => handleEdit(product)}
                    >
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-destructive"
                      onClick={() => handleDelete(product.id)}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
