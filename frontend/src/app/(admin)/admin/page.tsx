"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { apiFetch } from "@/services/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ShoppingBag, Users, Package, FileText, TrendingUp, ArrowUpRight, Clock, AlertTriangle, ChevronRight, PackageCheck } from "lucide-react";
import { motion } from "framer-motion";

export default function AdminDashboard() {
  const [stats, setStats] = useState<any>(null);
  const [pendingOrders, setPendingOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingPending, setLoadingPending] = useState(true);

  useEffect(() => {
    async function loadStats() {
      try {
        const response = await apiFetch("/auth/admin/stats");
        setStats(response.data);
      } catch (error) {
        console.error("Error loading dashboard stats", error);
      } finally {
        setLoading(false);
      }
    }

    async function loadPending() {
      try {
        const response = await apiFetch("/ecommerce/orders/pending-fulfillment");
        setPendingOrders(response.data?.slice(0, 4) || []);
      } catch {
        // silently fail — not critical for dashboard
      } finally {
        setLoadingPending(false);
      }
    }

    loadStats();
    loadPending();
  }, []);

  if (loading) return <div className="p-8 text-zinc-500 animate-pulse">Carregando métricas...</div>;

  const metrics = [
    { 
      title: "Vendas Totais", 
      value: `R$ ${parseFloat(stats?.metrics.total_sales || 0).toFixed(2)}`, 
      icon: TrendingUp, 
      color: "text-emerald-600", 
      bg: "bg-emerald-50" 
    },
    { 
      title: "Pedidos", 
      value: stats?.metrics.total_orders || 0, 
      icon: ShoppingBag, 
      color: "text-blue-600", 
      bg: "bg-blue-50" 
    },
    { 
      title: "Produtos", 
      value: stats?.metrics.total_products || 0, 
      icon: Package, 
      color: "text-amber-600", 
      bg: "bg-amber-50" 
    },
    { 
      title: "Artigos Blog", 
      value: stats?.metrics.total_posts || 0, 
      icon: FileText, 
      color: "text-purple-600", 
      bg: "bg-purple-50" 
    },
  ];

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold font-outfit text-zinc-900">Visão Geral</h1>
        <p className="text-zinc-500">Bem-vinda ao seu centro de controle artesanal.</p>
      </div>

      {/* ── Pending Orders Alert ── */}
      {!loadingPending && pendingOrders.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: -16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <div className="bg-gradient-to-r from-amber-50 to-orange-50 border-2 border-amber-200 rounded-2xl p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-5">
              <div className="flex items-center gap-3">
                <div className="relative">
                  <div className="w-10 h-10 rounded-full bg-amber-100 flex items-center justify-center">
                    <AlertTriangle className="w-5 h-5 text-amber-600" />
                  </div>
                  {/* Pulsing badge */}
                  <span className="absolute -top-1 -right-1 flex h-4 w-4">
                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                    <span className="relative inline-flex rounded-full h-4 w-4 bg-amber-500 items-center justify-center text-[9px] font-bold text-white">
                      {pendingOrders.length}
                    </span>
                  </span>
                </div>
                <div>
                  <p className="font-bold text-amber-900 text-lg font-outfit">
                    {pendingOrders.length} pedido{pendingOrders.length > 1 ? "s" : ""} aguardando envio
                  </p>
                  <p className="text-sm text-amber-600">
                    Clique para iniciar o processo de separação e embalagem.
                  </p>
                </div>
              </div>
              <Link
                href="/admin/fulfillment"
                className="flex items-center gap-2 bg-amber-500 hover:bg-amber-600 text-white px-5 py-2.5 rounded-xl font-semibold text-sm transition-colors flex-shrink-0"
              >
                <PackageCheck className="w-4 h-4" />
                Ir para Separação e Envio
                <ChevronRight className="w-4 h-4" />
              </Link>
            </div>

            {/* Mini cards dos pedidos pendentes */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
              {pendingOrders.map((order: any) => (
                <Link
                  key={order.id}
                  href="/admin/fulfillment"
                  className="bg-white/70 backdrop-blur-sm rounded-xl p-3 border border-amber-200/60 hover:bg-white hover:shadow-sm transition-all block"
                >
                  <div className="flex justify-between items-start mb-1.5">
                    <p className="text-xs font-bold text-zinc-700">{order.order_number}</p>
                    <div className="flex items-center gap-1 text-[10px] text-amber-600 font-medium">
                      <Clock className="w-3 h-3" />
                      {order.waiting_label}
                    </div>
                  </div>
                  <p className="text-sm font-medium text-zinc-800 truncate">
                    {order.user?.name || order.customer_name || "Cliente avulso"}
                  </p>
                  <p className="text-xs text-zinc-500 mt-0.5">
                    {order.items?.length} ite{order.items?.length === 1 ? "m" : "ns"} · R$ {parseFloat(order.total).toFixed(2)}
                  </p>
                </Link>
              ))}
            </div>
          </div>
        </motion.div>
      )}

      {/* Metrics Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {metrics.map((metric, index) => (
          <motion.div
            key={metric.title}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
          >
            <Card className="border-none shadow-sm hover:shadow-md transition-shadow">
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium text-zinc-500 uppercase tracking-wider">
                  {metric.title}
                </CardTitle>
                <div className={`${metric.bg} p-2 rounded-lg`}>
                  <metric.icon className={`w-4 h-4 ${metric.color}`} />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold font-outfit text-zinc-900">{metric.value}</div>
                <p className="text-xs text-zinc-400 mt-1 flex items-center gap-1">
                  <ArrowUpRight className="w-3 h-3 text-emerald-500" />
                  +12% desde o último mês
                </p>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Recent Orders */}
        <Card className="border-none shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-outfit">Pedidos Recentes</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              {stats?.recent_orders.map((order: any) => (
                <div key={order.id} className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-zinc-100 flex items-center justify-center font-bold text-zinc-600">
                      {order.user?.name[0]}
                    </div>
                    <div>
                      <p className="text-sm font-medium text-zinc-900">{order.user?.name}</p>
                      <p className="text-xs text-zinc-500">{order.order_number}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-bold text-primary">R$ {parseFloat(order.total).toFixed(2)}</p>
                    <p className="text-[10px] uppercase text-zinc-400">{order.status}</p>
                  </div>
                </div>
              ))}
              {stats?.recent_orders.length === 0 && (
                <p className="text-center text-zinc-400 py-4 italic">Nenhum pedido realizado ainda.</p>
              )}
            </div>
          </CardContent>
        </Card>

        {/* System Activity */}
        <Card className="border-none shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-outfit">Atividades do Sistema</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              <div className="flex gap-4">
                <div className="w-2 h-2 rounded-full bg-emerald-500 mt-1.5" />
                <div>
                  <p className="text-sm text-zinc-900">Nova erva "Lavanda" adicionada ao catálogo.</p>
                  <p className="text-xs text-zinc-400">Há 2 horas</p>
                </div>
              </div>
              <div className="flex gap-4">
                <div className="w-2 h-2 rounded-full bg-blue-500 mt-1.5" />
                <div>
                  <p className="text-sm text-zinc-900">Backup semanal concluído com sucesso.</p>
                  <p className="text-xs text-zinc-400">Há 5 horas</p>
                </div>
              </div>
              <div className="flex gap-4">
                <div className="w-2 h-2 rounded-full bg-amber-500 mt-1.5" />
                <div>
                  <p className="text-sm text-zinc-900">Estoque baixo para "Sabonete de Alecrim".</p>
                  <p className="text-xs text-zinc-400">Há 1 dia</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
