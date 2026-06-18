"use client";

import { useEffect, useRef, useState } from "react";
import { apiFetch } from "@/services/api";
import { motion, AnimatePresence } from "framer-motion";
import {
  Package,
  CheckCircle2,
  Circle,
  Truck,
  Printer,
  Clock,
  AlertTriangle,
  ChevronRight,
  X,
  PackageCheck,
  Scale,
  Ruler,
  Tag,
  ArrowRight,
  RefreshCw,
  User,
  MapPin,
  Phone,
  ShoppingBag,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import ShippingLabel from "@/modules/ecommerce/components/ShippingLabel";

type Stage = "list" | "separation" | "packaging" | "label";

interface CheckedItems {
  [key: number]: boolean;
}

export default function FulfillmentPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [stage, setStage] = useState<Stage>("list");
  const [activeOrder, setActiveOrder] = useState<any>(null);
  const [checkedItems, setCheckedItems] = useState<CheckedItems>({});
  const [weightKg, setWeightKg] = useState("");
  const [boxDimensions, setBoxDimensions] = useState("");
  const [freightValue, setFreightValue] = useState("");
  const [trackingCode, setTrackingCode] = useState("");
  const [shipping, setShipping] = useState(false);
  const labelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    loadPending();
  }, []);

  async function loadPending() {
    setLoading(true);
    try {
      const res = await apiFetch("/ecommerce/orders/pending-fulfillment");
      setOrders(res.data);
    } catch {
      toast.error("Erro ao carregar pedidos pendentes.");
    } finally {
      setLoading(false);
    }
  }

  function startFulfillment(order: any) {
    setActiveOrder(order);
    setCheckedItems({});
    setWeightKg(order.weight_kg ? String(order.weight_kg) : "");
    setBoxDimensions(order.box_dimensions || "");
    setFreightValue(order.freight_value !== null && order.freight_value !== undefined ? String(order.freight_value) : "");
    setTrackingCode(order.tracking_code || "");
    setStage("separation");
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  function closeWorkflow() {
    setStage("list");
    setActiveOrder(null);
  }

  const allChecked =
    activeOrder?.items?.length > 0 &&
    activeOrder.items.every((_: any, i: number) => checkedItems[i]);

  function toggleItem(index: number) {
    setCheckedItems((prev) => ({ ...prev, [index]: !prev[index] }));
  }

  async function markAsShipped() {
    if (!activeOrder) return;
    setShipping(true);
    try {
      await apiFetch(`/ecommerce/orders/${activeOrder.id}/ship`, {
        method: "PATCH",
        body: JSON.stringify({
          tracking_code: trackingCode || null,
          weight_kg: weightKg ? parseFloat(weightKg) : null,
          box_dimensions: boxDimensions || null,
          freight_value: freightValue ? parseFloat(freightValue) : null,
        }),
      });
      toast.success(`Pedido ${activeOrder.order_number} marcado como Enviado! 🚀`);
      closeWorkflow();
      loadPending();
    } catch (err: any) {
      toast.error(err.message || "Erro ao marcar pedido como enviado.");
    } finally {
      setShipping(false);
    }
  }

  function printLabel() {
    const printContent = labelRef.current?.innerHTML;
    if (!printContent) return;
    const win = window.open("", "_blank", "width=500,height=800");
    if (!win) return;
    win.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Etiqueta - ${activeOrder?.order_number}</title>
          <style>
            body { margin: 0; padding: 0.5cm; font-family: Arial, sans-serif; }
            @page { size: 10cm 15cm; margin: 0; }
            @media print { body { margin: 0; padding: 0.3cm; } }
          </style>
        </head>
        <body>${printContent}</body>
      </html>
    `);
    win.document.close();
    win.focus();
    setTimeout(() => { win.print(); win.close(); }, 300);
  }

  // ── Urgency color ──
  function urgencyColor(hours: number) {
    if (hours > 48) return "text-red-600 bg-red-50 border-red-200";
    if (hours > 24) return "text-amber-600 bg-amber-50 border-amber-200";
    return "text-emerald-600 bg-emerald-50 border-emerald-200";
  }

  // ── Stage indicator ──
  const stages = [
    { key: "separation", label: "Separação", icon: Package },
    { key: "packaging", label: "Embalagem", icon: Scale },
    { key: "label", label: "Etiqueta", icon: Printer },
  ];

  return (
    <div className="space-y-6">
      {/* ── Header ── */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900 flex items-center gap-2">
            <PackageCheck className="w-6 h-6 text-primary" />
            Separação e Envio de Pedidos
          </h1>
          <p className="text-sm text-zinc-500 mt-0.5">
            Separe, embale e gere a etiqueta para envio.
          </p>
        </div>
        {stage === "list" && (
          <Button
            variant="outline"
            size="sm"
            onClick={loadPending}
            className="gap-2 text-zinc-500"
          >
            <RefreshCw className="w-4 h-4" />
            Atualizar
          </Button>
        )}
      </div>

      {/* ── WORKFLOW ATIVO ── */}
      <AnimatePresence mode="wait">
        {stage !== "list" && activeOrder && (
          <motion.div
            key="workflow"
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -24 }}
            transition={{ duration: 0.3 }}
            className="space-y-6"
          >
            {/* Pipeline visual */}
            <div className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6">
              <div className="flex items-center justify-between mb-6">
                <div>
                  <p className="text-xs text-zinc-400 uppercase tracking-wider font-semibold">Processando</p>
                  <p className="text-lg font-bold font-outfit text-zinc-900">
                    {activeOrder.order_number}
                  </p>
                </div>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={closeWorkflow}
                  className="text-zinc-400 hover:text-zinc-700"
                >
                  <X className="w-5 h-5" />
                </Button>
              </div>

              {/* Stage tabs */}
              <div className="flex items-center gap-0">
                {stages.map((s, i) => {
                  const isActive = stage === s.key;
                  const isDone =
                    (s.key === "separation" && (stage === "packaging" || stage === "label")) ||
                    (s.key === "packaging" && stage === "label");
                  return (
                    <div key={s.key} className="flex items-center flex-1">
                      <button
                        onClick={() => {
                          if (isDone || isActive) setStage(s.key as Stage);
                        }}
                        className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-medium transition-all w-full justify-center ${
                          isActive
                            ? "bg-primary text-white shadow-sm"
                            : isDone
                            ? "text-emerald-600 bg-emerald-50 cursor-pointer hover:bg-emerald-100"
                            : "text-zinc-400 bg-zinc-50 cursor-not-allowed"
                        }`}
                      >
                        {isDone ? (
                          <CheckCircle2 className="w-4 h-4" />
                        ) : (
                          <s.icon className="w-4 h-4" />
                        )}
                        {s.label}
                      </button>
                      {i < stages.length - 1 && (
                        <ChevronRight className="w-4 h-4 text-zinc-300 mx-1 flex-shrink-0" />
                      )}
                    </div>
                  );
                })}
              </div>
            </div>

            {/* ── Stage: Separação ── */}
            {stage === "separation" && (
              <motion.div
                key="sep"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                className="grid grid-cols-1 lg:grid-cols-2 gap-6"
              >
                {/* Checklist */}
                <div className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6 space-y-4">
                  <div>
                    <h2 className="text-base font-bold text-zinc-900 flex items-center gap-2">
                      <Package className="w-4 h-4 text-primary" />
                      Lista de Separação
                    </h2>
                    <p className="text-xs text-zinc-400 mt-0.5">
                      Marque cada item conforme for separando.
                    </p>
                  </div>
                  <div className="space-y-3">
                    {activeOrder.items?.map((item: any, i: number) => (
                      <button
                        key={i}
                        onClick={() => toggleItem(i)}
                        className={`w-full flex items-center gap-4 p-4 rounded-xl border-2 transition-all text-left ${
                          checkedItems[i]
                            ? "border-emerald-400 bg-emerald-50"
                            : "border-zinc-200 bg-white hover:border-primary/40"
                        }`}
                      >
                        {checkedItems[i] ? (
                          <CheckCircle2 className="w-6 h-6 text-emerald-500 flex-shrink-0" />
                        ) : (
                          <Circle className="w-6 h-6 text-zinc-300 flex-shrink-0" />
                        )}
                        <div className="flex-1 min-w-0">
                          <p className={`font-semibold text-sm ${checkedItems[i] ? "line-through text-zinc-400" : "text-zinc-900"}`}>
                            {item.itemable?.name}
                          </p>
                          <p className="text-xs text-zinc-400">
                            {item.quantity} unidade{item.quantity > 1 ? "s" : ""} ×{" "}
                            R$ {parseFloat(item.price).toFixed(2)}
                          </p>
                        </div>
                        <div className="text-right flex-shrink-0">
                          <p className="font-bold text-sm text-zinc-900">
                            R$ {(item.quantity * item.price).toFixed(2)}
                          </p>
                        </div>
                      </button>
                    ))}
                  </div>

                  <div className="flex items-center justify-between pt-3 border-t border-zinc-100">
                    <p className="text-sm text-zinc-500">
                      {Object.values(checkedItems).filter(Boolean).length}/
                      {activeOrder.items?.length} itens separados
                    </p>
                    <Button
                      disabled={!allChecked}
                      onClick={() => setStage("packaging")}
                      className="gap-2"
                    >
                      Ir para Embalagem
                      <ArrowRight className="w-4 h-4" />
                    </Button>
                  </div>
                </div>

                {/* Info do pedido */}
                <div className="space-y-4">
                  <div className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6 space-y-4">
                    <h2 className="text-base font-bold text-zinc-900">Dados do Cliente</h2>
                    <div className="space-y-3">
                      <div className="flex items-start gap-3">
                        <User className="w-4 h-4 text-zinc-400 mt-0.5" />
                        <div>
                          <p className="text-xs text-zinc-400">Nome</p>
                          <p className="font-semibold text-sm text-zinc-900">
                            {activeOrder.user?.name || activeOrder.customer_name || "—"}
                          </p>
                        </div>
                      </div>
                      {(activeOrder.user?.email) && (
                        <div className="flex items-start gap-3">
                          <ShoppingBag className="w-4 h-4 text-zinc-400 mt-0.5" />
                          <div>
                            <p className="text-xs text-zinc-400">E-mail</p>
                            <p className="text-sm text-zinc-700">{activeOrder.user.email}</p>
                          </div>
                        </div>
                      )}
                      {activeOrder.customer_phone && (
                        <div className="flex items-start gap-3">
                          <Phone className="w-4 h-4 text-zinc-400 mt-0.5" />
                          <div>
                            <p className="text-xs text-zinc-400">Telefone</p>
                            <p className="text-sm text-zinc-700">{activeOrder.customer_phone}</p>
                          </div>
                        </div>
                      )}
                      <div className="flex items-start gap-3">
                        <MapPin className="w-4 h-4 text-zinc-400 mt-0.5" />
                        <div>
                          <p className="text-xs text-zinc-400">Endereço de Entrega</p>
                          <p className="text-sm text-zinc-700 whitespace-pre-wrap">
                            {activeOrder.shipping_address || "Não informado"}
                          </p>
                        </div>
                      </div>
                      {activeOrder.shipping_method && (
                        <div className="flex items-start gap-3">
                          <Truck className="w-4 h-4 text-zinc-400 mt-0.5" />
                          <div>
                            <p className="text-xs text-zinc-400">Forma de Envio Escolhida</p>
                            <p className="text-sm font-bold text-zinc-900">
                              {activeOrder.shipping_method}
                            </p>
                          </div>
                        </div>
                      )}
                      {activeOrder.freight_value !== null && activeOrder.freight_value !== undefined && (
                        <div className="flex items-start gap-3">
                          <Tag className="w-4 h-4 text-zinc-400 mt-0.5" />
                          <div>
                            <p className="text-xs text-zinc-400">Valor Pago Pelo Cliente</p>
                            <p className="text-sm font-bold text-emerald-600">
                              R$ {parseFloat(activeOrder.freight_value).toFixed(2)}
                            </p>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5">
                    <div className="flex items-center gap-2 mb-2">
                      <Clock className="w-4 h-4 text-amber-600" />
                      <span className="font-semibold text-amber-800 text-sm">Aguardando</span>
                    </div>
                    <p className="text-2xl font-bold text-amber-700">{activeOrder.waiting_label}</p>
                    <p className="text-xs text-amber-600 mt-1">
                      Pedido criado em {new Date(activeOrder.created_at).toLocaleString("pt-BR")}
                    </p>
                  </div>
                </div>
              </motion.div>
            )}

            {/* ── Stage: Embalagem ── */}
            {stage === "packaging" && (
              <motion.div
                key="pack"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6"
              >
                <div className="mb-6">
                  <h2 className="text-base font-bold text-zinc-900 flex items-center gap-2">
                    <Scale className="w-4 h-4 text-primary" />
                    Dados da Embalagem
                  </h2>
                  <p className="text-xs text-zinc-400 mt-0.5">
                    Preencha as informações da caixa para gerar a etiqueta. (opcional)
                  </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl">
                  <div className="space-y-2">
                    <label className="text-sm font-medium text-zinc-700 flex items-center gap-1.5">
                      <Scale className="w-3.5 h-3.5 text-zinc-400" />
                      Peso total (kg)
                    </label>
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      placeholder="ex: 0.5"
                      value={weightKg}
                      onChange={(e) => setWeightKg(e.target.value)}
                      className="border-zinc-200"
                    />
                  </div>

                  <div className="space-y-2">
                    <label className="text-sm font-medium text-zinc-700 flex items-center gap-1.5">
                      <Ruler className="w-3.5 h-3.5 text-zinc-400" />
                      Dimensões (C×L×A em cm)
                    </label>
                    <Input
                      placeholder="ex: 30x20x10"
                      value={boxDimensions}
                      onChange={(e) => setBoxDimensions(e.target.value)}
                      className="border-zinc-200"
                    />
                  </div>

                  <div className="space-y-2">
                    <label className="text-sm font-medium text-zinc-700 flex items-center gap-1.5">
                      <Tag className="w-3.5 h-3.5 text-zinc-400" />
                      Valor do Frete (R$)
                    </label>
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      placeholder="ex: 18.50"
                      value={freightValue}
                      onChange={(e) => setFreightValue(e.target.value)}
                      className="border-zinc-200"
                    />
                    <p className="text-xs text-zinc-400">
                      * Valor pré-preenchido conforme escolha do cliente no checkout.
                    </p>
                  </div>
                </div>

                <div className="flex justify-between items-center mt-8 pt-6 border-t border-zinc-100">
                  <Button
                    variant="outline"
                    onClick={() => setStage("separation")}
                    className="gap-2"
                  >
                    Voltar
                  </Button>
                  <Button onClick={() => setStage("label")} className="gap-2">
                    Gerar Etiqueta
                    <Printer className="w-4 h-4" />
                  </Button>
                </div>
              </motion.div>
            )}

            {/* ── Stage: Etiqueta ── */}
            {stage === "label" && (
              <motion.div
                key="label"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                className="grid grid-cols-1 xl:grid-cols-2 gap-6"
              >
                {/* Preview */}
                <div className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6">
                  <h2 className="text-base font-bold text-zinc-900 mb-4 flex items-center gap-2">
                    <Printer className="w-4 h-4 text-primary" />
                    Preview da Etiqueta
                  </h2>
                  <div className="flex justify-center">
                    <div style={{ transform: "scale(1.1)", transformOrigin: "top center" }}>
                      <ShippingLabel
                        ref={labelRef}
                        order={activeOrder}
                        freightValue={freightValue ? parseFloat(freightValue) : undefined}
                        trackingCode={trackingCode}
                        weightKg={weightKg ? parseFloat(weightKg) : undefined}
                        boxDimensions={boxDimensions}
                      />
                    </div>
                  </div>
                </div>

                {/* Painel direito */}
                <div className="space-y-4">
                  {/* Código de rastreio */}
                  <div className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-6 space-y-4">
                    <h2 className="text-base font-bold text-zinc-900">Código de Rastreio</h2>
                    <div className="space-y-2">
                      <Input
                        placeholder="ex: BR123456789BR"
                        value={trackingCode}
                        onChange={(e) => setTrackingCode(e.target.value.toUpperCase())}
                        className="font-mono text-lg tracking-widest border-zinc-200"
                      />
                      <p className="text-xs text-zinc-400">
                        Insira o código após postar o pacote. (opcional)
                      </p>
                    </div>
                  </div>

                  {/* Resumo */}
                  <div className="bg-zinc-50 rounded-2xl border border-zinc-200 p-5 space-y-2">
                    <h3 className="text-sm font-semibold text-zinc-700">Resumo do Envio</h3>
                    <div className="space-y-1 text-sm">
                      <div className="flex justify-between text-zinc-600">
                        <span>Pedido</span>
                        <span className="font-medium">{activeOrder.order_number}</span>
                      </div>
                      <div className="flex justify-between text-zinc-600">
                        <span>Destinatário</span>
                        <span className="font-medium">{activeOrder.user?.name || activeOrder.customer_name}</span>
                      </div>
                      {weightKg && (
                        <div className="flex justify-between text-zinc-600">
                          <span>Peso</span>
                          <span className="font-medium">{weightKg} kg</span>
                        </div>
                      )}
                      {boxDimensions && (
                        <div className="flex justify-between text-zinc-600">
                          <span>Dimensões</span>
                          <span className="font-medium">{boxDimensions} cm</span>
                        </div>
                      )}
                      {freightValue && (
                        <div className="flex justify-between text-zinc-600">
                          <span>Frete</span>
                          <span className="font-medium text-emerald-600">R$ {parseFloat(freightValue).toFixed(2)}</span>
                        </div>
                      )}
                      <div className="flex justify-between font-bold text-zinc-900 pt-2 border-t border-zinc-200 mt-2">
                        <span>Total do Pedido</span>
                        <span>R$ {parseFloat(activeOrder.total).toFixed(2)}</span>
                      </div>
                    </div>
                  </div>

                  {/* Ações */}
                  <div className="flex flex-col gap-3">
                    <Button
                      variant="outline"
                      onClick={printLabel}
                      className="gap-2 w-full border-zinc-300"
                    >
                      <Printer className="w-4 h-4" />
                      Imprimir Etiqueta
                    </Button>
                    <Button
                      onClick={markAsShipped}
                      disabled={shipping}
                      className="gap-2 w-full bg-emerald-600 hover:bg-emerald-700 text-white"
                    >
                      {shipping ? (
                        <RefreshCw className="w-4 h-4 animate-spin" />
                      ) : (
                        <Truck className="w-4 h-4" />
                      )}
                      {shipping ? "Processando..." : "Marcar como Enviado"}
                    </Button>
                  </div>

                  <Button
                    variant="ghost"
                    onClick={() => setStage("packaging")}
                    className="w-full text-zinc-400 text-sm"
                  >
                    Voltar para Embalagem
                  </Button>
                </div>
              </motion.div>
            )}
          </motion.div>
        )}

        {/* ── LISTA DE PENDENTES ── */}
        {stage === "list" && (
          <motion.div
            key="list"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="space-y-4"
          >
            {loading ? (
              <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
                {[1, 2, 3].map((i) => (
                  <div
                    key={i}
                    className="h-52 bg-zinc-100 rounded-2xl animate-pulse"
                  />
                ))}
              </div>
            ) : orders.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-24 text-center">
                <div className="w-20 h-20 rounded-full bg-emerald-50 flex items-center justify-center mb-4">
                  <PackageCheck className="w-10 h-10 text-emerald-400" />
                </div>
                <h3 className="text-xl font-bold text-zinc-700 font-outfit">
                  Tudo em dia! 🎉
                </h3>
                <p className="text-sm text-zinc-400 mt-1">
                  Nenhum pedido pendente de separação e envio no momento.
                </p>
              </div>
            ) : (
              <>
                <div className="flex items-center gap-3 mb-2">
                  <div className="flex items-center gap-2 bg-amber-50 border border-amber-200 text-amber-700 rounded-full px-4 py-1.5 text-sm font-semibold">
                    <AlertTriangle className="w-4 h-4" />
                    {orders.length} pedido{orders.length > 1 ? "s" : ""} aguardando envio
                  </div>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
                  {orders.map((order, idx) => (
                    <motion.div
                      key={order.id}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: idx * 0.05 }}
                      className="bg-white rounded-2xl shadow-sm border border-zinc-200 p-5 space-y-4 hover:shadow-md transition-shadow"
                    >
                      {/* Header do card */}
                      <div className="flex items-start justify-between">
                        <div>
                          <p className="font-bold text-zinc-900 font-outfit">{order.order_number}</p>
                          <p className="text-sm text-zinc-500">
                            {order.user?.name || order.customer_name || "Cliente avulso"}
                          </p>
                        </div>
                        <div
                          className={`text-xs font-medium px-2.5 py-1 rounded-full border ${urgencyColor(order.waiting_hours)}`}
                        >
                          <Clock className="w-3 h-3 inline mr-1" />
                          {order.waiting_label}
                        </div>
                      </div>

                      {/* Itens resumidos */}
                      <div className="space-y-1.5">
                        {order.items?.slice(0, 3).map((item: any, i: number) => (
                          <div key={i} className="flex items-center gap-2 text-sm">
                            <Package className="w-3.5 h-3.5 text-zinc-300 flex-shrink-0" />
                            <span className="text-zinc-600 truncate">
                              {item.quantity}× {item.itemable?.name}
                            </span>
                          </div>
                        ))}
                        {order.items?.length > 3 && (
                          <p className="text-xs text-zinc-400 pl-5">
                            +{order.items.length - 3} mais...
                          </p>
                        )}
                      </div>

                      {/* Footer do card */}
                      <div className="flex items-center justify-between pt-3 border-t border-zinc-100">
                        <div>
                          <p className="text-xs text-zinc-400">Total</p>
                          <p className="font-bold text-primary">
                            R$ {parseFloat(order.total).toFixed(2)}
                          </p>
                        </div>
                        <Button
                          size="sm"
                          onClick={() => startFulfillment(order)}
                          className="gap-2"
                        >
                          Iniciar
                          <ChevronRight className="w-4 h-4" />
                        </Button>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
