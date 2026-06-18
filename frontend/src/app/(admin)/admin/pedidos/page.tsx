"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Search, ShoppingBag, Eye, Truck, CheckCircle, Clock, Package, Filter, XCircle, Edit, Plus, Minus, Trash2, Tag } from "lucide-react";
import { Input } from "@/components/ui/input";
import { toast } from "sonner";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";

export default function AdminOrders() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState<any>(null);
  const [filterStatus, setFilterStatus] = useState("all");
  const [searchTerm, setSearchTerm] = useState("");

  // States for Editing Order
  const [catalog, setCatalog] = useState<any[]>([]);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [editingOrder, setEditingOrder] = useState<any>(null);
  const [editCart, setEditCart] = useState<any[]>([]);
  const [editCustomerName, setEditCustomerName] = useState("");
  const [editCustomerPhone, setEditCustomerPhone] = useState("");
  const [editNotes, setEditNotes] = useState("");
  const [editShippingAddress, setEditShippingAddress] = useState("");
  const [editPaymentMethod, setEditPaymentMethod] = useState("");
  const [editDiscountAmount, setEditDiscountAmount] = useState("");
  const [savingEdit, setSavingEdit] = useState(false);
  const [catalogSearch, setCatalogSearch] = useState("");

  // Load Catalog items once
  useEffect(() => {
    Promise.all([
      apiFetch("/ecommerce/products?per_page=200"),
      apiFetch("/ecommerce/kits?per_page=200"),
    ]).then(([pRes, kRes]) => {
      const prods = (pRes.data?.products ?? pRes.data ?? []).map((p: any) => ({ ...p, price: parseFloat(p.price), stock: parseInt(p.stock), type: "product" }));
      const kits  = (kRes.data?.kits     ?? kRes.data ?? []).map((k: any) => ({ ...k, price: parseFloat(k.price), stock: parseInt(k.stock), type: "kit" }));
      setCatalog([...prods, ...kits]);
    }).catch(() => {});
  }, []);

  const startEditing = (order: any) => {
    setEditingOrder(order);
    setEditCart(order.items.map((item: any) => ({
      id: item.itemable_id,
      name: item.itemable?.name || "Item Indisponível",
      price: parseFloat(item.price),
      stock: (item.itemable?.stock ?? 0) + item.quantity,
      type: item.itemable_type.includes("ProductVariant") ? "variant" : (item.itemable_type.includes("Product") ? "product" : "kit"),
      quantity: item.quantity
    })));
    setEditCustomerName(order.customer_name || "");
    setEditCustomerPhone(order.customer_phone || "");
    setEditNotes(order.notes || "");
    setEditShippingAddress(order.shipping_address || "");
    setEditPaymentMethod(order.payment_method || "cash");
    setEditDiscountAmount(order.discount_amount ? order.discount_amount.toString() : "");
  };

  const addCatalogItemToEditCart = (catalogItem: any) => {
    setEditCart(prev => {
      const existing = prev.find(i => i.id === catalogItem.id && i.type === catalogItem.type);
      if (existing) {
        if (existing.quantity >= catalogItem.stock) {
          toast.warning(`Estoque máximo: ${catalogItem.stock} un.`);
          return prev;
        }
        return prev.map(i => i.id === catalogItem.id && i.type === catalogItem.type ? { ...i, quantity: i.quantity + 1 } : i);
      }
      if (catalogItem.stock < 1) {
        toast.warning("Produto sem estoque.");
        return prev;
      }
      return [...prev, { ...catalogItem, quantity: 1 }];
    });
  };

  const changeEditCartQty = (item: any, delta: number) => {
    const next = item.quantity + delta;
    if (next < 1) {
      setEditCart(prev => prev.filter(i => !(i.id === item.id && i.type === item.type)));
      return;
    }
    if (next > item.stock) {
      toast.warning(`Estoque máximo: ${item.stock} un.`);
      return;
    }
    setEditCart(prev => prev.map(i => i.id === item.id && i.type === item.type ? { ...i, quantity: next } : i));
  };

  const removeEditCartItem = (item: any) => {
    setEditCart(prev => prev.filter(i => !(i.id === item.id && i.type === item.type)));
  };

  const saveOrderEdit = async () => {
    if (editCart.length === 0) {
      toast.error("O pedido deve ter pelo menos um item.");
      return;
    }
    setSavingEdit(true);
    try {
      const body = {
        items: editCart.map(i => ({ id: i.id, type: i.type, quantity: i.quantity })),
        customer_name: editCustomerName || undefined,
        customer_phone: editCustomerPhone || undefined,
        notes: editNotes || undefined,
        shipping_address: editShippingAddress || undefined,
        payment_method: editPaymentMethod,
        discount_amount: parseFloat(editDiscountAmount) || 0,
      };

      await apiFetch(`/ecommerce/orders/${editingOrder.id}`, {
        method: "PUT",
        body: JSON.stringify(body)
      });

      toast.success("Pedido atualizado com sucesso!");
      setIsEditDialogOpen(false);
      setEditingOrder(null);
      loadOrders();
    } catch (error: any) {
      toast.error(error.message || "Erro ao atualizar o pedido");
    } finally {
      setSavingEdit(false);
    }
  };

  const filteredCatalog = catalog.filter(item => 
    item.name.toLowerCase().includes(catalogSearch.toLowerCase())
  );

  useEffect(() => {
    loadOrders();
  }, []);

  async function loadOrders() {
    setLoading(true);
    try {
      const response = await apiFetch("/ecommerce/orders");
      setOrders(response.data);
    } catch (error) {
      console.error("Error loading orders", error);
    } finally {
      setLoading(false);
    }
  }

  const updateStatus = async (id: number, newStatus: string) => {
    try {
      await apiFetch(`/ecommerce/orders/${id}/status`, {
        method: "PATCH",
        body: JSON.stringify({ status: newStatus })
      });
      loadOrders();
      toast.success(`Pedido atualizado para: ${newStatus}`);
    } catch (error: any) {
      toast.error(error.message || "Erro ao atualizar pedido");
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'pending': return <Badge className="bg-amber-100 text-amber-700 hover:bg-amber-100 border-none">Pendente</Badge>;
      case 'processing': return <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-100 border-none">Processando</Badge>;
      case 'shipped': return <Badge className="bg-indigo-100 text-indigo-700 hover:bg-indigo-100 border-none">Enviado</Badge>;
      case 'delivered': return <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-none">Entregue</Badge>;
      case 'cancelled': return <Badge className="bg-red-100 text-red-700 hover:bg-red-100 border-none">Cancelado</Badge>;
      default: return <Badge variant="outline">{status}</Badge>;
    }
  };

  const STATUS_PRIORITY: Record<string, number> = {
    pending: 1,
    processing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5,
  };

  const filteredOrders = orders.filter((order: any) => {
    const matchesStatus = filterStatus === "all" || order.status === filterStatus;
    const searchString = `${order.order_number} ${order.user?.name || order.customer_name || ""} ${order.user?.email || order.customer_phone || ""}`.toLowerCase();
    const matchesSearch = searchTerm === "" || searchString.includes(searchTerm.toLowerCase());
    return matchesStatus && matchesSearch;
  }).sort((a: any, b: any) => {
    if (filterStatus !== "all") {
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
    }
    const priorityA = STATUS_PRIORITY[a.status] || 99;
    const priorityB = STATUS_PRIORITY[b.status] || 99;
    if (priorityA !== priorityB) {
      return priorityA - priorityB;
    }
    return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
  });

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Pedidos</h1>
          <p className="text-sm text-zinc-500">Acompanhe as vendas e atualize o status de entrega.</p>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
        <div className="p-4 border-b border-zinc-100 bg-zinc-50/50 flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
            <Input 
              className="pl-10 bg-white border-zinc-200" 
              placeholder="Buscar pedido ou cliente..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <div className="w-full sm:w-48">
            <Select value={filterStatus} onValueChange={setFilterStatus}>
              <SelectTrigger className="bg-white">
                <Filter className="w-4 h-4 mr-2 text-zinc-400" />
                <SelectValue placeholder="Filtrar por Status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Todos os Status</SelectItem>
                <SelectItem value="pending">Pendente</SelectItem>
                <SelectItem value="processing">Processando</SelectItem>
                <SelectItem value="shipped">Enviado</SelectItem>
                <SelectItem value="delivered">Entregue</SelectItem>
                <SelectItem value="cancelled">Cancelado</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        <Table>
          <TableHeader>
            <TableRow className="bg-zinc-50 hover:bg-zinc-50">
              <TableHead>Pedido</TableHead>
              <TableHead>Cliente</TableHead>
              <TableHead>Total</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Data</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
              </TableRow>
            ) : filteredOrders.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Nenhum pedido encontrado.</TableCell>
              </TableRow>
            ) : filteredOrders.map((order: any) => (
              <TableRow key={order.id}>
                <TableCell className="font-medium text-zinc-900">{order.order_number}</TableCell>
                <TableCell>
                  <div>
                    <p className="text-sm font-medium">{order.user?.name || order.customer_name || "Cliente Avulso"}</p>
                    <p className="text-xs text-zinc-500">{order.user?.email || order.customer_phone || "-"}</p>
                  </div>
                </TableCell>
                <TableCell className="font-bold text-primary">R$ {parseFloat(order.total).toFixed(2)}</TableCell>
                <TableCell>{getStatusBadge(order.status)}</TableCell>
                <TableCell className="text-xs text-zinc-500">
                  {new Date(order.created_at).toLocaleDateString()}
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-2">
                    {order.status === 'pending' && (
                      <Button 
                        variant="ghost" size="icon" className="h-8 w-8 text-blue-500 hover:bg-blue-50"
                        onClick={() => updateStatus(order.id, 'processing')}
                        title="Iniciar Processamento"
                      >
                        <Clock className="w-4 h-4" />
                      </Button>
                    )}
                    {order.status === 'processing' && (
                      <Button 
                        variant="ghost" size="icon" className="h-8 w-8 text-indigo-500 hover:bg-indigo-50"
                        onClick={() => updateStatus(order.id, 'shipped')}
                        title="Marcar como Enviado"
                      >
                        <Truck className="w-4 h-4" />
                      </Button>
                    )}
                    {order.status === 'shipped' && (
                      <Button 
                        variant="ghost" size="icon" className="h-8 w-8 text-emerald-500 hover:bg-emerald-50"
                        onClick={() => updateStatus(order.id, 'delivered')}
                        title="Confirmar Entrega"
                      >
                        <CheckCircle className="w-4 h-4" />
                      </Button>
                    )}
                    {order.status !== 'cancelled' && order.status !== 'delivered' && (
                      <Button 
                        variant="ghost" size="icon" className="h-8 w-8 text-red-500 hover:bg-red-50"
                        onClick={() => {
                          if(confirm('Tem certeza que deseja cancelar este pedido? O estoque será restaurado.')) {
                            updateStatus(order.id, 'cancelled');
                          }
                        }}
                        title="Cancelar Pedido"
                      >
                        <XCircle className="w-4 h-4" />
                      </Button>
                    )}
                    
                    {order.status !== 'cancelled' && (
                      <Button 
                        variant="ghost" size="icon" className="h-8 w-8 text-amber-500 hover:bg-amber-50"
                        onClick={() => {
                          startEditing(order);
                          setIsEditDialogOpen(true);
                        }}
                        title="Editar Pedido"
                      >
                        <Edit className="w-4 h-4" />
                      </Button>
                    )}
                    
                    <Dialog>
                      <DialogTrigger asChild>
                        <Button variant="ghost" size="icon" className="h-8 w-8 text-zinc-400 hover:text-primary" onClick={() => setSelectedOrder(order)}>
                          <Eye className="w-4 h-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent className="sm:max-w-[500px]">
                        <DialogHeader>
                          <DialogTitle>Detalhes do Pedido {selectedOrder?.order_number}</DialogTitle>
                          <DialogDescription>
                            Resumo dos itens e informações de entrega.
                          </DialogDescription>
                        </DialogHeader>
                        <div className="space-y-6 py-4">
                          <div className="bg-zinc-50 p-4 rounded-lg space-y-2">
                            <p className="text-sm font-medium text-zinc-900">Cliente: {selectedOrder?.user?.name || selectedOrder?.customer_name || 'Cliente Avulso'}</p>
                            <p className="text-sm text-zinc-500">Endereço: {selectedOrder?.shipping_address || 'Retirada Balcão'}</p>
                            {selectedOrder?.shipping_method && (
                              <p className="text-sm text-zinc-500">
                                Envio: <span className="font-semibold text-zinc-800">{selectedOrder.shipping_method}</span> 
                                {selectedOrder.freight_value !== undefined && selectedOrder.freight_value !== null && ` (R$ ${parseFloat(selectedOrder.freight_value).toFixed(2)})`}
                              </p>
                            )}
                            <p className="text-sm text-zinc-500">Pagamento: {selectedOrder?.payment_method}</p>
                            {selectedOrder?.notes && <p className="text-sm text-zinc-500">Obs: {selectedOrder.notes}</p>}
                          </div>

                          <div className="border border-zinc-150 rounded-lg p-4 space-y-3 bg-white shadow-sm">
                            <p className="text-xs font-bold uppercase tracking-wider text-zinc-400">Cronologia do Pedido</p>
                            <div className="grid grid-cols-1 gap-2.5 text-xs text-zinc-600">
                              <div className="flex justify-between items-center pb-1.5 border-b border-zinc-50">
                                <span className="font-medium">📅 Criado em:</span>
                                <span className="font-semibold text-zinc-800">
                                  {selectedOrder?.created_at ? new Date(selectedOrder.created_at).toLocaleString('pt-BR') : '—'}
                                </span>
                              </div>
                              <div className="flex justify-between items-center pb-1.5 border-b border-zinc-50">
                                <span className="font-medium">🚚 Enviado em:</span>
                                <span className="font-semibold text-zinc-800">
                                  {selectedOrder?.shipped_at ? new Date(selectedOrder.shipped_at).toLocaleString('pt-BR') : '—'}
                                </span>
                              </div>
                              <div className="flex justify-between items-center">
                                <span className="font-medium">✅ Entregue em:</span>
                                <span className="font-semibold text-zinc-800">
                                  {selectedOrder?.status === 'delivered' && selectedOrder?.updated_at 
                                    ? new Date(selectedOrder.updated_at).toLocaleString('pt-BR') 
                                    : '—'}
                                </span>
                              </div>
                            </div>
                          </div>
                          
                          <div className="space-y-3">
                            <p className="text-sm font-bold uppercase tracking-wider text-zinc-400">Itens do Pedido</p>
                            {selectedOrder?.items?.map((item: any) => (
                              <div key={item.id} className="flex justify-between items-center border-b border-zinc-100 pb-2">
                                <div className="flex items-center gap-3">
                                  <div className="w-8 h-8 bg-zinc-100 rounded flex items-center justify-center">
                                    <Package className="w-4 h-4 text-zinc-400" />
                                  </div>
                                  <div>
                                    <p className="text-sm font-medium">{item.itemable?.name || "Item Indisponível"}</p>
                                    <p className="text-xs text-zinc-500">{item.quantity}x R$ {parseFloat(item.price).toFixed(2)}</p>
                                  </div>
                                </div>
                                <p className="text-sm font-bold">R$ {(item.quantity * item.price).toFixed(2)}</p>
                              </div>
                            ))}
                          </div>
                          
                          <div className="flex justify-between items-center pt-4 border-t border-zinc-200">
                            <p className="font-bold text-lg">Total</p>
                            <p className="font-bold text-2xl text-primary">R$ {parseFloat(selectedOrder?.total || 0).toFixed(2)}</p>
                          </div>
                        </div>
                      </DialogContent>
                    </Dialog>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* MODAL DE EDIÇÃO DE PEDIDO */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent className="sm:max-w-[950px] max-h-[90vh] flex flex-col p-6">
          <DialogHeader className="border-b pb-4">
            <DialogTitle className="text-xl font-bold font-outfit text-zinc-900 flex items-center gap-2">
              <Edit className="w-5 h-5 text-amber-500" />
              Editar Pedido {editingOrder?.order_number}
            </DialogTitle>
            <DialogDescription>
              Adicione ou remova itens, ajuste as quantidades e atualize os dados do cliente e entrega.
            </DialogDescription>
          </DialogHeader>

          <div className="flex-1 grid grid-cols-1 lg:grid-cols-12 gap-6 py-4 overflow-y-auto min-h-0">
            {/* Coluna da Esquerda: Catálogo (lg:col-span-5) */}
            <div className="lg:col-span-5 flex flex-col border border-zinc-200 rounded-xl overflow-hidden bg-zinc-50/50 max-h-[50vh] lg:max-h-full">
              <div className="p-3 bg-white border-b border-zinc-200">
                <p className="text-xs font-semibold uppercase tracking-wider text-zinc-400 mb-2">Adicionar Produtos / Kits</p>
                <div className="relative">
                  <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
                  <Input
                    className="pl-8 h-8 text-xs bg-white border-zinc-200"
                    placeholder="Buscar itens do catálogo..."
                    value={catalogSearch}
                    onChange={e => setCatalogSearch(e.target.value)}
                  />
                </div>
              </div>

              <div className="flex-1 overflow-y-auto divide-y divide-zinc-100 bg-white">
                {filteredCatalog.length === 0 ? (
                  <p className="text-center text-xs text-zinc-400 py-6">Nenhum item encontrado.</p>
                ) : (
                  filteredCatalog.map(item => {
                    const inCart = editCart.find(i => i.id === item.id && i.type === item.type);
                    const currentQty = inCart ? inCart.quantity : 0;
                    const availableStock = item.stock;
                    const hasVariants = item.type === "product" && item.variants && item.variants.length > 0;

                    return (
                      <div key={`${item.type}-${item.id}`} className="flex flex-col border-b border-zinc-100 last:border-0 hover:bg-zinc-50/50">
                        <div className="flex items-center justify-between p-3">
                          <div className="min-w-0 flex-1 pr-2">
                            <p className="text-xs font-bold text-zinc-800 truncate">{item.name}</p>
                            <div className="flex items-center gap-1.5 mt-0.5">
                              {!hasVariants && <span className="text-xs font-bold text-primary">R$ {item.price.toFixed(2)}</span>}
                              {!hasVariants && (
                                <span className={`text-[10px] ${availableStock < 5 ? 'text-red-500 font-medium' : 'text-zinc-400'}`}>
                                  Estoque: {availableStock}
                                </span>
                              )}
                              <Badge className="text-[9px] py-0 px-1 bg-zinc-100 text-zinc-500 border-none font-normal">
                                {item.type === 'kit' ? 'Kit' : hasVariants ? 'Produto (Com Tamanhos)' : 'Produto'}
                              </Badge>
                            </div>
                          </div>
                          {!hasVariants && (
                            <Button
                              size="sm"
                              variant="outline"
                              className="h-7 w-7 p-0 flex-shrink-0"
                              disabled={availableStock <= currentQty}
                              onClick={() => addCatalogItemToEditCart(item)}
                            >
                              <Plus className="w-3.5 h-3.5" />
                            </Button>
                          )}
                        </div>

                        {/* Listar as variantes se houver */}
                        {hasVariants && (
                          <div className="pl-6 pr-3 pb-3 space-y-1.5">
                            {(item.variants || []).map((v: any) => {
                              const cleanName = v.name.replace(item.name + ' - ', '');
                              const vInCart = editCart.find(i => i.id === v.id && i.type === "variant");
                              const vCurrentQty = vInCart ? vInCart.quantity : 0;
                              const vStock = parseInt(v.stock);

                              return (
                                <div key={v.id} className="flex items-center justify-between bg-zinc-50 border border-zinc-200 p-2 rounded-lg text-[10px]">
                                  <span className="font-semibold text-zinc-700">{cleanName}</span>
                                  <div className="flex items-center gap-2">
                                    <span className="font-bold text-primary">R$ {parseFloat(v.price).toFixed(2)}</span>
                                    <span className={vStock < 5 ? "text-red-500 font-medium" : "text-zinc-400"}>Estoque: {vStock} un</span>
                                    <Button
                                      type="button"
                                      size="sm"
                                      variant="outline"
                                      className="h-6 w-6 p-0"
                                      disabled={vStock <= vCurrentQty}
                                      onClick={() => addCatalogItemToEditCart({
                                        id: v.id,
                                        name: v.name,
                                        price: parseFloat(v.price),
                                        stock: vStock,
                                        type: "variant"
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
                  })
                )}
              </div>
            </div>

            {/* Coluna da Direita: Itens no Pedido + Formulários (lg:col-span-7) */}
            <div className="lg:col-span-7 flex flex-col space-y-4 max-h-full">
              {/* Itens do Pedido Atual */}
              <div className="border border-zinc-200 rounded-xl overflow-hidden flex flex-col flex-1 bg-white">
                <div className="px-4 py-2.5 bg-zinc-50 border-b border-zinc-200 flex justify-between items-center">
                  <span className="text-xs font-bold text-zinc-700 flex items-center gap-1.5">
                    <ShoppingBag className="w-3.5 h-3.5 text-primary" /> Itens do Pedido
                  </span>
                  <Badge variant="secondary" className="text-[10px] font-bold">
                    {editCart.reduce((sum, i) => sum + i.quantity, 0)} unidade(s)
                  </Badge>
                </div>

                <div className="flex-1 overflow-y-auto divide-y divide-zinc-100 max-h-[220px]">
                  {editCart.length === 0 ? (
                    <div className="text-center py-8 text-zinc-400">
                      <ShoppingBag className="w-8 h-8 mx-auto mb-2 opacity-30" />
                      <p className="text-xs">Nenhum item no pedido. Adicione itens da lista ao lado.</p>
                    </div>
                  ) : (
                    editCart.map(item => (
                      <div key={`${item.type}-${item.id}`} className="flex items-center gap-2 p-3">
                        <div className="flex-1 min-w-0">
                          <p className="text-xs font-bold text-zinc-800 truncate">{item.name}</p>
                          <p className="text-xs text-zinc-400 mt-0.5">
                            R$ {item.price.toFixed(2)} × {item.quantity} = <span className="font-bold text-zinc-700">R$ {(item.price * item.quantity).toFixed(2)}</span>
                          </p>
                        </div>
                        <div className="flex items-center gap-1 flex-shrink-0">
                          <Button
                            type="button"
                            size="sm"
                            variant="ghost"
                            className="h-6 w-6 p-0 hover:bg-zinc-100"
                            onClick={() => changeEditCartQty(item, -1)}
                          >
                            <Minus className="w-3 h-3" />
                          </Button>
                          <span className="text-xs font-bold w-6 text-center">{item.quantity}</span>
                          <Button
                            type="button"
                            size="sm"
                            variant="ghost"
                            className="h-6 w-6 p-0 hover:bg-zinc-100"
                            onClick={() => changeEditCartQty(item, 1)}
                          >
                            <Plus className="w-3 h-3" />
                          </Button>
                          <Button
                            type="button"
                            size="sm"
                            variant="ghost"
                            className="h-6 w-6 p-0 text-zinc-300 hover:text-red-500 hover:bg-red-50"
                            onClick={() => removeEditCartItem(item)}
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </Button>
                        </div>
                      </div>
                    ))
                  )}
                </div>

                {/* Resumo financeiro temporário */}
                <div className="p-3 bg-zinc-50 border-t border-zinc-200 grid grid-cols-3 gap-2 text-xs">
                  <div className="flex flex-col">
                    <span className="text-zinc-400">Subtotal</span>
                    <span className="font-bold text-zinc-700">R$ {editCart.reduce((sum, i) => sum + i.price * i.quantity, 0).toFixed(2)}</span>
                  </div>
                  <div className="flex flex-col">
                    <span className="text-zinc-400 flex items-center gap-0.5"><Tag className="w-3 h-3" /> Desconto</span>
                    <span className="font-bold text-emerald-600">- R$ {(parseFloat(editDiscountAmount) || 0).toFixed(2)}</span>
                  </div>
                  <div className="flex flex-col items-end">
                    <span className="text-zinc-400">Total Editado</span>
                    <span className="font-black text-sm text-primary">
                      R$ {Math.max(0, editCart.reduce((sum, i) => sum + i.price * i.quantity, 0) - (parseFloat(editDiscountAmount) || 0)).toFixed(2)}
                    </span>
                  </div>
                </div>
              </div>

              {/* Informações adicionais do cliente e entrega */}
              <div className="bg-zinc-50/50 p-4 rounded-xl border border-zinc-200 grid grid-cols-2 gap-3 text-xs">
                <div className="col-span-2"><p className="font-semibold text-zinc-700 mb-1">Informações do Cliente & Entrega</p></div>
                
                <div>
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">Cliente (Nome)</Label>
                  <Input
                    className="h-8 text-xs mt-1 bg-white border-zinc-200"
                    placeholder="Nome do cliente avulso"
                    value={editCustomerName}
                    disabled={!!editingOrder?.user_id}
                    onChange={e => setEditCustomerName(e.target.value)}
                  />
                  {editingOrder?.user_id && (
                    <span className="text-[9px] text-zinc-400 block mt-0.5">Cliente cadastrado (não editável)</span>
                  )}
                </div>

                <div>
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">WhatsApp / Telefone</Label>
                  <Input
                    className="h-8 text-xs mt-1 bg-white border-zinc-200"
                    placeholder="Telefone de contato"
                    value={editCustomerPhone}
                    disabled={!!editingOrder?.user_id}
                    onChange={e => setEditCustomerPhone(e.target.value)}
                  />
                </div>

                <div>
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">Desconto Manual (R$)</Label>
                  <Input
                    type="number" min="0" step="0.01"
                    className="h-8 text-xs mt-1 bg-white border-zinc-200"
                    placeholder="0,00"
                    value={editDiscountAmount}
                    onChange={e => setEditDiscountAmount(e.target.value)}
                  />
                </div>

                <div>
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">Método Pagamento</Label>
                  <Select value={editPaymentMethod} onValueChange={setEditPaymentMethod}>
                    <SelectTrigger className="h-8 text-xs mt-1 bg-white border-zinc-200">
                      <SelectValue placeholder="Pagamento" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="cash">Dinheiro</SelectItem>
                      <SelectItem value="credit">Cartão Crédito</SelectItem>
                      <SelectItem value="debit">Cartão Débito</SelectItem>
                      <SelectItem value="pix">PIX</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="col-span-2">
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">Endereço de Entrega / Instruções</Label>
                  <Input
                    className="h-8 text-xs mt-1 bg-white border-zinc-200"
                    placeholder="Av. Principal 123... ou 'Retirada Balcão'"
                    value={editShippingAddress}
                    onChange={e => setEditShippingAddress(e.target.value)}
                  />
                </div>

                <div className="col-span-2">
                  <Label className="text-[10px] text-zinc-500 uppercase font-bold">Observações / Notas internas</Label>
                  <Input
                    className="h-8 text-xs mt-1 bg-white border-zinc-200"
                    placeholder="Notas sobre a alteração do pedido..."
                    value={editNotes}
                    onChange={e => setEditNotes(e.target.value)}
                  />
                </div>
              </div>
            </div>
          </div>

          <div className="border-t pt-4 flex justify-end gap-3">
            <Button
              variant="outline"
              onClick={() => {
                setIsEditDialogOpen(false);
                setEditingOrder(null);
              }}
              disabled={savingEdit}
            >
              Cancelar
            </Button>
            <Button
              onClick={saveOrderEdit}
              disabled={savingEdit || editCart.length === 0}
              className="bg-primary hover:bg-olive gap-1.5"
            >
              {savingEdit ? "Salvando..." : <><CheckCircle className="w-4 h-4" /> Salvar Alterações</>}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
