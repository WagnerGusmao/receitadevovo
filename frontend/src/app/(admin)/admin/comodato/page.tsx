"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { cn } from "@/lib/utils";
import {
  Building2, Users, Layers, Send, Receipt, Undo2, AlertOctagon,
  Search, ClipboardCheck, History, ArrowRight, ArrowLeft, Plus, Trash2, Calendar, Edit
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

type Partner = {
  id: number;
  name: string;
  contact_name: string | null;
  phone: string | null;
  address: string | null;
  commission_percentage: number;
  is_active: boolean;
  stocks_count: number;
  stocks?: Array<{
    id: number;
    itemable_type: string;
    itemable_id: number;
    quantity: number;
    itemable: {
      id: number;
      name: string;
      price: number;
    };
  }>;
  movements?: Array<{
    id: number;
    type: "dispatch" | "sale" | "return" | "loss";
    quantity: number;
    created_at: string;
    itemable: {
      name: string;
    };
  }>;
};

type CatalogItem = { id: number; name: string; price: number; type: "product" | "kit" | "variant" };

export default function ComodatoPage() {
  const [partners, setPartners] = useState<Partner[]>([]);
  const [catalog, setCatalog] = useState<CatalogItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<"partners" | "history">("partners");
  const [search, setSearch] = useState("");
  const [movements, setMovements] = useState<any[]>([]);

  // Modais e Estados de Ação
  const [selectedPartner, setSelectedPartner] = useState<Partner | null>(null);
  const [isPartnerModalOpen, setIsPartnerModalOpen] = useState(false);
  const [partnerName, setPartnerName] = useState("");
  const [partnerContact, setPartnerContact] = useState("");
  const [partnerPhone, setPartnerPhone] = useState("");
  const [partnerAddress, setPartnerAddress] = useState("");
  const [partnerCommission, setPartnerCommission] = useState("0");
  const [editingPartnerId, setEditingPartnerId] = useState<number | null>(null);

  // Ações de estoque
  const [actionType, setActionType] = useState<"dispatch" | "sale" | "return" | "loss" | "audit" | null>(null);
  const [selectedProduct, setSelectedProduct] = useState<string>("");
  const [actionQuantity, setActionQuantity] = useState("1");
  const [actionNotes, setActionNotes] = useState("");
  const [paymentMethod, setPaymentMethod] = useState("pix");

  // Auditoria
  const [auditCounts, setAuditCounts] = useState<{ [key: string]: number }>({});

  useEffect(() => {
    loadPartners();
    loadCatalog();
    loadMovements();
  }, []);

  async function loadPartners() {
    setLoading(true);
    try {
      const res = await apiFetch("/inventory/comodato/partners");
      setPartners(res.data ?? []);
    } catch {
      toast.error("Erro ao carregar parceiros.");
    } finally {
      setLoading(false);
    }
  }

  async function loadCatalog() {
    try {
      const [pRes, kRes] = await Promise.all([
        apiFetch("/ecommerce/products?per_page=200"),
        apiFetch("/ecommerce/kits?per_page=200"),
      ]);
      const prods = (pRes.data?.products ?? pRes.data ?? []).map((p: any) => ({ id: p.id, name: p.name, price: parseFloat(p.price), type: "product" }));
      const kits  = (kRes.data?.kits     ?? kRes.data ?? []).map((k: any) => ({ id: k.id, name: k.name, price: parseFloat(k.price), type: "kit" }));
      setCatalog([...prods, ...kits]);
    } catch {
      toast.error("Erro ao carregar catálogo.");
    }
  }

  async function loadMovements() {
    try {
      const res = await apiFetch("/inventory/comodato/movements");
      setMovements(res.data?.data ?? res.data ?? []);
    } catch {
      // Ignorar silenciando se falhar
    }
  }

  async function handlePartnerSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!partnerName.trim()) return;
    try {
      const url = editingPartnerId ? `/inventory/comodato/partners/${editingPartnerId}` : "/inventory/comodato/partners";
      const method = editingPartnerId ? "PUT" : "POST";
      
      await apiFetch(url, {
        method,
        body: JSON.stringify({
          name: partnerName,
          contact_name: partnerContact || undefined,
          phone: partnerPhone || undefined,
          address: partnerAddress || undefined,
          commission_percentage: parseFloat(partnerCommission) || 0,
        }),
      });

      toast.success(editingPartnerId ? "Parceiro atualizado!" : "Parceiro cadastrado! 🏢");
      closePartnerModal();
      loadPartners();
    } catch (err: any) {
      toast.error(err.message || "Erro ao salvar parceiro.");
    }
  }

  function openEditPartner(partner: Partner) {
    setEditingPartnerId(partner.id);
    setPartnerName(partner.name);
    setPartnerContact(partner.contact_name || "");
    setPartnerPhone(partner.phone || "");
    setPartnerAddress(partner.address || "");
    setPartnerCommission(String(partner.commission_percentage));
    setIsPartnerModalOpen(true);
  }

  function closePartnerModal() {
    setIsPartnerModalOpen(false);
    setEditingPartnerId(null);
    setPartnerName("");
    setPartnerContact("");
    setPartnerPhone("");
    setPartnerAddress("");
    setPartnerCommission("0");
  }

  async function handleActionSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!selectedPartner || !actionType) return;

    try {
      if (actionType === "dispatch") {
        const prod = catalog.find(p => p.id + "-" + p.type === selectedProduct);
        if (!prod) throw new Error("Selecione um produto.");
        
        await apiFetch("/inventory/comodato/dispatch", {
          method: "POST",
          body: JSON.stringify({
            partner_id: selectedPartner.id,
            type: prod.type,
            id: prod.id,
            quantity: parseInt(actionQuantity),
            notes: actionNotes || undefined,
          }),
        });
        toast.success("Produtos enviados com sucesso!");
      } else if (actionType === "return") {
        const [id, type] = selectedProduct.split("-");
        await apiFetch("/inventory/comodato/return", {
          method: "POST",
          body: JSON.stringify({
            partner_id: selectedPartner.id,
            type,
            id: parseInt(id),
            quantity: parseInt(actionQuantity),
            notes: actionNotes || undefined,
          }),
        });
        toast.success("Devolução registrada com sucesso!");
      } else if (actionType === "loss") {
        const [id, type] = selectedProduct.split("-");
        await apiFetch("/inventory/comodato/loss", {
          method: "POST",
          body: JSON.stringify({
            partner_id: selectedPartner.id,
            type,
            id: parseInt(id),
            quantity: parseInt(actionQuantity),
            notes: actionNotes || undefined,
          }),
        });
        toast.success("Avaria/Perda registrada no sistema.");
      } else if (actionType === "sale") {
        const [id, type] = selectedProduct.split("-");
        await apiFetch("/inventory/comodato/sale", {
          method: "POST",
          body: JSON.stringify({
            partner_id: selectedPartner.id,
            items: [{ id: parseInt(id), type, quantity: parseInt(actionQuantity) }],
            payment_method: paymentMethod,
            notes: actionNotes || undefined,
          }),
        });
        toast.success("Venda registrada com sucesso! 💸");
      }

      setActionType(null);
      setSelectedProduct("");
      setActionQuantity("1");
      setActionNotes("");
      
      // Recarregar parceiro selecionado e listagem geral
      if (selectedPartner) {
        const details = await apiFetch(`/inventory/comodato/partners/${selectedPartner.id}`);
        setSelectedPartner(details.data);
      }
      loadPartners();
      loadMovements();
    } catch (err: any) {
      toast.error(err.message || "Erro ao executar ação.");
    }
  }

  // Prepara dados para Auditoria
  function startAudit(partner: Partner) {
    const counts: { [key: string]: number } = {};
    (partner.stocks ?? []).forEach(s => {
      counts[`${s.itemable_id}-${s.itemable_type.split("\\").pop()?.toLowerCase()}`] = s.quantity;
    });
    setAuditCounts(counts);
    setActionType("audit");
  }

  async function handleAuditSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!selectedPartner) return;
    try {
      const items = Object.entries(auditCounts).map(([key, val]) => {
        const [id, type] = key.split("-");
        return {
          id: parseInt(id),
          type,
          quantity: val,
        };
      });

      await apiFetch("/inventory/comodato/audit", {
        method: "POST",
        body: JSON.stringify({
          partner_id: selectedPartner.id,
          items,
          notes: actionNotes || undefined,
        }),
      });

      toast.success("Auditoria e reconciliação concluídas com sucesso!");
      setActionType(null);
      setActionNotes("");
      const details = await apiFetch(`/inventory/comodato/partners/${selectedPartner.id}`);
      setSelectedPartner(details.data);
      loadPartners();
      loadMovements();
    } catch (err: any) {
      toast.error(err.message || "Erro ao registrar auditoria.");
    }
  }

  async function handleViewPartner(partner: Partner) {
    try {
      const details = await apiFetch(`/inventory/comodato/partners/${partner.id}`);
      setSelectedPartner(details.data);
    } catch {
      toast.error("Erro ao carregar detalhes do parceiro.");
    }
  }

  const filteredPartners = partners.filter(p =>
    p.name.toLowerCase().includes(search.toLowerCase()) ||
    (p.contact_name && p.contact_name.toLowerCase().includes(search.toLowerCase()))
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Comodatos (Consignações)</h1>
          <p className="text-sm text-zinc-500">Controle o estoque exposto em academias, salões, hotéis e registre as vendas.</p>
        </div>
        <Button onClick={() => setIsPartnerModalOpen(true)} className="bg-primary hover:bg-primary/90 gap-1.5 font-semibold">
          <Plus className="w-4 h-4" /> Novo Estabelecimento
        </Button>
      </div>

      {/* ── ABAS ── */}
      <div className="flex border-b border-zinc-200">
        <button
          onClick={() => setActiveTab("partners")}
          className={`px-4 py-2 text-sm font-semibold border-b-2 -mb-px transition-colors ${
            activeTab === "partners" ? "border-primary text-primary" : "border-transparent text-zinc-500 hover:text-zinc-800"
          }`}
        >
          Estabelecimentos Parceiros
        </button>
        <button
          onClick={() => setActiveTab("history")}
          className={`px-4 py-2 text-sm font-semibold border-b-2 -mb-px transition-colors ${
            activeTab === "history" ? "border-primary text-primary" : "border-transparent text-zinc-500 hover:text-zinc-800"
          }`}
        >
          Histórico de Movimentações
        </button>
      </div>

      {activeTab === "partners" ? (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* ── LISTA DE PARCEIROS ── */}
          <div className={cn(
            "lg:col-span-1 space-y-4",
            selectedPartner ? "hidden lg:block" : "block"
          )}>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
              <Input
                placeholder="Buscar parceiro..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                className="pl-9"
              />
            </div>

            {loading ? (
              <p className="text-center py-6 text-zinc-400 animate-pulse text-sm">Carregando parceiros...</p>
            ) : filteredPartners.length === 0 ? (
              <p className="text-center py-6 text-zinc-400 text-sm">Nenhum estabelecimento parceiro cadastrado.</p>
            ) : (
              <div className="space-y-3 max-h-[60vh] overflow-y-auto pr-1">
                {filteredPartners.map(p => (
                  <button
                    key={p.id}
                    onClick={() => handleViewPartner(p)}
                    className={`w-full text-left p-4 rounded-xl border transition-all ${
                      selectedPartner?.id === p.id
                        ? "border-primary bg-primary/5 shadow-sm"
                        : "border-zinc-200 bg-white hover:border-zinc-300"
                    }`}
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex gap-2.5">
                        <div className="w-9 h-9 rounded-lg bg-zinc-100 flex items-center justify-center flex-shrink-0 text-zinc-500">
                          <Building2 className="w-5 h-5" />
                        </div>
                        <div>
                          <p className="font-semibold text-zinc-900 text-sm">{p.name}</p>
                          {p.contact_name && <p className="text-xs text-zinc-500">Contato: {p.contact_name}</p>}
                        </div>
                      </div>
                      <Badge variant="outline" className="text-[10px] uppercase">
                        {p.commission_percentage > 0 ? `${p.commission_percentage}% comissão` : "Sem comissão"}
                      </Badge>
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* ── DETALHES DO PARCEIRO SELECIONADO ── */}
          <div className={cn(
            "lg:col-span-2",
            selectedPartner ? "block" : "hidden lg:block"
          )}>
            {selectedPartner ? (
              <div className="space-y-4">
                <button
                  type="button"
                  onClick={() => setSelectedPartner(null)}
                  className="lg:hidden flex items-center gap-1.5 text-xs font-semibold text-zinc-500 hover:text-zinc-800 bg-zinc-100 hover:bg-zinc-200/80 px-3 py-2 rounded-lg transition-colors"
                >
                  <ArrowLeft className="w-3.5 h-3.5" />
                  Voltar para lista
                </button>

                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="bg-white border border-zinc-200 rounded-xl p-5 shadow-sm space-y-6"
                >
                <div className="flex items-start justify-between border-b border-zinc-100 pb-4">
                  <div className="space-y-1">
                    <h2 className="text-xl font-bold text-zinc-950 font-outfit">{selectedPartner.name}</h2>
                    {selectedPartner.address && <p className="text-xs text-zinc-500">📍 {selectedPartner.address}</p>}
                    {selectedPartner.phone && <p className="text-xs text-zinc-500">📞 {selectedPartner.phone}</p>}
                  </div>
                  <div className="flex gap-2">
                    <Button variant="outline" size="sm" onClick={() => openEditPartner(selectedPartner)} className="h-8 text-xs gap-1">
                      <Edit className="w-3.5 h-3.5" /> Editar
                    </Button>
                  </div>
                </div>

                {/* AÇÕES DE ESTOQUE RÁPIDAS */}
                <div className="grid grid-cols-2 sm:grid-cols-5 gap-2">
                  <Button variant="outline" size="sm" className="h-10 text-xs gap-1 border-dashed hover:border-primary hover:text-primary" onClick={() => { setActionType("dispatch"); setSelectedProduct(catalog[0] ? catalog[0].id + "-" + catalog[0].type : ""); }}>
                    <Send className="w-3.5 h-3.5" /> Enviar
                  </Button>
                  <Button variant="outline" size="sm" className="h-10 text-xs gap-1 border-dashed hover:border-emerald-600 hover:text-emerald-600" onClick={() => { setActionType("sale"); setSelectedProduct(selectedPartner.stocks && selectedPartner.stocks[0] ? selectedPartner.stocks[0].itemable_id + "-" + selectedPartner.stocks[0].itemable_type.split("\\").pop()?.toLowerCase() : ""); }}>
                    <Receipt className="w-3.5 h-3.5" /> Venda
                  </Button>
                  <Button variant="outline" size="sm" className="h-10 text-xs gap-1 border-dashed hover:border-amber-600 hover:text-amber-600" onClick={() => { setActionType("return"); setSelectedProduct(selectedPartner.stocks && selectedPartner.stocks[0] ? selectedPartner.stocks[0].itemable_id + "-" + selectedPartner.stocks[0].itemable_type.split("\\").pop()?.toLowerCase() : ""); }}>
                    <Undo2 className="w-3.5 h-3.5" /> Devolver
                  </Button>
                  <Button variant="outline" size="sm" className="h-10 text-xs gap-1 border-dashed hover:border-rose-600 hover:text-rose-600" onClick={() => { setActionType("loss"); setSelectedProduct(selectedPartner.stocks && selectedPartner.stocks[0] ? selectedPartner.stocks[0].itemable_id + "-" + selectedPartner.stocks[0].itemable_type.split("\\").pop()?.toLowerCase() : ""); }}>
                    <AlertOctagon className="w-3.5 h-3.5" /> Avaria/Perda
                  </Button>
                  <Button variant="outline" size="sm" className="h-10 text-xs gap-1 border-dashed hover:border-blue-600 hover:text-blue-600 col-span-2 sm:col-span-1" onClick={() => startAudit(selectedPartner)}>
                    <ClipboardCheck className="w-3.5 h-3.5" /> Auditoria
                  </Button>
                </div>

                {/* ESTOQUE ATUAL NO PARCEIRO */}
                <div className="space-y-3">
                  <h3 className="font-bold text-zinc-900 text-sm flex items-center gap-1.5">
                    <Layers className="w-4 h-4 text-zinc-400" /> Estoque Atual no Estabelecimento
                  </h3>

                  {!selectedPartner.stocks || selectedPartner.stocks.filter(s => s.quantity > 0).length === 0 ? (
                    <div className="bg-zinc-50 border border-dashed border-zinc-200 rounded-xl py-8 text-center text-xs text-zinc-400">
                      Nenhum produto em estoque neste parceiro. Clique em &quot;Enviar&quot; para enviar mercadoria.
                    </div>
                  ) : (
                    <div className="border border-zinc-200 rounded-xl overflow-hidden divide-y divide-zinc-100">
                      {selectedPartner.stocks.filter(s => s.quantity > 0).map(stock => (
                        <div key={stock.id} className="flex justify-between items-center p-3 text-sm hover:bg-zinc-50/50">
                          <div>
                            <span className="font-semibold text-zinc-900">{stock.itemable?.name}</span>
                            <span className="text-[10px] text-zinc-400 block uppercase font-mono">
                              {stock.itemable_type.includes("Product") ? "Produto" : "Kit"}
                            </span>
                          </div>
                          <div className="text-right">
                            <span className="text-sm font-extrabold text-zinc-950 block">{stock.quantity} un</span>
                            <span className="text-xs text-primary font-medium">Valor: R$ {((stock.itemable?.price || 0) * stock.quantity).toFixed(2)}</span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* HISTÓRICO LOCAL RECENTE */}
                <div className="space-y-3">
                  <h3 className="font-bold text-zinc-900 text-sm flex items-center gap-1.5">
                    <History className="w-4 h-4 text-zinc-400" /> Histórico Recente
                  </h3>

                  {!selectedPartner.movements || selectedPartner.movements.length === 0 ? (
                    <p className="text-xs text-zinc-400 py-3 text-center">Nenhuma movimentação realizada ainda.</p>
                  ) : (
                    <div className="space-y-2">
                      {selectedPartner.movements.slice(0, 5).map(m => (
                        <div key={m.id} className="flex justify-between items-center text-xs border border-zinc-100 rounded-lg p-2.5 bg-zinc-50/20">
                          <div className="flex gap-2 items-center">
                            <Badge
                              className={`h-5 px-1.5 text-[9px] font-bold uppercase rounded-md ${
                                m.type === "dispatch" ? "bg-blue-100 text-blue-800" :
                                m.type === "sale" ? "bg-emerald-100 text-emerald-800" :
                                m.type === "return" ? "bg-amber-100 text-amber-800" : "bg-rose-100 text-rose-800"
                              }`}
                            >
                              {m.type === "dispatch" ? "Envio" :
                               m.type === "sale" ? "Venda" :
                               m.type === "return" ? "Retorno" : "Perda"}
                            </Badge>
                            <span className="font-medium text-zinc-900">{m.itemable?.name}</span>
                          </div>
                          <div className="text-right">
                            <span className="font-bold text-zinc-800 block">{m.quantity} un</span>
                            <span className="text-[9px] text-zinc-400">{new Date(m.created_at).toLocaleDateString("pt-BR")}</span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </motion.div>
              </div>
            ) : (
              <div className="h-64 border border-dashed border-zinc-200 bg-zinc-50/50 rounded-xl flex flex-col justify-center items-center text-zinc-400">
                <Building2 className="w-10 h-10 mb-2 text-zinc-300" />
                <p className="text-sm">Selecione um estabelecimento à esquerda para gerenciar o estoque e as vendas.</p>
              </div>
            )}
          </div>
        </div>
      ) : (
        /* ── HISTÓRICO GLOBAL DE MOVIMENTAÇÕES ── */
        <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
          {movements.length === 0 ? (
            <p className="text-center py-12 text-zinc-400 text-sm">Nenhuma movimentação registrada.</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm text-left text-zinc-500">
                <thead className="text-xs uppercase bg-zinc-50 border-b border-zinc-100 text-zinc-700 font-semibold font-outfit">
                  <tr>
                    <th className="px-6 py-4">Data</th>
                    <th className="px-6 py-4">Estabelecimento</th>
                    <th className="px-6 py-4">Operação</th>
                    <th className="px-6 py-4">Produto</th>
                    <th className="px-6 py-4 text-center">Quantidade</th>
                    <th className="px-6 py-4">Detalhes</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-100">
                  {movements.map(m => (
                    <tr key={m.id} className="hover:bg-zinc-50/50">
                      <td className="px-6 py-4">
                        <span className="text-zinc-600 flex items-center gap-1.5">
                          <Calendar className="w-3.5 h-3.5 text-zinc-400" />
                          {new Date(m.created_at).toLocaleDateString("pt-BR")}
                        </span>
                      </td>
                      <td className="px-6 py-4 font-semibold text-zinc-900">{m.partner?.name}</td>
                      <td className="px-6 py-4">
                        <Badge
                          className={`text-[10px] font-bold uppercase ${
                            m.type === "dispatch" ? "bg-blue-100 text-blue-800" :
                            m.type === "sale" ? "bg-emerald-100 text-emerald-800" :
                            m.type === "return" ? "bg-amber-100 text-amber-800" : "bg-rose-100 text-rose-800"
                          }`}
                        >
                          {m.type === "dispatch" ? "Envio para Parceiro" :
                           m.type === "sale" ? "Venda Registrada" :
                           m.type === "return" ? "Retorno ao Estoque" : "Perda / Avaria"}
                        </Badge>
                      </td>
                      <td className="px-6 py-4 font-medium text-zinc-900">{m.itemable?.name}</td>
                      <td className="px-6 py-4 text-center font-bold text-zinc-900">{m.quantity} un</td>
                      <td className="px-6 py-4 text-zinc-400 text-xs max-w-xs truncate">{m.notes || "-"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {/* ── MODAL CADASTRO / EDIÇÃO PARCEIRO ── */}
      {isPartnerModalOpen && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="bg-white rounded-xl border border-zinc-200 shadow-xl max-w-md w-full overflow-hidden"
          >
            <div className="p-5 border-b border-zinc-100 flex items-center justify-between">
              <h3 className="font-bold text-zinc-900 font-outfit text-base">
                {editingPartnerId ? "Editar Parceiro" : "Novo Estabelecimento Parceiro"}
              </h3>
              <button onClick={closePartnerModal} className="text-zinc-400 hover:text-zinc-600 text-sm">Fechar</button>
            </div>
            <form onSubmit={handlePartnerSubmit} className="p-5 space-y-4">
              <div className="space-y-1.5">
                <Label className="text-xs">Nome do Estabelecimento *</Label>
                <Input
                  required
                  placeholder="Ex: Academia FitLife, Espaço Zen..."
                  value={partnerName}
                  onChange={e => setPartnerName(e.target.value)}
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div className="space-y-1.5">
                  <Label className="text-xs">Responsável / Contato</Label>
                  <Input
                    placeholder="Nome do contato"
                    value={partnerContact}
                    onChange={e => setPartnerContact(e.target.value)}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs">Telefone / WhatsApp</Label>
                  <Input
                    placeholder="(00) 00000-0000"
                    value={partnerPhone}
                    onChange={e => setPartnerPhone(e.target.value)}
                  />
                </div>
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs">Endereço do Local</Label>
                <Input
                  placeholder="Ex: Av. Principal 123, Bairro..."
                  value={partnerAddress}
                  onChange={e => setPartnerAddress(e.target.value)}
                />
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs">Comissão do Estabelecimento (%)</Label>
                <Input
                  type="number"
                  min="0"
                  max="100"
                  step="0.1"
                  placeholder="Ex: 10"
                  value={partnerCommission}
                  onChange={e => setPartnerCommission(e.target.value)}
                />
                <span className="text-[10px] text-zinc-400 block">Percentual que o parceiro ganha sobre cada venda realizada lá.</span>
              </div>

              <div className="flex gap-3 pt-2">
                <Button type="button" variant="outline" className="flex-1" onClick={closePartnerModal}>
                  Cancelar
                </Button>
                <Button type="submit" className="flex-1 bg-primary hover:bg-primary/90 text-white font-bold">
                  {editingPartnerId ? "Atualizar" : "Cadastrar Estabelecimento"}
                </Button>
              </div>
            </form>
          </motion.div>
        </div>
      )}

      {/* ── MODAL OPERAÇÕES DE ESTOQUE (ENVIAR/VENDER/DEVOLVER/PERDA) ── */}
      {actionType && actionType !== "audit" && selectedPartner && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="bg-white rounded-xl border border-zinc-200 shadow-xl max-w-md w-full overflow-hidden"
          >
            <div className="p-5 border-b border-zinc-100 flex items-center justify-between">
              <h3 className="font-bold text-zinc-900 font-outfit text-base">
                {actionType === "dispatch" ? "Enviar Mercadoria" :
                 actionType === "sale" ? "Registrar Venda de Comodato" :
                 actionType === "return" ? "Registrar Devolução" : "Registrar Avaria / Perda"}
              </h3>
              <button onClick={() => setActionType(null)} className="text-zinc-400 hover:text-zinc-600 text-sm">Fechar</button>
            </div>
            <form onSubmit={handleActionSubmit} className="p-5 space-y-4">
              <div className="bg-zinc-50 border border-zinc-200 rounded-lg p-3 text-xs space-y-0.5">
                <span className="text-zinc-400">Local:</span> <span className="font-bold text-zinc-800">{selectedPartner.name}</span>
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs">Selecione o Produto/Kit</Label>
                {actionType === "dispatch" ? (
                  // Listar catálogo completo para envio
                  <select
                    value={selectedProduct}
                    onChange={e => setSelectedProduct(e.target.value)}
                    className="w-full h-9 border border-zinc-200 rounded-md bg-white px-2.5 text-sm focus:outline-none"
                  >
                    {catalog.map(c => (
                      <option key={`${c.id}-${c.type}`} value={`${c.id}-${c.type}`}>{c.name} (R$ {c.price.toFixed(2)})</option>
                    ))}
                  </select>
                ) : (
                  // Listar apenas produtos atualmente sob custódia
                  <select
                    value={selectedProduct}
                    onChange={e => setSelectedProduct(e.target.value)}
                    className="w-full h-9 border border-zinc-200 rounded-md bg-white px-2.5 text-sm focus:outline-none"
                  >
                    {(selectedPartner.stocks ?? []).filter(s => s.quantity > 0).map(s => {
                      const modelType = s.itemable_type.split("\\").pop()?.toLowerCase();
                      return (
                        <option key={`${s.itemable_id}-${modelType}`} value={`${s.itemable_id}-${modelType}`}>
                          {s.itemable?.name} (Disponível: {s.quantity} un)
                        </option>
                      );
                    })}
                  </select>
                )}
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div className="space-y-1.5">
                  <Label className="text-xs">Quantidade</Label>
                  <Input
                    type="number"
                    min="1"
                    required
                    value={actionQuantity}
                    onChange={e => setActionQuantity(e.target.value)}
                  />
                </div>
                {actionType === "sale" && (
                  <div className="space-y-1.5">
                    <Label className="text-xs">Forma de Recebimento</Label>
                    <select
                      value={paymentMethod}
                      onChange={e => setPaymentMethod(e.target.value)}
                      className="w-full h-9 border border-zinc-200 rounded-md bg-white px-2 text-sm focus:outline-none"
                    >
                      <option value="pix">PIX</option>
                      <option value="cash">Dinheiro</option>
                    </select>
                  </div>
                )}
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs">Observações / Motivo</Label>
                <Input
                  placeholder="Opcional..."
                  value={actionNotes}
                  onChange={e => setActionNotes(e.target.value)}
                />
              </div>

              <div className="flex gap-3 pt-2">
                <Button type="button" variant="outline" className="flex-1" onClick={() => setActionType(null)}>
                  Cancelar
                </Button>
                <Button type="submit" className="flex-1 bg-primary hover:bg-primary/90 text-white font-bold">
                  {actionType === "dispatch" ? "Confirmar Envio" :
                   actionType === "sale" ? "Registrar Venda" :
                   actionType === "return" ? "Confirmar Devolução" : "Registrar Perda"}
                </Button>
              </div>
            </form>
          </motion.div>
        </div>
      )}

      {/* ── MODAL AUDITORIA (CONTAGEM DE ESTOQUE FISICO) ── */}
      {actionType === "audit" && selectedPartner && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="bg-white rounded-xl border border-zinc-200 shadow-xl max-w-lg w-full overflow-hidden"
          >
            <div className="p-5 border-b border-zinc-100 flex items-center justify-between">
              <h3 className="font-bold text-zinc-900 font-outfit text-base">
                Realizar Auditoria de Estoque
              </h3>
              <button onClick={() => setActionType(null)} className="text-zinc-400 hover:text-zinc-600 text-sm">Fechar</button>
            </div>
            <form onSubmit={handleAuditSubmit} className="p-5 space-y-4">
              <div className="bg-zinc-50 border border-zinc-200 rounded-lg p-3 text-xs space-y-1">
                <p><span className="text-zinc-400">Local:</span> <span className="font-bold text-zinc-800">{selectedPartner.name}</span></p>
                <p className="text-zinc-400 text-[10px]">Instrução: Insira a quantidade física de produtos que você está vendo no local. O sistema ajustará eventuais perdas automaticamente.</p>
              </div>

              <div className="space-y-2.5 max-h-60 overflow-y-auto pr-1">
                {(selectedPartner.stocks ?? []).map(stock => {
                  const modelType = stock.itemable_type.split("\\").pop()?.toLowerCase() || "product";
                  const key = `${stock.itemable_id}-${modelType}`;
                  return (
                    <div key={stock.id} className="flex items-center justify-between bg-zinc-50 p-2.5 rounded-lg border border-zinc-200 text-sm">
                      <div>
                        <span className="font-semibold text-zinc-800 block">{stock.itemable?.name}</span>
                        <span className="text-[10px] text-zinc-400">Esperado em sistema: <strong className="text-zinc-600">{stock.quantity} un</strong></span>
                      </div>
                      <div className="flex items-center gap-3">
                        <Label className="text-xs text-zinc-600">Contagem Física:</Label>
                        <Input
                          type="number"
                          min="0"
                          value={auditCounts[key] !== undefined ? auditCounts[key] : ""}
                          onChange={e => setAuditCounts(prev => ({ ...prev, [key]: parseInt(e.target.value) || 0 }))}
                          className="w-16 h-8 text-center"
                        />
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs">Notas da Auditoria</Label>
                <Input
                  placeholder="Ex: Feito contagem mensal..."
                  value={actionNotes}
                  onChange={e => setActionNotes(e.target.value)}
                />
              </div>

              <div className="flex gap-3 pt-2">
                <Button type="button" variant="outline" className="flex-1" onClick={() => setActionType(null)}>
                  Cancelar
                </Button>
                <Button type="submit" className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-bold">
                  Salvar e Reconciliar
                </Button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </div>
  );
}
