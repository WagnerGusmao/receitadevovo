"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Plus, Edit, Trash2, Tag, Package } from "lucide-react";
import { toast } from "sonner";

export default function AdminCategories() {
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    slug: "",
  });

  useEffect(() => {
    loadCategories();
  }, []);

  async function loadCategories() {
    setLoading(true);
    try {
      const response = await apiFetch("/ecommerce/categories");
      setCategories(response.data || []);
    } catch (error) {
      console.error("Error loading categories", error);
      toast.error("Erro ao carregar categorias");
    } finally {
      setLoading(false);
    }
  }

  const resetForm = () => {
    setFormData({ name: "", description: "", slug: "" });
    setEditingId(null);
  };

  const handleEdit = (cat: any) => {
    setFormData({
      name: cat.name,
      description: cat.description || "",
      slug: cat.slug || "",
    });
    setEditingId(cat.id);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Deseja excluir esta categoria? Os produtos associados ficarão sem categoria.")) return;
    try {
      await apiFetch(`/ecommerce/categories/${id}`, { method: "DELETE" });
      setCategories(categories.filter((c: any) => c.id !== id));
      toast.success("Categoria excluída com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir categoria");
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/ecommerce/categories/${editingId}` : "/ecommerce/categories";
      const method = editingId ? "PUT" : "POST";

      await apiFetch(url, {
        method,
        body: JSON.stringify(formData),
      });

      setIsModalOpen(false);
      resetForm();
      loadCategories();
      toast.success(editingId ? "Categoria atualizada" : "Categoria criada com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar categoria");
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Categorias de Produtos</h1>
          <p className="text-sm text-zinc-500">Organize seus produtos em categorias para facilitar a navegação dos clientes.</p>
        </div>

        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Nova Categoria
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[480px]">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Categoria" : "Nova Categoria"}</DialogTitle>
                <DialogDescription>
                  {editingId
                    ? "Atualize as informações da categoria selecionada."
                    : "Crie uma nova categoria para organizar os produtos da loja."}
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label htmlFor="cat-name">Nome da Categoria</Label>
                  <Input
                    id="cat-name"
                    placeholder="Ex: Chás & Infusões"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    required
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="cat-slug">
                    Slug (URL)
                    <span className="ml-2 text-xs text-zinc-400 font-normal">Gerado automaticamente se vazio</span>
                  </Label>
                  <Input
                    id="cat-slug"
                    placeholder="chas-e-infusoes"
                    value={formData.slug}
                    onChange={(e) => setFormData({ ...formData, slug: e.target.value })}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="cat-description">Descrição</Label>
                  <Textarea
                    id="cat-description"
                    placeholder="Descreva brevemente esta categoria..."
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    rows={3}
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>
                  Cancelar
                </Button>
                <Button type="submit" className="bg-primary">
                  {editingId ? "Atualizar" : "Criar Categoria"}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {/* Stats summary */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white rounded-xl border border-zinc-200 p-4 flex items-center gap-4">
          <div className="w-10 h-10 rounded-lg bg-sage/10 flex items-center justify-center">
            <Tag className="w-5 h-5 text-sage" />
          </div>
          <div>
            <p className="text-2xl font-bold text-zinc-900">{categories.length}</p>
            <p className="text-xs text-zinc-500">Categorias cadastradas</p>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-zinc-200 p-4 flex items-center gap-4">
          <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
            <Package className="w-5 h-5 text-primary" />
          </div>
          <div>
            <p className="text-2xl font-bold text-zinc-900">
              {categories.reduce((sum: number, cat: any) => sum + (cat.products_count || 0), 0)}
            </p>
            <p className="text-xs text-zinc-500">Produtos categorizados</p>
          </div>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead className="w-[80px]">ID</TableHead>
              <TableHead>Categoria</TableHead>
              <TableHead>Slug</TableHead>
              <TableHead>Descrição</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-10 text-zinc-400">
                  Carregando categorias...
                </TableCell>
              </TableRow>
            ) : categories.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-12">
                  <div className="flex flex-col items-center gap-2 text-zinc-400">
                    <Tag className="w-8 h-8" />
                    <p className="font-medium">Nenhuma categoria cadastrada</p>
                    <p className="text-sm">Clique em "Nova Categoria" para começar</p>
                  </div>
                </TableCell>
              </TableRow>
            ) : categories.map((cat: any) => (
              <TableRow key={cat.id}>
                <TableCell className="font-mono text-xs text-zinc-500">#{cat.id}</TableCell>
                <TableCell>
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 rounded-lg bg-sage/10 flex items-center justify-center">
                      <Tag className="w-4 h-4 text-sage" />
                    </div>
                    <span className="font-medium text-zinc-900">{cat.name}</span>
                  </div>
                </TableCell>
                <TableCell>
                  <Badge variant="outline" className="font-mono text-xs">
                    {cat.slug}
                  </Badge>
                </TableCell>
                <TableCell className="text-sm text-zinc-500 max-w-[280px] truncate">
                  {cat.description || <span className="italic text-zinc-300">Sem descrição</span>}
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => handleEdit(cat)}
                    >
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-zinc-400 hover:text-destructive"
                      onClick={() => handleDelete(cat.id)}
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
