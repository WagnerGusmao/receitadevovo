"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import {
  Search, CheckCircle2, AlertCircle, Clock, Banknote, QrCode,
  Calendar, ArrowLeft, RefreshCw, Filter, MessageSquare, DollarSign
} from "lucide-react";
import Link from "next/link";
import { motion } from "framer-motion";

type Installment = {
  id: number;
  order_id: number;
  installment_number: number;
  amount: number;
  due_date: string;
  status: "pending" | "paid" | "overdue";
  payment_method: "pix" | "cash" | null;
  paid_at: string | null;
  notes: string | null;
  order: {
    id: number;
    order_number: string;
    customer_name: string;
    customer_phone: string | null;
    user?: {
      name: string;
      whatsapp: string | null;
    };
  };
};

export default function FinanceiroParcelasPage() {
  const [installments, setInstallments] = useState<Installment[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("all");
  
  // Modal de Baixa
  const [payingInstallment, setPayingInstallment] = useState<Installment | null>(null);
  const [payMethod, setPayMethod] = useState<"pix" | "cash">("pix");
  const [payNotes, setPayNotes] = useState("");
  const [paying, setPaying] = useState(false);

  useEffect(() => {
    loadInstallments();
  }, []);

  async function loadInstallments() {
    setLoading(true);
    try {
      const res = await apiFetch("/ecommerce/installments");
      // Mapear status dinâmico para atrasados
      const today = new Date().toISOString().split("T")[0];
      const items = (res.data ?? []).map((inst: Installment) => {
        let status = inst.status;
        if (status === "pending" && inst.due_date < today) {
          status = "overdue";
        }
        return { ...inst, status, amount: parseFloat(inst.amount as any) };
      });
      setInstallments(items);
    } catch {
      toast.error("Erro ao carregar parcelas.");
    } finally {
      setLoading(false);
    }
  }

  // Filtragem
  const filtered = installments.filter(inst => {
    const customer = inst.order.customer_name?.toLowerCase() || inst.order.user?.name?.toLowerCase() || "";
    const orderNo = inst.order.order_number.toLowerCase();
    const searchMatch = customer.includes(search.toLowerCase()) || orderNo.includes(search.toLowerCase());
    
    if (statusFilter === "all") return searchMatch;
    return searchMatch && inst.status === statusFilter;
  });

  // Totais
  const totalOverdue = installments
    .filter(i => i.status === "overdue")
    .reduce((sum, i) => sum + i.amount, 0);

  const totalPending = installments
    .filter(i => i.status === "pending")
    .reduce((sum, i) => sum + i.amount, 0);

  const totalPaid = installments
    .filter(i => i.status === "paid")
    .reduce((sum, i) => sum + i.amount, 0);

  // Executar a baixa (pagamento)
  async function handlePay(e: React.FormEvent) {
    e.preventDefault();
    if (!payingInstallment) return;
    setPaying(true);
    try {
      await apiFetch(`/ecommerce/orders/${payingInstallment.order_id}/installments/${payingInstallment.id}/pay`, {
        method: "PATCH",
        body: JSON.stringify({
          payment_method: payMethod,
          notes: payNotes || undefined,
        }),
      });
      toast.success("Pagamento registrado com sucesso! 🎉");
      setPayingInstallment(null);
      setPayNotes("");
      loadInstallments();
    } catch (err: any) {
      toast.error(err.message || "Erro ao registrar pagamento.");
    } finally {
      setPaying(false);
    }
  }

  // Copiar mensagem para WhatsApp
  function handleWhatsappReminder(inst: Installment) {
    const phone = inst.order.customer_phone || inst.order.user?.whatsapp;
    if (!phone) {
      toast.error("Este cliente não possui telefone cadastrado.");
      return;
    }
    const cleanPhone = phone.replace(/\D/g, "");
    const name = inst.order.customer_name || inst.order.user?.name || "Cliente";
    
    const message = `Olá, ${name}! Tudo bem? Passando para lembrar da parcela nº ${inst.installment_number} da sua compra na Receita de Vovó. \n\n*Valor:* R$ ${inst.amount.toFixed(2)}\n*Vencimento:* ${new Date(inst.due_date).toLocaleDateString("pt-BR")}\n\nVocê pode efetuar o pagamento via Pix ou Dinheiro. Se precisar da chave Pix, é só me pedir! Agradecemos a preferência! 🌿🌸`;
    
    const url = `https://api.whatsapp.com/send?phone=55${cleanPhone}&text=${encodeURIComponent(message)}`;
    window.open(url, "_blank");
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link href="/admin/financeiro">
            <Button variant="ghost" size="icon" className="rounded-full">
              <ArrowLeft className="w-5 h-5 text-zinc-500" />
            </Button>
          </Link>
          <div>
            <h1 className="text-2xl font-bold font-outfit text-zinc-900">Controle de Recebíveis (Parcelas)</h1>
            <p className="text-sm text-zinc-500">Monitore e dê baixa nas parcelas de vendas presenciais ou digitais.</p>
          </div>
        </div>
        <Button variant="outline" onClick={loadInstallments} className="gap-2">
          <RefreshCw className="w-4 h-4" /> Atualizar
        </Button>
      </div>

      {/* ── CARD INDICADORES ── */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="border-rose-100 bg-rose-50/20">
          <CardHeader className="pb-2">
            <CardTitle className="text-xs font-bold text-rose-500 uppercase tracking-wider flex items-center gap-1.5">
              <AlertCircle className="w-4 h-4" /> Em Atraso
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-2xl font-bold font-outfit text-rose-600">R$ {totalOverdue.toFixed(2)}</p>
            <p className="text-[10px] text-zinc-400 mt-1">Cobrança pendente dos clientes</p>
          </CardContent>
        </Card>

        <Card className="border-amber-100 bg-amber-50/20">
          <CardHeader className="pb-2">
            <CardTitle className="text-xs font-bold text-amber-500 uppercase tracking-wider flex items-center gap-1.5">
              <Clock className="w-4 h-4" /> A Receber (Pendente)
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-2xl font-bold font-outfit text-amber-600">R$ {totalPending.toFixed(2)}</p>
            <p className="text-[10px] text-zinc-400 mt-1">Valores dentro do prazo</p>
          </CardContent>
        </Card>

        <Card className="border-emerald-100 bg-emerald-50/20">
          <CardHeader className="pb-2">
            <CardTitle className="text-xs font-bold text-emerald-500 uppercase tracking-wider flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4" /> Total Recebido
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-2xl font-bold font-outfit text-emerald-600">R$ {totalPaid.toFixed(2)}</p>
            <p className="text-[10px] text-zinc-400 mt-1">Valores quitados e baixados</p>
          </CardContent>
        </Card>
      </div>

      {/* ── FILTROS ── */}
      <div className="bg-white rounded-xl border border-zinc-200 p-4 shadow-sm flex flex-col md:flex-row gap-4 items-center justify-between">
        <div className="relative w-full md:w-80">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
          <Input
            placeholder="Buscar por cliente ou pedido..."
            className="pl-9 text-sm"
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        <div className="flex gap-2 w-full md:w-auto">
          <Button
            variant={statusFilter === "all" ? "default" : "outline"}
            size="sm"
            onClick={() => setStatusFilter("all")}
          >
            Todas
          </Button>
          <Button
            variant={statusFilter === "overdue" ? "destructive" : "outline"}
            size="sm"
            onClick={() => setStatusFilter("overdue")}
            className="gap-1"
          >
            <span className="w-2 h-2 rounded-full bg-rose-500 animate-ping"></span>
            Atrasadas
          </Button>
          <Button
            variant={statusFilter === "pending" ? "default" : "outline"}
            size="sm"
            onClick={() => setStatusFilter("pending")}
            className="text-amber-600 border-amber-200 hover:bg-amber-50"
          >
            Pendentes
          </Button>
          <Button
            variant={statusFilter === "paid" ? "default" : "outline"}
            size="sm"
            onClick={() => setStatusFilter("paid")}
            className="text-emerald-600 border-emerald-200 hover:bg-emerald-50"
          >
            Pagas
          </Button>
        </div>
      </div>

      {/* ── TABELA ── */}
      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        {loading ? (
          <p className="text-center py-12 text-zinc-400 animate-pulse text-sm">Carregando parcelas...</p>
        ) : filtered.length === 0 ? (
          <p className="text-center py-12 text-zinc-400 text-sm">Nenhuma parcela encontrada.</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm text-left text-zinc-500">
              <thead className="text-xs uppercase bg-zinc-50 border-b border-zinc-100 text-zinc-700 font-semibold font-outfit">
                <tr>
                  <th className="px-6 py-4">Pedido / Parcela</th>
                  <th className="px-6 py-4">Cliente</th>
                  <th className="px-6 py-4 text-right">Valor</th>
                  <th className="px-6 py-4">Vencimento</th>
                  <th className="px-6 py-4">Status</th>
                  <th className="px-6 py-4">Pagamento</th>
                  <th className="px-6 py-4 text-center">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-zinc-100">
                {filtered.map(inst => (
                  <tr key={inst.id} className="hover:bg-zinc-50/50">
                    <td className="px-6 py-4">
                      <span className="font-mono font-bold text-zinc-900">{inst.order.order_number}</span>
                      <span className="text-xs text-zinc-400 block">nº {inst.installment_number}</span>
                    </td>
                    <td className="px-6 py-4 font-medium text-zinc-900">
                      {inst.order.customer_name || inst.order.user?.name || "Cliente Avulso"}
                      {(inst.order.customer_phone || inst.order.user?.whatsapp) && (
                        <span className="text-xs text-zinc-400 block font-normal">{inst.order.customer_phone || inst.order.user?.whatsapp}</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-right font-bold text-zinc-900">
                      R$ {inst.amount.toFixed(2)}
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-1.5">
                        <Calendar className="w-3.5 h-3.5 text-zinc-400" />
                        <span>{new Date(inst.due_date).toLocaleDateString("pt-BR")}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      {inst.status === "paid" && (
                        <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-100/80 border-none">Pago</Badge>
                      )}
                      {inst.status === "pending" && (
                        <Badge className="bg-amber-100 text-amber-700 hover:bg-amber-100/80 border-none">No prazo</Badge>
                      )}
                      {inst.status === "overdue" && (
                        <Badge className="bg-rose-100 text-rose-700 hover:bg-rose-100/80 border-none">Atrasado</Badge>
                      )}
                    </td>
                    <td className="px-6 py-4">
                      {inst.status === "paid" ? (
                        <div className="text-xs">
                          <span className="font-medium text-zinc-800 flex items-center gap-1">
                            {inst.payment_method === "pix" ? <QrCode className="w-3.5 h-3.5 text-blue-500" /> : <Banknote className="w-3.5 h-3.5 text-emerald-500" />}
                            {inst.payment_method === "pix" ? "PIX" : "Dinheiro"}
                          </span>
                          {inst.paid_at && (
                            <span className="text-[10px] text-zinc-400 block">{new Date(inst.paid_at).toLocaleDateString("pt-BR")}</span>
                          )}
                        </div>
                      ) : (
                        <span className="text-xs text-zinc-400">Pendente</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-center">
                      <div className="flex justify-center items-center gap-2">
                        {inst.status !== "paid" ? (
                          <>
                            <Button
                              size="sm"
                              className="bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-xs h-8"
                              onClick={() => setPayingInstallment(inst)}
                            >
                              Dar Baixa
                            </Button>
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => handleWhatsappReminder(inst)}
                              title="Enviar lembrete de cobrança"
                              className="h-8 w-8 p-0"
                            >
                              <MessageSquare className="w-4 h-4 text-emerald-600" />
                            </Button>
                          </>
                        ) : (
                          <span className="text-xs text-emerald-600 font-medium flex items-center gap-1 justify-center">
                            <CheckCircle2 className="w-3.5 h-3.5" /> Quitado
                          </span>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* ── MODAL DAR BAIXA ── */}
      {payingInstallment && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="bg-white rounded-xl border border-zinc-200 shadow-xl max-w-md w-full overflow-hidden"
          >
            <div className="p-5 border-b border-zinc-100 flex items-center justify-between">
              <h3 className="font-bold text-zinc-900 font-outfit text-base">Registrar Recebimento</h3>
              <button onClick={() => setPayingInstallment(null)} className="text-zinc-400 hover:text-zinc-600 text-sm">Fechar</button>
            </div>
            <form onSubmit={handlePay} className="p-5 space-y-4">
              <div className="bg-zinc-50 border border-zinc-200 rounded-lg p-3 space-y-1">
                <p className="text-xs text-zinc-400">Cliente / Pedido</p>
                <p className="text-sm font-bold text-zinc-800">
                  {payingInstallment.order.customer_name || payingInstallment.order.user?.name || "Cliente Avulso"}
                </p>
                <p className="text-xs text-zinc-500">
                  Pedido: {payingInstallment.order.order_number} · Parcela {payingInstallment.installment_number}
                </p>
                <div className="flex justify-between items-center pt-2 mt-2 border-t border-zinc-200/50">
                  <span className="text-xs text-zinc-600 font-medium">Valor da Parcela:</span>
                  <span className="text-base font-extrabold text-primary">R$ {payingInstallment.amount.toFixed(2)}</span>
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-xs font-semibold text-zinc-700 flex items-center gap-1">
                  <DollarSign className="w-3.5 h-3.5 text-zinc-400" /> Método de Recebimento
                </label>
                <div className="grid grid-cols-2 gap-2">
                  <button
                    type="button"
                    onClick={() => setPayMethod("pix")}
                    className={`flex items-center justify-center gap-1.5 py-2.5 rounded-lg border text-sm font-medium transition-colors ${
                      payMethod === "pix"
                        ? "border-primary bg-primary/10 text-primary"
                        : "border-zinc-200 text-zinc-500 hover:border-zinc-300"
                    }`}
                  >
                    <QrCode className="w-4 h-4" /> PIX
                  </button>
                  <button
                    type="button"
                    onClick={() => setPayMethod("cash")}
                    className={`flex items-center justify-center gap-1.5 py-2.5 rounded-lg border text-sm font-medium transition-colors ${
                      payMethod === "cash"
                        ? "border-primary bg-primary/10 text-primary"
                        : "border-zinc-200 text-zinc-500 hover:border-zinc-300"
                    }`}
                  >
                    <Banknote className="w-4 h-4" /> Dinheiro
                  </button>
                </div>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-zinc-700">Observações adicionais</label>
                <Input
                  placeholder="Ex: Recebido no balcão, comprovante arquivado..."
                  value={payNotes}
                  onChange={e => setPayNotes(e.target.value)}
                  className="text-sm"
                />
              </div>

              <div className="flex gap-3 pt-2">
                <Button type="button" variant="outline" className="flex-1" onClick={() => setPayingInstallment(null)}>
                  Cancelar
                </Button>
                <Button type="submit" className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-bold" disabled={paying}>
                  {paying ? "Confirmando..." : "Confirmar Recebimento"}
                </Button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </div>
  );
}
