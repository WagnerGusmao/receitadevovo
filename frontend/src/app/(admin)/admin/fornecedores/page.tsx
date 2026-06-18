"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { toast } from "sonner";
import { Plus, Edit, Trash2, Building2, Phone, Mail, Globe, MapPin } from "lucide-react";

const Instagram = (props: React.SVGProps<SVGSVGElement>) => (
  <svg
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <rect width="20" height="20" x="2" y="2" rx="5" ry="5" />
    <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
    <line x1="17.5" x2="17.51" y1="6.5" y2="6.5" />
  </svg>
);

type Supplier = {
  id: number;
  name: string;
  cnpj?: string;
  contact_name?: string;
  email?: string;
  phone?: string;
  website?: string;
  address?: string;
  instagram?: string;
  notes?: string;
  is_active: boolean;
  raw_materials_count: number;
};

const emptyForm = {
  name: "", cnpj: "", contact_name: "", email: "",
  phone: "", website: "", address: "", instagram: "", notes: "", is_active: true
};

export default function FornecedoresPage() {
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [form, setForm] = useState(emptyForm);

  useEffect(() => { load(); }, []);

  async function load() {
    setLoading(true);
    try {
      const res = await apiFetch("/inventory/suppliers");
      setSuppliers(res.data);
    } catch {
      toast.error("Erro ao carregar fornecedores");
    } finally {
      setLoading(false);
    }
  }

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm);
    setIsModalOpen(true);
  }

  function openEdit(s: Supplier) {
    setEditingId(s.id);
    setForm({
      name: s.name, cnpj: s.cnpj ?? "", contact_name: s.contact_name ?? "",
      email: s.email ?? "", phone: s.phone ?? "", website: s.website ?? "",
      address: s.address ?? "", instagram: s.instagram ?? "",
      notes: s.notes ?? "", is_active: s.is_active
    });
    setIsModalOpen(true);
  }

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingId) {
        await apiFetch(`/inventory/suppliers/${editingId}`, { method: "PUT", body: JSON.stringify(form) });
        toast.success("Fornecedor atualizado");
      } else {
        await apiFetch("/inventory/suppliers", { method: "POST", body: JSON.stringify(form) });
        toast.success("Fornecedor cadastrado");
      }
      setIsModalOpen(false);
      load();
    } catch (e: any) {
      toast.error(e.message || "Erro ao salvar");
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Remover este fornecedor?")) return;
    try {
      await apiFetch(`/inventory/suppliers/${id}`, { method: "DELETE" });
      toast.success("Removido");
      load();
    } catch (e: any) {
      toast.error(e.message || "Erro ao remover");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Fornecedores</h1>
          <p className="text-sm text-zinc-500">Gerencie seus fornecedores de matérias-primas.</p>
        </div>
        <Button className="bg-primary hover:bg-olive gap-2" onClick={openCreate}>
          <Plus className="w-4 h-4" /> Novo Fornecedor
        </Button>
      </div>

      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Fornecedor</TableHead>
              <TableHead>Contato</TableHead>
              <TableHead>CNPJ</TableHead>
              <TableHead className="text-center">Materiais</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-center">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell></TableRow>
            ) : suppliers.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-16">
                  <Building2 className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
                  <p className="text-zinc-400">Nenhum fornecedor cadastrado.</p>
                  <Button variant="link" onClick={openCreate} className="text-primary mt-2">Cadastrar agora</Button>
                </TableCell>
              </TableRow>
            ) : suppliers.map((s) => (
              <TableRow key={s.id}>
                <TableCell>
                  <div>
                    <p className="font-medium text-zinc-900">{s.name}</p>
                    {s.contact_name && <p className="text-xs text-zinc-400">{s.contact_name}</p>}
                  </div>
                </TableCell>
                <TableCell>
                  <div className="flex flex-col gap-1">
                    {s.email && (
                      <a href={`mailto:${s.email}`} className="text-xs text-zinc-500 flex items-center gap-1 hover:text-primary">
                        <Mail className="w-3 h-3" /> {s.email}
                      </a>
                    )}
                    {s.phone && (
                      <span className="text-xs text-zinc-500 flex items-center gap-1">
                        <Phone className="w-3 h-3" /> {s.phone}
                      </span>
                    )}
                    {s.website && (
                      <a href={s.website} target="_blank" rel="noopener noreferrer" className="text-xs text-zinc-500 flex items-center gap-1 hover:text-primary">
                        <Globe className="w-3 h-3" /> Site
                      </a>
                    )}
                    {s.instagram && (
                      <a href={`https://instagram.com/${s.instagram.replace('@', '')}`} target="_blank" rel="noopener noreferrer" className="text-xs text-zinc-500 flex items-center gap-1 hover:text-primary">
                        <Instagram className="w-3 h-3 text-pink-500" /> {s.instagram}
                      </a>
                    )}
                    {s.address && (
                      <span className="text-xs text-zinc-500 flex items-start gap-1 max-w-[200px]" title={s.address}>
                        <MapPin className="w-3.5 h-3.5 mt-0.5 text-zinc-400 shrink-0" /> <span className="truncate">{s.address}</span>
                      </span>
                    )}
                  </div>
                </TableCell>
                <TableCell className="font-mono text-sm text-zinc-500">{s.cnpj || "—"}</TableCell>
                <TableCell className="text-center">
                  <Badge variant="outline">{s.raw_materials_count} material(is)</Badge>
                </TableCell>
                <TableCell>
                  {s.is_active
                    ? <Badge className="bg-emerald-100 text-emerald-700 border-none">Ativo</Badge>
                    : <Badge className="bg-zinc-100 text-zinc-500 border-none">Inativo</Badge>}
                </TableCell>
                <TableCell>
                  <div className="flex items-center justify-center gap-1">
                    <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => openEdit(s)}>
                      <Edit className="w-3.5 h-3.5 text-zinc-500" />
                    </Button>
                    <Button size="sm" variant="ghost" className="h-8 w-8 p-0" onClick={() => handleDelete(s.id)}>
                      <Trash2 className="w-3.5 h-3.5 text-red-400" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-[560px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleSave}>
            <DialogHeader>
              <DialogTitle>{editingId ? "Editar Fornecedor" : "Novo Fornecedor"}</DialogTitle>
              <DialogDescription>Preencha os dados do fornecedor de insumos.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label>Nome *</Label>
                <Input required value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>CNPJ</Label>
                  <Input placeholder="00.000.000/0000-00" value={form.cnpj}
                    onChange={e => setForm({ ...form, cnpj: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Nome do Contato</Label>
                  <Input value={form.contact_name} onChange={e => setForm({ ...form, contact_name: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>E-mail</Label>
                  <Input type="email" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Telefone</Label>
                  <Input value={form.phone} onChange={e => setForm({ ...form, phone: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label>Website</Label>
                  <Input placeholder="https://" value={form.website} onChange={e => setForm({ ...form, website: e.target.value })} />
                </div>
                <div className="grid gap-2">
                  <Label>Instagram</Label>
                  <Input placeholder="@usuario" value={form.instagram} onChange={e => setForm({ ...form, instagram: e.target.value })} />
                </div>
              </div>
              <div className="grid gap-2">
                <Label>Endereço</Label>
                <Input placeholder="Endereço completo" value={form.address} onChange={e => setForm({ ...form, address: e.target.value })} />
              </div>
              <div className="grid gap-2">
                <Label>Observações</Label>
                <Input value={form.notes} onChange={e => setForm({ ...form, notes: e.target.value })} />
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancelar</Button>
              <Button type="submit" className="bg-primary">{editingId ? "Atualizar" : "Cadastrar"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
