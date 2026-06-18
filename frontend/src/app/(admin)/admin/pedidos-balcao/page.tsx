"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";
import {
  ShoppingCart, Search, Plus, Minus, Trash2, User, Phone,
  CreditCard, Banknote, QrCode, CheckCircle2, Package, Layers, Tag,
  UserSearch, UserPlus, X, Star, ShoppingBag, ChevronRight,
  UserX, Sparkles, AlertCircle, Clock, Calendar,
} from "lucide-react";

type CatalogItem = { id: number; name: string; price: number; stock: number; type: "product" | "kit" | "variant" };
type CartItem    = CatalogItem & { quantity: number };

type CustomerResult = {
  id: number;
  name: string;
  email: string;
  whatsapp: string;
  cpf: string | null;
  is_active: boolean;
  orders_count: number;
  loyalty_points: number;
};

type CustomerMode = "searching" | "found" | "registering" | "anonymous";

const PAYMENT_METHODS = [
  { value: "cash",   label: "Dinheiro",       icon: Banknote },
  { value: "credit", label: "Cartão Crédito", icon: CreditCard },
  { value: "debit",  label: "Cartão Débito",  icon: CreditCard },
  { value: "pix",    label: "PIX",            icon: QrCode },
  { value: "installments", label: "Parcelado (Pix/Dinheiro)", icon: Clock },
];

export default function PedidosBalcaoPage() {
  // ── Catálogo ──
  const [catalog, setCatalog]   = useState<CatalogItem[]>([]);
  const [search, setSearch]     = useState("");

  // ── Carrinho ──
  const [cart, setCart]         = useState<CartItem[]>([]);
  const [activeMobileTab, setActiveMobileTab] = useState<"catalog" | "cart">("catalog");

  // ── Cliente ──
  const [customerMode, setCustomerMode]   = useState<CustomerMode>("searching");
  const [customerQuery, setCustomerQuery] = useState("");
  const [searchResults, setSearchResults] = useState<CustomerResult[]>([]);
  const [searching, setSearching]         = useState(false);
  const [selectedCustomer, setSelectedCustomer] = useState<CustomerResult | null>(null);

  // Cadastro rápido
  const [regName, setRegName]       = useState("");
  const [regPhone, setRegPhone]     = useState("");
  const [regCpf, setRegCpf]         = useState("");
  const [regEmail, setRegEmail]     = useState("");
  const [registering, setRegistering] = useState(false);

  // ── Pagamento ──
  const [discount, setDiscount]     = useState("");
  const [payment, setPayment]       = useState("cash");
  const [notes, setNotes]           = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [done, setDone]             = useState<{ number: string; type: "immediate" | "later" } | null>(null);

  // ── Parcelamento ──
  const [installmentCount, setInstallmentCount] = useState<number>(2);
  const [customInstallments, setCustomInstallments] = useState<any[]>([]);

  // ── Entrega Posterior ──
  const [deliveryType, setDeliveryType]       = useState<"immediate" | "later">("immediate");
  const [shippingAddress, setShippingAddress] = useState("");

  // ── Lançamento Retroativo ──
  const [isRetroactive, setIsRetroactive]     = useState(false);
  const [retroactiveDate, setRetroactiveDate] = useState("");
  const [adjustInventory, setAdjustInventory] = useState(false); // default false for retroactives
  const [awardPoints, setAwardPoints]         = useState(true);

  const searchTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Totais recomputados
  const subtotal    = cart.reduce((s, i) => s + i.price * i.quantity, 0);
  const discountVal = parseFloat(discount) || 0;
  const total       = Math.max(0, subtotal - discountVal);

  // Efeito para recalcular parcelas
  useEffect(() => {
    if (payment === "installments" && total > 0) {
      const baseAmount = parseFloat((total / installmentCount).toFixed(2));
      const difference = parseFloat((total - baseAmount * installmentCount).toFixed(2));
      
      const newInsts = Array.from({ length: installmentCount }, (_, i) => {
        const dateObj = new Date();
        dateObj.setDate(dateObj.getDate() + i * 30);
        const yyyy = dateObj.getFullYear();
        const mm = String(dateObj.getMonth() + 1).padStart(2, "0");
        const dd = String(dateObj.getDate()).padStart(2, "0");
        const formattedDate = `${yyyy}-${mm}-${dd}`;
        
        const amount = i === installmentCount - 1 
          ? parseFloat((baseAmount + difference).toFixed(2)) 
          : baseAmount;
          
        return {
          installment_number: i + 1,
          amount: amount,
          due_date: formattedDate,
          status: i === 0 ? "paid" : "pending",
          payment_method: i === 0 ? "pix" : "",
        };
      });
      setCustomInstallments(newInsts);
    } else {
      setCustomInstallments([]);
    }
  }, [payment, total, installmentCount]);

  function updateInstallment(index: number, fields: any) {
    setCustomInstallments(prev => prev.map((inst, i) => i === index ? { ...inst, ...fields } : inst));
  }

  const installmentsSum = customInstallments.reduce((sum, inst) => sum + parseFloat(inst.amount || 0), 0);
  const isInstallmentsSumValid = payment !== "installments" || Math.abs(installmentsSum - total) < 0.05;

  // ── Carregar catálogo ──
  useEffect(() => {
    Promise.all([
      apiFetch("/ecommerce/products?per_page=200"),
      apiFetch("/ecommerce/kits?per_page=200"),
    ]).then(([pRes, kRes]) => {
      const prods = (pRes.data?.products ?? pRes.data ?? []).map((p: any) => ({ ...p, price: parseFloat(p.price), stock: parseInt(p.stock), type: "product" }));
      const kits  = (kRes.data?.kits     ?? kRes.data ?? []).map((k: any) => ({ ...k, price: parseFloat(k.price), stock: parseInt(k.stock), type: "kit" }));
      setCatalog([...prods, ...kits]);
    }).catch(() => toast.error("Erro ao carregar catálogo"));
  }, []);

  // ── Busca de cliente com debounce ──
  useEffect(() => {
    if (customerQuery.length < 2) {
      setSearchResults([]);
      return;
    }
    if (searchTimer.current) clearTimeout(searchTimer.current);
    setSearching(true);
    searchTimer.current = setTimeout(async () => {
      try {
        const res = await apiFetch(`/auth/admin/counter/search-customer?q=${encodeURIComponent(customerQuery)}`);
        setSearchResults(res.data ?? []);
      } catch {
        setSearchResults([]);
      } finally {
        setSearching(false);
      }
    }, 350);
  }, [customerQuery]);

  // ── Carrinho ──
  const filtered = useMemo(() => {
    if (!search.trim()) return catalog;
    return catalog.filter(i => i.name.toLowerCase().includes(search.toLowerCase()));
  }, [catalog, search]);

  function addToCart(item: CatalogItem) {
    setCart(prev => {
      const existing = prev.find(c => c.id === item.id && c.type === item.type);
      if (existing) {
        if (existing.quantity >= item.stock) { toast.warning(`Estoque máximo: ${item.stock} un.`); return prev; }
        return prev.map(c => c.id === item.id && c.type === item.type ? { ...c, quantity: c.quantity + 1 } : c);
      }
      if (item.stock < 1) { toast.warning("Produto sem estoque."); return prev; }
      return [...prev, { ...item, quantity: 1 }];
    });
  }

  function changeQty(item: CartItem, delta: number) {
    const next = item.quantity + delta;
    if (next < 1) { removeFromCart(item); return; }
    if (next > item.stock) { toast.warning(`Estoque máximo: ${item.stock} un.`); return; }
    setCart(prev => prev.map(c => c.id === item.id && c.type === item.type ? { ...c, quantity: next } : c));
  }

  function removeFromCart(item: CartItem) {
    setCart(prev => prev.filter(c => !(c.id === item.id && c.type === item.type)));
  }

  // ── Seleção de cliente ──
  function selectCustomer(customer: CustomerResult) {
    setSelectedCustomer(customer);
    setCustomerMode("found");
    setSearchResults([]);
    setCustomerQuery("");
  }

  function clearCustomer() {
    setSelectedCustomer(null);
    setCustomerMode("searching");
    setCustomerQuery("");
    setSearchResults([]);
  }

  // Se o cliente for selecionado e mudar para modo de entrega, vamos buscar informações adicionais dele se necessário
  // mas o próprio campo de texto é suficiente por hora

  function goAnonymous() {
    setSelectedCustomer(null);
    setCustomerMode("anonymous");
    setCustomerQuery("");
    setSearchResults([]);
  }

  // ── Cadastro rápido ──
  function goRegister() {
    setRegName(customerQuery.match(/^\d/) ? "" : customerQuery); // pré-preenche se for nome
    setRegPhone(customerQuery.match(/^\d/) ? customerQuery : ""); // pré-preenche se for telefone
    setCustomerMode("registering");
    setSearchResults([]);
  }

  async function handleQuickRegister() {
    if (!regName.trim() || !regPhone.trim()) {
      toast.error("Nome e telefone são obrigatórios.");
      return;
    }
    setRegistering(true);
    try {
      const res = await apiFetch("/auth/admin/counter/quick-register", {
        method: "POST",
        body: JSON.stringify({
          name: regName,
          whatsapp: regPhone,
          cpf: regCpf || undefined,
          email: regEmail || undefined,
        }),
      });
      const newCustomer = res.data as CustomerResult;
      selectCustomer(newCustomer);
      toast.success(`Cliente ${newCustomer.name} cadastrado e vinculado! ✨`);
    } catch (err: any) {
      toast.error(err.message || "Erro ao cadastrar cliente.");
    } finally {
      setRegistering(false);
    }
  }

  // canSubmit validado com a soma das parcelas
  const canSubmit   = cart.length > 0 && 
                      (customerMode === "found" || customerMode === "anonymous") && 
                      payment && 
                      (deliveryType === "immediate" || shippingAddress.trim().length > 0) && 
                      (!isRetroactive || retroactiveDate.trim().length > 0) &&
                      isInstallmentsSumValid;

  // ── Finalizar venda ──
  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!canSubmit) return;
    setSubmitting(true);
    try {
      const body: any = {
        items: cart.map(i => ({ id: i.id, type: i.type, quantity: i.quantity })),
        payment_method: payment,
        discount_amount: discountVal > 0 ? discountVal : undefined,
        notes: notes || undefined,
        status: deliveryType === "later" ? "pending" : (payment === "installments" ? "pending" : "delivered"),
        shipping_address: deliveryType === "later" ? shippingAddress : undefined,
        installments: payment === "installments" ? customInstallments.map(inst => ({
          installment_number: inst.installment_number,
          amount: parseFloat(inst.amount),
          due_date: inst.due_date,
          status: inst.status,
          payment_method: inst.status === "paid" ? inst.payment_method : null
        })) : undefined,
        
        // Retroativo / Histórico
        is_retroactive: isRetroactive ? true : undefined,
        retroactive_date: isRetroactive ? retroactiveDate : undefined,
        adjust_inventory: isRetroactive ? adjustInventory : undefined,
        award_points: isRetroactive ? awardPoints : undefined,
      };

      if (selectedCustomer) {
        body.user_id = selectedCustomer.id;
      } else {
        // venda anônima — mínimo necessário
        body.customer_name  = "Cliente Avulso";
        body.customer_phone = undefined;
      }

      const res = await apiFetch("/ecommerce/counter-orders", {
        method: "POST",
        body: JSON.stringify(body),
      });

      setDone({
        number: res.data?.order_number ?? "BAL-OK",
        type: deliveryType,
      });
      setCart([]);
      clearCustomer();
      setDiscount(""); setNotes(""); setPayment("cash");
      setDeliveryType("immediate"); setShippingAddress("");
      setIsRetroactive(false);
      setRetroactiveDate("");
      setAdjustInventory(false);
      setAwardPoints(true);
      toast.success(deliveryType === "later" ? "Pedido enviado para separação!" : "Venda registrada com sucesso!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao registrar venda");
    } finally {
      setSubmitting(false);
    }
  }

  // ── Tela de sucesso ──
  if (done) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-6">
        <motion.div
          initial={{ scale: 0.5, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: "spring", stiffness: 200 }}
          className={`w-24 h-24 rounded-full flex items-center justify-center ${
            done.type === "later" ? "bg-amber-100 text-amber-600" : "bg-emerald-100 text-emerald-600"
          }`}
        >
          {done.type === "later" ? (
            <Package className="w-12 h-12" />
          ) : (
            <CheckCircle2 className="w-12 h-12" />
          )}
        </motion.div>
        <div className="text-center space-y-1">
          <h2 className="text-2xl font-bold text-zinc-900 font-outfit">
            {done.type === "later" ? "Pedido Pendente Criado!" : "Venda Registrada!"}
          </h2>
          <p className="text-zinc-500">
            Pedido <span className="font-mono font-bold text-primary">{done.number}</span> criado com sucesso.
          </p>
          {done.type === "later" ? (
            <p className="text-sm text-amber-700 font-medium bg-amber-50 border border-amber-200 rounded-full px-4 py-1.5 mt-2 inline-flex items-center gap-1.5 mx-auto">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-amber-500"></span>
              </span>
              Enviado para a fila de Separação e Envio
            </p>
          ) : (
            selectedCustomer && (
              <p className="text-sm text-emerald-600 flex items-center justify-center gap-1 mt-2">
                <Sparkles className="w-4 h-4" />
                Pontos de fidelidade concedidos para {selectedCustomer.name}!
              </p>
            )
          )}
        </div>
        <div className="flex gap-3">
          <Button variant="outline" onClick={() => { setDone(null); }}>Nova Venda</Button>
          <Button onClick={() => window.location.href = done.type === "later" ? "/admin" : "/admin/pedidos"}>
            {done.type === "later" ? "Ir para Separação (Painel)" : "Ver Pedidos"}
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-bold font-outfit text-zinc-900">Venda Balcão</h1>
        <p className="text-sm text-zinc-500">Registre vendas presenciais diretamente no sistema.</p>
      </div>

      {/* Mobile Tab Selector */}
      <div className="flex lg:hidden bg-zinc-100 p-1 rounded-xl border border-zinc-200 mb-4">
        <button
          type="button"
          onClick={() => setActiveMobileTab("catalog")}
          className={cn(
            "flex-1 py-2.5 text-xs font-semibold rounded-lg transition-all flex items-center justify-center gap-2",
            activeMobileTab === "catalog"
              ? "bg-white text-zinc-900 shadow-sm"
              : "text-zinc-500 hover:text-zinc-900"
          )}
        >
          <Package className="w-4 h-4" />
          Produtos
        </button>
        <button
          type="button"
          onClick={() => setActiveMobileTab("cart")}
          className={cn(
            "flex-1 py-2.5 text-xs font-semibold rounded-lg transition-all flex items-center justify-center gap-2",
            activeMobileTab === "cart"
              ? "bg-white text-zinc-900 shadow-sm"
              : "text-zinc-500 hover:text-zinc-900"
          )}
        >
          <ShoppingCart className="w-4 h-4" />
          Carrinho
          {cart.length > 0 && (
            <span className="px-1.5 py-0.5 rounded-full text-[10px] font-bold bg-primary text-white ml-1.5">
              {cart.reduce((sum, i) => sum + i.quantity, 0)}
            </span>
          )}
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-5 gap-6 items-start">

        {/* ── CATÁLOGO ── */}
        <div className={cn(
          "lg:col-span-3 bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden",
          activeMobileTab === "catalog" ? "block" : "hidden lg:block"
        )}>
          <div className="p-4 border-b border-zinc-100">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
              <Input
                className="pl-10"
                placeholder="Buscar produto ou kit..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
            </div>
          </div>
          <div className="divide-y divide-zinc-100 max-h-[60vh] overflow-y-auto">
            {filtered.length === 0 && (
              <p className="text-center text-zinc-400 py-10 text-sm">Nenhum item encontrado.</p>
            )}
            {filtered.map(item => {
              const hasVariants = item.type === "product" && (item as any).variants && (item as any).variants.length > 0;
              return (
                <div key={`${item.type}-${item.id}`} className="flex flex-col border-b border-zinc-100 last:border-0 hover:bg-zinc-50/50">
                  <div className="flex items-center justify-between px-4 py-3">
                    <div className="flex items-center gap-3 min-w-0">
                      <div className="w-8 h-8 rounded-lg bg-zinc-100 flex items-center justify-center flex-shrink-0">
                        {item.type === "kit" ? <Layers className="w-4 h-4 text-zinc-400" /> : <Package className="w-4 h-4 text-zinc-400" />}
                      </div>
                      <div className="min-w-0">
                        <p className="text-sm font-medium text-zinc-900 truncate">{item.name}</p>
                        <div className="flex items-center gap-2 mt-0.5">
                          {!hasVariants && <span className="text-xs font-bold text-primary">R$ {item.price.toFixed(2)}</span>}
                          {!hasVariants && (
                            <span className={`text-xs ${item.stock < 5 ? "text-red-500" : "text-zinc-400"}`}>
                              estoque: {item.stock}
                            </span>
                          )}
                          <Badge variant="outline" className="text-[10px] py-0 h-4">
                            {item.type === "kit" ? "Kit" : hasVariants ? "Produto (Com Tamanhos)" : "Produto"}
                          </Badge>
                        </div>
                      </div>
                    </div>
                    {!hasVariants && (
                      <Button
                        type="button"
                        size="sm" variant="outline"
                        className="flex-shrink-0 h-8 w-8 p-0"
                        disabled={item.stock < 1}
                        onClick={() => addToCart(item)}
                      >
                        <Plus className="w-4 h-4" />
                      </Button>
                    )}
                  </div>
                  
                  {/* Listar as variantes se houver */}
                  {hasVariants && (
                    <div className="pl-14 pr-4 pb-3 space-y-2">
                      {((item as any).variants).map((v: any) => {
                        const cleanName = v.name.replace(item.name + ' - ', '');
                        return (
                          <div key={v.id} className="flex items-center justify-between bg-zinc-50 border border-zinc-200 p-2 rounded-lg text-xs">
                            <span className="font-semibold text-zinc-700">{cleanName}</span>
                            <div className="flex items-center gap-3">
                              <span className="font-bold text-primary">R$ {parseFloat(v.price).toFixed(2)}</span>
                              <span className={v.stock < 5 ? "text-red-500" : "text-zinc-400"}>Estoque: {v.stock} un</span>
                              <Button
                                type="button"
                                size="sm"
                                variant="outline"
                                className="h-6 w-6 p-0"
                                disabled={v.stock < 1}
                                onClick={() => addToCart({
                                  id: v.id,
                                  name: v.name,
                                  price: parseFloat(v.price),
                                  stock: parseInt(v.stock),
                                  type: "variant" as any
                                })}
                              >
                                <Plus className="w-3 h-3" />
                              </Button>
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        {/* ── CARRINHO + CHECKOUT ── */}
        <form onSubmit={handleSubmit} className={cn(
          "lg:col-span-2 flex flex-col gap-4",
          activeMobileTab === "cart" ? "flex" : "hidden lg:flex"
        )}>

          {/* ── IDENTIFICAÇÃO DO CLIENTE ── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
            <div className="px-4 py-3 border-b border-zinc-100 flex items-center gap-2">
              <User className="w-4 h-4 text-zinc-500" />
              <span className="font-semibold text-zinc-900 text-sm">Cliente</span>
              {customerMode === "found" && selectedCustomer && (
                <Badge className="ml-auto bg-emerald-100 text-emerald-700 border-none text-xs">
                  <CheckCircle2 className="w-3 h-3 mr-1" /> Identificado
                </Badge>
              )}
              {customerMode === "anonymous" && (
                <Badge className="ml-auto bg-zinc-100 text-zinc-500 border-none text-xs">
                  <UserX className="w-3 h-3 mr-1" /> Anônimo
                </Badge>
              )}
            </div>

            <div className="p-4 space-y-3">
              <AnimatePresence mode="wait">

                {/* ── MODO: BUSCA ── */}
                {(customerMode === "searching") && (
                  <motion.div
                    key="searching"
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -8 }}
                    className="space-y-3"
                  >
                    <div className="relative">
                      <UserSearch className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
                      <Input
                        className="pl-10 h-9 text-sm"
                        placeholder="Nome, telefone ou CPF..."
                        value={customerQuery}
                        onChange={e => setCustomerQuery(e.target.value)}
                        autoFocus
                      />
                      {customerQuery && (
                        <button
                          type="button"
                          onClick={() => setCustomerQuery("")}
                          className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600"
                        >
                          <X className="w-3.5 h-3.5" />
                        </button>
                      )}
                    </div>

                    {/* Resultados */}
                    <AnimatePresence>
                      {customerQuery.length >= 2 && (
                        <motion.div
                          initial={{ opacity: 0, height: 0 }}
                          animate={{ opacity: 1, height: "auto" }}
                          exit={{ opacity: 0, height: 0 }}
                          className="overflow-hidden"
                        >
                          {searching ? (
                            <p className="text-xs text-zinc-400 text-center py-3 animate-pulse">Buscando...</p>
                          ) : searchResults.length > 0 ? (
                            <div className="border border-zinc-200 rounded-lg divide-y divide-zinc-100 max-h-52 overflow-y-auto">
                              {searchResults.map(c => (
                                <button
                                  key={c.id}
                                  type="button"
                                  onClick={() => selectCustomer(c)}
                                  className="w-full flex items-center gap-3 px-3 py-2.5 hover:bg-zinc-50 text-left transition-colors"
                                >
                                  <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 text-primary font-bold text-sm">
                                    {c.name[0].toUpperCase()}
                                  </div>
                                  <div className="flex-1 min-w-0">
                                    <p className="text-sm font-medium text-zinc-900 truncate">{c.name}</p>
                                    <div className="flex items-center gap-2 mt-0.5">
                                      {c.whatsapp && (
                                        <span className="text-xs text-zinc-400">{c.whatsapp}</span>
                                      )}
                                      {c.loyalty_points > 0 && (
                                        <span className="text-xs text-amber-600 flex items-center gap-0.5">
                                          <Star className="w-3 h-3" /> {c.loyalty_points} pts
                                        </span>
                                      )}
                                    </div>
                                  </div>
                                  <ChevronRight className="w-4 h-4 text-zinc-300 flex-shrink-0" />
                                </button>
                              ))}
                            </div>
                          ) : (
                            <div className="border border-zinc-200 rounded-lg p-3 space-y-2">
                              <p className="text-xs text-zinc-500 text-center">Nenhum cliente encontrado.</p>
                              <div className="flex gap-2">
                                <Button
                                  type="button"
                                  size="sm"
                                  variant="outline"
                                  className="flex-1 text-xs gap-1 h-8"
                                  onClick={goRegister}
                                >
                                  <UserPlus className="w-3.5 h-3.5" />
                                  Cadastrar
                                </Button>
                                <Button
                                  type="button"
                                  size="sm"
                                  variant="ghost"
                                  className="flex-1 text-xs gap-1 h-8 text-zinc-400"
                                  onClick={goAnonymous}
                                >
                                  <UserX className="w-3.5 h-3.5" />
                                  Venda Anônima
                                </Button>
                              </div>
                            </div>
                          )}
                        </motion.div>
                      )}
                    </AnimatePresence>

                    {/* Ações quando campo vazio */}
                    {customerQuery.length < 2 && (
                      <div className="flex gap-2">
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className="flex-1 text-xs gap-1 h-8 border-dashed"
                          onClick={goRegister}
                        >
                          <UserPlus className="w-3.5 h-3.5" />
                          Novo Cliente
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="ghost"
                          className="flex-1 text-xs gap-1 h-8 text-zinc-400"
                          onClick={goAnonymous}
                        >
                          <UserX className="w-3.5 h-3.5" />
                          Venda Anônima
                        </Button>
                      </div>
                    )}
                  </motion.div>
                )}

                {/* ── MODO: CLIENTE ENCONTRADO ── */}
                {customerMode === "found" && selectedCustomer && (
                  <motion.div
                    key="found"
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -8 }}
                    className="space-y-2"
                  >
                    <div className="flex items-center gap-3 bg-emerald-50 border border-emerald-200 rounded-xl p-3">
                      <div className="w-10 h-10 rounded-full bg-emerald-200 flex items-center justify-center text-emerald-800 font-bold flex-shrink-0">
                        {selectedCustomer.name[0].toUpperCase()}
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold text-zinc-900 text-sm truncate">{selectedCustomer.name}</p>
                        <div className="flex flex-wrap items-center gap-x-3 gap-y-0.5 mt-0.5">
                          {selectedCustomer.whatsapp && (
                            <span className="text-xs text-zinc-500 flex items-center gap-1">
                              <Phone className="w-3 h-3" /> {selectedCustomer.whatsapp}
                            </span>
                          )}
                          <span className="text-xs text-zinc-500 flex items-center gap-1">
                            <ShoppingBag className="w-3 h-3" /> {selectedCustomer.orders_count} pedidos
                          </span>
                        </div>
                      </div>
                      <button
                        type="button"
                        onClick={clearCustomer}
                        className="text-zinc-400 hover:text-zinc-600 flex-shrink-0 ml-1"
                        title="Trocar cliente"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>

                    {selectedCustomer.loyalty_points > 0 && (
                      <div className="flex items-center gap-2 bg-amber-50 border border-amber-200 rounded-lg px-3 py-2">
                        <Star className="w-4 h-4 text-amber-500 flex-shrink-0" />
                        <p className="text-xs text-amber-700">
                          <span className="font-bold">{selectedCustomer.loyalty_points} pontos</span> de fidelidade · Esta compra vai gerar novos pontos!
                        </p>
                      </div>
                    )}
                    {selectedCustomer.loyalty_points === 0 && (
                      <div className="flex items-center gap-2 bg-blue-50 border border-blue-100 rounded-lg px-3 py-2">
                        <Sparkles className="w-4 h-4 text-blue-400 flex-shrink-0" />
                        <p className="text-xs text-blue-600">Esta compra vai gerar pontos de fidelidade!</p>
                      </div>
                    )}
                  </motion.div>
                )}

                {/* ── MODO: CADASTRO RÁPIDO ── */}
                {customerMode === "registering" && (
                  <motion.div
                    key="registering"
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -8 }}
                    className="space-y-3"
                  >
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-semibold text-zinc-700 flex items-center gap-1.5">
                        <UserPlus className="w-4 h-4 text-primary" />
                        Cadastro Rápido
                      </p>
                      <button type="button" onClick={() => setCustomerMode("searching")} className="text-zinc-400 hover:text-zinc-600">
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                    <div className="space-y-2">
                      <div>
                        <Label className="text-xs">Nome *</Label>
                        <Input
                          className="h-8 text-sm mt-1"
                          placeholder="Nome completo"
                          value={regName}
                          onChange={e => setRegName(e.target.value)}
                        />
                      </div>
                      <div>
                        <Label className="text-xs">WhatsApp / Telefone *</Label>
                        <Input
                          className="h-8 text-sm mt-1"
                          placeholder="(00) 00000-0000"
                          value={regPhone}
                          onChange={e => setRegPhone(e.target.value)}
                        />
                      </div>
                      <div className="grid grid-cols-2 gap-2">
                        <div>
                          <Label className="text-xs">CPF <span className="text-zinc-400">(opcional)</span></Label>
                          <Input
                            className="h-8 text-sm mt-1"
                            placeholder="000.000.000-00"
                            value={regCpf}
                            onChange={e => setRegCpf(e.target.value)}
                          />
                        </div>
                        <div>
                          <Label className="text-xs">E-mail <span className="text-zinc-400">(opcional)</span></Label>
                          <Input
                            className="h-8 text-sm mt-1"
                            placeholder="email@exemplo.com"
                            value={regEmail}
                            onChange={e => setRegEmail(e.target.value)}
                          />
                        </div>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <Button
                        type="button"
                        size="sm"
                        className="flex-1 gap-1"
                        onClick={handleQuickRegister}
                        disabled={registering || !regName.trim() || !regPhone.trim()}
                      >
                        {registering ? "Cadastrando..." : <><CheckCircle2 className="w-3.5 h-3.5" /> Cadastrar e Vincular</>}
                      </Button>
                      <Button
                        type="button"
                        size="sm"
                        variant="ghost"
                        className="text-zinc-400 gap-1 text-xs"
                        onClick={goAnonymous}
                      >
                        <UserX className="w-3.5 h-3.5" />
                        Pular
                      </Button>
                    </div>
                  </motion.div>
                )}

                {/* ── MODO: ANÔNIMO ── */}
                {customerMode === "anonymous" && (
                  <motion.div
                    key="anonymous"
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -8 }}
                    className="space-y-2"
                  >
                    <div className="flex items-center gap-3 bg-zinc-50 border border-zinc-200 rounded-xl p-3">
                      <div className="w-9 h-9 rounded-full bg-zinc-200 flex items-center justify-center flex-shrink-0">
                        <UserX className="w-4 h-4 text-zinc-400" />
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-semibold text-zinc-700">Venda Anônima</p>
                        <p className="text-xs text-zinc-400">Sem vinculação a cliente cadastrado.</p>
                      </div>
                      <button
                        type="button"
                        onClick={clearCustomer}
                        className="text-zinc-400 hover:text-zinc-600"
                        title="Identificar cliente"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                    <div className="flex items-start gap-2 bg-amber-50 border border-amber-100 rounded-lg px-3 py-2">
                      <AlertCircle className="w-4 h-4 text-amber-500 flex-shrink-0 mt-0.5" />
                      <p className="text-xs text-amber-700">
                        Esta venda <strong>não vai gerar pontos de fidelidade</strong>. Identifique o cliente para que ele acumule pontos.
                      </p>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </div>

          {/* ── LANÇAMENTO RETROATIVO ── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden p-4 space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-zinc-500" />
                <span className="font-semibold text-zinc-900 text-sm">Lançamento Histórico / Retroativo</span>
              </div>
              <label className="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  className="sr-only peer"
                  checked={isRetroactive}
                  onChange={(e) => {
                    const checked = e.target.checked;
                    setIsRetroactive(checked);
                    if (checked) {
                      setAdjustInventory(false); // Default false for retroactives
                      if (!retroactiveDate) {
                        const today = new Date().toISOString().split("T")[0];
                        setRetroactiveDate(today);
                      }
                    } else {
                      setAdjustInventory(true);
                    }
                  }}
                />
                <div className="w-9 h-5 bg-zinc-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-zinc-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>

            <AnimatePresence>
              {isRetroactive && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  className="space-y-4 pt-3 border-t border-dashed border-zinc-100 overflow-hidden"
                >
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold text-zinc-600 flex items-center gap-1">
                      <Calendar className="w-3.5 h-3.5 text-zinc-400" />
                      Data Real da Venda no Passado
                    </Label>
                    <Input
                      type="date"
                      value={retroactiveDate}
                      onChange={(e) => setRetroactiveDate(e.target.value)}
                      className="text-sm h-9 border-zinc-200 bg-white"
                      max={new Date().toISOString().split("T")[0]}
                      required={isRetroactive}
                    />
                  </div>

                  <div className="space-y-2.5 bg-zinc-50 p-3 rounded-lg border border-zinc-200">
                    <p className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Configurações Avançadas</p>
                    
                    <div className="flex items-center justify-between">
                      <div className="flex flex-col pr-4">
                        <span className="text-xs font-semibold text-zinc-700">Baixar estoque atual no sistema</span>
                        <span className="text-[10px] text-zinc-400">Diminuir a quantidade física das ervas/kits hoje</span>
                      </div>
                      <label className="relative inline-flex items-center cursor-pointer flex-shrink-0">
                        <input
                          type="checkbox"
                          className="sr-only peer"
                          checked={adjustInventory}
                          onChange={(e) => setAdjustInventory(e.target.checked)}
                        />
                        <div className="w-9 h-5 bg-zinc-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-zinc-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
                      </label>
                    </div>

                    <div className="flex items-center justify-between pt-2 border-t border-zinc-200/50">
                      <div className="flex flex-col pr-4">
                        <span className="text-xs font-semibold text-zinc-700">Creditar pontos de fidelidade</span>
                        <span className="text-[10px] text-zinc-400">Gerar sementes retroativas para o cliente</span>
                      </div>
                      <label className="relative inline-flex items-center cursor-pointer flex-shrink-0">
                        <input
                          type="checkbox"
                          className="sr-only peer"
                          checked={awardPoints}
                          onChange={(e) => setAwardPoints(e.target.checked)}
                        />
                        <div className="w-9 h-5 bg-zinc-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-zinc-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
                      </label>
                    </div>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* ── CARRINHO ── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
            <div className="px-4 py-3 border-b border-zinc-100 flex items-center gap-2">
              <ShoppingCart className="w-4 h-4 text-zinc-500" />
              <span className="font-semibold text-zinc-900 text-sm">Carrinho</span>
              {cart.length > 0 && (
                <Badge className="ml-auto bg-primary/10 text-primary border-none">{cart.length} item(s)</Badge>
              )}
            </div>

            {cart.length === 0 ? (
              <p className="text-center text-zinc-400 text-sm py-8">Adicione itens do catálogo.</p>
            ) : (
              <div className="divide-y divide-zinc-100 max-h-44 overflow-y-auto">
                {cart.map(item => (
                  <div key={`${item.type}-${item.id}`} className="flex items-center gap-2 px-4 py-2.5">
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium text-zinc-900 truncate">{item.name}</p>
                      <p className="text-xs text-zinc-400">R$ {item.price.toFixed(2)} × {item.quantity} = <span className="font-semibold text-zinc-700">R$ {(item.price * item.quantity).toFixed(2)}</span></p>
                    </div>
                    <div className="flex items-center gap-1 flex-shrink-0">
                      <Button type="button" size="sm" variant="ghost" className="h-6 w-6 p-0" onClick={() => changeQty(item, -1)}>
                        <Minus className="w-3 h-3" />
                      </Button>
                      <span className="text-xs font-bold w-5 text-center">{item.quantity}</span>
                      <Button type="button" size="sm" variant="ghost" className="h-6 w-6 p-0" onClick={() => changeQty(item, 1)}>
                        <Plus className="w-3 h-3" />
                      </Button>
                      <Button type="button" size="sm" variant="ghost" className="h-6 w-6 p-0 text-zinc-300 hover:text-red-500" onClick={() => removeFromCart(item)}>
                        <Trash2 className="w-3 h-3" />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {cart.length > 0 && (
              <div className="px-4 py-3 border-t border-zinc-100 bg-zinc-50 space-y-1.5">
                <div className="flex justify-between text-sm text-zinc-500">
                  <span>Subtotal</span><span>R$ {subtotal.toFixed(2)}</span>
                </div>
                {discountVal > 0 && (
                  <div className="flex justify-between text-sm text-emerald-600">
                    <span>Desconto</span><span>- R$ {discountVal.toFixed(2)}</span>
                  </div>
                )}
                <div className="flex justify-between font-bold text-zinc-900">
                  <span>Total</span><span className="text-primary text-lg">R$ {total.toFixed(2)}</span>
                </div>
              </div>
            )}
          </div>

          {/* ── TIPO DE ENTREGA / FLUXO ── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-4 space-y-3">
            <p className="text-sm font-semibold text-zinc-900 flex items-center gap-2">
              <Package className="w-4 h-4 text-zinc-500" /> Tipo de Entrega
            </p>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => {
                  setDeliveryType("immediate");
                  setShippingAddress("");
                }}
                className={`flex flex-col items-center gap-1.5 p-3 rounded-xl border text-center transition-all ${
                  deliveryType === "immediate"
                    ? "border-primary bg-primary/5 text-primary font-bold shadow-sm"
                    : "border-zinc-200 text-zinc-500 hover:border-zinc-300"
                }`}
              >
                <span className="text-xl">🛍️</span>
                <span className="text-xs">Retirada Imediata</span>
              </button>
              <button
                type="button"
                onClick={() => setDeliveryType("later")}
                className={`flex flex-col items-center gap-1.5 p-3 rounded-xl border text-center transition-all ${
                  deliveryType === "later"
                    ? "border-primary bg-primary/5 text-primary font-bold shadow-sm"
                    : "border-zinc-200 text-zinc-500 hover:border-zinc-300"
                }`}
              >
                <span className="text-xl">🚚</span>
                <span className="text-xs">Separação / Entrega</span>
              </button>
            </div>

            {deliveryType === "later" && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                className="space-y-1.5 pt-1.5 border-t border-dashed border-zinc-100"
              >
                <Label className="text-xs font-semibold text-zinc-600">Endereço de Entrega / Instruções</Label>
                <Input
                  placeholder="Ex: Av. das Flores 450, Bairro - CEP 00000-000 ou 'Mandar motoboy'"
                  value={shippingAddress}
                  onChange={e => setShippingAddress(e.target.value)}
                  className="text-sm h-9 border-zinc-200"
                  required={deliveryType === "later"}
                />
              </motion.div>
            )}
          </div>

          {/* ── PAGAMENTO ── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-4 space-y-3">
            <p className="text-sm font-semibold text-zinc-900 flex items-center gap-2">
              <CreditCard className="w-4 h-4" /> Pagamento
            </p>
            <div className="grid grid-cols-2 gap-2">
              {PAYMENT_METHODS.map(m => (
                <button
                  key={m.value}
                  type="button"
                  onClick={() => setPayment(m.value)}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-sm font-medium transition-colors ${
                    payment === m.value
                      ? "border-primary bg-primary/10 text-primary"
                      : "border-zinc-200 text-zinc-500 hover:border-zinc-300"
                  }`}
                >
                  <m.icon className="w-4 h-4" /> {m.label}
                </button>
              ))}
            </div>

            {payment === "installments" && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                className="space-y-3 pt-3 border-t border-zinc-100"
              >
                <div className="flex items-center justify-between">
                  <Label className="text-xs font-semibold text-zinc-700">Número de Parcelas</Label>
                  <select
                    value={installmentCount}
                    onChange={e => setInstallmentCount(parseInt(e.target.value))}
                    className="h-8 text-xs border border-zinc-200 rounded-md bg-white px-2 focus:outline-none focus:ring-1 focus:ring-primary"
                  >
                    {[2, 3, 4, 5, 6, 8, 10, 12].map(n => (
                      <option key={n} value={n}>{n}x</option>
                    ))}
                  </select>
                </div>

                <div className="space-y-2.5 max-h-60 overflow-y-auto pr-1">
                  {customInstallments.map((inst, index) => (
                    <div key={index} className="bg-zinc-50 border border-zinc-200 rounded-lg p-2.5 space-y-2">
                      <div className="flex items-center justify-between text-xs font-bold text-zinc-700">
                        <span>Parcela #{inst.installment_number}</span>
                      </div>
                      
                      <div className="grid grid-cols-2 gap-2">
                        <div>
                          <Label className="text-[10px] text-zinc-500">Valor (R$)</Label>
                          <Input
                            type="number"
                            step="0.01"
                            min="0.01"
                            value={inst.amount}
                            onChange={e => updateInstallment(index, { amount: e.target.value })}
                            className="h-7 text-xs px-2 py-1 mt-0.5"
                          />
                        </div>
                        <div>
                          <Label className="text-[10px] text-zinc-500">Vencimento</Label>
                          <Input
                            type="date"
                            value={inst.due_date}
                            onChange={e => updateInstallment(index, { due_date: e.target.value })}
                            className="h-7 text-xs px-2 py-1 mt-0.5"
                          />
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-2 pt-1 border-t border-zinc-200/50">
                        <div>
                          <Label className="text-[10px] text-zinc-500">Status</Label>
                          <select
                            value={inst.status}
                            onChange={e => updateInstallment(index, { 
                              status: e.target.value,
                              payment_method: e.target.value === "paid" ? "pix" : "" 
                            })}
                            className="w-full h-7 text-xs border border-zinc-200 rounded-md bg-white px-2 mt-0.5 focus:outline-none"
                          >
                            <option value="pending">Pendente</option>
                            <option value="paid">Pago</option>
                          </select>
                        </div>
                        {inst.status === "paid" && (
                          <div>
                            <Label className="text-[10px] text-zinc-500">Recebido em</Label>
                            <select
                              value={inst.payment_method}
                              onChange={e => updateInstallment(index, { payment_method: e.target.value })}
                              className="w-full h-7 text-xs border border-zinc-200 rounded-md bg-white px-2 mt-0.5 focus:outline-none"
                            >
                              <option value="pix">PIX</option>
                              <option value="cash">Dinheiro</option>
                            </select>
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>

                {!isInstallmentsSumValid && (
                  <div className="flex items-center gap-1.5 p-2 bg-red-50 border border-red-200 text-red-700 text-xs rounded-lg font-medium">
                    <AlertCircle className="w-4 h-4 flex-shrink-0" />
                    <span>A soma das parcelas (R$ {installmentsSum.toFixed(2)}) não bate com o total (R$ {total.toFixed(2)}).</span>
                  </div>
                )}
              </motion.div>
            )}

            <div className="grid grid-cols-2 gap-2">
              <div>
                <Label className="text-xs flex items-center gap-1"><Tag className="w-3 h-3" /> Desconto (R$)</Label>
                <Input
                  type="number" min="0" step="0.01" placeholder="0,00"
                  value={discount}
                  onChange={e => setDiscount(e.target.value)}
                  className="h-8 text-sm mt-1"
                />
              </div>
              <div>
                <Label className="text-xs">Observações</Label>
                <Input
                  placeholder="Opcional..."
                  value={notes}
                  onChange={e => setNotes(e.target.value)}
                  className="h-8 text-sm mt-1"
                />
              </div>
            </div>
          </div>

          <Button
            type="submit"
            disabled={!canSubmit || submitting}
            className="w-full h-12 text-base font-semibold bg-primary hover:bg-primary/90"
          >
            {submitting ? "Registrando..." : `Finalizar Venda — R$ ${total.toFixed(2)}`}
          </Button>
        </form>
      </div>
    </div>
  );
}
