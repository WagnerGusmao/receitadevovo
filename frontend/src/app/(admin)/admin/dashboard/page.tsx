"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { DollarSign, ShoppingCart, TrendingUp, Package, Activity, Users, Archive, FlaskConical, Sparkles, Info } from "lucide-react";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";

export default function AdminDashboard() {
  const [metrics, setMetrics] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadMetrics();
  }, []);

  async function loadMetrics() {
    try {
      const response = await apiFetch("/ecommerce/dashboard/metrics");
      setMetrics(response.data);
    } catch (error) {
      console.error("Error loading metrics", error);
      toast.error("Erro ao carregar métricas do painel");
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return <div className="flex items-center justify-center min-h-[400px]">Carregando painel de vendas...</div>;
  }

  if (!metrics) return null;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold font-outfit text-zinc-900">Painel de Vendas</h1>
        <p className="text-sm text-zinc-500">Visão geral do desempenho da sua loja neste mês.</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
          <div className="absolute top-0 right-0 p-4 opacity-5">
            <DollarSign className="w-16 h-16" />
          </div>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-zinc-600">Faturamento Mensal</CardTitle>
            <div className="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center">
              <DollarSign className="h-4 w-4 text-emerald-600" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-zinc-900">
              R$ {parseFloat(metrics.revenue.current || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
            </div>
            <p className={`text-xs mt-1 flex items-center gap-1 ${metrics.revenue.growth >= 0 ? 'text-emerald-600' : 'text-red-600'}`}>
              <TrendingUp className={`h-3 w-3 ${metrics.revenue.growth < 0 && 'rotate-180'}`} />
              {metrics.revenue.growth > 0 ? '+' : ''}{metrics.revenue.growth}% em relação ao mês anterior
            </p>
          </CardContent>
        </Card>

        <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
          <div className="absolute top-0 right-0 p-4 opacity-5">
            <ShoppingCart className="w-16 h-16" />
          </div>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-zinc-600">Total de Pedidos</CardTitle>
            <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
              <ShoppingCart className="h-4 w-4 text-blue-600" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-zinc-900">{metrics.orders.current}</div>
            <p className={`text-xs mt-1 flex items-center gap-1 ${metrics.orders.growth >= 0 ? 'text-emerald-600' : 'text-red-600'}`}>
              <TrendingUp className={`h-3 w-3 ${metrics.orders.growth < 0 && 'rotate-180'}`} />
              {metrics.orders.growth > 0 ? '+' : ''}{metrics.orders.growth}% em relação ao mês anterior
            </p>
          </CardContent>
        </Card>

        <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
          <div className="absolute top-0 right-0 p-4 opacity-5">
            <Activity className="w-16 h-16" />
          </div>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-zinc-600">Ticket Médio</CardTitle>
            <div className="w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center">
              <Activity className="h-4 w-4 text-amber-600" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-zinc-900">
              R$ {parseFloat(metrics.ticket_medio || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
            </div>
            <p className="text-xs text-zinc-500 mt-1">
              Baseado nos pedidos do mês atual
            </p>
          </CardContent>
        </Card>
        <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
          <div className="absolute top-0 right-0 p-4 opacity-5">
            <Users className="w-16 h-16" />
          </div>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-zinc-600">Total de Clientes</CardTitle>
            <div className="w-8 h-8 rounded-full bg-purple-100 flex items-center justify-center">
              <Users className="h-4 w-4 text-purple-600" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-zinc-900">{metrics.customers.current}</div>
            <p className={`text-xs mt-1 flex items-center gap-1 ${metrics.customers.growth >= 0 ? 'text-emerald-600' : 'text-red-600'}`}>
              <TrendingUp className={`h-3 w-3 ${metrics.customers.growth < 0 && 'rotate-180'}`} />
              {metrics.customers.growth > 0 ? '+' : ''}{metrics.customers.growth}% em relação ao mês anterior
            </p>
          </CardContent>
        </Card>
      </div>

      {/* ── Cards Financeiros de Estoque ── */}
      <div>
        <h2 className="text-sm font-semibold text-zinc-500 uppercase tracking-widest mb-3 flex items-center gap-2">
          <Archive className="w-4 h-4" /> Inteligência de Estoque
        </h2>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">

          <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-5"><Archive className="w-16 h-16" /></div>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-zinc-600">Estoque (valor de venda)</CardTitle>
              <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                <Archive className="h-4 w-4 text-blue-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-zinc-900">
                R$ {parseFloat(metrics.inventory?.stock_value_sale || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
              </div>
              <p className="text-xs text-zinc-500 mt-1">Produtos × preço de venda</p>
            </CardContent>
          </Card>

          <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-5"><FlaskConical className="w-16 h-16" /></div>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-zinc-600">Matérias-Primas em Estoque</CardTitle>
              <div className="w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center">
                <FlaskConical className="h-4 w-4 text-amber-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-zinc-900">
                R$ {parseFloat(metrics.inventory?.raw_material_value || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
              </div>
              <p className="text-xs text-zinc-500 mt-1">Insumos × custo médio</p>
            </CardContent>
          </Card>

          <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-5"><Sparkles className="w-16 h-16" /></div>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-zinc-600">Lucro Potencial em Estoque</CardTitle>
              <div className="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center">
                <Sparkles className="h-4 w-4 text-emerald-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${(metrics.inventory?.profit_potential || 0) >= 0 ? 'text-emerald-700' : 'text-red-600'}`}>
                R$ {parseFloat(metrics.inventory?.profit_potential || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
              </div>
              <p className="text-xs text-zinc-500 mt-1">Se vender tudo em estoque</p>
            </CardContent>
          </Card>

          <Card className="bg-white border-zinc-200/60 shadow-sm relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-5"><Info className="w-16 h-16" /></div>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-zinc-600">Custo Cadastrado</CardTitle>
              <div className="w-8 h-8 rounded-full bg-purple-100 flex items-center justify-center">
                <Info className="h-4 w-4 text-purple-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-zinc-900">
                {metrics.inventory?.products_with_cost || 0}
                <span className="text-sm font-normal text-zinc-400"> / {metrics.inventory?.products_total || 0}</span>
              </div>
              <p className="text-xs text-zinc-500 mt-1">
                {metrics.inventory?.products_total > 0
                  ? `${Math.round((metrics.inventory.products_with_cost / metrics.inventory.products_total) * 100)}% dos produtos com custo vinculado`
                  : 'Vincule receitas aos produtos'}
              </p>
              {(metrics.inventory?.products_with_cost < metrics.inventory?.products_total) && (
                <p className="text-xs text-amber-600 mt-1 flex items-center gap-1">
                  <Info className="w-3 h-3" /> Vincule receitas para calcular margens
                </p>
              )}
            </CardContent>
          </Card>

        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        <Card className="shadow-sm border-zinc-200/60">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Package className="w-5 h-5 text-primary" /> 
              Top 5 Produtos Mais Vendidos
            </CardTitle>
          </CardHeader>
          <CardContent>
            {metrics.top_products.length === 0 ? (
              <p className="text-sm text-zinc-500 text-center py-4">Nenhum dado disponível.</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Produto</TableHead>
                    <TableHead className="text-right">Qtd. Vendida</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {metrics.top_products.map((item: any, i: number) => (
                    <TableRow key={i}>
                      <TableCell>
                        <p className="font-medium">{item.itemable?.name}</p>
                        <p className="text-xs text-zinc-500">{item.itemable_type.includes('Product') ? 'Produto' : 'Kit'}</p>
                      </TableCell>
                      <TableCell className="text-right font-bold text-primary">
                        {item.total_sold} un.
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        <Card className="shadow-sm border-zinc-200/60">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Users className="w-5 h-5 text-primary" /> 
              Top 5 Clientes
            </CardTitle>
          </CardHeader>
          <CardContent>
            {metrics.top_customers.length === 0 ? (
              <p className="text-sm text-zinc-500 text-center py-4">Nenhum dado disponível.</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Cliente</TableHead>
                    <TableHead className="text-right">Total Gasto</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {metrics.top_customers.map((customer: any, i: number) => (
                    <TableRow key={i}>
                      <TableCell>
                        <p className="font-medium">{customer.name}</p>
                        <p className="text-xs text-zinc-500">{customer.email}</p>
                      </TableCell>
                      <TableCell className="text-right font-bold text-primary">
                        R$ {parseFloat(customer.total_spent).toFixed(2)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        <Card className="shadow-sm border-zinc-200/60">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Activity className="w-5 h-5 text-primary" /> 
              Status dos Pedidos
            </CardTitle>
          </CardHeader>
          <CardContent>
            {metrics.orders_by_status.length === 0 ? (
              <p className="text-sm text-zinc-500 text-center py-4">Nenhum pedido no sistema.</p>
            ) : (
              <div className="space-y-4 mt-2">
                {metrics.orders_by_status.map((statusData: any) => {
                  let label = statusData.status;
                  let colorClass = "bg-zinc-100 text-zinc-700";
                  
                  switch (statusData.status) {
                    case 'pending': label = 'Pendente'; colorClass = 'bg-amber-100 text-amber-700'; break;
                    case 'processing': label = 'Processando'; colorClass = 'bg-blue-100 text-blue-700'; break;
                    case 'shipped': label = 'Enviado'; colorClass = 'bg-indigo-100 text-indigo-700'; break;
                    case 'delivered': label = 'Entregue'; colorClass = 'bg-emerald-100 text-emerald-700'; break;
                    case 'cancelled': label = 'Cancelado'; colorClass = 'bg-red-100 text-red-700'; break;
                  }

                  return (
                    <div key={statusData.status} className="flex items-center justify-between p-3 rounded-lg border border-zinc-100 bg-zinc-50/50">
                      <div className="flex items-center gap-3">
                        <Badge className={`${colorClass} hover:${colorClass} border-none`}>{label}</Badge>
                      </div>
                      <div className="font-bold">{statusData.total} <span className="text-xs font-normal text-zinc-500">pedidos</span></div>
                    </div>
                  );
                })}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
