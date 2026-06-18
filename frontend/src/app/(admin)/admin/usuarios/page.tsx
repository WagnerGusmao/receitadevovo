"use client";

import { useEffect, useState } from "react";
import { userService, UserFilterParams } from "@/modules/admin/services/userService";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { Search, Edit2, ShieldAlert, CheckCircle2, XCircle, Key, Trash2, Shield, User, ChevronLeft, ChevronRight, Eye, EyeOff } from "lucide-react";
import { toast } from "sonner";
import { formatCPF, formatWhatsApp } from "@/lib/masks";

export default function UsersAdminPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [pagination, setPagination] = useState({
    current_page: 1,
    last_page: 1,
    total: 0,
  });
  const [filters, setFilters] = useState<UserFilterParams>({
    search: "",
    role: "all",
    status: "all",
    page: 1,
  });
  const [loading, setLoading] = useState(true);

  // Modals state
  const [editingUser, setEditingUser] = useState<any>(null);
  const [resettingUser, setResettingUser] = useState<any>(null);
  const [deletingUser, setDeletingUser] = useState<any>(null);

  // Form states
  const [editForm, setEditForm] = useState({
    name: "",
    email: "",
    whatsapp: "",
    phone: "",
    cpf: "",
    is_admin: false,
    is_active: true,
  });

  const [passwordForm, setPasswordForm] = useState({
    password: "",
    password_confirmation: "",
  });
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    loadUsers();
  }, [filters]);

  async function loadUsers() {
    setLoading(true);
    try {
      const response = await userService.getUsers(filters);
      if (response.status === "success") {
        setUsers(response.data.data);
        setPagination({
          current_page: response.data.current_page,
          last_page: response.data.last_page,
          total: response.data.total,
        });
      } else {
        toast.error("Erro ao carregar usuários.");
      }
    } catch (error) {
      console.error(error);
      toast.error("Erro de conexão ao carregar usuários.");
    } finally {
      setLoading(false);
    }
  }

  const handleFilterChange = (key: keyof UserFilterParams, value: any) => {
    setFilters((prev) => ({
      ...prev,
      [key]: value,
      page: key === "page" ? value : 1, // reset page to 1 if filter changes
    }));
  };

  const handleOpenEdit = (user: any) => {
    setEditingUser(user);
    setEditForm({
      name: user.name || "",
      email: user.email || "",
      whatsapp: formatWhatsApp(user.whatsapp || ""),
      phone: formatWhatsApp(user.phone || ""),
      cpf: formatCPF(user.cpf || ""),
      is_admin: !!user.is_admin,
      is_active: !!user.is_active,
    });
  };

  const handleSaveEdit = async () => {
    if (!editForm.name || !editForm.email || !editForm.whatsapp) {
      toast.error("Nome, Email e WhatsApp são obrigatórios.");
      return;
    }

    try {
      const response = await userService.updateUser(editingUser.id, editForm);
      if (response.status === "success") {
        toast.success("Usuário atualizado com sucesso!");
        setEditingUser(null);
        loadUsers();
      } else {
        toast.error(response.message || "Erro ao atualizar usuário.");
      }
    } catch (error: any) {
      console.error(error);
      toast.error("Ocorreu um erro ao atualizar.");
    }
  };

  const handleOpenReset = (user: any) => {
    setResettingUser(user);
    setPasswordForm({
      password: "",
      password_confirmation: "",
    });
    setShowPassword(false);
  };

  const generateRandomPassword = () => {
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+";
    let pass = "";
    for (let i = 0; i < 12; i++) {
      pass += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    setPasswordForm({
      password: pass,
      password_confirmation: pass,
    });
    setShowPassword(true);
    toast.success("Senha gerada aleatoriamente!");
  };

  const handleSaveReset = async () => {
    if (passwordForm.password.length < 8) {
      toast.error("A senha deve ter no mínimo 8 caracteres.");
      return;
    }
    if (passwordForm.password !== passwordForm.password_confirmation) {
      toast.error("As senhas não conferem.");
      return;
    }

    try {
      const response = await userService.resetPassword(resettingUser.id, {
        password: passwordForm.password,
        password_confirmation: passwordForm.password_confirmation,
      });
      if (response.status === "success") {
        toast.success("Senha redefinida com sucesso!");
        setResettingUser(null);
      } else {
        toast.error(response.message || "Erro ao redefinir senha.");
      }
    } catch (error) {
      console.error(error);
      toast.error("Erro ao redefinir a senha.");
    }
  };

  const handleDelete = async () => {
    try {
      const response = await userService.deleteUser(deletingUser.id);
      if (response.status === "success") {
        toast.success("Usuário excluído com sucesso!");
        setDeletingUser(null);
        loadUsers();
      } else {
        toast.error(response.message || "Erro ao excluir usuário.");
      }
    } catch (error: any) {
      console.error(error);
      toast.error(error.message || "Erro ao excluir o usuário.");
    }
  };

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold font-outfit text-zinc-900">Gestão de Usuários</h1>
          <p className="text-zinc-500">Controle privilégios, altere permissões de acesso e redefina senhas.</p>
        </div>
      </div>

      {/* Filters Card */}
      <Card className="border-none shadow-sm bg-white">
        <CardContent className="pt-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="md:col-span-2 relative">
              <Search className="absolute left-3 top-3.5 h-4 w-4 text-zinc-400" />
              <Input
                placeholder="Buscar por nome, e-mail, whatsapp ou CPF..."
                value={filters.search}
                onChange={(e) => handleFilterChange("search", e.target.value)}
                className="pl-9 h-11 border-zinc-200 focus:ring-primary"
              />
            </div>

            <div>
              <Select
                value={filters.role}
                onValueChange={(val) => handleFilterChange("role", val)}
              >
                <SelectTrigger className="h-11 border-zinc-200">
                  <SelectValue placeholder="Nível de Permissão" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos os Perfis</SelectItem>
                  <SelectItem value="admin">Administradores</SelectItem>
                  <SelectItem value="client">Clientes</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div>
              <Select
                value={filters.status}
                onValueChange={(val) => handleFilterChange("status", val)}
              >
                <SelectTrigger className="h-11 border-zinc-200">
                  <SelectValue placeholder="Status da Conta" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos os Status</SelectItem>
                  <SelectItem value="active">Contas Ativas</SelectItem>
                  <SelectItem value="inactive">Contas Desativadas</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Users Table */}
      <Card className="border-none shadow-sm bg-white overflow-hidden">
        <Table>
          <TableHeader className="bg-zinc-50/50">
            <TableRow>
              <TableHead className="w-[30%]">Nome / Email</TableHead>
              <TableHead className="w-[25%]">WhatsApp / CPF</TableHead>
              <TableHead className="w-[15%]">Perfil</TableHead>
              <TableHead className="w-[15%]">Status</TableHead>
              <TableHead className="w-[15%] text-right pr-6">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              Array.from({ length: 5 }).map((_, idx) => (
                <TableRow key={idx}>
                  <TableCell><div className="h-5 bg-zinc-100 rounded w-40 animate-pulse" /></TableCell>
                  <TableCell><div className="h-5 bg-zinc-100 rounded w-32 animate-pulse" /></TableCell>
                  <TableCell><div className="h-6 bg-zinc-100 rounded-full w-20 animate-pulse" /></TableCell>
                  <TableCell><div className="h-6 bg-zinc-100 rounded-full w-16 animate-pulse" /></TableCell>
                  <TableCell className="text-right pr-6"><div className="h-8 bg-zinc-100 rounded w-24 ml-auto animate-pulse" /></TableCell>
                </TableRow>
              ))
            ) : users.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-10 text-zinc-400 italic">
                  Nenhum usuário correspondente aos filtros foi encontrado.
                </TableCell>
              </TableRow>
            ) : (
              users.map((user) => (
                <TableRow key={user.id} className="hover:bg-zinc-50/40 transition-colors">
                  <TableCell>
                    <div className="font-medium text-zinc-900">{user.name}</div>
                    <div className="text-xs text-zinc-500">{user.email}</div>
                  </TableCell>
                  <TableCell>
                    <div className="text-sm text-zinc-700">{formatWhatsApp(user.whatsapp || "")}</div>
                    {user.cpf && <div className="text-xs text-zinc-400">CPF: {formatCPF(user.cpf)}</div>}
                  </TableCell>
                  <TableCell>
                    {user.is_admin ? (
                      <Badge className="bg-indigo-50 hover:bg-indigo-50 text-indigo-700 border border-indigo-200/50 rounded-full gap-1 py-0.5">
                        <Shield className="w-3 h-3" /> Admin
                      </Badge>
                    ) : (
                      <Badge variant="secondary" className="bg-zinc-100 hover:bg-zinc-100 text-zinc-600 rounded-full gap-1 py-0.5">
                        <User className="w-3 h-3" /> Cliente
                      </Badge>
                    )}
                  </TableCell>
                  <TableCell>
                    {user.is_active ? (
                      <Badge className="bg-emerald-50 hover:bg-emerald-50 text-emerald-700 border border-emerald-200/50 rounded-full gap-1 py-0.5">
                        <CheckCircle2 className="w-3 h-3" /> Ativo
                      </Badge>
                    ) : (
                      <Badge className="bg-rose-50 hover:bg-rose-50 text-rose-700 border border-rose-200/50 rounded-full gap-1 py-0.5">
                        <XCircle className="w-3 h-3" /> Inativo
                      </Badge>
                    )}
                  </TableCell>
                  <TableCell className="text-right pr-6">
                    <div className="flex justify-end gap-1.5">
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleOpenEdit(user)}
                        className="h-9 w-9 text-zinc-500 hover:text-primary hover:bg-primary/5 rounded-lg"
                        title="Editar Usuário"
                      >
                        <Edit2 className="w-4 h-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleOpenReset(user)}
                        className="h-9 w-9 text-zinc-500 hover:text-amber-600 hover:bg-amber-50 rounded-lg"
                        title="Redefinir Senha"
                      >
                        <Key className="w-4 h-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => setDeletingUser(user)}
                        className="h-9 w-9 text-zinc-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg"
                        title="Excluir Usuário"
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>

        {/* Pagination bar */}
        {!loading && pagination.last_page > 1 && (
          <div className="flex items-center justify-between px-6 py-4 border-t border-zinc-100 bg-zinc-50/50">
            <span className="text-sm text-zinc-500">
              Mostrando página <strong className="text-zinc-700">{pagination.current_page}</strong> de{" "}
              <strong className="text-zinc-700">{pagination.last_page}</strong> ({pagination.total} usuários)
            </span>
            <div className="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => handleFilterChange("page", pagination.current_page - 1)}
                disabled={pagination.current_page === 1}
                className="h-9 border-zinc-200 gap-1 rounded-lg"
              >
                <ChevronLeft className="w-4 h-4" /> Anterior
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => handleFilterChange("page", pagination.current_page + 1)}
                disabled={pagination.current_page === pagination.last_page}
                className="h-9 border-zinc-200 gap-1 rounded-lg"
              >
                Próximo <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )}
      </Card>

      {/* Edit User Modal */}
      {editingUser && (
        <Dialog open={true} onOpenChange={(open) => !open && setEditingUser(null)}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <Edit2 className="w-5 h-5 text-primary" /> Editar Cadastro
              </DialogTitle>
              <DialogDescription>
                Atualize os dados cadastrais e o perfil de acesso de <strong>{editingUser.name}</strong>.
              </DialogDescription>
            </DialogHeader>

            <div className="space-y-4 py-2">
              <div className="grid gap-1.5">
                <Label htmlFor="edit-name">Nome Completo</Label>
                <Input
                  id="edit-name"
                  value={editForm.name}
                  onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                  className="border-zinc-200"
                />
              </div>

              <div className="grid gap-1.5">
                <Label htmlFor="edit-email">E-mail</Label>
                <Input
                  id="edit-email"
                  type="email"
                  value={editForm.email}
                  onChange={(e) => setEditForm({ ...editForm, email: e.target.value })}
                  className="border-zinc-200"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-1.5">
                  <Label htmlFor="edit-whatsapp">WhatsApp (Obrigatório)</Label>
                  <Input
                    id="edit-whatsapp"
                    value={editForm.whatsapp}
                    maxLength={15}
                    onChange={(e) => setEditForm({ ...editForm, whatsapp: formatWhatsApp(e.target.value) })}
                    className="border-zinc-200"
                  />
                </div>
                <div className="grid gap-1.5">
                  <Label htmlFor="edit-phone">Telefone Secundário</Label>
                  <Input
                    id="edit-phone"
                    value={editForm.phone}
                    maxLength={15}
                    onChange={(e) => setEditForm({ ...editForm, phone: formatWhatsApp(e.target.value) })}
                    className="border-zinc-200"
                  />
                </div>
              </div>

              <div className="grid gap-1.5">
                <Label htmlFor="edit-cpf">CPF</Label>
                <Input
                  id="edit-cpf"
                  value={editForm.cpf}
                  maxLength={14}
                  onChange={(e) => setEditForm({ ...editForm, cpf: formatCPF(e.target.value) })}
                  placeholder="000.000.000-00"
                  className="border-zinc-200"
                />
              </div>

              <div className="flex flex-col gap-3 pt-2">
                <div className="flex items-center space-x-2">
                  <Checkbox
                    id="edit-admin"
                    checked={editForm.is_admin}
                    onCheckedChange={(checked) => setEditForm({ ...editForm, is_admin: !!checked })}
                  />
                  <Label htmlFor="edit-admin" className="font-medium cursor-pointer text-zinc-700">
                    Conceder privilégios de Administrador
                  </Label>
                </div>

                <div className="flex items-center space-x-2">
                  <Checkbox
                    id="edit-active"
                    checked={editForm.is_active}
                    onCheckedChange={(checked) => setEditForm({ ...editForm, is_active: !!checked })}
                  />
                  <Label htmlFor="edit-active" className="font-medium cursor-pointer text-zinc-700">
                    Conta Ativa (Desmarque para suspender o acesso)
                  </Label>
                </div>
              </div>
            </div>

            <DialogFooter className="gap-2 sm:gap-0">
              <Button variant="ghost" onClick={() => setEditingUser(null)} className="text-zinc-500">
                Cancelar
              </Button>
              <Button onClick={handleSaveEdit} className="bg-primary hover:bg-olive text-white">
                Salvar Alterações
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Reset Password Modal */}
      {resettingUser && (
        <Dialog open={true} onOpenChange={(open) => !open && setResettingUser(null)}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <Key className="w-5 h-5 text-amber-500" /> Redefinir Senha
              </DialogTitle>
              <DialogDescription>
                Defina uma nova senha para <strong>{resettingUser.name}</strong> ou gere uma de forma aleatória.
              </DialogDescription>
            </DialogHeader>

            <div className="space-y-4 py-2">
              <div className="flex justify-end">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={generateRandomPassword}
                  className="border-amber-200 bg-amber-50 hover:bg-amber-100 text-amber-800 text-xs rounded-lg"
                >
                  Gerar Senha Aleatória Segura
                </Button>
              </div>

              <div className="grid gap-1.5 relative">
                <Label htmlFor="new-password">Nova Senha (mín. 8 caracteres)</Label>
                <div className="relative">
                  <Input
                    id="new-password"
                    type={showPassword ? "text" : "password"}
                    value={passwordForm.password}
                    onChange={(e) => setPasswordForm({ ...passwordForm, password: e.target.value })}
                    className="border-zinc-200 pr-10"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-3 text-zinc-400 hover:text-zinc-600"
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>

              <div className="grid gap-1.5">
                <Label htmlFor="confirm-password">Confirmar Nova Senha</Label>
                <Input
                  id="confirm-password"
                  type={showPassword ? "text" : "password"}
                  value={passwordForm.password_confirmation}
                  onChange={(e) => setPasswordForm({ ...passwordForm, password_confirmation: e.target.value })}
                  className="border-zinc-200"
                />
              </div>
            </div>

            <DialogFooter className="gap-2 sm:gap-0">
              <Button variant="ghost" onClick={() => setResettingUser(null)} className="text-zinc-500">
                Cancelar
              </Button>
              <Button onClick={handleSaveReset} className="bg-amber-600 hover:bg-amber-700 text-white">
                Confirmar Nova Senha
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Delete Confirmation Modal */}
      {deletingUser && (
        <Dialog open={true} onOpenChange={(open) => !open && setDeletingUser(null)}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2 text-rose-600">
                <ShieldAlert className="w-5 h-5" /> Excluir Conta?
              </DialogTitle>
              <DialogDescription className="text-zinc-600">
                Tem certeza que deseja excluir o cadastro de <strong>{deletingUser.name}</strong>?
                <br />
                Esta ação é definitiva e removerá todos os dados e endereços do usuário.
              </DialogDescription>
            </DialogHeader>

            <div className="bg-rose-50 border border-rose-100 p-4 rounded-xl text-xs text-rose-800 space-y-2">
              <p className="font-bold flex items-center gap-1.5">
                <ShieldAlert className="w-4 h-4 flex-shrink-0" /> Restrição Fiscal
              </p>
              <p>
                Se o usuário possuir histórico de compras efetuadas, a exclusão física será impedida pelo banco de dados por integridade cadastral de notas fiscais. Nesses casos, recomendamos reverter o status para <strong>Inativo</strong>.
              </p>
            </div>

            <DialogFooter className="gap-2 sm:gap-0">
              <Button variant="ghost" onClick={() => setDeletingUser(null)} className="text-zinc-500">
                Cancelar
              </Button>
              <Button onClick={handleDelete} className="bg-rose-600 hover:bg-rose-700 text-white">
                Sim, Excluir Usuário
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}
    </div>
  );
}
