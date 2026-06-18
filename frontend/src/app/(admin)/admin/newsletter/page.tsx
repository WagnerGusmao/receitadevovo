"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Mail, Download, ToggleLeft, ToggleRight, Trash2, Search, Users, RefreshCw, PenTool, Eye, Bold, Link as LinkIcon, Image as ImageIcon, AlignLeft, Send } from "lucide-react";
import { toast } from "sonner";

interface Subscriber {
  id: number;
  email: string;
  active: boolean;
  created_at: string;
}

export default function AdminNewsletter() {
  const [subscribers, setSubscribers] = useState<Subscriber[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [filterActive, setFilterActive] = useState("all");

  // Compositor de E-mail
  const [isComposerOpen, setIsComposerOpen] = useState(false);
  const [composerTab, setComposerTab] = useState<"edit" | "preview">("edit");
  const [sendingMail, setSendingMail] = useState(false);
  const [mailForm, setMailForm] = useState({
    subject: "",
    body: "",
  });

  useEffect(() => {
    loadSubscribers();
  }, [search, filterActive]);

  async function loadSubscribers() {
    setLoading(true);
    try {
      const activeParam = filterActive === "all" ? "" : filterActive === "active" ? "true" : "false";
      const response = await apiFetch(`/newsletter/admin/subscribers?search=${encodeURIComponent(search)}&active=${activeParam}`);
      setSubscribers(response.data || []);
    } catch (error: any) {
      console.error("Error loading subscribers", error);
      toast.error(error.message || "Erro ao carregar os inscritos.");
    } finally {
      setLoading(false);
    }
  }

  const handleToggle = async (id: number) => {
    try {
      const response = await apiFetch(`/newsletter/admin/subscribers/${id}/toggle`, {
        method: "POST",
      });
      toast.success(response.message || "Status alterado com sucesso.");
      
      setSubscribers(subscribers.map(sub => 
        sub.id === id ? { ...sub, active: !sub.active } : sub
      ));
    } catch (error: any) {
      toast.error(error.message || "Erro ao alterar o status do inscrito.");
    }
  };

  const handleDelete = async (id: number, email: string) => {
    if (!confirm(`Tem certeza que deseja excluir o e-mail "${email}" da lista de newsletter?`)) {
      return;
    }

    try {
      await apiFetch(`/newsletter/admin/subscribers/${id}`, {
        method: "DELETE",
      });
      toast.success("Inscrito removido com sucesso.");
      setSubscribers(subscribers.filter(sub => sub.id !== id));
    } catch (error: any) {
      toast.error(error.message || "Erro ao remover o inscrito.");
    }
  };

  const exportToCSV = () => {
    if (subscribers.length === 0) {
      toast.error("Não há inscritos para exportar.");
      return;
    }

    const headers = ["ID", "E-mail", "Status", "Data de Inscrição"];
    const rows = subscribers.map(sub => [
      sub.id,
      sub.email,
      sub.active ? "Ativo" : "Inativo",
      new Date(sub.created_at).toLocaleDateString("pt-BR")
    ]);

    const csvContent = [
      headers.join(","),
      ...rows.map(e => e.map(val => `"${val}"`).join(","))
    ].join("\n");

    const blob = new Blob(["\uFEFF" + csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.setAttribute("href", url);
    link.setAttribute("download", `newsletter_inscritos_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    toast.success("Lista exportada com sucesso em formato CSV!");
  };

  // Atalhos do Editor HTML
  const insertAtCursor = (before: string, after: string = "") => {
    const textarea = document.getElementById("email-body-textarea") as HTMLTextAreaElement;
    if (!textarea) return;

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const text = textarea.value;
    const selected = text.substring(start, end);
    const replacement = before + selected + after;

    setMailForm({
      ...mailForm,
      body: text.substring(0, start) + replacement + text.substring(end)
    });

    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(start + before.length, start + before.length + selected.length);
    }, 0);
  };

  const handleSendEmail = async (e: React.FormEvent) => {
    e.preventDefault();
    const activeCount = subscribers.filter(sub => sub.active).length;

    if (activeCount === 0) {
      toast.error("Não há inscritos ativos para enviar a newsletter.");
      return;
    }

    if (!confirm(`Deseja enviar esta newsletter para todos os ${activeCount} inscrito(s) ativo(s)?`)) {
      return;
    }

    setSendingMail(true);
    try {
      const response = await apiFetch("/newsletter/admin/send", {
        method: "POST",
        body: JSON.stringify(mailForm),
      });

      toast.success(response.message || "Newsletter enviada com sucesso!");
      setIsComposerOpen(false);
      setMailForm({ subject: "", body: "" });
      setComposerTab("edit");
    } catch (error: any) {
      toast.error(error.message || "Erro ao enviar a newsletter.");
    } finally {
      setSendingMail(false);
    }
  };

  // Preview final estilizado
  const activeSubscribersCount = subscribers.filter(sub => sub.active).length;

  return (
    <div className="space-y-6">
      {/* Cabeçalho */}
      <div className="flex flex-col md:flex-row md:justify-between md:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900 flex items-center gap-2">
            <Mail className="w-6 h-6 text-primary" /> Gestão da Newsletter
          </h1>
          <p className="text-sm text-zinc-500">
            Gerencie a lista de e-mails cadastrados e faça disparos de comunicados diretamente do painel.
          </p>
        </div>

        <div className="flex gap-2">
          <Button 
            variant="outline" 
            size="sm"
            onClick={loadSubscribers}
            className="border-zinc-200 text-zinc-700 hover:bg-zinc-50"
            title="Atualizar lista"
          >
            <RefreshCw className="w-4 h-4" />
          </Button>

          <Button 
            onClick={exportToCSV} 
            variant="outline"
            className="border-zinc-200 text-zinc-700 hover:bg-zinc-50 gap-2"
          >
            <Download className="w-4 h-4" /> Exportar CSV
          </Button>

          {/* Modal de Disparo de Newsletter */}
          <Dialog open={isComposerOpen} onOpenChange={(open) => {
            setIsComposerOpen(open);
            if (!open) {
              setMailForm({ subject: "", body: "" });
              setComposerTab("edit");
            }
          }}>
            <DialogTrigger asChild>
              <Button className="bg-primary hover:bg-olive text-white gap-2">
                <PenTool className="w-4 h-4" /> Escrever Newsletter
              </Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[700px] max-h-[90vh] flex flex-col">
              <form onSubmit={handleSendEmail} className="flex flex-col h-full overflow-hidden">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2 text-zinc-900">
                    <PenTool className="w-5 h-5 text-primary" /> Compor E-mail de Newsletter
                  </DialogTitle>
                  <DialogDescription>
                    Escreva e estilize a newsletter que será enviada para todos os {activeSubscribersCount} inscritos ativos.
                  </DialogDescription>
                </DialogHeader>

                {/* Abas Editor / Visualização */}
                <div className="flex border-b border-zinc-200 mt-4">
                  <button
                    type="button"
                    className={`px-4 py-2 text-sm font-semibold border-b-2 transition-all ${
                      composerTab === "edit"
                        ? "border-primary text-primary"
                        : "border-transparent text-zinc-500 hover:text-zinc-700"
                    }`}
                    onClick={() => setComposerTab("edit")}
                  >
                    <span className="flex items-center gap-1.5"><AlignLeft className="w-4 h-4" /> Editor</span>
                  </button>
                  <button
                    type="button"
                    className={`px-4 py-2 text-sm font-semibold border-b-2 transition-all ${
                      composerTab === "preview"
                        ? "border-primary text-primary"
                        : "border-transparent text-zinc-500 hover:text-zinc-700"
                    }`}
                    onClick={() => setComposerTab("preview")}
                  >
                    <span className="flex items-center gap-1.5"><Eye className="w-4 h-4" /> Visualização (Live Preview)</span>
                  </button>
                </div>

                <div className="flex-1 overflow-y-auto py-4 min-h-[300px]">
                  {composerTab === "edit" ? (
                    <div className="space-y-4">
                      <div className="grid gap-2">
                        <Label htmlFor="subject">Assunto do E-mail</Label>
                        <Input
                          id="subject"
                          placeholder="Ex: 🌿 Novas ervas rituais e ofertas exclusivas de bem-estar!"
                          value={mailForm.subject}
                          onChange={(e) => setMailForm({ ...mailForm, subject: e.target.value })}
                          required
                          disabled={sendingMail}
                          className="border-zinc-200 focus-visible:ring-primary/20"
                        />
                      </div>

                      <div className="grid gap-2">
                        <div className="flex justify-between items-center">
                          <Label htmlFor="email-body-textarea">Conteúdo da Mensagem (HTML)</Label>
                          {/* Barra de atalhos HTML */}
                          <div className="flex gap-1.5 border border-zinc-200 rounded-md p-1 bg-zinc-50">
                            <button
                              type="button"
                              onClick={() => insertAtCursor("<strong>", "</strong>")}
                              className="p-1 hover:bg-zinc-200 rounded text-zinc-600"
                              title="Negrito"
                            >
                              <Bold className="w-3.5 h-3.5" />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertAtCursor("<p>", "</p>")}
                              className="p-1 hover:bg-zinc-200 rounded text-zinc-600"
                              title="Parágrafo"
                            >
                              <AlignLeft className="w-3.5 h-3.5" />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertAtCursor('<a href="https://receitadevovo.com.br/produtos" style="color: #4F6F52; font-weight: bold; text-decoration: underline;">', '</a>')}
                              className="p-1 hover:bg-zinc-200 rounded text-zinc-600"
                              title="Link de Produto"
                            >
                              <LinkIcon className="w-3.5 h-3.5" />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertAtCursor('<img src="https://images.unsplash.com/photo-1546842931-886c185b4c8c?w=600" style="max-width: 100%; border-radius: 8px; margin: 12px 0;" alt="Ritual Vovó" />')}
                              className="p-1 hover:bg-zinc-200 rounded text-zinc-600"
                              title="Inserir Foto"
                            >
                              <ImageIcon className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        </div>

                        <Textarea
                          id="email-body-textarea"
                          className="min-h-[250px] font-mono text-sm border-zinc-200 focus-visible:ring-primary/20"
                          placeholder="<p>Olá, querida comunidade do bem-estar!</p>&#10;<p>Hoje queremos compartilhar um novo ritual ancestral...</p>"
                          value={mailForm.body}
                          onChange={(e) => setMailForm({ ...mailForm, body: e.target.value })}
                          required
                          disabled={sendingMail}
                        />
                        <p className="text-[10px] text-zinc-400">
                          Dica: Você pode usar tags HTML para formatar parágrafos, links e imagens. Use os botões acima para inserir rapidamente.
                        </p>
                      </div>
                    </div>
                  ) : (
                    <div className="bg-zinc-100 p-4 rounded-xl border border-zinc-200 overflow-x-auto flex justify-center">
                      {/* Simulação exata do template do backend */}
                      <div className="bg-[#FAF6F0] w-full max-w-[550px] p-6 border border-zinc-200 rounded-xl shadow-sm font-sans text-left">
                        <div className="text-center mb-5 border-b-2 border-[#EAE3D2] pb-4">
                          <h1 className="text-2xl font-bold font-serif text-[#4F6F52] m-0">🌿 Receita de Vovó</h1>
                          <p className="text-xs text-[#8C6A5C] m-1 italic">Ritual & Bem-Estar Ancestral</p>
                        </div>
                        
                        <div 
                          className="text-[#2D2727] text-sm leading-relaxed min-h-[150px] whitespace-pre-line"
                          dangerouslySetInnerHTML={{ 
                            __html: mailForm.body || '<p style="color: #999; font-style: italic; text-align: center; margin-top: 50px;">Nenhum conteúdo escrito ainda. Escreva na aba "Editor".</p>' 
                          }}
                        />

                        <div className="text-center mt-6 border-t border-[#EAE3D2] pt-4 text-[10px] text-zinc-500 leading-normal">
                          <p className="m-0">Você recebeu esta mensagem porque se inscreveu na nossa newsletter.</p>
                          <p className="m-1 font-semibold">Receita de Vovó - Barueri, São Paulo - Brasil</p>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                <DialogFooter className="border-t border-zinc-100 pt-4">
                  <Button
                    type="button"
                    variant="ghost"
                    onClick={() => setIsComposerOpen(false)}
                    disabled={sendingMail}
                  >
                    Cancelar
                  </Button>
                  <Button
                    type="submit"
                    className="bg-primary hover:bg-olive text-white gap-2"
                    disabled={sendingMail || activeSubscribersCount === 0}
                  >
                    <Send className="w-4 h-4" /> {sendingMail ? "Enviando..." : `Enviar para ${activeSubscribersCount} Inscrito(s)`}
                  </Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      {/* Cards de Métricas */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white p-4 rounded-xl border border-zinc-200 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-primary/10 rounded-lg text-primary">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Total de Inscritos</p>
            <p className="text-2xl font-bold text-zinc-900">{subscribers.length}</p>
          </div>
        </div>

        <div className="bg-white p-4 rounded-xl border border-zinc-200 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-emerald-50 rounded-lg text-emerald-600">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Ativos</p>
            <p className="text-2xl font-bold text-emerald-600">
              {subscribers.filter(sub => sub.active).length}
            </p>
          </div>
        </div>

        <div className="bg-white p-4 rounded-xl border border-zinc-200 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-red-50 rounded-lg text-red-500">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Desativados</p>
            <p className="text-2xl font-bold text-red-500">
              {subscribers.filter(sub => !sub.active).length}
            </p>
          </div>
        </div>
      </div>

      {/* Filtros e Busca */}
      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <div className="p-4 border-b border-zinc-100 bg-zinc-50/50 flex flex-col sm:flex-row gap-4 justify-between items-center">
          <div className="relative w-full sm:max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
            <Input 
              className="pl-10 bg-white border-zinc-200" 
              placeholder="Buscar e-mails..." 
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
            <span className="text-xs font-medium text-zinc-500 shrink-0">Filtrar por:</span>
            <select
              className="bg-white border border-zinc-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 text-zinc-700 w-full sm:w-auto"
              value={filterActive}
              onChange={(e) => setFilterActive(e.target.value)}
            >
              <option value="all">Todos</option>
              <option value="active">Ativos</option>
              <option value="inactive">Inativos</option>
            </select>
          </div>
        </div>

        {/* Tabela de Inscritos */}
        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>E-mail</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Data de Inscrição</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-10 text-zinc-400">
                  Carregando inscritos...
                </TableCell>
              </TableRow>
            ) : subscribers.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-10 text-zinc-400">
                  Nenhum inscrito encontrado.
                </TableCell>
              </TableRow>
            ) : (
              subscribers.map((sub) => (
                <TableRow key={sub.id}>
                  <TableCell>
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded bg-primary/10 flex items-center justify-center text-primary">
                        <Mail className="w-4 h-4" />
                      </div>
                      <span className="font-medium text-zinc-900">{sub.email}</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    {sub.active ? (
                      <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 shadow-none hover:bg-emerald-50">
                        Ativo
                      </Badge>
                    ) : (
                      <Badge className="bg-zinc-100 text-zinc-500 border-zinc-200 shadow-none hover:bg-zinc-100">
                        Inativo
                      </Badge>
                    )}
                  </TableCell>
                  <TableCell className="text-sm text-zinc-500">
                    {new Date(sub.created_at).toLocaleString("pt-BR")}
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <button 
                        className="p-1 rounded-lg text-zinc-400 hover:text-primary transition-colors"
                        onClick={() => handleToggle(sub.id)}
                        title={sub.active ? "Desativar inscrição" : "Ativar inscrição"}
                      >
                        {sub.active ? (
                          <ToggleRight className="w-6 h-6 text-primary" />
                        ) : (
                          <ToggleLeft className="w-6 h-6 text-zinc-300" />
                        )}
                      </button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 text-zinc-400 hover:text-destructive"
                        onClick={() => handleDelete(sub.id, sub.email)}
                        title="Remover inscrito"
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
      </div>
    </div>
  );
}
