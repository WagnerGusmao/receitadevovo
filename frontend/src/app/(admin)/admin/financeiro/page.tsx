"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Legend, Cell,
} from "recharts";
import {
  TrendingUp, ShoppingBag, Package, RefreshCw,
  AlertCircle, DollarSign, BarChart3, ArrowUpRight, ArrowDownRight,
  Calendar,
} from "lucide-react";

const PERIODS = [
  { label: "7 dias",  value: "7d" },
  { label: "30 dias", value: "30d" },
  { label: "3 meses", value: "90d" },
  { label: "6 meses", value: "6m" },
  { label: "1 ano",   value: "1y" },
  { label: "Personalizado", value: "custom" },
];

const getLast12Months = () => {
  const list = [];
  const date = new Date();
  for (let i = 0; i < 12; i++) {
    const y = date.getFullYear();
    const m = date.getMonth();
    
    const start = new Date(y, m, 1);
    const end = new Date(y, m + 1, 0);
    
    const formatDate = (d: Date) => {
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };

    const label = start.toLocaleDateString("pt-BR", { month: "long", year: "numeric" });
    const capitalizedLabel = label.charAt(0).toUpperCase() + label.slice(1);
    
    list.push({
      label: capitalizedLabel,
      start: formatDate(start),
      end: formatDate(end),
      value: `${y}-${String(m + 1).padStart(2, '0')}`,
    });

    date.setMonth(date.getMonth() - 1);
  }
  return list;
};

const monthsList = getLast12Months();
const COLORS = ["#7c6f45","#4a7c5c","#c4b080","#6aaa7a","#f59e0b","#ef4444","#8b5cf6","#06b6d4"];

type DRE = {
  period: { from: string; to: string };
  gross_revenue: number; order_count: number; cancelled_count: number;
  cmv: number; gross_profit: number; gross_margin: number | null;
  purchase_cost: number; production_cost: number; stock_value: number;
};
type MonthRow = {
  month: string; label: string; revenue: number; cmv: number;
  gross_profit: number; purchase_cost: number; production_cost: number;
};
type ProductMargin = {
  product_id: number; product_name: string; units_sold: number;
  unit_price: number; unit_cost: number; unit_margin: number | null;
  revenue: number; cmv: number; gross_profit: number;
  margin_pct: number | null; has_cost_data: boolean;
};
type TopProduct = { product_id: number; name: string; units: number; revenue: number };

const currency = (v: number) =>
  v.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
const pct = (v: number | null) =>
  v !== null && v !== undefined ? `${v.toFixed(1)}%` : '—';

const TooltipBRL = ({ active, payload, label }: any) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-white border border-zinc-200 rounded-lg shadow-lg p-3 text-xs">
      <p className="font-semibold text-zinc-700 mb-1">{label}</p>
      {payload.map((p: any) => (
        <p key={p.name} style={{ color: p.color }}>
          {p.name}: {currency(p.value)}
        </p>
      ))}
    </div>
  );
};

function DeltaBadge({ value, inverted = false }: { value: number | null; inverted?: boolean }) {
  if (value === null || value === undefined) return <span className="text-zinc-400">—</span>;
  const positive = inverted ? value < 0 : value > 0;
  return (
    <span className={`flex items-center gap-0.5 text-xs font-semibold ${positive ? 'text-emerald-600' : 'text-red-500'}`}>
      {positive ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
      {pct(value)}
    </span>
  );
}

export default function FinanceiroPage() {
  const [period, setPeriod]       = useState("30d");
  const [loading, setLoading]     = useState(true);
  const [dre, setDre]             = useState<DRE | null>(null);
  const [monthly, setMonthly]     = useState<MonthRow[]>([]);
  const [margins, setMargins]     = useState<ProductMargin[]>([]);
  const [topProducts, setTopProducts] = useState<TopProduct[]>([]);

  const [startDate, setStartDate] = useState(() => {
    const d = new Date();
    const y = d.getFullYear();
    const m = d.getMonth();
    return `${y}-${String(m + 1).padStart(2, '0')}-01`;
  });
  const [endDate, setEndDate] = useState(() => {
    const d = new Date();
    const y = d.getFullYear();
    const m = d.getMonth();
    const lastDay = new Date(y, m + 1, 0).getDate();
    return `${y}-${String(m + 1).padStart(2, '0')}-${String(lastDay).padStart(2, '0')}`;
  });

  const [appliedStartDate, setAppliedStartDate] = useState(startDate);
  const [appliedEndDate, setAppliedEndDate] = useState(endDate);

  const loadAll = useCallback(async () => {
    setLoading(true);
    try {
      let queryParams = `?period=${period}`;
      if (period === "custom") {
        queryParams += `&from=${appliedStartDate}&to=${appliedEndDate}`;
      }

      const [dreRes, monthRes, marginRes, topRes] = await Promise.all([
        apiFetch(`/inventory/financial/dre${queryParams}`),
        apiFetch(`/inventory/financial/monthly-series?months=6`),
        apiFetch(`/inventory/financial/product-margins${queryParams}`),
        apiFetch(`/inventory/financial/top-products${queryParams}`),
      ]);
      setDre(dreRes.data);
      setMonthly(monthRes.data);
      setMargins(marginRes.data);
      setTopProducts(topRes.data);
    } catch {
      toast.error("Erro ao carregar dados financeiros");
    } finally {
      setLoading(false);
    }
  }, [period, appliedStartDate, appliedEndDate]);

  useEffect(() => { loadAll(); }, [loadAll]);

  const handleMonthChange = (monthValue: string) => {
    const selected = monthsList.find(m => m.value === monthValue);
    if (selected) {
      setStartDate(selected.start);
      setEndDate(selected.end);
      setAppliedStartDate(selected.start);
      setAppliedEndDate(selected.end);
    }
  };

  const handleApplyFilter = () => {
    if (!startDate || !endDate) {
      toast.error("Por favor, preencha ambas as datas");
      return;
    }
    if (new Date(startDate) > new Date(endDate)) {
      toast.error("A data de início não pode ser maior que a data de término");
      return;
    }
    setAppliedStartDate(startDate);
    setAppliedEndDate(endDate);
  };

  const hasCostGap = margins.some(m => !m.has_cost_data);

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Dashboard Financeiro</h1>
          <p className="text-sm text-zinc-500">DRE simplificada, CMV e lucratividade por produto.</p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <div className="flex gap-1 bg-zinc-100 rounded-full p-1">
            {PERIODS.map(p => (
              <button key={p.value}
                onClick={() => setPeriod(p.value)}
                className={`px-3 py-1 rounded-full text-xs font-medium transition-all ${
                  period === p.value ? 'bg-white shadow text-zinc-900' : 'text-zinc-400 hover:text-zinc-600'
                }`}>
                {p.label}
              </button>
            ))}
          </div>
          <Button variant="outline" size="sm" onClick={loadAll} disabled={loading} className="h-8 gap-1">
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
          </Button>
        </div>
      </div>

      {/* Filtro Personalizado */}
      {period === 'custom' && (
        <div className="bg-white border border-zinc-200 rounded-xl p-5 shadow-sm space-y-4 animate-in fade-in slide-in-from-top-1 duration-200">
          <div className="flex items-center gap-2 text-zinc-700 font-semibold text-sm">
            <Calendar className="w-4 h-4 text-[#7c6f45]" />
            <span>Filtro Personalizado de Período</span>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-4 gap-4 items-end">
            <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1.5 uppercase tracking-wider">
                Mês Rápido
              </label>
              <Select onValueChange={handleMonthChange}>
                <SelectTrigger className="w-full h-10 border-bege text-terra">
                  <SelectValue placeholder="Selecionar mês..." />
                </SelectTrigger>
                <SelectContent>
                  {monthsList.map(m => (
                    <SelectItem key={m.value} value={m.value}>
                      {m.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            
            <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1.5 uppercase tracking-wider">
                Data Início
              </label>
              <Input
                type="date"
                value={startDate}
                onChange={e => setStartDate(e.target.value)}
                className="w-full h-10 border-bege"
              />
            </div>
            
            <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1.5 uppercase tracking-wider">
                Data Fim
              </label>
              <Input
                type="date"
                value={endDate}
                onChange={e => setEndDate(e.target.value)}
                className="w-full h-10 border-bege"
              />
            </div>
            
            <div>
              <Button
                onClick={handleApplyFilter}
                className="w-full h-10 bg-[#7c6f45] hover:bg-[#635837] text-white font-medium transition-colors"
              >
                Aplicar Filtro
              </Button>
            </div>
          </div>
        </div>
      )}

      {hasCostGap && (
        <div className="flex items-start gap-3 bg-amber-50 border border-amber-200 rounded-xl px-4 py-3 text-sm text-amber-800">
          <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
          <div>
            <strong>CMV parcialmente calculado.</strong> Alguns produtos ainda não possuem custo unitário registrado.
            Finalize ao menos uma Ordem de Produção para que o custo seja atualizado automaticamente.
          </div>
        </div>
      )}

      {loading && !dre ? (
        <div className="text-center py-20 text-zinc-400">Carregando dados financeiros...</div>
      ) : dre && (
        <>
          {/* ── DRE em cards ────────────────────────────────── */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {/* Receita Bruta */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5 col-span-1">
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Receita Bruta</span>
                <div className="w-8 h-8 rounded-full bg-emerald-50 flex items-center justify-center">
                  <TrendingUp className="w-4 h-4 text-emerald-600" />
                </div>
              </div>
              <p className="text-2xl font-bold text-zinc-900">{currency(dre.gross_revenue)}</p>
              <p className="text-xs text-zinc-400 mt-1">
                {dre.order_count} pedidos · {dre.cancelled_count} cancelados
              </p>
            </div>

            {/* CMV */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">CMV</span>
                <div className="w-8 h-8 rounded-full bg-red-50 flex items-center justify-center">
                  <Package className="w-4 h-4 text-red-500" />
                </div>
              </div>
              <p className="text-2xl font-bold text-zinc-900">{currency(dre.cmv)}</p>
              <p className="text-xs text-zinc-400 mt-1">
                {dre.gross_revenue > 0
                  ? `${((dre.cmv / dre.gross_revenue) * 100).toFixed(1)}% da receita`
                  : 'Custo da mercadoria vendida'}
              </p>
            </div>

            {/* Lucro Bruto */}
            <div className={`rounded-xl border shadow-sm p-5 ${
              dre.gross_profit >= 0 ? 'bg-emerald-50 border-emerald-200' : 'bg-red-50 border-red-200'
            }`}>
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs text-emerald-700 uppercase tracking-wider font-medium">Lucro Bruto</span>
                <DeltaBadge value={dre.gross_margin} />
              </div>
              <p className={`text-2xl font-bold ${dre.gross_profit >= 0 ? 'text-emerald-800' : 'text-red-700'}`}>
                {currency(dre.gross_profit)}
              </p>
              <p className="text-xs text-emerald-700 mt-1">
                Margem: <strong>{pct(dre.gross_margin)}</strong>
              </p>
            </div>

            {/* Valor em Estoque */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Estoque (MP)</span>
                <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center">
                  <DollarSign className="w-4 h-4 text-blue-600" />
                </div>
              </div>
              <p className="text-2xl font-bold text-zinc-900">{currency(dre.stock_value)}</p>
              <p className="text-xs text-zinc-400 mt-1">Valor atual em matérias-primas</p>
            </div>
          </div>

          {/* DRE detalhada em linha */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
            <div className="px-5 py-4 border-b border-zinc-100">
              <h2 className="font-semibold text-zinc-800 flex items-center gap-2">
                <BarChart3 className="w-4 h-4 text-primary" /> DRE Simplificada
              </h2>
              <p className="text-xs text-zinc-400 mt-0.5">
                {dre.period.from} → {dre.period.to}
              </p>
            </div>
            <div className="divide-y divide-zinc-50">
              {[
                { label: "Receita Bruta",       value: dre.gross_revenue,   cls: "font-bold text-zinc-900 text-base" },
                { label: "( - ) CMV",           value: -dre.cmv,            cls: "text-red-600" },
                { label: "= Lucro Bruto",        value: dre.gross_profit,    cls: `font-semibold ${dre.gross_profit >= 0 ? 'text-emerald-700' : 'text-red-600'}` },
                { label: "Custo de Compras (MP)",value: dre.purchase_cost,   cls: "text-zinc-600" },
                { label: "Custo de Produção",    value: dre.production_cost, cls: "text-zinc-600" },
              ].map(row => (
                <div key={row.label} className="flex justify-between items-center px-5 py-3">
                  <span className={`text-sm ${row.cls.includes('font') ? '' : 'text-zinc-600'}`}>{row.label}</span>
                  <span className={`text-sm font-mono ${row.cls}`}>
                    {currency(Math.abs(row.value))}
                  </span>
                </div>
              ))}
              <div className="flex justify-between items-center px-5 py-3 bg-zinc-50">
                <span className="text-xs text-zinc-400">Margem Bruta</span>
                <span className={`text-sm font-bold ${(dre.gross_margin ?? 0) >= 0 ? 'text-emerald-700' : 'text-red-600'}`}>
                  {pct(dre.gross_margin)}
                </span>
              </div>
            </div>
          </div>

          {/* ── Série Mensal ─────────────────────────────────── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
            <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-primary" /> Receita vs CMV vs Lucro Bruto (mensal)
            </h2>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={monthly} margin={{ top: 5, right: 20, left: 10, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f4f4f5" vertical={false} />
                <XAxis dataKey="label" tick={{ fontSize: 11 }} tickLine={false} />
                <YAxis tick={{ fontSize: 10 }} tickLine={false} axisLine={false}
                  tickFormatter={v => `R$${v >= 1000 ? (v / 1000).toFixed(0) + 'k' : v}`} />
                <Tooltip content={<TooltipBRL />} />
                <Legend wrapperStyle={{ fontSize: 11 }} />
                <Bar dataKey="revenue"      name="Receita"     fill="#7c6f45" radius={[3,3,0,0]} />
                <Bar dataKey="cmv"          name="CMV"         fill="#ef4444" radius={[3,3,0,0]} />
                <Bar dataKey="gross_profit" name="Lucro Bruto" fill="#4a7c5c" radius={[3,3,0,0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* ── Linha: Top Produtos + Margens ───────────────── */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Top produtos por receita */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
                <ShoppingBag className="w-4 h-4 text-amber-500" /> Top Produtos por Receita
              </h2>
              {topProducts.length === 0 ? (
                <p className="text-sm text-zinc-400 text-center py-8">Sem vendas no período</p>
              ) : (
                <>
                  <div className="space-y-2 mb-4">
                    {topProducts.slice(0, 5).map((p, i) => (
                      <div key={p.product_id} className="flex items-center gap-3">
                        <span className={`w-5 h-5 rounded-full text-[10px] font-bold flex items-center justify-center shrink-0
                          ${i === 0 ? 'bg-amber-100 text-amber-700' : 'bg-zinc-100 text-zinc-400'}`}>
                          {i + 1}
                        </span>
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium text-zinc-800 truncate">{p.name}</p>
                          <p className="text-xs text-zinc-400">{p.units} un vendidas</p>
                        </div>
                        <span className="font-semibold text-sm text-zinc-800 shrink-0">{currency(p.revenue)}</span>
                      </div>
                    ))}
                  </div>
                  <ResponsiveContainer width="100%" height={130}>
                    <BarChart data={topProducts.slice(0, 6)} layout="vertical"
                      margin={{ top: 0, right: 20, left: 0, bottom: 0 }}>
                      <XAxis type="number" hide />
                      <YAxis type="category" dataKey="name" tick={{ fontSize: 9 }} width={90}
                        tickFormatter={v => v.length > 12 ? v.slice(0, 12) + '…' : v} />
                      <Tooltip formatter={(v: any) => currency(Number(v))} />
                      <Bar dataKey="revenue" name="Receita" radius={[0, 3, 3, 0]}>
                        {topProducts.slice(0, 6).map((_, i) => (
                          <Cell key={i} fill={COLORS[i % COLORS.length]} />
                        ))}
                      </Bar>
                    </BarChart>
                  </ResponsiveContainer>
                </>
              )}
            </div>

            {/* Margens por produto */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
                <TrendingUp className="w-4 h-4 text-emerald-600" /> Margem por Produto
              </h2>
              {margins.length === 0 ? (
                <p className="text-sm text-zinc-400 text-center py-8">Sem vendas no período</p>
              ) : (
                <div className="space-y-3">
                  {margins.map((m, i) => (
                    <div key={m.product_id} className={`rounded-lg p-3 border ${
                      !m.has_cost_data ? 'border-zinc-100 bg-zinc-50' : 'border-zinc-200 bg-white'
                    }`}>
                      <div className="flex items-start justify-between gap-2">
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-zinc-800 truncate">{m.product_name}</p>
                          <div className="flex gap-3 mt-0.5 text-xs text-zinc-400 flex-wrap">
                            <span>{m.units_sold} un · {currency(m.revenue)}</span>
                            {m.has_cost_data && (
                              <span>CMV: {currency(m.cmv)} · Lucro: {currency(m.gross_profit)}</span>
                            )}
                          </div>
                        </div>
                        <div className="text-right shrink-0">
                          {m.has_cost_data ? (
                            <Badge className={`border-none text-xs ${
                              (m.margin_pct ?? 0) >= 40 ? 'bg-emerald-100 text-emerald-700' :
                              (m.margin_pct ?? 0) >= 20 ? 'bg-amber-100 text-amber-700' :
                              'bg-red-100 text-red-600'
                            }`}>
                              {pct(m.margin_pct)}
                            </Badge>
                          ) : (
                            <Badge className="border-none text-xs bg-zinc-100 text-zinc-400">
                              sem custo
                            </Badge>
                          )}
                        </div>
                      </div>
                      {m.has_cost_data && (
                        <div className="mt-2">
                          <div className="h-1.5 w-full bg-zinc-100 rounded-full overflow-hidden">
                            <div
                              className="h-full rounded-full transition-all"
                              style={{
                                width: `${Math.min(Math.max(m.margin_pct ?? 0, 0), 100)}%`,
                                background: (m.margin_pct ?? 0) >= 40 ? '#10b981'
                                  : (m.margin_pct ?? 0) >= 20 ? '#f59e0b' : '#ef4444',
                              }}
                            />
                          </div>
                          <div className="flex justify-between text-[10px] text-zinc-400 mt-0.5">
                            <span>Custo/un: {currency(m.unit_cost)}</span>
                            <span>Preço/un: {currency(m.unit_price)}</span>
                          </div>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
}
