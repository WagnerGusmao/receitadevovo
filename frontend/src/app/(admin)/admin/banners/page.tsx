"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Edit, Trash2, Image as ImageIcon, ExternalLink, Power, PowerOff, Upload, Loader2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";

interface Banner {
  id: number;
  title: string | null;
  subtitle: string | null;
  description: string | null;
  image_desktop: string;
  image_mobile: string | null;
  image_fit?: string;
  image_position?: string;
  button_text: string | null;
  button_url: string | null;
  page_target: string;
  is_active: boolean;
  sort_order: number;
  created_at: string;
}

export default function AdminBanners() {
  const [banners, setBanners] = useState<Banner[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  
  const [uploadingDesktop, setUploadingDesktop] = useState(false);
  const [uploadingMobile, setUploadingMobile] = useState(false);

  const [formData, setFormData] = useState({
    title: "",
    subtitle: "",
    description: "",
    image_desktop: "",
    image_mobile: "",
    image_fit: "cover",
    image_position: "center",
    button_text: "",
    button_url: "",
    page_target: "home",
    is_active: true,
    sort_order: 0,
  });

  useEffect(() => {
    loadBanners();
  }, []);

  async function loadBanners() {
    setLoading(true);
    try {
      const response = await apiFetch("/content/banners");
      setBanners(response.data);
    } catch (error) {
      console.error("Erro ao carregar banners", error);
      toast.error("Erro ao carregar banners");
    } finally {
      setLoading(false);
    }
  }

  const resetForm = () => {
    setFormData({
      title: "",
      subtitle: "",
      description: "",
      image_desktop: "",
      image_mobile: "",
      image_fit: "cover",
      image_position: "center",
      button_text: "",
      button_url: "",
      page_target: "home",
      is_active: true,
      sort_order: 0,
    });
    setEditingId(null);
  };

  const handleEdit = (banner: Banner) => {
    setFormData({
      title: banner.title || "",
      subtitle: banner.subtitle || "",
      description: banner.description || "",
      image_desktop: banner.image_desktop,
      image_mobile: banner.image_mobile || "",
      image_fit: banner.image_fit || "cover",
      image_position: banner.image_position || "center",
      button_text: banner.button_text || "",
      button_url: banner.button_url || "",
      page_target: banner.page_target,
      is_active: banner.is_active,
      sort_order: banner.sort_order,
    });
    setEditingId(banner.id);
    setIsModalOpen(true);
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>, field: 'desktop' | 'mobile') => {
    const file = e.target.files?.[0];
    if (!file) return;

    const isDesktop = field === 'desktop';
    if (isDesktop) setUploadingDesktop(true);
    else setUploadingMobile(true);

    try {
      const uploadData = new FormData();
      uploadData.append("image", file);

      const response = await apiFetch("/upload", {
        method: "POST",
        body: uploadData,
      });

      if (response.data?.url) {
        if (isDesktop) {
          setFormData(prev => ({ ...prev, image_desktop: response.data.url }));
          toast.success("Imagem desktop carregada!");
        } else {
          setFormData(prev => ({ ...prev, image_mobile: response.data.url }));
          toast.success("Imagem mobile carregada!");
        }
      }
    } catch (error: any) {
      console.error("Erro no upload", error);
      toast.error(error.message || "Falha no envio da imagem");
    } finally {
      if (isDesktop) setUploadingDesktop(false);
      else setUploadingMobile(false);
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Tem certeza que deseja excluir este banner?")) return;

    try {
      await apiFetch(`/content/banners/${id}`, { method: "DELETE" });
      setBanners(banners.filter((b) => b.id !== id));
      toast.success("Banner excluído com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao excluir banner");
    }
  };

  const handleToggleActive = async (banner: Banner) => {
    try {
      const updatedStatus = !banner.is_active;
      await apiFetch(`/content/banners/${banner.id}`, {
        method: "PUT",
        body: JSON.stringify({ is_active: updatedStatus }),
      });
      setBanners(banners.map(b => b.id === banner.id ? { ...b, is_active: updatedStatus } : b));
      toast.success(updatedStatus ? "Banner ativado" : "Banner desativado");
    } catch (error: any) {
      toast.error(error.message || "Erro ao atualizar status do banner");
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = editingId ? `/content/banners/${editingId}` : "/content/banners";
      const method = editingId ? "PUT" : "POST";

      await apiFetch(url, {
        method,
        body: JSON.stringify(formData),
      });

      setIsModalOpen(false);
      resetForm();
      loadBanners();
      toast.success(editingId ? "Banner atualizado" : "Banner criado com sucesso");
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar banner");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Banners</h1>
          <p className="text-sm text-zinc-500">Configure os banners do carrossel principal e de outras páginas.</p>
        </div>

        <Dialog open={isModalOpen} onOpenChange={(open) => {
          setIsModalOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-[#7c6f45] hover:bg-[#635837] text-white gap-2" onClick={resetForm}>
              <Plus className="w-4 h-4" /> Novo Banner
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
            <form onSubmit={handleSave}>
              <DialogHeader>
                <DialogTitle>{editingId ? "Editar Banner" : "Novo Banner Promocional"}</DialogTitle>
                <DialogDescription>
                  {editingId ? "Atualize as informações e imagens do banner selecionado." : "Adicione um novo banner para campanhas, cupons ou lançamentos."}
                </DialogDescription>
              </DialogHeader>
              
              <div className="grid gap-4 py-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="title">Título do Banner (Opcional)</Label>
                    <Input 
                      id="title" 
                      placeholder="Ex: 20% de Desconto"
                      value={formData.title} 
                      onChange={(e) => setFormData({...formData, title: e.target.value})}
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="subtitle">Subtítulo (Opcional)</Label>
                    <Input 
                      id="subtitle" 
                      placeholder="Ex: Nas linhas de Sabonetes Artesanais"
                      value={formData.subtitle} 
                      onChange={(e) => setFormData({...formData, subtitle: e.target.value})}
                    />
                  </div>
                </div>

                <div className="grid gap-2">
                  <Label htmlFor="description">Descrição / Texto Explicativo (Opcional)</Label>
                  <Textarea 
                    id="description" 
                    placeholder="Ex: Utilize o cupom VOVO10 no carrinho para garantir o desconto."
                    value={formData.description} 
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    className="min-h-[80px]"
                  />
                </div>

                <div className="grid gap-2">
                  <div className="flex justify-between items-center">
                    <Label htmlFor="image_desktop">URL da Imagem Desktop <span className="text-red-500">*</span></Label>
                    <div className="relative cursor-pointer flex items-center gap-1.5 text-xs text-[#7c6f45] font-semibold hover:text-[#635837]">
                      {uploadingDesktop ? (
                        <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      ) : (
                        <Upload className="w-3.5 h-3.5" />
                      )}
                      <span>Upload do PC</span>
                      <input 
                        type="file" 
                        accept="image/*" 
                        className="absolute inset-0 opacity-0 cursor-pointer"
                        onChange={(e) => handleFileUpload(e, 'desktop')}
                        disabled={uploadingDesktop}
                      />
                    </div>
                  </div>
                  <Input 
                    id="image_desktop" 
                    placeholder="https://exemplo.com/banner-desktop.jpg"
                    value={formData.image_desktop} 
                    onChange={(e) => setFormData({...formData, image_desktop: e.target.value})}
                    required 
                  />
                </div>

                <div className="grid gap-2">
                  <div className="flex justify-between items-center">
                    <Label htmlFor="image_mobile">URL da Imagem Mobile (Opcional)</Label>
                    <div className="relative cursor-pointer flex items-center gap-1.5 text-xs text-[#7c6f45] font-semibold hover:text-[#635837]">
                      {uploadingMobile ? (
                        <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      ) : (
                        <Upload className="w-3.5 h-3.5" />
                      )}
                      <span>Upload do PC</span>
                      <input 
                        type="file" 
                        accept="image/*" 
                        className="absolute inset-0 opacity-0 cursor-pointer"
                        onChange={(e) => handleFileUpload(e, 'mobile')}
                        disabled={uploadingMobile}
                      />
                    </div>
                  </div>
                  <Input 
                    id="image_mobile" 
                    placeholder="https://exemplo.com/banner-mobile.jpg"
                    value={formData.image_mobile} 
                    onChange={(e) => setFormData({...formData, image_mobile: e.target.value})}
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="button_text">Texto do Botão (Opcional)</Label>
                    <Input 
                      id="button_text" 
                      placeholder="Ex: Aproveitar Oferta"
                      value={formData.button_text} 
                      onChange={(e) => setFormData({...formData, button_text: e.target.value})}
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="button_url">URL de Destino (Opcional)</Label>
                    <Input 
                      id="button_url" 
                      placeholder="Ex: /produtos/sabonetes"
                      value={formData.button_url} 
                      onChange={(e) => setFormData({...formData, button_url: e.target.value})}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label htmlFor="image_fit">Estilo de Ajuste (Imagem)</Label>
                    <Select 
                      value={formData.image_fit}
                      onValueChange={(val) => setFormData({...formData, image_fit: val})}
                    >
                      <SelectTrigger id="image_fit" className="w-full">
                        <SelectValue placeholder="Selecione..." />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cover">Preencher (Pode cortar)</SelectItem>
                        <SelectItem value="contain">Conter (Mostrar inteira)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  
                  <div className="grid gap-2">
                    <Label htmlFor="image_position">Alinhamento da Imagem</Label>
                    <Select 
                      value={formData.image_position}
                      onValueChange={(val) => setFormData({...formData, image_position: val})}
                    >
                      <SelectTrigger id="image_position" className="w-full">
                        <SelectValue placeholder="Selecione..." />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="center">Centro</SelectItem>
                        <SelectItem value="top">Topo</SelectItem>
                        <SelectItem value="bottom">Base (Abaixo)</SelectItem>
                        <SelectItem value="left">Esquerda</SelectItem>
                        <SelectItem value="right">Direita</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-4 items-end">
                  <div className="grid gap-2">
                    <Label htmlFor="page_target">Página Alvo</Label>
                    <Select 
                      value={formData.page_target}
                      onValueChange={(val) => setFormData({...formData, page_target: val})}
                    >
                      <SelectTrigger id="page_target" className="w-full">
                        <SelectValue placeholder="Selecione..." />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="home">Página Inicial (Home)</SelectItem>
                        <SelectItem value="shop">Catálogo (Shop)</SelectItem>
                        <SelectItem value="blog">Artigos (Blog)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  
                  <div className="grid gap-2">
                    <Label htmlFor="sort_order">Ordem de Exibição</Label>
                    <Input 
                      id="sort_order" 
                      type="number"
                      value={formData.sort_order} 
                      onChange={(e) => setFormData({...formData, sort_order: parseInt(e.target.value) || 0})}
                      required 
                    />
                  </div>

                  <div className="flex items-center gap-2 h-10 border border-bege rounded-lg px-3 bg-zinc-50/50">
                    <input 
                      id="is_active" 
                      type="checkbox"
                      checked={formData.is_active} 
                      onChange={(e) => setFormData({...formData, is_active: e.target.checked})}
                      className="h-4 w-4 rounded border-bege text-primary focus:ring-primary/20 accent-[#7c6f45]"
                    />
                    <Label htmlFor="is_active" className="cursor-pointer font-normal text-sm select-none">Banner Ativo</Label>
                  </div>
                </div>
              </div>

              <DialogFooter>
                <Button type="submit" className="bg-[#7c6f45] hover:bg-[#635837] text-white">
                  {editingId ? "Atualizar Banner" : "Salvar Banner"}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead className="w-[100px]">Prévia</TableHead>
              <TableHead>Título / Subtítulo</TableHead>
              <TableHead>Página Alvo</TableHead>
              <TableHead>Ordem</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
              </TableRow>
            ) : banners.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Nenhum banner cadastrado.</TableCell>
              </TableRow>
            ) : banners.map((banner) => (
              <TableRow key={banner.id}>
                <TableCell>
                  <div className="relative w-16 h-10 rounded border border-zinc-200 bg-zinc-50 overflow-hidden flex items-center justify-center">
                    {banner.image_desktop ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img 
                        src={banner.image_desktop} 
                        alt={banner.title || "Banner"} 
                        className="object-cover w-full h-full"
                        onError={(e) => {
                          // Fallback icon on error
                          (e.target as HTMLElement).style.display = 'none';
                        }}
                      />
                    ) : (
                      <ImageIcon className="w-5 h-5 text-zinc-300" />
                    )}
                  </div>
                </TableCell>
                <TableCell>
                  <div>
                    <span className="font-semibold text-zinc-900 block truncate max-w-[250px]">{banner.title || "Sem título"}</span>
                    <span className="text-xs text-zinc-400 block truncate max-w-[250px]">{banner.subtitle || "Sem subtítulo"}</span>
                  </div>
                </TableCell>
                <TableCell>
                  <Badge className="bg-bege-light text-terra border-bege shadow-none uppercase font-semibold text-[10px]">
                    {banner.page_target}
                  </Badge>
                </TableCell>
                <TableCell className="font-medium text-sm text-zinc-700">
                  {banner.sort_order}
                </TableCell>
                <TableCell>
                  <button
                    onClick={() => handleToggleActive(banner)}
                    className={`flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold shadow-none transition-colors border
                      ${banner.is_active 
                        ? 'bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100/70' 
                        : 'bg-zinc-50 text-zinc-400 border-zinc-200 hover:bg-zinc-100'}`}
                    title={banner.is_active ? "Clique para desativar" : "Clique para ativar"}
                  >
                    {banner.is_active ? (
                      <>
                        <Power className="w-3 h-3 text-emerald-600" /> Ativo
                      </>
                    ) : (
                      <>
                        <PowerOff className="w-3 h-3 text-zinc-400" /> Inativo
                      </>
                    )}
                  </button>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    {banner.button_url && (
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 text-zinc-400 hover:text-primary"
                        onClick={() => window.open(banner.button_url || "", '_blank')}
                      >
                        <ExternalLink className="w-4 h-4" />
                      </Button>
                    )}
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-primary"
                      onClick={() => handleEdit(banner)}
                    >
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-zinc-400 hover:text-destructive"
                      onClick={() => handleDelete(banner.id)}
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
