"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Edit, Trash2, Search, Package } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { Checkbox } from "@/components/ui/checkbox";
import { ImageUpload } from "@/components/admin/ImageUpload";

export default function AdminKits() {
  const [kits, setKits] = useState([]);
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    price: "",
    slug: "",
    featured_image: "",
    is_on_demand: false,
    lead_time_days: "0",
    selectedProducts: [] as { id: number; quantity: number }[]
  });

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    setLoading(true);
    try {
      const [kitsRes, productsRes] = await Promise.all([
        apiFetch("/ecommerce/kits"),
        apiFetch("/ecommerce/products")
      ]);
      setKits(kitsRes.data);
      setProducts(productsRes.data.products);
    } catch (error) {
      console.error("Error loading data", error);
    } finally {
      setLoading(false);
    }
  }

  const resetForm = () => {
    setFormData({ name: "", description: "", price: "", slug: "", featured_image: "", selectedProducts: [], is_on_demand: false, lead_time_days: "0" });
    setEditingId(null);
  };

  const handleEdit = (kit: any) => {
    setFormData({
      name: kit.name,
      description: kit.description,
      price: kit.price.toString(),
      slug: kit.slug,
      featured_image: kit.featured_image || "",
      is_on_demand: !!kit.is_on_demand,
      lead_time_days: kit.lead_time_days ? kit.lead_time_days.toString() : "0",
      selectedProducts: kit.products.map((p: any) => ({
        id: p.id,
        quantity: p.pivot.quantity
      }))
    });
    setEditingId(kit.id);
    setIsModalOpen(true);
  };

  const toggleProduct = (productId: number) => {
    const exists = formData.selectedProducts.find(p => p.id === productId);
    if (exists) {
      setFormData({
        ...formData,
        selectedProducts: formData.selectedProducts.filter(p => p.id !== productId)
      });
    } else {
      setFormData({
        ...formData,
        selectedProducts: [...formData.selectedProducts, { id: productId, quantity: 1 }]
      });
    }
  };

  const updateProductQuantity = (productId: number, quantity: number) => {
    setFormData({
      ...formData,
      selectedProducts: formData.selectedProducts.map(p => 
        p.id === productId ? { ...p, quantity: Math.max(1, quantity) } : p
      )
    });
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/ecommerce/kits/${editingId}` : "/ecommerce/kits";
      const method = editingId ? "PUT" : "POST";

      const payload = {
        name: formData.name,
        description: formData.description,
        price: parseFloat(formData.price),
        slug: formData.slug,
        is_on_demand: !!formData.is_on_demand,
        lead_time_days: parseInt(formData.lead_time_days) || 0,
        products: formData.selectedProducts
      };

      await apiFetch(url, {
        method,
        body: JSON.stringify(payload)
      });
      
      setIsModalOpen(false);
      resetForm();
      loadData();
      toast.success(editingId ? "Kit atualizado" : "Kit criado com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar kit");
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Tem certeza que deseja excluir este kit?")) return;
    try {
      await apiFetch(`/ecommerce/kits/${id}`, { method: "DELETE" });
      setKits(kits.filter((k: any) => k.id !== id));
      toast.success("Kit removido");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir kit");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Kits</h1>
          <p className="text-sm text-zinc-500">Combine produtos artesanais em kits exclusivos.</p>
        </div>
        
        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Novo Kit
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Kit" : "Novo Kit Ritual"}</DialogTitle>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label htmlFor="name">Nome do Kit</Label>
                  <Input 
                    id="name" 
                    value={formData.name} 
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="price">Preço Total (R$)</Label>
                    <Input 
                      id="price" 
                      type="number" 
                      step="0.01"
                      value={formData.price} 
                      onChange={(e) => setFormData({...formData, price: e.target.value})}
                      required 
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="slug">Slug (URL)</Label>
                    <Input 
                      id="slug" 
                      value={formData.slug} 
                      onChange={(e) => setFormData({...formData, slug: e.target.value})}
                      required 
                    />
                  </div>
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
                <div className="grid gap-2">
                  <Label>Produtos no Kit</Label>
                  <div className="border rounded-lg p-4 space-y-4 max-h-[300px] overflow-y-auto">
                    {products.map((product: any) => {
                      const selected = formData.selectedProducts.find(p => p.id === product.id);
                      return (
                        <div key={product.id} className="flex items-center justify-between gap-4">
                          <div className="flex items-center gap-3">
                            <Checkbox 
                              id={`prod-${product.id}`} 
                              checked={!!selected}
                              onCheckedChange={() => toggleProduct(product.id)}
                            />
                            <Label htmlFor={`prod-${product.id}`} className="cursor-pointer">{product.name}</Label>
                          </div>
                          {selected && (
                            <div className="flex items-center gap-2">
                              <span className="text-xs text-zinc-400">Qtd:</span>
                              <Input 
                                type="number" 
                                className="w-16 h-8 text-center" 
                                value={selected.quantity}
                                onChange={(e) => updateProductQuantity(product.id, parseInt(e.target.value))}
                              />
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="description">Descrição do Ritual</Label>
                  <Textarea 
                    id="description" 
                    value={formData.description} 
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    required 
                  />
                </div>
                <div className="pt-2">
                  <ImageUpload 
                    value={formData.featured_image} 
                    onUpload={(url) => setFormData({...formData, featured_image: url})} 
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit" className="bg-primary w-full">
                  {editingId ? "Atualizar Kit" : "Criar Kit"}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50">
              <TableHead>Kit</TableHead>
              <TableHead>Produtos</TableHead>
              <TableHead>Preço</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-10">Carregando...</TableCell>
              </TableRow>
            ) : kits.map((kit: any) => (
              <TableRow key={kit.id}>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-lg bg-zinc-100 flex items-center justify-center text-xl">🎁</div>
                    <div>
                      <div className="flex items-center gap-2">
                        <p className="font-medium">{kit.name}</p>
                        {kit.is_on_demand && (
                          <Badge variant="outline" className="bg-amber-50 text-amber-700 border-amber-200 text-[9px] py-0.5 px-1.5 leading-none">Encomenda</Badge>
                        )}
                      </div>
                      <p className="text-xs text-zinc-500">Slug: {kit.slug}</p>
                    </div>
                  </div>
                </TableCell>
                <TableCell>
                  <div className="flex flex-wrap gap-1">
                    {kit.products.map((p: any) => (
                      <Badge key={p.id} variant="secondary" className="text-[10px]">
                        {p.pivot.quantity}x {p.name}
                      </Badge>
                    ))}
                  </div>
                </TableCell>
                <TableCell className="font-bold text-primary">R$ {parseFloat(kit.price).toFixed(2)}</TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(kit)}>
                      <Edit className="w-4 h-4 text-zinc-400 hover:text-primary" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(kit.id)}>
                      <Trash2 className="w-4 h-4 text-zinc-400 hover:text-destructive" />
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
