"use client";

import { useEffect, useMemo, useState } from "react";
import { apiFetch } from "@/services/api";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { AlertCircle, ArrowDown, ArrowUp, Plus, RefreshCw } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

export default function AdminEstoque() {
  const [activeTab, setActiveTab] = useState<'movements' | 'lowstock'>('movements');
  const [movements, setMovements] = useState([]);
  const [lowStockProducts, setLowStockProducts] = useState([]);
  const [lowStockVariants, setLowStockVariants] = useState([]);
  const [lowStockKits, setLowStockKits] = useState([]);
  const [loading, setLoading] = useState(true);

  const [products, setProducts] = useState<any[]>([]);
  const [kits, setKits]         = useState<any[]>([]);
  const [itemSearch, setItemSearch] = useState("");

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [adjustData, setAdjustData] = useState({
    item_id: "",
    item_type: "product",
    type: "in",
    quantity: "1",
    reason: "manual_adjustment",
    notes: ""
  });

  useEffect(() => {
    loadData();
  }, [activeTab]);

  useEffect(() => {
    apiFetch("/ecommerce/products?per_page=200").then(r => setProducts(r.data?.products ?? r.data ?? [])).catch(() => {});
    apiFetch("/ecommerce/kits?per_page=200").then(r => setKits(r.data?.kits ?? r.data ?? [])).catch(() => {});
  }, []);

  // Derivar a lista de variantes a partir dos produtos de forma reativa e transparente
  const variants = useMemo(() => {
    const list: any[] = [];
    products.forEach((p: any) => {
      if (p.variants && p.variants.length > 0) {
        p.variants.forEach((v: any) => {
          list.push({
            id: v.id,
            name: v.name, // O accessor do backend já retorna o nome completo ("Produto - Variante")
            stock: v.stock
          });
        });
      }
    });
    return list;
  }, [products]);

  const itemOptions = useMemo(() => {
    const list = adjustData.item_type === "product"
      ? products.filter(p => !p.variants || p.variants.length === 0) // Apenas produtos simples
      : adjustData.item_type === "variant"
      ? variants
      : kits;

    if (!itemSearch.trim()) return list;
    return list.filter(i => i.name.toLowerCase().includes(itemSearch.toLowerCase()));
  }, [adjustData.item_type, products, variants, kits, itemSearch]);

  async function loadData() {
    setLoading(true);
    try {
      if (activeTab === 'movements') {
        const response = await apiFetch("/ecommerce/inventory/movements");
        setMovements(response.data.data); // Paginated
      } else {
        const response = await apiFetch("/ecommerce/inventory/low-stock?threshold=10");
        setLowStockProducts(response.data.products);
        setLowStockKits(response.data.kits);
        setLowStockVariants(response.data.variants || []);
      }
    } catch (error) {
      console.error("Error loading inventory data", error);
      toast.error("Erro ao carregar dados de estoque");
    } finally {
      setLoading(false);
    }
  }

  const handleAdjust = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch("/ecommerce/inventory/adjust", {
        method: "POST",
        body: JSON.stringify({
          item_id: parseInt(adjustData.item_id),
          item_type: adjustData.item_type,
          type: adjustData.type,
          quantity: parseInt(adjustData.quantity),
          reason: adjustData.reason,
          notes: adjustData.notes
        })
      });
      
      setIsModalOpen(false);
      setAdjustData({ item_id: "", item_type: "product", type: "in", quantity: "1", reason: "manual_adjustment", notes: "" });
      setItemSearch("");
      toast.success("Estoque ajustado com sucesso");
      loadData();
    } catch (error: any) {
      toast.error(error.message || "Erro ao ajustar estoque");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Gestão de Estoque</h1>
          <p className="text-sm text-zinc-500">Monitore níveis de estoque e histórico de movimentações.</p>
        </div>
        
        <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-olive gap-2">
              <Plus className="w-4 h-4" /> Ajuste Manual
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[500px]">
            <form onSubmit={handleAdjust}>
              <DialogHeader>
                <DialogTitle>Ajuste de Estoque</DialogTitle>
                <DialogDescription>
                  Registre uma entrada ou saída manual de um produto ou kit.
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label>Tipo de Item</Label>
                  <Select value={adjustData.item_type} onValueChange={(v) => setAdjustData({...adjustData, item_type: v, item_id: ""})}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="product">Produto Simples</SelectItem>
                      <SelectItem value="variant">Tamanho/Variante</SelectItem>
                      <SelectItem value="kit">Kit</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="grid gap-2">
                  <Label>
                    {adjustData.item_type === "product"
                      ? "Produto Simples"
                      : adjustData.item_type === "variant"
                      ? "Tamanho / Variante"
                      : "Kit"}
                  </Label>
                  <Input
                    placeholder="Buscar por nome..."
                    value={itemSearch}
                    onChange={e => { setItemSearch(e.target.value); setAdjustData(d => ({...d, item_id: ""})); }}
                    className="mb-1"
                  />
                  <select
                    required
                    size={Math.min(5, itemOptions.length + 1)}
                    value={adjustData.item_id}
                    onChange={e => setAdjustData(d => ({...d, item_id: e.target.value}))}
                    className="w-full rounded-md border border-zinc-200 bg-white px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-zinc-950"
                  >
                    <option value="">-- selecione --</option>
                    {itemOptions.map(i => (
                      <option key={i.id} value={i.id}>{i.name} (estoque: {i.stock ?? '?'})</option>
                    ))}
                  </select>
                  {adjustData.item_id && (
                    <p className="text-xs text-zinc-400">ID selecionado: #{adjustData.item_id}</p>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <Label>Movimentação</Label>
                    <Select value={adjustData.type} onValueChange={(v) => setAdjustData({...adjustData, type: v})}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="in">Entrada (+)</SelectItem>
                        <SelectItem value="out">Saída (-)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="grid gap-2">
                    <Label>Quantidade</Label>
                    <Input 
                      type="number" 
                      min="1"
                      value={adjustData.quantity} 
                      onChange={(e) => setAdjustData({...adjustData, quantity: e.target.value})}
                      required 
                    />
                  </div>
                </div>

                <div className="grid gap-2">
                  <Label>Motivo</Label>
                  <Select value={adjustData.reason} onValueChange={(v) => {
                    const outReasons = ['gift_order','gift_promotion','sample','damage','expired','internal_use'];
                    const inReasons  = ['restock','return','manual_adjustment'];
                    const newType = outReasons.includes(v) ? 'out' : inReasons.includes(v) ? 'in' : adjustData.type;
                    setAdjustData({...adjustData, reason: v, type: newType});
                  }}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <optgroup label="── Entradas ──" />
                      <SelectItem value="restock">📦 Reabastecimento</SelectItem>
                      <SelectItem value="return">↩️ Devolução de cliente</SelectItem>
                      <SelectItem value="manual_adjustment">🔧 Ajuste Manual</SelectItem>
                      <optgroup label="── Saídas ──" />
                      <SelectItem value="gift_order">🎁 Brinde em pedido</SelectItem>
                      <SelectItem value="gift_promotion">🎀 Brinde promocional</SelectItem>
                      <SelectItem value="sample">🧪 Amostra grátis</SelectItem>
                      <SelectItem value="damage">⚠️ Avaria / Perda</SelectItem>
                      <SelectItem value="expired">⏰ Produto vencido</SelectItem>
                      <SelectItem value="internal_use">🏭 Uso interno / Testes</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="grid gap-2">
                  <Label>Observações (opcional)</Label>
                  <Input 
                    value={adjustData.notes} 
                    onChange={(e) => setAdjustData({...adjustData, notes: e.target.value})}
                  />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit" className="bg-primary">Confirmar Ajuste</Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex space-x-1 border-b border-zinc-200">
        <button
          className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${activeTab === 'movements' ? 'border-primary text-primary' : 'border-transparent text-zinc-500 hover:text-zinc-700 hover:border-zinc-300'}`}
          onClick={() => setActiveTab('movements')}
        >
          Histórico de Movimentações
        </button>
        <button
          className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors flex items-center gap-2 ${activeTab === 'lowstock' ? 'border-primary text-primary' : 'border-transparent text-zinc-500 hover:text-zinc-700 hover:border-zinc-300'}`}
          onClick={() => setActiveTab('lowstock')}
        >
          Alertas de Estoque
          {(lowStockProducts.length > 0 || lowStockKits.length > 0 || lowStockVariants.length > 0) && (
            <span className="flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-[10px] text-red-600 font-bold">
              {lowStockProducts.length + lowStockKits.length + lowStockVariants.length}
            </span>
          )}
        </button>
      </div>

      {activeTab === 'movements' && (
        <div className="bg-white rounded-xl shadow-sm border border-zinc-200 overflow-hidden">
          <div className="p-4 border-b border-zinc-100 bg-zinc-50/50 flex justify-between items-center">
            <h2 className="font-medium text-zinc-900">Últimas Movimentações</h2>
            <Button variant="ghost" size="sm" onClick={loadData} className="text-zinc-500">
              <RefreshCw className="w-4 h-4 mr-2" /> Atualizar
            </Button>
          </div>
          <Table>
            <TableHeader>
              <TableRow className="bg-zinc-50 hover:bg-zinc-50">
                <TableHead>Data</TableHead>
                <TableHead>Tipo</TableHead>
                <TableHead>Item</TableHead>
                <TableHead>Qtd.</TableHead>
                <TableHead>Motivo</TableHead>
                <TableHead>Usuário/Pedido</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Carregando...</TableCell>
                </TableRow>
              ) : movements.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} className="text-center py-10 text-zinc-400">Nenhuma movimentação registrada.</TableCell>
                </TableRow>
              ) : movements.map((mov: any) => (
                <TableRow key={mov.id}>
                  <TableCell className="text-sm text-zinc-500">
                    {new Date(mov.created_at).toLocaleString()}
                  </TableCell>
                  <TableCell>
                    {mov.type === 'in' ? (
                      <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-none gap-1">
                        <ArrowUp className="w-3 h-3" /> Entrada
                      </Badge>
                    ) : (
                      <Badge className="bg-red-100 text-red-700 hover:bg-red-100 border-none gap-1">
                        <ArrowDown className="w-3 h-3" /> Saída
                      </Badge>
                    )}
                  </TableCell>
                  <TableCell>
                    <p className="font-medium text-zinc-900">{mov.itemable?.name || `Item ID ${mov.itemable_id}`}</p>
                    <p className="text-xs text-zinc-500">
                      {mov.itemable_type.includes('ProductVariant')
                        ? 'Tamanho / Variante'
                        : mov.itemable_type.includes('Product')
                        ? 'Produto'
                        : 'Kit'}
                    </p>
                  </TableCell>
                  <TableCell className="font-bold">
                    {mov.type === 'in' ? '+' : '-'}{mov.quantity}
                  </TableCell>
                  <TableCell className="text-sm">
  {({'sale':'Venda','manual_adjustment':'Ajuste Manual','restock':'Reabastecimento','return':'Devolução','damage':'Avaria/Perda','gift_order':'Brinde em pedido','gift_promotion':'Brinde promocional','sample':'Amostra grátis','expired':'Produto vencido','internal_use':'Uso interno'} as Record<string,string>)[mov.reason] ?? mov.reason}
                  </TableCell>
                  <TableCell className="text-sm text-zinc-500">
                    {mov.order_id ? (
                      <span>Pedido #{mov.order?.order_number || mov.order_id}</span>
                    ) : mov.user_id ? (
                      <span>Usuário {mov.user?.name || mov.user_id}</span>
                    ) : '-'}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      )}

      {activeTab === 'lowstock' && (
        <div className="space-y-6">
          <div className="bg-white rounded-xl shadow-sm border border-red-200 overflow-hidden">
            <div className="p-4 border-b border-red-100 bg-red-50 flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-red-500" />
              <h2 className="font-medium text-red-900">Produtos Simples com Estoque Baixo (≤ 10 un.)</h2>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Produto</TableHead>
                  <TableHead>Estoque Atual</TableHead>
                  <TableHead className="text-right">Ação</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4">Carregando...</TableCell></TableRow>
                ) : lowStockProducts.length === 0 ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4 text-zinc-500">Nenhum produto com estoque baixo.</TableCell></TableRow>
                ) : lowStockProducts.map((p: any) => (
                  <TableRow key={p.id}>
                    <TableCell className="font-mono text-xs">{p.id}</TableCell>
                    <TableCell className="font-medium">{p.name}</TableCell>
                    <TableCell><span className="text-red-600 font-bold">{p.stock} un.</span></TableCell>
                    <TableCell className="text-right">
                      <Button variant="outline" size="sm" onClick={() => {
                        setAdjustData({...adjustData, item_type: 'product', item_id: p.id.toString(), type: 'in'});
                        setIsModalOpen(true);
                      }}>
                        Reabastecer
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-red-200 overflow-hidden">
            <div className="p-4 border-b border-red-100 bg-red-50 flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-red-500" />
              <h2 className="font-medium text-red-900">Tamanhos / Variantes com Estoque Baixo (≤ 10 un.)</h2>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Tamanho/Variante</TableHead>
                  <TableHead>Estoque Atual</TableHead>
                  <TableHead className="text-right">Ação</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4">Carregando...</TableCell></TableRow>
                ) : lowStockVariants.length === 0 ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4 text-zinc-500">Nenhum tamanho/variante com estoque baixo.</TableCell></TableRow>
                ) : lowStockVariants.map((v: any) => (
                  <TableRow key={v.id}>
                    <TableCell className="font-mono text-xs">{v.id}</TableCell>
                    <TableCell className="font-medium">
                      {v.name.includes(v.product?.name) ? v.name : `${v.product?.name || ''} - ${v.name}`}
                    </TableCell>
                    <TableCell><span className="text-red-600 font-bold">{v.stock} un.</span></TableCell>
                    <TableCell className="text-right">
                      <Button variant="outline" size="sm" onClick={() => {
                        setAdjustData({...adjustData, item_type: 'variant', item_id: v.id.toString(), type: 'in'});
                        setIsModalOpen(true);
                      }}>
                        Reabastecer
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-amber-200 overflow-hidden">
            <div className="p-4 border-b border-amber-100 bg-amber-50 flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-amber-500" />
              <h2 className="font-medium text-amber-900">Kits com Estoque Baixo (≤ 10 un.)</h2>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Kit</TableHead>
                  <TableHead>Estoque Atual</TableHead>
                  <TableHead className="text-right">Ação</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4">Carregando...</TableCell></TableRow>
                ) : lowStockKits.length === 0 ? (
                  <TableRow><TableCell colSpan={4} className="text-center py-4 text-zinc-500">Nenhum kit com estoque baixo.</TableCell></TableRow>
                ) : lowStockKits.map((k: any) => (
                  <TableRow key={k.id}>
                    <TableCell className="font-mono text-xs">{k.id}</TableCell>
                    <TableCell className="font-medium">{k.name}</TableCell>
                    <TableCell><span className="text-amber-600 font-bold">{k.stock} un.</span></TableCell>
                    <TableCell className="text-right">
                      <Button variant="outline" size="sm" onClick={() => {
                        setAdjustData({...adjustData, item_type: 'kit', item_id: k.id.toString(), type: 'in'});
                        setIsModalOpen(true);
                      }}>
                        Reabastecer
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </div>
      )}
    </div>
  );
}
