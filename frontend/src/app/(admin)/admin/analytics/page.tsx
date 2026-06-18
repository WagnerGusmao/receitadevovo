"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Legend, PieChart, Pie, Cell
} from "recharts";
import {
  TrendingUp, Factory, AlertTriangle, PackageSearch,
  RefreshCw, BarChart3, Flame, Target, Layers, ChevronUp, ChevronDown
} from "lucide-react";

const PERIODS = [
  { label: "7 dias",   value: "7d" },
  { label: "30 dias",  value: "30d" },
  { label: "3 meses",  value: "90d" },
  { label: "6 meses",  value: "6m" },
  { label: "1 ano",    value: "1y" },
];

const CHART_COLORS = ["#7c6f45", "#a09060", "#c4b080", "#4a7c5c", "#6aaa7a", "#f59e0b", "#ef4444"];

type Overview = {
  period: { from: string; to: string };
  total_orders: number; completed_orders: number; cancelled_orders: number;
  total_units: number; total_cost: number; cost_variance: number;
  efficiency: number | null; total_waste: number;
  stock_value: number; consumption_cost: number;
};
type TimeSeriesPoint = { date: string; cost: number; planned: number; units: number; orders: number };
type RecipeRank = {
  recipe_name: string; product_name: string; total_units: number;
  total_cost: number; avg_unit_cost: number; product_price: number;
  revenue: number; profit: number; margin_percent: number | null;
  total_waste: number; cost_variance: number;
};
type TopMaterial = { name: string; unit: string; total_qty: number; total_cost: number; avg_unit_cost: number };
type WasteData = {
  production_waste: { recipe_name: string; product_name: string; total_waste: number; occurrences: number }[];
  material_waste: { name: string; unit: string; total_qty: number; total_cost: number }[];
  total_waste_cost: number;
};
type EffRow = {
  code: string; recipe: string; product: string;
  planned_yield: number; actual_yield: number; yield_eff: number | null;
  planned_cost: number; actual_cost: number; cost_eff: number | null;
  cost_variance: number; waste: number | null; completed_at: string;
};

function currency(v: number) {
  return v.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}
function pct(v: number | null, suffix = '%') {
  return v !== null && v !== undefined ? `${v.toFixed(1)}${suffix}` : '—';
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-white border border-zinc-200 rounded-lg shadow-lg p-3 text-xs">
      <p className="font-semibold text-zinc-700 mb-1">{label}</p>
      {payload.map((p: any) => (
        <p key={p.name} style={{ color: p.color }}>
          {p.name}: {typeof p.value === 'number' && p.name.toLowerCase().includes('custo')
            ? currency(p.value) : p.value}
        </p>
      ))}
    </div>
  );
};

export default function AnalyticsPage() {
  const [period, setPeriod] = useState("30d");
  const [loading, setLoading] = useState(true);

  const [overview, setOverview]       = useState<Overview | null>(null);
  const [timeSeries, setTimeSeries]   = useState<TimeSeriesPoint[]>([]);
  const [recipes, setRecipes]         = useState<RecipeRank[]>([]);
  const [materials, setMaterials]     = useState<TopMaterial[]>([]);
  const [waste, setWaste]             = useState<WasteData | null>(null);
  const [efficiency, setEfficiency]   = useState<EffRow[]>([]);
  const [effSortDir, setEffSortDir]   = useState<'asc'|'desc'>('desc');

  const loadAll = useCallback(async () => {
    setLoading(true);
    try {
      const [ovRes, tsRes, recRes, matRes, wRes, effRes] = await Promise.all([
        apiFetch(`/inventory/analytics/overview?period=${period}`),
        apiFetch(`/inventory/analytics/cost-time-series?period=${period}`),
        apiFetch(`/inventory/analytics/recipe-profitability?period=${period}`),
        apiFetch(`/inventory/analytics/top-materials?period=${period}`),
        apiFetch(`/inventory/analytics/waste?period=${period}`),
        apiFetch(`/inventory/analytics/efficiency?period=${period}`),
      ]);
      setOverview(ovRes.data);
      setTimeSeries(tsRes.data);
      setRecipes(recRes.data);
      setMaterials(matRes.data);
      setWaste(wRes.data);
      setEfficiency(effRes.data);
    } catch {
      toast.error("Erro ao carregar analytics");
    } finally {
      setLoading(false);
    }
  }, [period]);

  useEffect(() => { loadAll(); }, [loadAll]);

  const sortedEff = [...efficiency].sort((a, b) =>
    effSortDir === 'desc'
      ? (b.yield_eff ?? 0) - (a.yield_eff ?? 0)
      : (a.yield_eff ?? 0) - (b.yield_eff ?? 0)
  );

  const topMaterialPie = materials.slice(0, 6).map((m, i) => ({
    name: m.name, value: m.total_cost, fill: CHART_COLORS[i % CHART_COLORS.length]
  }));

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Analytics Operacional</h1>
          <p className="text-sm text-zinc-500">Custo, eficiência, lucratividade e desperdício da produção artesanal.</p>
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

      {loading && !overview ? (
        <div className="text-center py-20 text-zinc-400">Carregando dados...</div>
      ) : (
        <>
          {/* ── KPIs ─────────────────────────────────────────── */}
          {overview && (
            <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
              {[
                {
                  label: "Ordens Concluídas",
                  value: `${overview.completed_orders} / ${overview.total_orders}`,
                  icon: Factory, color: "blue",
                  sub: `${overview.cancelled_orders} canceladas`
                },
                {
                  label: "Unidades Produzidas",
                  value: String(overview.total_units),
                  icon: PackageSearch, color: "emerald", sub: "no período"
                },
                {
                  label: "Custo Total",
                  value: currency(overview.total_cost),
                  icon: BarChart3, color: "zinc",
                  sub: `consumo MP: ${currency(overview.consumption_cost)}`
                },
                {
                  label: "Eficiência de Custo",
                  value: overview.efficiency !== null ? `${overview.efficiency}%` : '—',
                  icon: Target,
                  color: overview.efficiency !== null
                    ? (overview.efficiency >= 95 ? "emerald" : overview.efficiency >= 85 ? "amber" : "red")
                    : "zinc",
                  sub: `var: ${overview.cost_variance >= 0 ? '+' : ''}${currency(overview.cost_variance)}`
                },
                {
                  label: "Valor em Estoque",
                  value: currency(overview.stock_value),
                  icon: Layers, color: "violet", sub: "matérias-primas"
                },
              ].map(kpi => (
                <div key={kpi.label} className="bg-white rounded-xl border border-zinc-100 shadow-sm p-4 flex items-start gap-3">
                  <div className={`w-9 h-9 rounded-full shrink-0 flex items-center justify-center bg-${kpi.color}-50`}>
                    <kpi.icon className={`w-4 h-4 text-${kpi.color}-600`} />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[10px] text-zinc-400 uppercase tracking-wider">{kpi.label}</p>
                    <p className="text-base font-bold text-zinc-900 truncate">{kpi.value}</p>
                    <p className="text-[10px] text-zinc-400 mt-0.5">{kpi.sub}</p>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* ── Série Temporal ───────────────────────────────── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
            <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-primary" /> Custo de Produção por Período
            </h2>
            <ResponsiveContainer width="100%" height={240}>
              <LineChart data={timeSeries} margin={{ top: 5, right: 20, left: 10, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f4f4f5" />
                <XAxis dataKey="date" tick={{ fontSize: 10 }} tickLine={false}
                  tickFormatter={v => v.slice(5)} />
                <YAxis tick={{ fontSize: 10 }} tickLine={false} axisLine={false}
                  tickFormatter={v => `R$${v >= 1000 ? (v/1000).toFixed(1)+'k' : v}`} />
                <Tooltip content={<CustomTooltip />} />
                <Legend wrapperStyle={{ fontSize: 11 }} />
                <Line type="monotone" dataKey="cost" stroke="#7c6f45" strokeWidth={2}
                  dot={false} name="Custo Real" />
                <Line type="monotone" dataKey="planned" stroke="#c4b080" strokeWidth={2}
                  strokeDasharray="4 4" dot={false} name="Custo Planejado" />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {/* ── Linha 2: Top Receitas + Materiais ───────────── */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Receitas mais lucrativas */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
                <Flame className="w-4 h-4 text-amber-500" /> Receitas por Lucratividade
              </h2>
              {recipes.length === 0 ? (
                <p className="text-sm text-zinc-400 text-center py-10">Sem dados no período</p>
              ) : (
                <div className="space-y-2">
                  {recipes.slice(0, 6).map((r, i) => (
                    <div key={i} className="flex items-center gap-3">
                      <span className={`w-5 h-5 rounded-full text-[10px] flex items-center justify-center font-bold shrink-0
                        ${i === 0 ? 'bg-amber-100 text-amber-700' : i === 1 ? 'bg-zinc-200 text-zinc-600' : 'bg-zinc-100 text-zinc-400'}`}>
                        {i + 1}
                      </span>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-zinc-800 truncate">{r.recipe_name}</p>
                        <p className="text-xs text-zinc-400">{r.product_name} · {r.total_units} un</p>
                      </div>
                      <div className="text-right shrink-0">
                        <p className="text-sm font-bold text-emerald-700">{currency(r.profit)}</p>
                        <Badge className={`text-[10px] border-none ${
                          r.margin_percent !== null && r.margin_percent >= 40 ? 'bg-emerald-100 text-emerald-700' :
                          r.margin_percent !== null && r.margin_percent >= 20 ? 'bg-amber-100 text-amber-700' :
                          'bg-red-100 text-red-600'}`}>
                          {pct(r.margin_percent)} margem
                        </Badge>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              {recipes.length > 0 && (
                <div className="mt-4 pt-3 border-t border-zinc-100">
                  <ResponsiveContainer width="100%" height={140}>
                    <BarChart data={recipes.slice(0, 5)} margin={{ top: 0, right: 5, left: 5, bottom: 0 }}>
                      <CartesianGrid strokeDasharray="3 3" stroke="#f4f4f5" vertical={false} />
                      <XAxis dataKey="recipe_name" tick={{ fontSize: 9 }}
                        tickFormatter={v => v.split(' ').slice(0, 2).join(' ')} />
                      <YAxis hide />
                      <Tooltip formatter={(v: any) => currency(Number(v))} />
                      <Bar dataKey="profit" name="Lucro" radius={[4, 4, 0, 0]}>
                        {recipes.slice(0, 5).map((_, i) => (
                          <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                        ))}
                      </Bar>
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              )}
            </div>

            {/* Top Matérias-Primas */}
            <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
              <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
                <PackageSearch className="w-4 h-4 text-primary" /> Top Matérias-Primas Consumidas
              </h2>
              {materials.length === 0 ? (
                <p className="text-sm text-zinc-400 text-center py-10">Sem consumo no período</p>
              ) : (
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    {materials.slice(0, 6).map((m, i) => (
                      <div key={i} className="flex items-center justify-between text-sm">
                        <div className="flex items-center gap-2 min-w-0">
                          <span className="w-2.5 h-2.5 rounded-full shrink-0" style={{ background: CHART_COLORS[i % CHART_COLORS.length] }} />
                          <span className="text-zinc-700 truncate text-xs">{m.name}</span>
                        </div>
                        <span className="font-semibold text-zinc-800 text-xs ml-2 shrink-0">{currency(m.total_cost)}</span>
                      </div>
                    ))}
                  </div>
                  <ResponsiveContainer width="100%" height={150}>
                    <PieChart>
                      <Pie data={topMaterialPie} cx="50%" cy="50%" innerRadius={35} outerRadius={65}
                        dataKey="value" stroke="none">
                        {topMaterialPie.map((entry, i) => <Cell key={i} fill={entry.fill} />)}
                      </Pie>
                      <Tooltip formatter={(v: any) => currency(Number(v))} />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
              )}
            </div>
          </div>

          {/* ── Eficiência de Produção ───────────────────────── */}
          <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-semibold text-zinc-800 flex items-center gap-2">
                <Target className="w-4 h-4 text-primary" /> Eficiência por Ordem de Produção
              </h2>
              <Button size="sm" variant="ghost" className="h-7 gap-1 text-xs text-zinc-400"
                onClick={() => setEffSortDir(d => d === 'desc' ? 'asc' : 'desc')}>
                Rendimento {effSortDir === 'desc' ? <ChevronDown className="w-3 h-3" /> : <ChevronUp className="w-3 h-3" />}
              </Button>
            </div>
            {efficiency.length === 0 ? (
              <p className="text-sm text-zinc-400 text-center py-10">Sem produções concluídas no período</p>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-zinc-100">
                      {["Ordem", "Receita", "Rendimento", "Efic. Rendimento", "Custo Real", "Var. Custo", "Efic. Custo", "Data"].map(h => (
                        <th key={h} className="text-left text-xs text-zinc-400 font-medium pb-2 pr-4 whitespace-nowrap">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {sortedEff.map((row, i) => {
                      const yEff = row.yield_eff ?? 0;
                      const cEff = row.cost_eff ?? 0;
                      return (
                        <tr key={i} className="border-b border-zinc-50 hover:bg-zinc-50/50">
                          <td className="py-2.5 pr-4">
                            <span className="font-mono text-xs bg-zinc-100 px-1.5 py-0.5 rounded">{row.code}</span>
                          </td>
                          <td className="py-2.5 pr-4 max-w-[140px] truncate text-zinc-700">{row.recipe}</td>
                          <td className="py-2.5 pr-4 font-mono text-xs">
                            {row.actual_yield} / {row.planned_yield}
                          </td>
                          <td className="py-2.5 pr-4">
                            <div className="flex items-center gap-1.5">
                              <div className="w-16 h-1.5 bg-zinc-100 rounded-full overflow-hidden">
                                <div className="h-full rounded-full"
                                  style={{ width: `${Math.min(yEff, 100)}%`,
                                    background: yEff >= 95 ? '#10b981' : yEff >= 80 ? '#f59e0b' : '#ef4444' }} />
                              </div>
                              <span className={`text-xs font-semibold ${yEff >= 95 ? 'text-emerald-600' : yEff >= 80 ? 'text-amber-600' : 'text-red-600'}`}>
                                {pct(row.yield_eff)}
                              </span>
                            </div>
                          </td>
                          <td className="py-2.5 pr-4 font-mono text-xs">{currency(row.actual_cost)}</td>
                          <td className={`py-2.5 pr-4 text-xs font-semibold ${row.cost_variance > 0 ? 'text-red-600' : 'text-emerald-600'}`}>
                            {row.cost_variance > 0 ? '+' : ''}{currency(row.cost_variance)}
                          </td>
                          <td className="py-2.5 pr-4">
                            <div className="flex items-center gap-1.5">
                              <div className="w-16 h-1.5 bg-zinc-100 rounded-full overflow-hidden">
                                <div className="h-full rounded-full"
                                  style={{ width: `${Math.min(Math.max(cEff, 0), 100)}%`,
                                    background: cEff >= 95 ? '#10b981' : cEff >= 85 ? '#f59e0b' : '#ef4444' }} />
                              </div>
                              <span className={`text-xs font-semibold ${cEff >= 95 ? 'text-emerald-600' : cEff >= 85 ? 'text-amber-600' : 'text-red-600'}`}>
                                {pct(row.cost_eff)}
                              </span>
                            </div>
                          </td>
                          <td className="py-2.5 text-xs text-zinc-400">{row.completed_at}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          {/* ── Análise de Desperdício ───────────────────────── */}
          {waste && (
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
                <h2 className="font-semibold text-zinc-800 mb-4 flex items-center gap-2">
                  <AlertTriangle className="w-4 h-4 text-amber-500" /> Perdas por Receita
                </h2>
                {waste.production_waste.length === 0 ? (
                  <p className="text-sm text-zinc-400 text-center py-8">Nenhuma perda registrada</p>
                ) : (
                  <div className="space-y-2">
                    {waste.production_waste.map((w, i) => (
                      <div key={i} className="flex justify-between items-center py-2 border-b border-zinc-50 last:border-0 text-sm">
                        <div>
                          <p className="font-medium text-zinc-800">{w.recipe_name}</p>
                          <p className="text-xs text-zinc-400">{w.occurrences} ocorrência(s)</p>
                        </div>
                        <span className="text-amber-700 font-semibold">{w.total_waste} un</span>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
                <h2 className="font-semibold text-zinc-800 mb-1 flex items-center gap-2">
                  <AlertTriangle className="w-4 h-4 text-red-400" /> Descarte de Matérias-Primas
                </h2>
                <p className="text-xs text-zinc-400 mb-4">
                  Custo total de descarte: <strong className="text-red-600">{currency(waste.total_waste_cost)}</strong>
                </p>
                {waste.material_waste.length === 0 ? (
                  <p className="text-sm text-zinc-400 text-center py-8">Nenhum descarte registrado</p>
                ) : (
                  <div className="space-y-2">
                    {waste.material_waste.map((w, i) => (
                      <div key={i} className="flex justify-between items-center py-2 border-b border-zinc-50 last:border-0 text-sm">
                        <div>
                          <p className="font-medium text-zinc-800">{w.name}</p>
                          <p className="text-xs text-zinc-400">{w.total_qty} {w.unit} descartado(s)</p>
                        </div>
                        <span className="text-red-600 font-semibold">{currency(w.total_cost)}</span>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}
