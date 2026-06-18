"use client";

import { useEffect, useState } from "react";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { authService } from "@/modules/auth/services/auth";
import { apiFetch } from "@/services/api";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle, CardDescription, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast, Toaster } from "sonner";
import { 
  ShoppingBag, LogOut, Package, Clock, ChevronRight, User, 
  MapPin, Edit2, ShieldAlert, Plus, Trash2, Camera, MapPinned, 
  KeyRound, Check, Home, Landmark, Eye, EyeOff
} from "lucide-react";

export default function ProfilePage() {
  const router = useRouter();
  const { user, logout, isAuthenticated, setAuth } = useAuthStore();
  
  // Tabs State
  const [activeTab, setActiveTab] = useState<"orders" | "details" | "addresses">("orders");

  // Orders State
  const [orders, setOrders] = useState<any[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(true);

  // Profile Form State
  const [profileName, setProfileName] = useState("");
  const [profileEmail, setProfileEmail] = useState("");
  const [profileWhatsapp, setProfileWhatsapp] = useState("");
  const [profilePassword, setProfilePassword] = useState("");
  const [profilePasswordConfirm, setProfilePasswordConfirm] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [profileAvatar, setProfileAvatar] = useState("");
  const [profileLoading, setProfileLoading] = useState(false);
  const [uploadingAvatar, setUploadingAvatar] = useState(false);

  // Estados para enquadramento (Crop)
  const [cropImageSrc, setCropImageSrc] = useState<string | null>(null);
  const [cropPosition, setCropPosition] = useState({ x: 0, y: 0 });
  const [cropZoom, setCropZoom] = useState(1);
  const [isDragging, setIsDragging] = useState(false);
  const [dragStart, setDragStart] = useState({ x: 0, y: 0 });
  const [cropImageFile, setCropImageFile] = useState<File | null>(null);
  const [isEditMenuOpen, setIsEditMenuOpen] = useState(false);

  // Addresses State
  const [addresses, setAddresses] = useState<any[]>([]);
  const [addressesLoading, setAddressesLoading] = useState(true);
  const [isEditingAddress, setIsEditingAddress] = useState(false);
  const [editingAddressId, setEditingAddressId] = useState<number | null>(null);

  // Address Form State
  const [addrLabel, setAddrLabel] = useState("Casa");
  const [addrRecipient, setAddrRecipient] = useState("");
  const [addrCpf, setAddrCpf] = useState("");
  const [addrPhone, setAddrPhone] = useState("");
  const [addrZipcode, setAddrZipcode] = useState("");
  const [addrStreet, setAddrStreet] = useState("");
  const [addrNumber, setAddrNumber] = useState("");
  const [addrComplement, setAddrComplement] = useState("");
  const [addrNeighborhood, setAddrNeighborhood] = useState("");
  const [addrCity, setAddrCity] = useState("");
  const [addrState, setAddrState] = useState("");
  const [addrReference, setAddrReference] = useState("");
  const [addrIsDefault, setAddrIsDefault] = useState(false);
  const [addrLoading, setAddrLoading] = useState(false);

  useEffect(() => {
    if (!isAuthenticated) {
      router.push("/login");
      return;
    }

    // Populate profile form from store
    if (user) {
      setProfileName(user.name || "");
      setProfileEmail(user.email || "");
      setProfileWhatsapp(formatPhoneString(user.whatsapp || ""));
      setProfileAvatar(user.avatar_path || "");
    }

    loadOrders();
    loadAddresses();
  }, [isAuthenticated, router, user]);

  // Loader Functions
  async function loadOrders() {
    try {
      setOrdersLoading(true);
      const response = await apiFetch("/ecommerce/orders");
      if (response && response.status === "success") {
        setOrders(response.data || []);
      }
    } catch (error) {
      console.error("Error loading orders", error);
    } finally {
      setOrdersLoading(false);
    }
  }

  async function loadAddresses() {
    try {
      setAddressesLoading(true);
      const response = await apiFetch("/ecommerce/addresses");
      if (response && response.status === "success") {
        setAddresses(response.data || []);
      }
    } catch (error) {
      console.error("Error loading addresses", error);
    } finally {
      setAddressesLoading(false);
    }
  }

  // Format Helpers
  function formatPhoneString(value: string) {
    const cleaned = value.replace(/\D/g, "");
    if (cleaned.length === 11) {
      return cleaned.replace(/^(\d{2})(\d{5})(\d{4})$/, "($1) $2-$3");
    }
    if (cleaned.length === 10) {
      return cleaned.replace(/^(\d{2})(\d{4})(\d{4})$/, "($1) $2-$3");
    }
    return value;
  }

  function handleWhatsappChange(e: React.ChangeEvent<HTMLInputElement>) {
    const cleaned = e.target.value.replace(/\D/g, "");
    if (cleaned.length <= 11) {
      setProfileWhatsapp(formatPhoneString(cleaned));
    }
  }

  function handleCpfChange(e: React.ChangeEvent<HTMLInputElement>) {
    const cleaned = e.target.value.replace(/\D/g, "");
    if (cleaned.length <= 11) {
      setAddrCpf(cleaned.replace(/^(\d{3})(\d{3})(\d{3})(\d{2})$/, "$1.$2.$3-$4"));
    }
  }

  function handlePhoneChange(e: React.ChangeEvent<HTMLInputElement>) {
    const cleaned = e.target.value.replace(/\D/g, "");
    if (cleaned.length <= 11) {
      setAddrPhone(formatPhoneString(cleaned));
    }
  }

  function handleZipcodeChange(e: React.ChangeEvent<HTMLInputElement>) {
    const cleaned = e.target.value.replace(/\D/g, "");
    if (cleaned.length <= 8) {
      setAddrZipcode(cleaned.replace(/^(\d{5})(\d{3})$/, "$1-$2"));
      
      // Auto lookup when full CEP is typed
      if (cleaned.length === 8) {
        lookupCep(cleaned);
      }
    }
  }

  // Look up Zipcode via API
  async function lookupCep(cep: string) {
    try {
      toast.info("Buscando CEP...");
      const response = await apiFetch(`/ecommerce/addresses/zipcode/${cep}`);
      if (response && response.status === "success" && response.data) {
        const { logradouro, bairro, localidade, uf } = response.data;
        setAddrStreet(logradouro || "");
        setAddrNeighborhood(bairro || "");
        setAddrCity(localidade || "");
        setAddrState(uf || "");
        toast.success("CEP localizado!");
      }
    } catch (err) {
      toast.error("CEP não localizado. Preencha manualmente.");
    }
  }

  // Profile Picture Upload Handler
  async function handleAvatarChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;

    if (file.size > 5 * 1024 * 1024) {
      toast.error("A imagem deve ter no máximo 5MB");
      return;
    }

    const reader = new FileReader();
    reader.onload = (event) => {
      if (event.target?.result) {
        setCropImageFile(file);
        setCropImageSrc(event.target.result as string);
        setCropPosition({ x: 0, y: 0 });
        setCropZoom(1);
      }
    };
    reader.readAsDataURL(file);
    // Resetar input de arquivo para que o mesmo arquivo possa ser selecionado novamente
    e.target.value = "";
  }

  // Carrega a imagem atual para enquadramento (ajuste de zoom/posição)
  async function loadExistingAvatarForCrop() {
    const url = getAvatarUrl(profileAvatar);
    if (!url) return;
    
    setUploadingAvatar(true);
    try {
      const proxyUrl = `/api/proxy-image?url=${encodeURIComponent(url)}`;
      const res = await fetch(proxyUrl);
      if (!res.ok) throw new Error("Não foi possível carregar o arquivo da imagem");
      const blob = await res.blob();
      const reader = new FileReader();
      reader.onload = (event) => {
        if (event.target?.result) {
          setCropImageFile(null); // indica que é uma imagem existente
          setCropImageSrc(event.target.result as string);
          setCropPosition({ x: 0, y: 0 });
          setCropZoom(1);
        }
      };
      reader.readAsDataURL(blob);
    } catch (err) {
      console.error("Erro ao carregar imagem existente para crop:", err);
      // Fallback: carregar diretamente da URL. Se houver erro de CORS no Canvas,
      // a mensagem no confirmCrop instruirá o usuário a subir a imagem novamente.
      setCropImageFile(null);
      setCropImageSrc(url);
      setCropPosition({ x: 0, y: 0 });
      setCropZoom(1);
    } finally {
      setUploadingAvatar(false);
    }
  }

  function handleAvatarClick() {
    // Se o usuário clicar na foto, mudamos para a aba de dados pessoais
    setActiveTab("details");
    
    if (profileAvatar) {
      setIsEditMenuOpen(true);
    } else {
      setTimeout(() => {
        document.getElementById("avatar-file-upload")?.click();
      }, 50);
    }
  }

  // Confirma o enquadramento, desenha no canvas e envia ao backend
  async function confirmCrop() {
    if (!cropImageSrc) return;

    setUploadingAvatar(true);

    try {
      // 1. Criar objeto de imagem HTML
      const img = new Image();
      // Configurar crossOrigin para evitar erros de Canvas contaminado se for URL
      if (cropImageSrc.startsWith("http")) {
        img.crossOrigin = "anonymous";
      }
      img.src = cropImageSrc;
      
      await new Promise<void>((resolve, reject) => {
        img.onload = () => resolve();
        img.onerror = () => reject(new Error("Erro ao carregar imagem no navegador."));
      });

      // 2. Criar canvas de 300x300 pixels
      const canvas = document.createElement("canvas");
      canvas.width = 300;
      canvas.height = 300;
      const ctx = canvas.getContext("2d");
      
      if (!ctx) {
        throw new Error("Erro ao obter contexto do canvas.");
      }

      // Preencher fundo com branco (evita margens pretas em JPEGs caso a imagem seja menor que o canvas)
      ctx.fillStyle = "#ffffff";
      ctx.fillRect(0, 0, 300, 300);

      // 3. Obter dimensões originais da imagem
      const wOrig = img.naturalWidth;
      const hOrig = img.naturalHeight;
      const ar = wOrig / hOrig;

      // 4. Calcular dimensões renderizadas como o navegador faz para cobrir a caixa 256x256 (Viewport)
      let imgW: number;
      let imgH: number;
      if (ar > 1) {
        // Paisagem
        imgH = 256;
        imgW = 256 * ar;
      } else {
        // Retrato
        imgW = 256;
        imgH = 256 / ar;
      }

      // Fator de escala do Viewport de visualização (256px) para o Canvas final (300px)
      const scaleFactor = 300 / 256;

      // Calcular o posicionamento do canto superior esquerdo da imagem relative ao topo-esquerdo do viewport
      const xLeft = (128 + cropPosition.x) - (imgW * cropZoom / 2);
      const yTop = (128 + cropPosition.y) - (imgH * cropZoom / 2);

      // Desenhar a imagem no canvas aplicando as escalas correspondentes
      ctx.imageSmoothingEnabled = true;
      ctx.imageSmoothingQuality = "high";
      ctx.drawImage(
        img,
        xLeft * scaleFactor,
        yTop * scaleFactor,
        imgW * cropZoom * scaleFactor,
        imgH * cropZoom * scaleFactor
      );

      // 5. Converter o canvas para Blob e fazer upload
      const blob = await new Promise<Blob | null>((resolve) => {
        canvas.toBlob((b) => resolve(b), "image/jpeg", 0.9);
      });

      if (!blob) {
        throw new Error("Erro ao gerar arquivo de imagem.");
      }

      const croppedFile = new File([blob], "avatar.jpg", { type: "image/jpeg" });
      const formData = new FormData();
      formData.append("image", croppedFile);

      const token = localStorage.getItem("auth_token");
      const response = await fetch("http://localhost:8000/api/upload", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: formData,
      });

      const data = await response.json();
      if (response.ok && data.status === "success") {
        setProfileAvatar(data.data.path);
        setCropImageSrc(null); // Fechar modal
        toast.success("Foto de perfil enquadrada com sucesso! Lembre-se de salvar suas alterações.");
      } else {
        toast.error(data.message || "Erro ao fazer upload da imagem");
      }
    } catch (err: any) {
      console.error(err);
      if (err.name === "SecurityError" || err.message?.includes("taint") || err.message?.includes("Security")) {
        toast.error("Por restrições de segurança do navegador, recortes de fotos antigas podem falhar. Por favor, selecione e envie o arquivo da foto novamente.");
      } else {
        toast.error(err.message || "Erro de conexão ao enviar imagem");
      }
    } finally {
      setUploadingAvatar(false);
    }
  }

  // Update Profile Submit
  async function handleUpdateProfile(e: React.FormEvent) {
    e.preventDefault();
    if (profilePassword && profilePassword !== profilePasswordConfirm) {
      toast.error("A confirmação da nova senha não confere.");
      return;
    }

    setProfileLoading(true);
    try {
      const payload: any = {
        name: profileName,
        email: profileEmail,
        whatsapp: profileWhatsapp,
        avatar_path: profileAvatar,
      };

      if (profilePassword) {
        payload.password = profilePassword;
        payload.password_confirmation = profilePasswordConfirm;
      }

      const response = await authService.updateProfile(payload);
      if (response && response.status === "success") {
        toast.success("Perfil atualizado com sucesso!");
        
        // Update user state in store
        if (user) {
          const updatedUser = { ...user, ...response.data };
          setAuth(updatedUser, localStorage.getItem("auth_token") || "");
        }
        
        setProfilePassword("");
        setProfilePasswordConfirm("");
      } else {
        toast.error(response.message || "Erro ao atualizar perfil.");
      }
    } catch (err: any) {
      toast.error(err.message || "Erro de validação ou de servidor.");
    } finally {
      setProfileLoading(false);
    }
  }

  // Address Actions
  function startNewAddress() {
    setIsEditingAddress(true);
    setEditingAddressId(null);
    setAddrLabel("Casa");
    setAddrRecipient(user?.name || "");
    setAddrCpf("");
    setAddrPhone(formatPhoneString(user?.whatsapp || ""));
    setAddrZipcode("");
    setAddrStreet("");
    setAddrNumber("");
    setAddrComplement("");
    setAddrNeighborhood("");
    setAddrCity("");
    setAddrState("");
    setAddrReference("");
    setAddrIsDefault(addresses.length === 0); // default if first address
  }

  function startEditAddress(addr: any) {
    setIsEditingAddress(true);
    setEditingAddressId(addr.id);
    setAddrLabel(addr.label || "Casa");
    setAddrRecipient(addr.recipient_name || "");
    setAddrCpf(addr.cpf || "");
    setAddrPhone(formatPhoneString(addr.phone || ""));
    setAddrZipcode(addr.zipcode || "");
    setAddrStreet(addr.street || "");
    setAddrNumber(addr.number || "");
    setAddrComplement(addr.complement || "");
    setAddrNeighborhood(addr.neighborhood || "");
    setAddrCity(addr.city || "");
    setAddrState(addr.state || "");
    setAddrReference(addr.reference || "");
    setAddrIsDefault(!!addr.is_default);
  }

  async function handleSaveAddress(e: React.FormEvent) {
    e.preventDefault();
    setAddrLoading(true);

    const payload = {
      label: addrLabel,
      recipient_name: addrRecipient,
      cpf: addrCpf.replace(/\D/g, ""),
      phone: addrPhone.replace(/\D/g, ""),
      zipcode: addrZipcode.replace(/\D/g, ""),
      street: addrStreet,
      number: addrNumber,
      complement: addrComplement,
      neighborhood: addrNeighborhood,
      city: addrCity,
      state: addrState,
      reference: addrReference,
      is_default: addrIsDefault,
    };

    try {
      let response;
      if (editingAddressId) {
        // Update Address
        response = await apiFetch(`/ecommerce/addresses/${editingAddressId}`, {
          method: "PUT",
          body: JSON.stringify(payload),
        });
      } else {
        // Create Address
        response = await apiFetch("/ecommerce/addresses", {
          method: "POST",
          body: JSON.stringify(payload),
        });
      }

      if (response && response.status === "success") {
        toast.success(editingAddressId ? "Endereço atualizado!" : "Endereço cadastrado!");
        setIsEditingAddress(false);
        loadAddresses();
      } else {
        toast.error(response.message || "Erro ao salvar endereço.");
      }
    } catch (err: any) {
      toast.error(err.message || "Preencha todos os campos corretamente.");
    } finally {
      setAddrLoading(false);
    }
  }

  async function handleDeleteAddress(id: number) {
    if (!confirm("Deseja realmente remover este endereço?")) return;

    try {
      const response = await apiFetch(`/ecommerce/addresses/${id}`, {
        method: "DELETE",
      });
      if (response && response.status === "success") {
        toast.success("Endereço removido.");
        loadAddresses();
      }
    } catch (err) {
      toast.error("Erro ao remover endereço.");
    }
  }

  async function handleSetDefaultAddress(id: number) {
    try {
      const response = await apiFetch(`/ecommerce/addresses/${id}/default`, {
        method: "PATCH",
      });
      if (response && response.status === "success") {
        toast.success("Endereço padrão atualizado!");
        loadAddresses();
      }
    } catch (err) {
      toast.error("Erro ao definir endereço padrão.");
    }
  }

  const handleLogout = () => {
    logout();
    router.push("/");
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "pending": return <Badge className="bg-amber-100 text-amber-700 hover:bg-amber-150 border-none">Pendente</Badge>;
      case "processing": return <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-150 border-none">Processando</Badge>;
      case "shipped": return <Badge className="bg-indigo-100 text-indigo-700 hover:bg-indigo-150 border-none">Enviado</Badge>;
      case "delivered": return <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-150 border-none">Entregue</Badge>;
      default: return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getAvatarUrl = (path?: string) => {
    if (!path) return null;
    return path.startsWith("http") ? path : `http://localhost:8000/storage/${path}`;
  };

  return (
    <div className="container mx-auto px-6 py-12">
      <Toaster position="top-right" richColors />
      
      <div className="max-w-5xl mx-auto space-y-12">
        
        {/* Header Profile */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 pb-6 border-b border-zinc-200">
          <div className="flex items-center gap-6">
            <div 
              onClick={handleAvatarClick}
              className="relative group w-20 h-20 rounded-full overflow-hidden bg-primary/10 border-2 border-primary/20 flex items-center justify-center cursor-pointer hover:border-primary transition-all hover:scale-[1.03]"
              title="Editar foto de perfil"
            >
              {getAvatarUrl(profileAvatar) ? (
                <img 
                  src={getAvatarUrl(profileAvatar)!} 
                  alt={user?.name || "Avatar"} 
                  className="w-full h-full object-cover" 
                />
              ) : (
                <span className="text-primary text-3xl font-bold font-outfit">
                  {user?.name ? user.name[0].toUpperCase() : "A"}
                </span>
              )}
              <div className="absolute inset-0 bg-black/45 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                <Camera className="w-5 h-5 text-white" />
              </div>
            </div>
            <div>
              <h1 className="text-3xl font-bold font-outfit text-zinc-900">{user?.name}</h1>
              <p className="text-zinc-500">{user?.email}</p>
            </div>
          </div>
          <Button variant="outline" onClick={handleLogout} className="text-destructive border-destructive/20 hover:bg-destructive/5 gap-2 h-11">
            <LogOut className="w-4 h-4" /> Sair da Conta
          </Button>
        </div>

        {/* Content Tab layout */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          
          {/* Navigation Sidebar */}
          <div className="space-y-6 md:col-span-1">
            <Card className="border-none shadow-md bg-primary text-white overflow-hidden">
              <CardContent className="p-6 space-y-4">
                <div className="space-y-1">
                  <p className="text-primary-foreground/80 text-[10px] font-bold uppercase tracking-widest">Nível de Membro</p>
                  <h3 className="text-xl font-black font-outfit flex items-center gap-2">
                    {user?.loyalty_level?.name ? `🌿 ${user.loyalty_level.name}` : "🌿 Semente de Alecrim"}
                  </h3>
                  {user?.loyalty_level?.discount_percentage ? (
                    <span className="inline-block bg-white/20 text-white text-[10px] font-bold px-2 py-0.5 rounded-full mt-1">
                      {user.loyalty_level.discount_percentage}% de desconto 🍃
                    </span>
                  ) : null}
                </div>

                <div className="pt-3 border-t border-white/10 space-y-1">
                  <p className="text-primary-foreground/80 text-[10px] font-bold uppercase tracking-widest">Saldo de Pontos</p>
                  <div className="flex items-baseline gap-1.5">
                    <span className="text-3xl font-black font-outfit leading-none">{user?.loyalty_points_balance ?? 0}</span>
                    <span className="text-xs opacity-75 font-semibold">pontos</span>
                  </div>
                  <p className="text-[10px] opacity-75 font-medium">Acumulado histórico: {user?.loyalty_lifetime_points ?? 0} pts</p>
                </div>

                <Button 
                  onClick={() => router.push("/fidelidade")} 
                  className="w-full text-xs font-bold bg-white text-primary hover:bg-zinc-50 hover:scale-[1.02] border-none rounded-xl py-2 h-9 shadow transition-all"
                >
                  Usar Pontos / Ver Prêmios
                </Button>
              </CardContent>
            </Card>

            <div className="bg-white rounded-2xl p-4 shadow-sm border border-zinc-100 flex flex-col space-y-1">
              <button 
                onClick={() => { setActiveTab("orders"); setIsEditingAddress(false); }}
                className={`w-full text-left px-4 py-3 rounded-lg transition-all flex items-center gap-3 ${activeTab === "orders" ? "bg-primary/10 text-primary font-bold" : "hover:bg-zinc-50 text-zinc-600"}`}
              >
                <ShoppingBag className="w-4 h-4" />
                <span className="text-sm">Meus Pedidos</span>
              </button>
              <button 
                onClick={() => { setActiveTab("details"); setIsEditingAddress(false); }}
                className={`w-full text-left px-4 py-3 rounded-lg transition-all flex items-center gap-3 ${activeTab === "details" ? "bg-primary/10 text-primary font-bold" : "hover:bg-zinc-50 text-zinc-600"}`}
              >
                <User className="w-4 h-4" />
                <span className="text-sm">Dados Pessoais</span>
              </button>
              <button 
                onClick={() => { setActiveTab("addresses"); setIsEditingAddress(false); }}
                className={`w-full text-left px-4 py-3 rounded-lg transition-all flex items-center gap-3 ${activeTab === "addresses" ? "bg-primary/10 text-primary font-bold" : "hover:bg-zinc-50 text-zinc-600"}`}
              >
                <MapPin className="w-4 h-4" />
                <span className="text-sm">Endereços</span>
              </button>
            </div>
          </div>

          {/* Active Tab Screen */}
          <div className="md:col-span-3 space-y-6">
            
            {/* Orders Screen */}
            {activeTab === "orders" && (
              <div className="space-y-6">
                <h2 className="text-2xl font-bold font-outfit flex items-center gap-3">
                  <ShoppingBag className="text-primary" /> Meus Pedidos
                </h2>

                {ordersLoading ? (
                  <div className="space-y-4">
                    {[1, 2].map((i) => (
                      <div key={i} className="h-32 bg-zinc-100 animate-pulse rounded-2xl" />
                    ))}
                  </div>
                ) : orders.length === 0 ? (
                  <div className="bg-white rounded-2xl p-12 text-center border border-zinc-200 border-dashed space-y-4">
                    <div className="w-16 h-16 bg-zinc-50 rounded-full flex items-center justify-center mx-auto text-zinc-350">
                      <Package className="w-8 h-8" />
                    </div>
                    <p className="text-zinc-500 font-medium">Você ainda não realizou nenhum pedido.</p>
                    <Button onClick={() => router.push("/produtos")} className="bg-primary text-white">Explorar Loja</Button>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {orders.map((order: any) => (
                      <Card key={order.id} className="border-none shadow-sm hover:shadow-md transition-shadow">
                        <CardContent className="p-6">
                          <div className="flex flex-col sm:flex-row justify-between gap-4">
                            <div className="space-y-1">
                              <p className="text-xs text-zinc-400 font-mono">#{order.order_number}</p>
                              <div className="flex items-center gap-2">
                                <Clock className="w-3.5 h-3.5 text-zinc-400" />
                                <span className="text-xs text-zinc-500">{new Date(order.created_at).toLocaleDateString()}</span>
                              </div>
                              <div className="mt-2 flex -space-x-1.5">
                                {order.items?.map((item: any, idx: number) => (
                                  <div key={idx} className="w-8 h-8 rounded-full border-2 border-white bg-zinc-100 flex items-center justify-center text-xs" title={item.itemable?.name}>
                                    {item.itemable_type?.includes("Kit") ? "🎁" : "🌿"}
                                  </div>
                                ))}
                              </div>
                            </div>
                            <div className="text-right flex flex-col items-end gap-2">
                              {getStatusBadge(order.status)}
                              <p className="font-bold text-lg text-primary">R$ {parseFloat(order.total).toFixed(2)}</p>
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Profile Details Screen */}
            {activeTab === "details" && (
              <div className="space-y-6">
                <h2 className="text-2xl font-bold font-outfit flex items-center gap-3">
                  <User className="text-primary" /> Meus Dados & Personalização
                </h2>

                <form onSubmit={handleUpdateProfile}>
                  <Card className="border border-zinc-200 shadow-sm">
                    <CardHeader>
                      <CardTitle className="text-xl font-outfit text-zinc-800">Foto de Perfil</CardTitle>
                      <CardDescription>Esta imagem será usada na sua conta e personalização de rituais.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-6">
                      
                      {/* Avatar Picker Section */}
                      <div className="flex flex-col sm:flex-row items-center gap-6">
                        <div 
                          onClick={handleAvatarClick}
                          className="relative group w-24 h-24 rounded-full overflow-hidden bg-zinc-100 border-2 border-zinc-200 cursor-pointer hover:border-primary transition-all hover:scale-[1.03]"
                          title="Clique para editar a foto"
                        >
                          {profileAvatar ? (
                            <img 
                              src={getAvatarUrl(profileAvatar)!} 
                              alt="Visualização" 
                              className="w-full h-full object-cover" 
                            />
                          ) : (
                            <div className="w-full h-full flex items-center justify-center text-zinc-400">
                              <User className="w-10 h-10" />
                            </div>
                          )}
                          <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                            <Camera className="w-6 h-6 text-white" />
                          </div>
                        </div>

                        <div className="flex-1 space-y-2 text-center sm:text-left">
                          <input 
                            type="file" 
                            className="hidden" 
                            id="avatar-file-upload" 
                            accept="image/*"
                            onChange={handleAvatarChange}
                          />
                          <Button 
                            type="button" 
                            variant="outline" 
                            disabled={uploadingAvatar}
                            className="border-primary/20 text-primary hover:bg-primary/5 h-10"
                            onClick={() => document.getElementById("avatar-file-upload")?.click()}
                          >
                            {uploadingAvatar ? "Enviando..." : "Escolher Nova Foto"}
                          </Button>
                          <p className="text-xs text-zinc-400">
                            Apenas arquivos JPG ou PNG de até 5MB. A imagem será ajustada automaticamente.
                          </p>
                        </div>
                      </div>

                      <div className="border-t border-zinc-100 pt-6 grid grid-cols-1 sm:grid-cols-2 gap-6">
                        
                        <div className="space-y-2">
                          <Label htmlFor="prof-name">Nome Completo</Label>
                          <Input 
                            id="prof-name"
                            value={profileName}
                            onChange={(e) => setProfileName(e.target.value)}
                            required
                          />
                        </div>

                        <div className="space-y-2">
                          <Label htmlFor="prof-email">E-mail</Label>
                          <Input 
                            id="prof-email"
                            type="email"
                            value={profileEmail}
                            onChange={(e) => setProfileEmail(e.target.value)}
                            required
                          />
                        </div>

                        <div className="space-y-2">
                          <Label htmlFor="prof-whatsapp">WhatsApp</Label>
                          <Input 
                            id="prof-whatsapp"
                            value={profileWhatsapp}
                            onChange={handleWhatsappChange}
                            required
                            placeholder="(00) 00000-0000"
                          />
                        </div>
                      </div>

                      {/* Password reset sub-section */}
                      <div className="border-t border-zinc-100 pt-6 space-y-4">
                        <div className="flex items-center gap-2 text-primary font-semibold text-sm">
                          <KeyRound className="w-4 h-4" /> Alterar Senha (Opcional)
                        </div>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                          <div className="space-y-2">
                            <Label htmlFor="prof-password">Nova Senha</Label>
                            <div className="relative">
                              <Input 
                                id="prof-password"
                                type={showPassword ? "text" : "password"}
                                placeholder="Digite apenas se quiser alterar"
                                value={profilePassword}
                                onChange={(e) => setProfilePassword(e.target.value)}
                                className="pr-10"
                              />
                              <button
                                type="button"
                                onClick={() => setShowPassword(!showPassword)}
                                className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-650 transition-colors"
                                title={showPassword ? "Ocultar senha" : "Mostrar senha"}
                              >
                                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                              </button>
                            </div>
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="prof-passconfirm">Confirmar Nova Senha</Label>
                            <div className="relative">
                              <Input 
                                id="prof-passconfirm"
                                type={showConfirmPassword ? "text" : "password"}
                                placeholder="Confirme a nova senha"
                                value={profilePasswordConfirm}
                                onChange={(e) => setProfilePasswordConfirm(e.target.value)}
                                className="pr-10"
                              />
                              <button
                                type="button"
                                onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                                className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-650 transition-colors"
                                title={showConfirmPassword ? "Ocultar senha" : "Mostrar senha"}
                              >
                                {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>

                    </CardContent>
                    <CardFooter className="bg-zinc-50 px-6 py-4 flex justify-end">
                      <Button type="submit" disabled={profileLoading} className="bg-primary hover:bg-olive-green text-white h-11 px-8">
                        {profileLoading ? "Salvando..." : "Salvar Alterações"}
                      </Button>
                    </CardFooter>
                  </Card>
                </form>
              </div>
            )}

            {/* Addresses Screen */}
            {activeTab === "addresses" && (
              <div className="space-y-6">
                
                {/* Form Editor or Creator */}
                {isEditingAddress ? (
                  <form onSubmit={handleSaveAddress} className="space-y-6">
                    <div className="flex items-center justify-between">
                      <h3 className="text-xl font-bold font-outfit text-zinc-950 flex items-center gap-2">
                        <MapPinned className="text-primary w-5 h-5" /> 
                        {editingAddressId ? "Editar Endereço" : "Novo Endereço"}
                      </h3>
                      <Button 
                        type="button" 
                        variant="ghost" 
                        size="sm" 
                        className="text-zinc-500 hover:text-zinc-900"
                        onClick={() => setIsEditingAddress(false)}
                      >
                        Cancelar
                      </Button>
                    </div>

                    <Card className="border border-zinc-200 shadow-sm">
                      <CardContent className="p-6 space-y-6">
                        
                        {/* Label Type */}
                        <div className="space-y-2">
                          <Label>Tipo de Endereço</Label>
                          <div className="flex gap-4">
                            <button
                              type="button"
                              onClick={() => setAddrLabel("Casa")}
                              className={`flex-1 py-3 px-4 rounded-xl border flex items-center justify-center gap-2 text-sm font-medium transition-all ${addrLabel === "Casa" ? "border-primary bg-primary/5 text-primary" : "border-zinc-200 hover:bg-zinc-50"}`}
                            >
                              <Home className="w-4 h-4" /> Casa
                            </button>
                            <button
                              type="button"
                              onClick={() => setAddrLabel("Trabalho")}
                              className={`flex-1 py-3 px-4 rounded-xl border flex items-center justify-center gap-2 text-sm font-medium transition-all ${addrLabel === "Trabalho" ? "border-primary bg-primary/5 text-primary" : "border-zinc-200 hover:bg-zinc-50"}`}
                            >
                              <Landmark className="w-4 h-4" /> Trabalho
                            </button>
                          </div>
                        </div>

                        {/* Recipient Details */}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                          <div className="space-y-2">
                            <Label htmlFor="addr-recip">Nome do Destinatário</Label>
                            <Input 
                              id="addr-recip"
                              value={addrRecipient}
                              onChange={(e) => setAddrRecipient(e.target.value)}
                              required
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-cpf">CPF do Destinatário</Label>
                            <Input 
                              id="addr-cpf"
                              value={addrCpf}
                              onChange={handleCpfChange}
                              required
                              placeholder="000.000.000-00"
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-phone">Telefone do Destinatário</Label>
                            <Input 
                              id="addr-phone"
                              value={addrPhone}
                              onChange={handlePhoneChange}
                              required
                              placeholder="(00) 00000-0000"
                            />
                          </div>
                        </div>

                        {/* Location Details */}
                        <div className="border-t border-zinc-100 pt-6 grid grid-cols-1 sm:grid-cols-3 gap-6">
                          <div className="space-y-2">
                            <Label htmlFor="addr-cep">CEP</Label>
                            <Input 
                              id="addr-cep"
                              value={addrZipcode}
                              onChange={handleZipcodeChange}
                              required
                              placeholder="00000-000"
                            />
                          </div>
                          <div className="sm:col-span-2 space-y-2">
                            <Label htmlFor="addr-street">Rua/Logradouro</Label>
                            <Input 
                              id="addr-street"
                              value={addrStreet}
                              onChange={(e) => setAddrStreet(e.target.value)}
                              required
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-num">Número</Label>
                            <Input 
                              id="addr-num"
                              value={addrNumber}
                              onChange={(e) => setAddrNumber(e.target.value)}
                              required
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-comp">Complemento (Opcional)</Label>
                            <Input 
                              id="addr-comp"
                              value={addrComplement}
                              onChange={(e) => setAddrComplement(e.target.value)}
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-neigh">Bairro</Label>
                            <Input 
                              id="addr-neigh"
                              value={addrNeighborhood}
                              onChange={(e) => setAddrNeighborhood(e.target.value)}
                              required
                            />
                          </div>
                          <div className="sm:col-span-2 space-y-2">
                            <Label htmlFor="addr-city">Cidade</Label>
                            <Input 
                              id="addr-city"
                              value={addrCity}
                              onChange={(e) => setAddrCity(e.target.value)}
                              required
                            />
                          </div>
                          <div className="space-y-2">
                            <Label htmlFor="addr-state">Estado (UF)</Label>
                            <Input 
                              id="addr-state"
                              value={addrState}
                              onChange={(e) => setAddrState(e.target.value)}
                              required
                              maxLength={2}
                            />
                          </div>
                          <div className="sm:col-span-3 space-y-2">
                            <Label htmlFor="addr-ref">Ponto de Referência (Opcional)</Label>
                            <Input 
                              id="addr-ref"
                              value={addrReference}
                              onChange={(e) => setAddrReference(e.target.value)}
                            />
                          </div>
                        </div>

                        {/* Set Default */}
                        <div className="flex items-center gap-3">
                          <input 
                            id="addr-default"
                            type="checkbox" 
                            checked={addrIsDefault}
                            onChange={(e) => setAddrIsDefault(e.target.checked)}
                            className="w-4 h-4 rounded text-primary focus:ring-primary"
                          />
                          <Label htmlFor="addr-default" className="font-medium cursor-pointer">Definir como endereço padrão de entrega</Label>
                        </div>

                      </CardContent>
                      <CardFooter className="bg-zinc-50 px-6 py-4 flex justify-end gap-3">
                        <Button 
                          type="button" 
                          variant="outline" 
                          onClick={() => setIsEditingAddress(false)}
                          className="h-11"
                        >
                          Cancelar
                        </Button>
                        <Button 
                          type="submit" 
                          disabled={addrLoading} 
                          className="bg-primary hover:bg-olive-green text-white h-11 px-8"
                        >
                          {addrLoading ? "Salvando..." : "Salvar Endereço"}
                        </Button>
                      </CardFooter>
                    </Card>
                  </form>
                ) : (
                  <div className="space-y-6">
                    <div className="flex justify-between items-center">
                      <h2 className="text-2xl font-bold font-outfit flex items-center gap-3">
                        <MapPin className="text-primary" /> Meus Endereços
                      </h2>
                      <Button onClick={startNewAddress} className="bg-primary hover:bg-olive-green text-white gap-2 h-10">
                        <Plus className="w-4 h-4" /> Novo Endereço
                      </Button>
                    </div>

                    {addressesLoading ? (
                      <div className="space-y-4">
                        <div className="h-32 bg-zinc-100 animate-pulse rounded-2xl" />
                      </div>
                    ) : addresses.length === 0 ? (
                      <div className="bg-white rounded-2xl p-12 text-center border border-zinc-200 border-dashed space-y-4">
                        <p className="text-zinc-500">Nenhum endereço cadastrado para entrega.</p>
                        <Button onClick={startNewAddress} className="bg-primary">Adicionar Endereço</Button>
                      </div>
                    ) : (
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        {addresses.map((addr) => (
                          <Card key={addr.id} className="border border-zinc-200 shadow-sm relative flex flex-col justify-between">
                            <CardContent className="p-6 space-y-3">
                              <div className="flex justify-between items-start gap-4">
                                <h3 className="font-bold text-lg font-outfit text-primary flex items-center gap-1.5">
                                  {addr.label === "Casa" ? <Home className="w-4 h-4" /> : <Landmark className="w-4 h-4" />}
                                  {addr.label || "Casa"}
                                </h3>
                                {addr.is_default && (
                                  <Badge className="bg-emerald-100 text-emerald-800 hover:bg-emerald-100 border-none font-bold text-[10px] uppercase">
                                    Padrão
                                  </Badge>
                                )}
                              </div>
                              
                              <div className="text-sm space-y-1 text-zinc-600">
                                <p className="font-medium text-zinc-900">{addr.recipient_name}</p>
                                <p>{addr.street}, {addr.number} {addr.complement && `- ${addr.complement}`}</p>
                                <p>{addr.neighborhood}</p>
                                <p>{addr.city} / {addr.state}</p>
                                <p>CEP: {addr.zipcode || addr.cep}</p>
                              </div>
                            </CardContent>
                            <CardFooter className="bg-zinc-50/50 px-6 py-3 border-t border-zinc-100 flex justify-between gap-3 text-xs">
                              {!addr.is_default ? (
                                <button 
                                  onClick={() => handleSetDefaultAddress(addr.id)} 
                                  className="text-zinc-500 hover:text-primary font-medium"
                                >
                                  Tornar padrão
                                </button>
                              ) : (
                                <span className="text-emerald-700 font-medium inline-flex items-center gap-1">
                                  <Check className="w-3.5 h-3.5" /> Endereço principal
                                </span>
                              )}
                              
                              <div className="flex gap-3">
                                <button 
                                  onClick={() => startEditAddress(addr)} 
                                  className="text-zinc-500 hover:text-zinc-800 flex items-center gap-1"
                                >
                                  <Edit2 className="w-3 h-3" /> Editar
                                </button>
                                <button 
                                  onClick={() => handleDeleteAddress(addr.id)} 
                                  className="text-destructive hover:text-destructive/80 flex items-center gap-1"
                                >
                                  <Trash2 className="w-3 h-3" /> Excluir
                                </button>
                              </div>
                            </CardFooter>
                          </Card>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}

          </div>

        </div>
      </div>

      {/* Modal de Enquadramento da Foto (Cropper) */}
      {cropImageSrc && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-in fade-in duration-300">
          <Card className="w-full max-w-md border-none shadow-2xl bg-white overflow-hidden animate-in zoom-in-95 duration-200">
            <CardHeader className="bg-primary/5 pb-4">
              <CardTitle className="font-outfit text-xl text-primary">Enquadrar Foto de Perfil</CardTitle>
              <CardDescription className="text-zinc-600">Arraste a foto e ajuste o zoom para centralizar seu rosto no círculo.</CardDescription>
            </CardHeader>
            <CardContent className="pt-6 flex flex-col items-center gap-6">
              
              {/* Visor de Corte Circular */}
              <div 
                className="w-64 h-64 rounded-full overflow-hidden border-4 border-white shadow-xl relative cursor-move bg-zinc-100 select-none touch-none"
                onPointerDown={(e) => {
                  setIsDragging(true);
                  setDragStart({ x: e.clientX - cropPosition.x, y: e.clientY - cropPosition.y });
                  (e.target as HTMLElement).setPointerCapture(e.pointerId);
                }}
                onPointerMove={(e) => {
                  if (!isDragging) return;
                  const newX = e.clientX - dragStart.x;
                  const newY = e.clientY - dragStart.y;
                  setCropPosition({ x: newX, y: newY });
                }}
                onPointerUp={(e) => {
                  setIsDragging(false);
                  (e.target as HTMLElement).releasePointerCapture(e.pointerId);
                }}
                onPointerCancel={() => setIsDragging(false)}
              >
                {/* Imagem sendo enquadrada */}
                <img 
                  src={cropImageSrc} 
                  alt="Ajuste" 
                  style={{
                    transform: `translate(${cropPosition.x}px, ${cropPosition.y}px) scale(${cropZoom})`,
                  }}
                  className="absolute origin-center min-w-full min-h-full max-w-none max-h-none select-none pointer-events-none top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                />
              </div>

              {/* Slider de Zoom */}
              <div className="w-full space-y-2 px-4">
                <div className="flex justify-between text-xs text-zinc-500 font-bold">
                  <span>ZOOM</span>
                  <span>{cropZoom.toFixed(2)}x</span>
                </div>
                <input 
                  type="range" 
                  min="0.2" 
                  max="3" 
                  step="0.05"
                  value={cropZoom}
                  onChange={(e) => setCropZoom(parseFloat(e.target.value))}
                  className="w-full h-2 bg-zinc-200 rounded-lg appearance-none cursor-pointer accent-primary"
                />
              </div>

            </CardContent>
            <CardFooter className="bg-zinc-50 px-6 py-4 flex justify-end gap-3 border-t border-zinc-100">
              <Button 
                type="button" 
                variant="ghost" 
                onClick={() => setCropImageSrc(null)}
                className="h-11 text-zinc-500 hover:bg-zinc-100"
              >
                Cancelar
              </Button>
              <Button 
                type="button" 
                onClick={confirmCrop}
                disabled={uploadingAvatar}
                className="bg-primary hover:bg-olive-green text-white h-11 px-8 shadow-md"
              >
                {uploadingAvatar ? "Processando..." : "Confirmar Recorte"}
              </Button>
            </CardFooter>
          </Card>
        </div>
      )}

      {/* Modal de Opções da Foto de Perfil */}
      {isEditMenuOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-in fade-in duration-300">
          <Card className="w-full max-w-sm border-none shadow-2xl bg-white overflow-hidden animate-in zoom-in-95 duration-200">
            <CardHeader className="bg-primary/5 pb-4 text-center">
              <CardTitle className="font-outfit text-xl text-primary flex items-center justify-center gap-2">
                <Camera className="w-5 h-5" /> Foto de Perfil
              </CardTitle>
              <CardDescription className="text-zinc-650">O que você gostaria de fazer com sua foto?</CardDescription>
            </CardHeader>
            <CardContent className="pt-6 flex flex-col items-center gap-6">
              {/* Preview da foto atual */}
              <div className="w-28 h-28 rounded-full overflow-hidden border-4 border-zinc-150 shadow-md">
                <img 
                  src={getAvatarUrl(profileAvatar)!} 
                  alt="Avatar Atual" 
                  className="w-full h-full object-cover" 
                />
              </div>

              <div className="w-full space-y-2 mt-2">
                <Button
                  type="button"
                  variant="outline"
                  className="w-full justify-start gap-3 h-11 border-zinc-200 text-zinc-700 hover:bg-zinc-50 rounded-xl"
                  onClick={() => {
                    setIsEditMenuOpen(false);
                    document.getElementById("avatar-file-upload")?.click();
                  }}
                >
                  <Plus className="w-4 h-4 text-primary" /> Carregar Nova Foto
                </Button>

                <Button
                  type="button"
                  variant="outline"
                  className="w-full justify-start gap-3 h-11 border-zinc-200 text-zinc-700 hover:bg-zinc-50 rounded-xl"
                  onClick={() => {
                    setIsEditMenuOpen(false);
                    loadExistingAvatarForCrop();
                  }}
                >
                  <Edit2 className="w-4 h-4 text-primary" /> Ajustar Foto Atual
                </Button>

                <Button
                  type="button"
                  variant="outline"
                  className="w-full justify-start gap-3 h-11 border-destructive/20 text-destructive hover:bg-destructive/5 hover:text-destructive rounded-xl"
                  onClick={() => {
                    if (confirm("Tem certeza que deseja remover sua foto de perfil?")) {
                      setProfileAvatar("");
                      setIsEditMenuOpen(false);
                      toast.success("Foto de perfil removida. Clique em 'Salvar Alterações' para salvar.");
                    }
                  }}
                >
                  <Trash2 className="w-4 h-4 text-destructive" /> Remover Foto
                </Button>
              </div>
            </CardContent>
            <CardFooter className="bg-zinc-50 px-6 py-3 flex justify-end border-t border-zinc-100">
              <Button
                type="button"
                variant="ghost"
                onClick={() => setIsEditMenuOpen(false)}
                className="h-10 text-zinc-500 hover:bg-zinc-100 rounded-lg"
              >
                Cancelar
              </Button>
            </CardFooter>
          </Card>
        </div>
      )}
    </div>
  );
}
