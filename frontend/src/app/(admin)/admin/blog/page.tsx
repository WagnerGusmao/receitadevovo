"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Edit, Trash2, Search, FileText, Eye } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";

export default function AdminBlog() {
  const [posts, setPosts] = useState([]);
  const [products, setProducts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [formData, setFormData] = useState({
    title: "",
    content: "",
    slug: "",
    category_id: "1",
    featured_image: "",
    linked_product_id: "",
    show_on_home: false,
    home_order: 0,
  });

  useEffect(() => {
    loadPosts();
    loadProducts();
  }, []);

  async function loadPosts() {
    setLoading(true);
    try {
      const response = await apiFetch("/content/posts");
      setPosts(response.data);
    } catch (error) {
      console.error("Error loading posts", error);
    } finally {
      setLoading(false);
    }
  }

  async function loadProducts() {
    try {
      const response = await apiFetch("/ecommerce/products");
      setProducts(response.data?.products || []);
    } catch (error) {
      console.error("Error loading products", error);
    }
  }

  const resetForm = () => {
    setFormData({
      title: "",
      content: "",
      slug: "",
      category_id: "1",
      featured_image: "",
      linked_product_id: "",
      show_on_home: false,
      home_order: 0,
    });
    setEditingId(null);
  };

  const handleEdit = (post: any) => {
    setFormData({
      title: post.title,
      content: post.content,
      slug: post.slug,
      category_id: post.category_id.toString(),
      featured_image: post.featured_image || "",
      linked_product_id: post.linked_product_id ? post.linked_product_id.toString() : "",
      show_on_home: !!post.show_on_home,
      home_order: post.home_order || 0,
    });
    setEditingId(post.id);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Tem certeza que deseja excluir este artigo?")) return;

    try {
      await apiFetch(`/content/posts/${id}`, { method: "DELETE" });
      setPosts(posts.filter((p: any) => p.id !== id));
      toast.success("Artigo removido com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir artigo");
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/content/posts/${editingId}` : "/content/posts";
      const method = editingId ? "PUT" : "POST";

      const payload = {
        ...formData,
        linked_product_id: formData.linked_product_id === "" ? null : parseInt(formData.linked_product_id),
        home_order: parseInt(formData.home_order.toString()) || 0,
      };

      await apiFetch(url, {
        method,
        body: JSON.stringify(payload)
      });
      
      setIsModalOpen(false);
      resetForm();
      loadPosts();
      toast.success(editingId ? "Artigo atualizado" : "Artigo publicado com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar artigo");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Conteúdo</h1>
          <p className="text-sm text-zinc-500">Escreva e publique novos artigos no blog.</p>
        </div>

        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Novo Artigo
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Artigo" : "Novo Artigo de Sabedoria"}</DialogTitle>
                <DialogDescription>
                  {editingId ? "Atualize o conteúdo do artigo selecionado." : "Compartilhe seu conhecimento artesanal com a comunidade."}
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4 max-h-[60vh] overflow-y-auto pr-1">
                <div className="grid gap-2">
                  <Label htmlFor="title">Título</Label>
                  <Input 
                    id="title" 
                    value={formData.title} 
                    onChange={(e) => setFormData({...formData, title: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="slug">Slug (URL)</Label>
                  <Input 
                    id="slug" 
                    placeholder="o-poder-das-ervas"
                    value={formData.slug} 
                    onChange={(e) => setFormData({...formData, slug: e.target.value})}
                    required 
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="featured_image">URL da Imagem de Destaque</Label>
                  <Input 
                    id="featured_image" 
                    placeholder="https://exemplo.com/imagem-artigo.jpg"
                    value={formData.featured_image} 
                    onChange={(e) => setFormData({...formData, featured_image: e.target.value})}
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="linked_product_id">Produto Vinculado (Opcional)</Label>
                  <Select 
                    value={formData.linked_product_id}
                    onValueChange={(val) => setFormData({...formData, linked_product_id: val})}
                  >
                    <SelectTrigger id="linked_product_id" className="w-full border-bege text-terra">
                      <SelectValue placeholder="Selecione um produto..." />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="">Nenhum produto</SelectItem>
                      {products.map((prod: any) => (
                        <SelectItem key={prod.id} value={prod.id.toString()}>
                          {prod.name} (R$ {parseFloat(prod.price).toFixed(2)})
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="grid grid-cols-2 gap-4 items-end">
                  <div className="flex items-center gap-2 h-10 border border-bege rounded-lg px-3 bg-zinc-50/50">
                    <input 
                      id="show_on_home" 
                      type="checkbox"
                      checked={formData.show_on_home} 
                      onChange={(e) => setFormData({...formData, show_on_home: e.target.checked})}
                      className="h-4 w-4 rounded border-bege text-primary focus:ring-primary/20 accent-[#7c6f45]"
                    />
                    <Label htmlFor="show_on_home" className="cursor-pointer font-normal text-sm select-none">Exibir na Home</Label>
                  </div>
                  
                  <div className="grid gap-2">
                    <Label htmlFor="home_order">Ordem na Home</Label>
                    <Input 
                      id="home_order" 
                      type="number"
                      disabled={!formData.show_on_home}
                      value={formData.home_order} 
                      onChange={(e) => setFormData({...formData, home_order: parseInt(e.target.value) || 0})}
                    />
                  </div>
                </div>

                <div className="grid gap-2">
                  <Label htmlFor="content">Conteúdo (Markdown)</Label>
                  <Textarea 
                    id="content" 
                    className="min-h-[150px]"
                    value={formData.content} 
                    onChange={(e) => setFormData({...formData, content: e.target.value})}
                    required 
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit" className="bg-[#7c6f45] hover:bg-[#635837] text-white">
                  {editingId ? "Atualizar Artigo" : "Publicar Artigo"}
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
            <Input className="pl-10 bg-white border-zinc-200" placeholder="Buscar artigos..." />
          </div>
        </div>

        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Título / Produto Vinculado</TableHead>
              <TableHead>Destaque Home</TableHead>
              <TableHead>Autor</TableHead>
              <TableHead>Data</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
              </TableRow>
            ) : posts.map((post: any) => (
              <TableRow key={post.id}>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded bg-bege-light flex items-center justify-center text-terra">
                      <FileText className="w-4 h-4" />
                    </div>
                    <div>
                      <span className="font-medium text-zinc-900 block">{post.title}</span>
                      {post.product && (
                        <span className="text-xs text-sage font-medium block mt-0.5">
                          Linkado: {post.product.name}
                        </span>
                      )}
                    </div>
                  </div>
                </TableCell>
                <TableCell>
                  {post.show_on_home ? (
                    <Badge className="bg-[#7c6f45]/10 text-[#7c6f45] border-[#7c6f45]/20 shadow-none">
                      Sim (Ordem: {post.home_order})
                    </Badge>
                  ) : (
                    <span className="text-xs text-zinc-400">—</span>
                  )}
                </TableCell>
                <TableCell className="text-sm text-zinc-500">{post.user?.name || 'Vovó'}</TableCell>
                <TableCell className="text-sm text-zinc-500">
                  {new Date(post.created_at).toLocaleDateString()}
                </TableCell>
                <TableCell>
                  <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 shadow-none">Publicado</Badge>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => window.open(`/blog/${post.slug}`, '_blank')}
                    >
                      <Eye className="w-4 h-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => handleEdit(post)}
                    >
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-destructive"
                      onClick={() => handleDelete(post.id)}
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
