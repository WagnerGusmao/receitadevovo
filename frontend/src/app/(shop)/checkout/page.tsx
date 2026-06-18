"use client";

import { useState, useEffect } from "react";
import { useCartStore } from "@/modules/ecommerce/store/cartStore";
import { apiFetch } from "@/services/api";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { ShoppingBag, MapPin, CreditCard, ChevronRight, CheckCircle2, Plus, Home, Briefcase, MapPinned } from "lucide-react";
import { toast } from "sonner";
import { addressService } from "@/modules/ecommerce/services/addressService";
import { Address } from "@/modules/ecommerce/types";
import { fetchCEP as getCEP } from "@/services/viacep";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { formatCEP, formatCPF, formatWhatsApp, removeFormat } from "@/lib/masks";
import { Checkbox } from "@/components/ui/checkbox";
import { ecommerceService } from "@/modules/ecommerce/services/ecommerce";

export default function CheckoutPage() {
  const router = useRouter();
  const { items, addItem, removeItem, getTotal, clearCart } = useCartStore();
  const total = getTotal();
  
  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(false);
  const { user } = useAuthStore();
  const [addresses, setAddresses] = useState<Address[]>([]);
  const [selectedAddressId, setSelectedAddressId] = useState<number | null>(null);
  const [showNewAddressForm, setShowNewAddressForm] = useState(false);
  const [createdOrder, setCreatedOrder] = useState<any>(null);
  const [copied, setCopied] = useState(false);
  const [mounted, setMounted] = useState(false);

  // Estados de cálculo de frete
  const [shippingOptions, setShippingOptions] = useState<any[]>([]);
  const [selectedOption, setSelectedOption] = useState<any | null>(null);
  const [shippingLoading, setShippingLoading] = useState(false);

  const grandTotal = total + (selectedOption ? selectedOption.price : 0);

  // Estados e lógica de embalagem especial (cestas/sacolas)
  const [dbProducts, setDbProducts] = useState<any[]>([]);

  useEffect(() => {
    async function loadDbProducts() {
      try {
        const prodData = await ecommerceService.getProducts();
        if (prodData && prodData.data && Array.isArray(prodData.data.products)) {
          setDbProducts(prodData.data.products);
        }
      } catch (error) {
        console.error("Error loading products on checkout", error);
      }
    }
    loadDbProducts();
  }, []);

  const sacolaProduct = dbProducts.find(p => p.slug === 'embalagem-presente-sacola');
  const cestaProduct = dbProducts.find(p => p.slug === 'embalagem-presente-cesta');

  const handleToggleBag = (checked: boolean | 'indeterminate') => {
    if (!sacolaProduct) return;
    if (checked === true) {
      addItem({
        id: sacolaProduct.id,
        name: sacolaProduct.name,
        price: parseFloat(sacolaProduct.price),
        quantity: 1,
        image: '🎁',
        type: 'product',
        slug: 'embalagem-presente-sacola'
      });
      toast.success("Sacolinha para presente adicionada!");
    } else {
      removeItem(sacolaProduct.id, 'product');
      toast.info("Sacolinha para presente removida.");
    }
  };

  const handleToggleBasket = (checked: boolean | 'indeterminate') => {
    if (!cestaProduct) return;
    if (checked === true) {
      addItem({
        id: cestaProduct.id,
        name: cestaProduct.name,
        price: parseFloat(cestaProduct.price),
        quantity: 1,
        image: '🧺',
        type: 'product',
        slug: 'embalagem-presente-cesta'
      });
      toast.success("Cesta especial adicionada!");
    } else {
      removeItem(cestaProduct.id, 'product');
      toast.info("Cesta especial removida.");
    }
  };

  const loadShippingRates = async (zipcode: string) => {
    if (!zipcode || items.length === 0) return;
    setShippingLoading(true);
    try {
      const res = await apiFetch("/ecommerce/shipping/calculate", {
        method: "POST",
        body: JSON.stringify({
          zipcode: zipcode,
          items: items.map(item => ({
            id: item.id,
            type: item.type || 'product',
            quantity: item.quantity
          }))
        })
      });
      if (res.data && Array.isArray(res.data)) {
        setShippingOptions(res.data);
        if (res.data.length > 0) {
          setSelectedOption(res.data[0]); // Autoseleciona a opção mais barata
        }
      } else {
        setShippingOptions([]);
        setSelectedOption(null);
      }
    } catch (error) {
      console.error("Error loading shipping rates", error);
      toast.error("Erro ao calcular o frete para este CEP.");
      setShippingOptions([]);
      setSelectedOption(null);
    } finally {
      setShippingLoading(false);
    }
  };

  useEffect(() => {
    setMounted(true);
  }, []);
  
  const [newAddress, setNewAddress] = useState({
    label: "Casa",
    recipient_name: "",
    cpf: "",
    phone: "",
    cep: "",
    street: "",
    number: "",
    complement: "",
    neighborhood: "",
    city: "",
    state: "",
    is_default: false
  });

  const [formData, setFormData] = useState({
    payment_method: "credit_card",
  });

  // Pre-fill address fields when newAddress form opens
  useEffect(() => {
    if (showNewAddressForm && user) {
      setNewAddress(prev => ({
        ...prev,
        recipient_name: prev.recipient_name || user.name || "",
        cpf: prev.cpf || (user as any).cpf || "",
        phone: prev.phone || (user as any).phone || (user as any).whatsapp || ""
      }));
    }
  }, [showNewAddressForm, user]);

  // Redirect if cart is empty
  useEffect(() => {
    if (items.length === 0 && step !== 3) {
      router.push("/produtos");
    }
  }, [items, step, router]);

  // Load addresses
  useEffect(() => {
    async function loadAddresses() {
      try {
        const response = await addressService.getAddresses();
        setAddresses(response.data);
        
        // Auto-select default address
        const defaultAddr = response.data.find((a: Address) => a.is_default);
        if (defaultAddr) {
          setSelectedAddressId(defaultAddr.id);
        } else if (response.data.length > 0) {
          setSelectedAddressId(response.data[0].id);
        } else {
          setShowNewAddressForm(true);
        }
      } catch (error) {
        console.error("Error loading addresses", error);
      }
    }
    loadAddresses();
  }, []);

  // Monitorar seleção de endereço para calcular frete
  useEffect(() => {
    if (selectedAddressId && addresses.length > 0) {
      const addr = addresses.find(a => a.id === selectedAddressId);
      if (addr && addr.cep) {
        loadShippingRates(addr.cep);
      }
    } else {
      setShippingOptions([]);
      setSelectedOption(null);
    }
  }, [selectedAddressId, addresses]);

  const handleCepLookup = async (rawCep: string) => {
    const formatted = formatCEP(rawCep);
    const cleaned = rawCep.replace(/\D/g, '');
    setNewAddress(prev => ({ ...prev, cep: formatted }));
    
    if (cleaned.length === 8) {
      const data = await getCEP(cleaned);
      if (data) {
        setNewAddress(prev => ({
          ...prev,
          cep: formatted,
          street: data.logradouro,
          neighborhood: data.bairro,
          city: data.localidade,
          state: data.uf
        }));
        toast.success("Endereço encontrado!");
      }
    }
  };

  const handleSaveNewAddress = async () => {
    if (!newAddress.recipient_name.trim()) {
      toast.error("Nome do destinatário é obrigatório");
      return;
    }
    const cleanCpf = removeFormat(newAddress.cpf);
    if (cleanCpf.length !== 11) {
      toast.error("CPF deve conter exatamente 11 dígitos");
      return;
    }
    const cleanPhone = removeFormat(newAddress.phone);
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      toast.error("Telefone deve conter 10 ou 11 dígitos");
      return;
    }
    const cleanCep = removeFormat(newAddress.cep);
    if (cleanCep.length !== 8) {
      toast.error("CEP inválido");
      return;
    }

    setLoading(true);
    try {
      const payload = {
        label: newAddress.label,
        recipient_name: newAddress.recipient_name,
        cpf: cleanCpf,
        phone: cleanPhone,
        zipcode: cleanCep,
        cep: cleanCep,
        street: newAddress.street,
        number: newAddress.number,
        complement: newAddress.complement,
        neighborhood: newAddress.neighborhood,
        city: newAddress.city,
        state: newAddress.state,
        is_default: newAddress.is_default
      };

      const response = await addressService.createAddress(payload as any);
      const created = response.data;
      setAddresses(prev => [...prev, created]);
      setSelectedAddressId(created.id);
      setShowNewAddressForm(false);
      toast.success("Endereço salvo com sucesso!");
      
      // Reset form
      setNewAddress({
        label: "Casa",
        recipient_name: "",
        cpf: "",
        phone: "",
        cep: "",
        street: "",
        number: "",
        complement: "",
        neighborhood: "",
        city: "",
        state: "",
        is_default: false
      });
    } catch (error: any) {
      toast.error(error.message || "Erro ao salvar endereço");
    } finally {
      setLoading(false);
    }
  };

  const handleFinishOrder = async () => {
    if (!selectedAddressId) {
      toast.error("Por favor, selecione um endereço de entrega");
      return;
    }

    setLoading(true);
    try {
      const selectedAddr = addresses.find(a => a.id === selectedAddressId);
      const addressString = `${selectedAddr?.street}, ${selectedAddr?.number} ${selectedAddr?.complement ? `- ${selectedAddr.complement}` : ''}, ${selectedAddr?.neighborhood}, ${selectedAddr?.city} - ${selectedAddr?.state} | CEP: ${selectedAddr?.cep}`;

      const orderData = {
        items: items.map(item => ({
          id: item.id,
          type: item.type || 'product',
          quantity: item.quantity
        })),
        shipping_address: addressString,
        shipping_method: selectedOption ? `${selectedOption.company?.name} - ${selectedOption.name}` : undefined,
        shipping_cost: selectedOption ? selectedOption.price : 0,
        payment_method: formData.payment_method
      };

      const res = await apiFetch("/ecommerce/orders", {
        method: "POST",
        body: JSON.stringify(orderData)
      });

      const order = res.data;
      setCreatedOrder(order);

      toast.success("Pedido realizado com sucesso! 🌿");

      // Redirecionamento automático se for Cartão de Crédito
      if (formData.payment_method === "credit_card" && order?.payment_link) {
        toast.info("Redirecionando para o pagamento seguro...");
        setTimeout(() => {
          window.location.href = order.payment_link;
        }, 1500);
      }

      setStep(3);
      clearCart();
    } catch (error: any) {
      toast.error(error.message || "Erro ao processar pedido");
    } finally {
      setLoading(false);
    }
  };

  if (!mounted) {
    return (
      <div className="container mx-auto px-6 py-12 flex items-center justify-center min-h-[50vh] bg-cream/20">
        <div className="animate-pulse space-y-6 w-full max-w-4xl grid grid-cols-1 lg:grid-cols-3 gap-12 pt-12">
          <div className="lg:col-span-2 space-y-6">
            <div className="h-10 bg-zinc-200 rounded-full w-1/3"></div>
            <div className="h-64 bg-zinc-200 rounded-2xl"></div>
          </div>
          <div className="space-y-6">
            <div className="h-80 bg-zinc-200 rounded-2xl"></div>
          </div>
        </div>
      </div>
    );
  }

  if (step === 3) {
    const isPix = createdOrder?.payment_method === 'pix';
    const isCc = createdOrder?.payment_method === 'credit_card';
    const isBoleto = createdOrder?.payment_method === 'boleto';

    return (
      <div className="min-h-[70vh] flex flex-col items-center justify-center p-6 space-y-8 max-w-2xl mx-auto text-center animate-in fade-in duration-500">
        <div className="w-24 h-24 bg-emerald-50 text-emerald-500 rounded-full flex items-center justify-center animate-bounce shadow-inner">
          <CheckCircle2 className="w-14 h-14" />
        </div>
        <div className="space-y-2">
          <h1 className="text-4xl font-bold font-outfit text-primary">Ritual Concluído!</h1>
          <p className="text-zinc-500 max-w-md mx-auto">
            Seu pedido <span className="font-mono font-bold text-primary">{createdOrder?.order_number || ''}</span> foi recebido com carinho. Em breve você receberá um e-mail com os detalhes do envio e o código de rastreio.
          </p>
        </div>

        {isPix && createdOrder?.payment_pix_qr && (
          <Card className="w-full border-none shadow-2xl bg-white/90 backdrop-blur-md overflow-hidden p-6 max-w-md text-left">
            <CardHeader className="pb-4 px-0">
              <CardTitle className="font-outfit text-xl text-primary flex items-center gap-2">
                <div className="px-2.5 py-1 rounded-lg bg-primary text-white flex items-center justify-center font-black text-xs">PIX</div>
                Pague com Pix
              </CardTitle>
              <CardDescription className="text-zinc-600">
                Escaneie o QR Code abaixo ou utilize a chave Copia e Cola.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6 flex flex-col items-center px-0 pb-0">
              {/* QR Code */}
              <div className="bg-white p-3 rounded-2xl border border-zinc-100 shadow-sm">
                <img 
                  src={`data:image/jpeg;base64,${createdOrder.payment_pix_qr}`} 
                  alt="QR Code Pix"
                  className="w-48 h-48 object-contain"
                />
              </div>
              
              {/* Copia e Cola */}
              <div className="w-full space-y-2">
                <Label className="text-xs text-zinc-500 uppercase font-bold tracking-wider">Código Pix Copia e Cola</Label>
                <div className="flex gap-2">
                  <Input 
                    readOnly 
                    value={createdOrder.payment_pix_code} 
                    className="h-12 border-zinc-200 bg-zinc-50 focus:ring-0 select-all font-mono text-xs"
                  />
                  <Button 
                    onClick={() => {
                      navigator.clipboard.writeText(createdOrder.payment_pix_code);
                      setCopied(true);
                      toast.success("Código Pix copiado!");
                      setTimeout(() => setCopied(false), 2000);
                    }}
                    className="h-12 px-4 bg-primary hover:bg-olive text-white shadow-md rounded-xl transition-all"
                  >
                    {copied ? "Copiado!" : "Copiar"}
                  </Button>
                </div>
              </div>

              <div className="bg-amber-50/50 p-4 rounded-xl border border-amber-100 flex gap-3 w-full">
                <span className="text-amber-500 font-bold shrink-0">🕒</span>
                <p className="text-[11px] text-amber-800 leading-relaxed">
                  Aprovação imediata. O Pix expira em 24 horas. Seu estoque está garantido até lá!
                </p>
              </div>
            </CardContent>
          </Card>
        )}

        {isBoleto && createdOrder?.payment_pix_code && (
          <Card className="w-full border-none shadow-2xl bg-white/90 backdrop-blur-md overflow-hidden p-6 max-w-md text-left">
            <CardHeader className="pb-4 px-0">
              <CardTitle className="font-outfit text-xl text-primary flex items-center gap-2">
                <div className="px-2.5 py-1 rounded-lg bg-primary text-white flex items-center justify-center font-black text-xs">BOLETO</div>
                Pague com Boleto
              </CardTitle>
              <CardDescription className="text-zinc-600">
                Copie o código de barras abaixo ou baixe o PDF do boleto.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6 flex flex-col items-center px-0 pb-0">
              {/* Código de barras */}
              <div className="w-full space-y-2">
                <Label className="text-xs text-zinc-500 uppercase font-bold tracking-wider">Linha Digitável / Código de Barras</Label>
                <div className="flex gap-2">
                  <Input 
                    readOnly 
                    value={createdOrder.payment_pix_code} 
                    className="h-12 border-zinc-200 bg-zinc-50 focus:ring-0 select-all font-mono text-xs"
                  />
                  <Button 
                    onClick={() => {
                      navigator.clipboard.writeText(createdOrder.payment_pix_code);
                      setCopied(true);
                      toast.success("Código de barras copiado!");
                      setTimeout(() => setCopied(false), 2000);
                    }}
                    className="h-12 px-4 bg-primary hover:bg-olive text-white shadow-md rounded-xl transition-all"
                  >
                    {copied ? "Copiado!" : "Copiar"}
                  </Button>
                </div>
              </div>

              {/* Download PDF button */}
              {createdOrder.payment_link && (
                <Button 
                  onClick={() => window.open(createdOrder.payment_link, '_blank')}
                  className="w-full h-12 bg-primary hover:bg-olive text-white font-medium rounded-xl flex items-center justify-center gap-2 transition-all"
                >
                  Visualizar / Imprimir Boleto PDF
                </Button>
              )}

              <div className="bg-amber-50/50 p-4 rounded-xl border border-amber-100 flex gap-3 w-full">
                <span className="text-amber-500 font-bold shrink-0">🕒</span>
                <p className="text-[11px] text-amber-800 leading-relaxed">
                  Compensação em até 2 dias úteis após o pagamento. O boleto vence em 3 dias.
                </p>
              </div>
            </CardContent>
          </Card>
        )}

        {isCc && createdOrder?.payment_link && (
          <Card className="w-full border-none shadow-2xl bg-white/90 backdrop-blur-md overflow-hidden p-6 max-w-md text-left">
            <CardHeader className="pb-4 px-0">
              <CardTitle className="font-outfit text-xl text-primary flex items-center gap-2">
                <CreditCard className="w-5 h-5" />
                Pagamento Pendente
              </CardTitle>
              <CardDescription className="text-zinc-600">
                Se você não foi redirecionado, use o botão seguro abaixo para pagar no Mercado Pago.
              </CardDescription>
            </CardHeader>
            <CardContent className="px-0 pb-0">
              <Button 
                onClick={() => window.location.href = createdOrder.payment_link}
                className="w-full h-14 bg-primary hover:bg-olive text-lg shadow-lg rounded-xl flex items-center justify-center gap-2 text-white"
              >
                Efetuar Pagamento <ChevronRight className="w-5 h-5" />
              </Button>
            </CardContent>
          </Card>
        )}

        <Button onClick={() => router.push("/")} className="bg-primary hover:bg-olive px-10 h-14 rounded-full text-lg shadow-lg transition-all hover:scale-105">
          Voltar para o Início
        </Button>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-6 py-12 bg-cream/20">
      <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        {/* Main Checkout Form */}
        <div className="lg:col-span-2 space-y-8">
          <div className="flex items-center gap-6 mb-12">
            <div className="flex items-center gap-2">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all ${step >= 1 ? 'bg-primary text-white shadow-lg' : 'bg-zinc-200 text-zinc-500'}`}>1</div>
              <span className={`font-medium ${step >= 1 ? 'text-primary' : 'text-zinc-400'}`}>Entrega</span>
            </div>
            <div className="h-[2px] w-12 bg-zinc-200" />
            <div className="flex items-center gap-2">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all ${step >= 2 ? 'bg-primary text-white shadow-lg' : 'bg-zinc-200 text-zinc-500'}`}>2</div>
              <span className={`font-medium ${step >= 2 ? 'text-primary' : 'text-zinc-400'}`}>Pagamento</span>
            </div>
          </div>

          {step === 1 ? (
            <div className="space-y-6 animate-in fade-in slide-in-from-left-4 duration-500">
              <Card className="border-none shadow-2xl bg-white/80 backdrop-blur-md overflow-hidden">
                <CardHeader className="bg-primary/5 pb-8">
                  <div className="flex justify-between items-center">
                    <CardTitle className="flex items-center gap-3 font-outfit text-3xl text-primary">
                      <MapPinned className="w-8 h-8" /> Onde entregamos seu ritual?
                    </CardTitle>
                    {addresses.length > 0 && !showNewAddressForm && (
                      <Button variant="outline" size="sm" onClick={() => setShowNewAddressForm(true)} className="border-primary text-primary hover:bg-primary/10 rounded-full">
                        <Plus className="w-4 h-4 mr-1" /> Novo Endereço
                      </Button>
                    )}
                  </div>
                  <CardDescription className="text-zinc-600 mt-2">
                    Escolha um endereço salvo ou cadastre um novo para entrega.
                  </CardDescription>
                </CardHeader>
                
                <CardContent className="pt-8">
                  {showNewAddressForm ? (
                    <div className="space-y-6 animate-in zoom-in-95 duration-300">
                      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <div className="grid gap-2">
                          <Label htmlFor="cep">CEP</Label>
                          <Input 
                            id="cep" 
                            placeholder="00000-000" 
                            maxLength={9}
                            value={newAddress.cep}
                            onChange={(e) => handleCepLookup(e.target.value)}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                        <div className="sm:col-span-2 grid gap-2">
                          <Label htmlFor="label">Apelido do Endereço</Label>
                          <div className="flex gap-2">
                            {["Casa", "Trabalho", "Outro"].map((l) => (
                              <Button 
                                key={l}
                                type="button"
                                variant={newAddress.label === l ? "default" : "outline"}
                                className={`flex-1 h-12 rounded-xl transition-all ${newAddress.label === l ? 'bg-primary text-white' : 'border-zinc-200'}`}
                                onClick={() => setNewAddress({...newAddress, label: l})}
                              >
                                {l === "Casa" && <Home className="w-4 h-4 mr-2" />}
                                {l === "Trabalho" && <Briefcase className="w-4 h-4 mr-2" />}
                                {l}
                              </Button>
                            ))}
                          </div>
                        </div>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <div className="sm:col-span-1 grid gap-2">
                          <Label htmlFor="recipient_name">Destinatário</Label>
                          <Input 
                            id="recipient_name" 
                            placeholder="Nome de quem recebe" 
                            value={newAddress.recipient_name}
                            onChange={(e) => setNewAddress({...newAddress, recipient_name: e.target.value})}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                        <div className="grid gap-2">
                          <Label htmlFor="cpf">CPF para Nota Fiscal</Label>
                          <Input 
                            id="cpf" 
                            placeholder="000.000.000-00" 
                            maxLength={14}
                            value={newAddress.cpf}
                            onChange={(e) => setNewAddress({...newAddress, cpf: formatCPF(e.target.value)})}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                        <div className="grid gap-2">
                          <Label htmlFor="phone">Telefone / WhatsApp</Label>
                          <Input 
                            id="phone" 
                            placeholder="(00) 00000-0000" 
                            maxLength={15}
                            value={newAddress.phone}
                            onChange={(e) => setNewAddress({...newAddress, phone: formatWhatsApp(e.target.value)})}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-4 gap-6">
                        <div className="sm:col-span-3 grid gap-2">
                          <Label htmlFor="street">Rua / Logradouro</Label>
                          <Input id="street" value={newAddress.street} readOnly className="bg-zinc-50 h-12" />
                        </div>
                        <div className="grid gap-2">
                          <Label htmlFor="number">Número</Label>
                          <Input 
                            id="number" 
                            placeholder="123" 
                            value={newAddress.number}
                            onChange={(e) => setNewAddress({...newAddress, number: e.target.value})}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <div className="grid gap-2">
                          <Label htmlFor="complement">Complemento</Label>
                          <Input 
                            id="complement" 
                            placeholder="Apt, Bloco, etc. (Opcional)" 
                            value={newAddress.complement}
                            onChange={(e) => setNewAddress({...newAddress, complement: e.target.value})}
                            className="h-12 border-zinc-200 focus:ring-primary"
                          />
                        </div>
                        <div className="grid gap-2">
                          <Label htmlFor="neighborhood">Bairro</Label>
                          <Input id="neighborhood" value={newAddress.neighborhood} readOnly className="bg-zinc-50 h-12" />
                        </div>
                        <div className="grid gap-2">
                          <Label htmlFor="city">Cidade / UF</Label>
                          <Input id="city" value={newAddress.city ? `${newAddress.city} - ${newAddress.state}` : ''} readOnly className="bg-zinc-50 h-12" />
                        </div>
                      </div>

                      <div className="flex items-center space-x-2 pt-2">
                        <Checkbox 
                          id="is_default" 
                          checked={newAddress.is_default}
                          onCheckedChange={(checked) => setNewAddress({...newAddress, is_default: !!checked})}
                        />
                        <Label htmlFor="is_default" className="text-sm text-zinc-600 font-medium cursor-pointer">Definir como endereço padrão</Label>
                      </div>

                      <div className="flex gap-4 pt-4">
                        <Button 
                          onClick={handleSaveNewAddress} 
                          disabled={loading || !newAddress.number || !newAddress.cep || !newAddress.recipient_name || !newAddress.cpf || !newAddress.phone}
                          className="flex-1 h-14 bg-primary hover:bg-olive text-lg shadow-lg"
                        >
                          {loading ? "Salvando..." : "Salvar e Continuar"}
                        </Button>
                        {addresses.length > 0 && (
                          <Button variant="ghost" onClick={() => setShowNewAddressForm(false)} className="h-14 text-zinc-500">
                            Cancelar
                          </Button>
                        )}
                      </div>
                    </div>
                  ) : (
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      {addresses.map((addr) => (
                        <div 
                          key={addr.id}
                          onClick={() => setSelectedAddressId(addr.id)}
                          className={`p-6 rounded-2xl border-2 cursor-pointer transition-all hover:shadow-md ${selectedAddressId === addr.id ? 'border-primary bg-primary/5' : 'border-zinc-100 hover:border-zinc-200'}`}
                        >
                          <div className="flex justify-between items-start mb-3">
                            <div className="flex items-center gap-2">
                              {addr.label === "Casa" ? <Home className="w-5 h-5 text-primary" /> : <Briefcase className="w-5 h-5 text-primary" />}
                              <span className="font-bold text-zinc-800">{addr.label}</span>
                            </div>
                            {addr.is_default && <Badge variant="secondary" className="bg-primary/10 text-primary text-[10px]">Padrão</Badge>}
                          </div>
                           <p className="text-sm text-zinc-600 leading-relaxed">
                            {addr.recipient_name && <span className="font-semibold block text-zinc-800 mb-1">{addr.recipient_name}</span>}
                            {addr.street}, {addr.number}<br />
                            {addr.neighborhood}<br />
                            {addr.city} - {addr.state}
                          </p>
                        </div>
                      ))}
                    </div>
                  )}

                  {/* Opções de Frete */}
                  {!showNewAddressForm && selectedAddressId && (
                    <div className="mt-8 pt-8 border-t border-zinc-100 space-y-4">
                      <h3 className="font-outfit text-xl font-bold text-primary flex items-center gap-2">
                        🚚 Escolha a forma de envio
                      </h3>
                      
                      {shippingLoading ? (
                        <div className="space-y-3">
                          <div className="h-16 bg-zinc-50 rounded-2xl animate-pulse border border-zinc-100 flex items-center px-4 justify-between">
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-6 bg-zinc-200 rounded"></div>
                              <div className="space-y-2">
                                <div className="h-4 bg-zinc-200 rounded w-28"></div>
                                <div className="h-3 bg-zinc-200 rounded w-36"></div>
                              </div>
                            </div>
                            <div className="h-5 bg-zinc-200 rounded w-14"></div>
                          </div>
                          <div className="h-16 bg-zinc-50 rounded-2xl animate-pulse border border-zinc-100 flex items-center px-4 justify-between">
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-6 bg-zinc-200 rounded"></div>
                              <div className="space-y-2">
                                <div className="h-4 bg-zinc-200 rounded w-28"></div>
                                <div className="h-3 bg-zinc-200 rounded w-36"></div>
                              </div>
                            </div>
                            <div className="h-5 bg-zinc-200 rounded w-14"></div>
                          </div>
                        </div>
                      ) : shippingOptions.length > 0 ? (
                        <div className="grid grid-cols-1 gap-3">
                          {shippingOptions.map((opt) => {
                            const isSelected = selectedOption?.id === opt.id && selectedOption?.name === opt.name;
                            return (
                              <div
                                key={opt.id + opt.name}
                                onClick={() => setSelectedOption(opt)}
                                className={`flex items-center justify-between p-4 rounded-xl border-2 cursor-pointer transition-all hover:bg-zinc-50 ${isSelected ? 'border-primary bg-primary/5 shadow-sm' : 'border-zinc-100 hover:border-zinc-200'}`}
                              >
                                <div className="flex items-center gap-3">
                                  {opt.company?.picture ? (
                                    <img src={opt.company.picture} alt={opt.company.name} className="w-10 h-6 object-contain" />
                                  ) : (
                                    <span className="text-xl">📦</span>
                                  )}
                                  <div>
                                    <p className="font-bold text-zinc-800 text-sm">{opt.company?.name} - {opt.name}</p>
                                    <p className="text-xs text-zinc-500">Prazo estimado: {opt.delivery_time} {opt.delivery_time === 1 ? 'dia útil' : 'dias úteis'}</p>
                                  </div>
                                </div>
                                <span className="font-bold text-primary">R$ {opt.price.toFixed(2)}</span>
                              </div>
                            );
                          })}
                        </div>
                      ) : (
                        <div className="p-4 rounded-xl bg-amber-50/50 border border-amber-100 text-amber-800 text-sm">
                          Nenhuma opção de entrega disponível para este CEP.
                        </div>
                      )}
                    </div>
                  )}

                  {!showNewAddressForm && (
                    <Button 
                      onClick={() => setStep(2)} 
                      disabled={!selectedAddressId || shippingLoading || !selectedOption}
                      className="w-full h-14 mt-8 bg-primary hover:bg-olive gap-2 text-lg rounded-xl shadow-xl transition-all"
                    >
                      Continuar para Pagamento <ChevronRight className="w-5 h-5" />
                    </Button>
                  )}
                </CardContent>
              </Card>
            </div>
          ) : (
            <Card className="border-none shadow-2xl bg-white/80 backdrop-blur-md animate-in fade-in slide-in-from-right-4 duration-500">
              <CardHeader className="bg-primary/5 pb-8">
                <CardTitle className="flex items-center gap-3 font-outfit text-3xl text-primary">
                  <CreditCard className="w-8 h-8" /> Escolha o pagamento
                </CardTitle>
                <CardDescription className="text-zinc-600 mt-2">
                  Ambiente seguro e criptografado.
                </CardDescription>
              </CardHeader>
              <CardContent className="pt-8 space-y-8">
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                  {/* Cartão de Crédito */}
                  <button 
                    onClick={() => setFormData({...formData, payment_method: "credit_card"})}
                    className={`p-6 rounded-2xl border-2 text-left transition-all hover:shadow-lg flex flex-col justify-between min-h-[175px] ${formData.payment_method === "credit_card" ? 'border-primary bg-primary/5 scale-[1.02] shadow-sm' : 'border-zinc-100'}`}
                  >
                    <div>
                      <CreditCard className={`w-8 h-8 mb-4 ${formData.payment_method === "credit_card" ? 'text-primary' : 'text-zinc-300'}`} />
                      <p className="font-bold text-lg mb-1">Cartão de Crédito</p>
                      <p className="text-xs text-zinc-500">Até 12x sem juros</p>
                    </div>
                    {/* Bandeiras de Cartão */}
                    <div className="flex flex-wrap gap-1 mt-4">
                      <span className="text-[9px] font-extrabold italic text-blue-800 bg-zinc-50 border border-zinc-200 rounded px-1.5 py-0.5 leading-none shadow-sm select-none">VISA</span>
                      <div className="flex items-center gap-0.5 bg-zinc-50 border border-zinc-200 rounded px-1.5 py-0.5 shadow-sm select-none">
                        <div className="w-2 h-2 rounded-full bg-[#EB001B]"></div>
                        <div className="w-2 h-2 rounded-full bg-[#F79E1B] -ml-1 opacity-90"></div>
                        <span className="text-[8px] font-bold text-zinc-500 -mt-0.5 font-sans tracking-tight">MC</span>
                      </div>
                      <span className="text-[9px] font-black italic text-zinc-800 bg-zinc-50 border border-zinc-200 rounded px-1.5 py-0.5 leading-none shadow-sm select-none">ELO</span>
                      <span className="text-[9px] font-extrabold text-white bg-sky-500 border border-sky-600 rounded px-1 py-0.5 leading-none shadow-sm select-none">AMEX</span>
                      <span className="text-[9px] font-bold text-white bg-red-600 border border-red-700 rounded px-1 py-0.5 leading-none shadow-sm select-none">HIPER</span>
                    </div>
                  </button>

                  {/* PIX */}
                  <button 
                    onClick={() => setFormData({...formData, payment_method: "pix"})}
                    className={`p-6 rounded-2xl border-2 text-left transition-all hover:shadow-lg flex flex-col justify-between min-h-[175px] ${formData.payment_method === "pix" ? 'border-primary bg-primary/5 scale-[1.02] shadow-sm' : 'border-zinc-100'}`}
                  >
                    <div>
                      <div className="mb-4">
                        <svg className={`w-8 h-8 ${formData.payment_method === "pix" ? 'text-primary' : 'text-zinc-300'}`} viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M256 0C114.6 0 0 114.6 0 256s114.6 256 256 256 256-114.6 256-256S397.4 0 256 0zm97.7 205.8l-80.1 80.1c-4.4 4.4-11.5 4.4-15.9 0l-44.5-44.5-44.5 44.5c-4.4 4.4-11.5 4.4-15.9 0l-80.1-80.1c-4.4-4.4-4.4-11.5 0-15.9l80.1-80.1c4.4-4.4 11.5-4.4 15.9 0l44.5 44.5 44.5-44.5c4.4-4.4 11.5-4.4 15.9 0l80.1 80.1c4.4 4.4 4.4 11.5 0 15.9zm0 132.8l-80.1 80.1c-4.4 4.4-11.5 4.4-15.9 0l-44.5-44.5-44.5 44.5c-4.4 4.4-11.5 4.4-15.9 0l-80.1-80.1c-4.4-4.4-4.4-11.5 0-15.9l80.1-80.1c4.4-4.4 11.5-4.4 15.9 0l44.5 44.5 44.5-44.5c4.4-4.4 11.5-4.4 15.9 0l80.1 80.1c4.4 4.4 4.4 11.5 0 15.9z" fill="currentColor"/>
                        </svg>
                      </div>
                      <p className="font-bold text-lg mb-1">PIX Instantâneo</p>
                      <p className="text-xs text-zinc-500">Aprovação imediata</p>
                    </div>
                    <div className="flex gap-1 mt-4">
                      <span className="text-[9px] font-black text-emerald-700 bg-emerald-50 border border-emerald-200 rounded px-2 py-0.5 leading-none shadow-sm select-none tracking-widest uppercase">PIX</span>
                      <span className="text-[9px] font-medium text-emerald-800 bg-emerald-50/50 border border-emerald-100 rounded px-1.5 py-0.5 leading-none select-none">Liberação Rápida</span>
                    </div>
                  </button>

                  {/* Boleto */}
                  <button 
                    onClick={() => setFormData({...formData, payment_method: "boleto"})}
                    className={`p-6 rounded-2xl border-2 text-left transition-all hover:shadow-lg flex flex-col justify-between min-h-[175px] ${formData.payment_method === "boleto" ? 'border-primary bg-primary/5 scale-[1.02] shadow-sm' : 'border-zinc-100'}`}
                  >
                    <div>
                      <div className="mb-4">
                        <svg className={`w-8 h-8 ${formData.payment_method === "boleto" ? 'text-primary' : 'text-zinc-300'}`} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" xmlns="http://www.w3.org/2000/svg">
                          <line x1="3" y1="5" x2="3" y2="19" />
                          <line x1="6" y1="5" x2="6" y2="19" />
                          <line x1="10" y1="5" x2="10" y2="19" />
                          <line x1="14" y1="5" x2="14" y2="19" />
                          <line x1="18" y1="5" x2="18" y2="19" />
                          <line x1="21" y1="5" x2="21" y2="19" />
                        </svg>
                      </div>
                      <p className="font-bold text-lg mb-1">Boleto Bancário</p>
                      <p className="text-xs text-zinc-500">Compensação em 1-2 dias</p>
                    </div>
                    <div className="flex gap-1 mt-4">
                      <span className="text-[9px] font-black text-amber-700 bg-amber-50 border border-amber-200 rounded px-2 py-0.5 leading-none shadow-sm select-none tracking-widest uppercase">BOLETO</span>
                      <span className="text-[9px] font-medium text-amber-800 bg-amber-50/50 border border-amber-100 rounded px-1.5 py-0.5 leading-none select-none">Qualquer Banco</span>
                    </div>
                  </button>
                </div>

                <div className="space-y-4 pt-4">
                  <Button 
                    onClick={handleFinishOrder} 
                    disabled={loading}
                    className="w-full h-16 bg-primary hover:bg-olive text-xl font-bold rounded-2xl shadow-2xl transition-all hover:scale-[1.01]"
                  >
                    {loading ? "Processando..." : `Finalizar Pedido (R$ ${grandTotal.toFixed(2)})`}
                  </Button>
                  
                  {/* Mercado Pago Trust Badge / SSL */}
                  <div className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2 pt-4 border-t border-dashed border-zinc-100 text-xs text-zinc-400 select-none">
                    <span className="flex items-center gap-1.5">
                      <span className="text-emerald-500 font-bold">✓</span> Pagamento processado pelo
                    </span>
                    <div className="flex items-center gap-1 bg-zinc-50 px-2.5 py-1 rounded-full border border-zinc-100 font-outfit shadow-sm">
                      <span className="font-bold text-zinc-400 text-[10px] tracking-wider uppercase">Mercado</span>
                      <span className="font-black text-[#009EE3] text-[10px] tracking-wider uppercase">Pago</span>
                    </div>
                    <span className="hidden sm:inline text-zinc-200">|</span>
                    <span className="flex items-center gap-1">
                      🔒 Conexão SSL Criptografada
                    </span>
                  </div>

                  <button 
                    onClick={() => setStep(1)}
                    className="w-full text-sm text-zinc-400 hover:text-primary transition-colors flex items-center justify-center gap-1 pt-2"
                  >
                    <ChevronRight className="w-4 h-4 rotate-180" /> Alterar endereço de entrega
                  </button>
                </div>
              </CardContent>
            </Card>
          )}
        </div>

        {/* Order Summary Sidebar */}
        <div className="space-y-6 lg:sticky lg:top-28 h-fit">
          {/* Card de Embalagens de Presente */}
          {dbProducts.length > 0 && (
            <Card className="border-none shadow-xl bg-white/90 backdrop-blur-sm overflow-hidden border border-primary/10">
              <CardHeader className="border-b border-zinc-100 py-5">
                <CardTitle className="font-outfit text-lg flex items-center gap-2 text-primary">
                  🎁 Quer enviar como Presente?
                </CardTitle>
                <CardDescription className="text-xs">
                  Adicione uma embalagem especial ao seu ritual.
                </CardDescription>
              </CardHeader>
              <CardContent className="pt-5 space-y-4">
                {sacolaProduct && (
                  <div className="flex items-start gap-3">
                    <Checkbox 
                      id="packaging-bag" 
                      checked={items.some(i => i.slug === 'embalagem-presente-sacola')}
                      onCheckedChange={handleToggleBag}
                    />
                    <div className="grid gap-1 leading-none text-left">
                      <label
                        htmlFor="packaging-bag"
                        className="text-sm font-bold text-zinc-800 cursor-pointer hover:text-primary transition-colors"
                      >
                        Sacolinha de Presente Kraft (+ R$ {parseFloat(sacolaProduct.price).toFixed(2)})
                      </label>
                      <p className="text-[11px] text-zinc-500">
                        Sacola Kraft premium decorada com fita de cetim e tag da vovó.
                      </p>
                    </div>
                  </div>
                )}
                
                {sacolaProduct && cestaProduct && <Separator className="bg-zinc-100/60" />}
                
                {cestaProduct && (
                  <div className="flex items-start gap-3">
                    <Checkbox 
                      id="packaging-basket" 
                      checked={items.some(i => i.slug === 'embalagem-presente-cesta')}
                      onCheckedChange={handleToggleBasket}
                    />
                    <div className="grid gap-1 leading-none text-left">
                      <label
                        htmlFor="packaging-basket"
                        className="text-sm font-bold text-zinc-800 cursor-pointer hover:text-primary transition-colors"
                      >
                        Cesta Especial Decorada (+ R$ {parseFloat(cestaProduct.price).toFixed(2)})
                      </label>
                      <p className="text-[11px] text-zinc-500">
                        Cesta especial com palha, laço de cetim e flores desidratadas.
                      </p>
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          <Card className="border-none shadow-xl bg-white/90 backdrop-blur-sm overflow-hidden">
            <CardHeader className="border-b border-zinc-100 py-6">
              <CardTitle className="font-outfit text-xl flex items-center gap-2">
                <ShoppingBag className="w-5 h-5 text-primary" /> Seu Carrinho
              </CardTitle>
            </CardHeader>
            <CardContent className="pt-6 space-y-6">
              <div className="max-h-[350px] overflow-y-auto space-y-5 pr-2 scrollbar-thin scrollbar-thumb-zinc-200">
                {items.map((item) => (
                  <div key={`${item.type}-${item.id}`} className="flex gap-4 group">
                    <div className="w-16 h-16 bg-cream/30 rounded-xl flex items-center justify-center text-2xl shadow-inner group-hover:scale-105 transition-transform">
                      {item.type === 'kit' ? '🎁' : '🌿'}
                    </div>
                    <div className="flex-1 flex flex-col justify-center">
                      <p className="font-bold text-zinc-800 line-clamp-1">{item.name}</p>
                      <div className="flex justify-between items-center mt-1">
                        <span className="text-xs px-2 py-0.5 bg-zinc-100 text-zinc-500 rounded-full">{item.quantity}x</span>
                        <span className="font-medium text-primary">R$ {(item.price * item.quantity).toFixed(2)}</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
              
              <Separator className="bg-zinc-100" />
              
              <div className="space-y-3">
                <div className="flex justify-between text-sm">
                  <span className="text-zinc-500 font-medium">Subtotal</span>
                  <span className="text-zinc-700">R$ {total.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-sm items-center">
                  <span className="text-zinc-500 font-medium">Frete</span>
                  {selectedOption ? (
                    <span className="text-zinc-700 font-medium text-xs">
                      R$ {selectedOption.price.toFixed(2)} <span className="text-zinc-400 text-[10px]">({selectedOption.company?.name})</span>
                    </span>
                  ) : (
                    <span className="text-zinc-400 text-xs italic">A calcular 🚚</span>
                  )}
                </div>
                <div className="flex justify-between pt-4 border-t border-dashed border-zinc-200 mt-4">
                  <span className="font-outfit text-lg font-bold text-zinc-900">Total</span>
                  <div className="text-right">
                    <span className="block font-outfit text-3xl font-black text-primary leading-none">R$ {grandTotal.toFixed(2)}</span>
                    <span className="text-[10px] text-zinc-400 uppercase tracking-widest mt-1 block">Pagamento Protegido</span>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
          
          <div className="bg-emerald-50/50 p-6 rounded-2xl border border-emerald-100 flex gap-4 shadow-sm animate-pulse">
            <CheckCircle2 className="w-6 h-6 text-emerald-500 shrink-0" />
            <div>
              <p className="text-xs text-emerald-800 font-bold mb-1">Satisfação Garantida</p>
              <p className="text-[11px] text-emerald-700 leading-relaxed">
                Cada produto é preparado artesanalmente com ervas selecionadas. Sua satisfação é nosso maior ritual.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// Badge component definition if not exists in UI
function Badge({ children, className, variant }: { children: React.ReactNode, className?: string, variant?: string }) {
  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full font-medium ${className}`}>
      {children}
    </span>
  );
}
