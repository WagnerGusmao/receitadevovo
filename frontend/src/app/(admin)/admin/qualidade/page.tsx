"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import {
  Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription,
} from "@/components/ui/dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import {
  ShieldCheck, ClipboardList, XCircle, AlertTriangle, CheckCircle2,
  RefreshCw, ChevronDown, ChevronUp, Clock, Eye,
} from "lucide-react";

/* ── Tipos ─────────────────────────────────────────────── */
type Criteria = {
  id: number; criterion: string; criterion_label: string;
  result: "pass" | "fail" | "conditional" | null;
  measured_value: string | null; notes: string | null; result_icon: string;
};
type QualityCheck = {
  id: number; check_type: "receipt" | "production"; status: string;
  status_label: string; checked_at: string | null; notes: string | null;
  rejection_reason: string | null; pass_rate: number | null; has_failures: boolean;
  criteria_count?: number; criteria: Criteria[];
  checkable: any; user?: { name: string };
  created_at: string;
};
type Dashboard = {
  pending_count: number; approved_month: number; rejected_month: number;
  quarantine_month: number; approval_rate: number | null;
  top_failures: { criterion_label: string; fail_count: number }[];
  pending_list: QualityCheck[];
};
type NcReport = {
  period: { from: string; to: string }; total: number; rejected: number; quarantine: number;
  checks: QualityCheck[];
  criteria_stats: { criterion_label: string; fail_count: number }[];
};

const STATUS_CFG: Record<string, { label: string; badge: string; icon: React.ElementType }> = {
  pending:    { label: "Pendente",    badge: "bg-amber-100 text-amber-700 border-none",     icon: Clock },
  approved:   { label: "Aprovado",    badge: "bg-emerald-100 text-emerald-700 border-none", icon: CheckCircle2 },
  rejected:   { label: "Reprovado",   badge: "bg-red-100 text-red-600 border-none",         icon: XCircle },
  quarantine: { label: "Quarentena",  badge: "bg-purple-100 text-purple-700 border-none",   icon: AlertTriangle },
};

const RESULT_CFG: Record<string, { label: string; cls: string }> = {
  pass:        { label: "Aprovado",    cls: "bg-emerald-100 text-emerald-700 border-none" },
  fail:        { label: "Reprovado",   cls: "bg-red-100 text-red-600 border-none" },
  conditional: { label: "Condicional", cls: "bg-amber-100 text-amber-700 border-none" },
  na:          { label: "Não se Aplica", cls: "bg-zinc-150 text-zinc-650 border-none" },
};

const NC_PERIODS = [
  { label: "7 dias",  value: "7d" },
  { label: "30 dias", value: "30d" },
  { label: "3 meses", value: "90d" },
];

export default function QualidadePage() {
  const [checks, setChecks]       = useState<QualityCheck[]>([]);
  const [dashboard, setDashboard] = useState<Dashboard | null>(null);
  const [ncReport, setNcReport]   = useState<NcReport | null>(null);
  const [ncPeriod, setNcPeriod]   = useState("30d");
  const [loading, setLoading]     = useState(true);
  const [statusFilter, setStatusFilter] = useState("all");
  const [expandedId, setExpandedId]     = useState<number | null>(null);
  const [activeTab, setActiveTab]       = useState<"pending" | "history" | "nc">("pending");

  // Avaliação
  const [isEvalOpen, setIsEvalOpen]   = useState(false);
  const [selectedCheck, setSelectedCheck] = useState<QualityCheck | null>(null);
  const [evalDecision, setEvalDecision]   = useState<"approved" | "rejected" | "quarantine">("approved");
  const [evalNotes, setEvalNotes]         = useState("");
  const [evalRejReason, setEvalRejReason] = useState("");
  const [evalCriteria, setEvalCriteria]   = useState<
    { id: number; result: string; measured_value: string; notes: string }[]
  >([]);

  const loadAll = useCallback(async () => {
    setLoading(true);
    try {
      const [listRes, dashRes] = await Promise.all([
        apiFetch("/inventory/quality"),
        apiFetch("/inventory/quality/dashboard"),
      ]);
      setChecks(listRes.data.data ?? listRes.data);
      setDashboard(dashRes.data);
    } catch {
      toast.error("Erro ao carregar inspeções");
    } finally {
      setLoading(false);
    }
  }, []);

  const loadNc = useCallback(async () => {
    try {
      const res = await apiFetch(`/inventory/quality/non-conformities?period=${ncPeriod}`);
      setNcReport(res.data);
    } catch {
      toast.error("Erro ao carregar relatório");
    }
  }, [ncPeriod]);

  useEffect(() => { loadAll(); }, [loadAll]);
  useEffect(() => { if (activeTab === "nc") loadNc(); }, [activeTab, loadNc]);

  /* ── Abrir avaliação ─────────────────────────────── */
  const openEval = async (check: QualityCheck) => {
    const res = await apiFetch(`/inventory/quality/${check.id}`);
    const full: QualityCheck = res.data;
    setSelectedCheck(full);
    setEvalDecision("approved");
    setEvalNotes("");
    setEvalRejReason("");
    setEvalCriteria(full.criteria.map(c => ({
      id:             c.id,
      result:         c.result ?? "",
      measured_value: c.measured_value ?? "",
      notes:          c.notes ?? "",
    })));
    setIsEvalOpen(true);
  };

  const updateCriterion = (id: number, field: string, val: string) =>
    setEvalCriteria(prev => prev.map(c => c.id === id ? { ...c, [field]: val } : c));

  /* ── Submeter avaliação ──────────────────────────── */
  const handleEvaluate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedCheck) return;
    try {
      await apiFetch(`/inventory/quality/${selectedCheck.id}/evaluate`, {
        method: "POST",
        body: JSON.stringify({
          decision:         evalDecision,
          notes:            evalNotes || null,
          rejection_reason: evalDecision !== "approved" ? evalRejReason || null : null,
          criteria: evalCriteria.map(c => ({
            id:             c.id,
            result:         c.result || null,
            measured_value: c.measured_value || null,
            notes:          c.notes || null,
          })),
        }),
      });
      toast.success(
        evalDecision === "approved" ? "Inspeção aprovada!" :
        evalDecision === "rejected" ? "Inspeção reprovada." : "Item em quarentena."
      );
      setIsEvalOpen(false);
      loadAll();
    } catch (e: any) {
      toast.error(e.message || "Erro ao salvar avaliação");
    }
  };

  const filtered = statusFilter === "all"
    ? checks
    : checks.filter(c => c.status === statusFilter);

  /* ── Render de um card de inspeção ──────────────── */
  const renderCheck = (check: QualityCheck, showEvalBtn = true) => {
    const cfg   = STATUS_CFG[check.status];
    const Icon  = cfg.icon;
    const isExp = expandedId === check.id;

    const checkableName = check.checkable
      ? (check.checkable.code           // ProductionOrder / PurchaseOrder
          ?? check.checkable.batch_number  // Batch (número do fornecedor)
          ?? check.checkable.internal_code // Batch (código interno LOT-xxx)
          ?? `#${check.checkable.id}`)
      : "—";

    return (
      <div key={check.id} className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <div className="p-4">
          <div className="flex items-start gap-3">
            <div className={`w-9 h-9 rounded-full flex items-center justify-center shrink-0 ${
              check.status === "approved"   ? "bg-emerald-50" :
              check.status === "pending"    ? "bg-amber-50" :
              check.status === "rejected"   ? "bg-red-50" : "bg-purple-50"
            }`}>
              <Icon className={`w-4 h-4 ${
                check.status === "approved"   ? "text-emerald-600" :
                check.status === "pending"    ? "text-amber-500" :
                check.status === "rejected"   ? "text-red-500" : "text-purple-600"
              }`} />
            </div>

            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 flex-wrap">
                <Badge className={cfg.badge}>{cfg.label}</Badge>
                <Badge className="border-none text-xs bg-zinc-100 text-zinc-500">
                  {check.check_type === "receipt" ? "Recebimento" : "Produção"}
                </Badge>
                <span className="text-xs text-zinc-400">{checkableName}</span>
              </div>
              <div className="flex gap-3 mt-1 flex-wrap text-xs text-zinc-400">
                {check.pass_rate !== null && (
                  <span>Taxa de aprovação: <strong className="text-zinc-700">{check.pass_rate}%</strong></span>
                )}
                {check.checked_at && (
                  <span>Avaliado: {new Date(check.checked_at).toLocaleDateString("pt-BR")}</span>
                )}
                {check.user && <span>por {check.user.name}</span>}
                <span>Criado: {new Date(check.created_at).toLocaleDateString("pt-BR")}</span>
              </div>
              
              {check.check_type === "production" && check.checkable && (
                <div className="mt-2 text-xs text-zinc-700 bg-zinc-50 border border-zinc-150 rounded-lg px-3 py-2 w-fit">
                  <span className="font-semibold text-zinc-800">Produzido:</span> {check.checkable.product?.name || "—"} 
                  {check.checkable.outputs && check.checkable.outputs.length > 0 ? (
                    <span className="text-zinc-500">
                      {" · "} 
                      {check.checkable.outputs.map((out: any) => `${out.quantity}x ${out.itemable?.name || "un"}`).join(" + ")}
                    </span>
                  ) : check.checkable.actual_yield ? (
                    <span className="text-zinc-500"> · {check.checkable.actual_yield} un</span>
                  ) : null}
                  {check.checkable.duration_minutes ? ` (Tempo: ${check.checkable.duration_minutes} min)` : ""}
                </div>
              )}

              {check.check_type === "receipt" && check.checkable && (
                <div className="mt-2 text-xs text-zinc-700 bg-zinc-50 border border-zinc-150 rounded-lg px-3 py-2 w-fit">
                  <span className="font-semibold text-zinc-800">Recebido:</span>{" "}
                  {check.checkable.raw_material 
                    ? `${check.checkable.raw_material.name} (${check.checkable.quantity_received} ${check.checkable.raw_material.unit})`
                    : "Lote de matéria-prima"}
                  {check.checkable.supplier && ` · Fornecedor: ${check.checkable.supplier.name}`}
                </div>
              )}

              {check.rejection_reason && (
                <p className="text-xs text-red-500 mt-1 italic">Motivo: {check.rejection_reason}</p>
              )}
            </div>

            <div className="flex items-center gap-1 shrink-0">
              {showEvalBtn && check.status === "pending" && (
                <Button size="sm" className="bg-primary hover:bg-olive gap-1 h-8 text-xs"
                  onClick={() => openEval(check)}>
                  <ClipboardList className="w-3 h-3" /> Avaliar
                </Button>
              )}
              <Button size="sm" variant="ghost" className="h-8 w-8 p-0"
                onClick={() => setExpandedId(isExp ? null : check.id)}>
                {isExp ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
              </Button>
            </div>
          </div>
        </div>

        {isExp && (
          <div className="border-t border-zinc-100 bg-zinc-50/50 px-4 py-3">
            {check.criteria && check.criteria.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {check.criteria.map(c => (
                  <div key={c.id} className="flex items-center justify-between rounded-lg border border-zinc-200 bg-white px-3 py-2 text-sm">
                    <span className="text-zinc-600">{c.criterion_label}</span>
                    <div className="flex items-center gap-2">
                      {c.measured_value && (
                        <span className="text-xs text-zinc-400">{c.measured_value}</span>
                      )}
                      {c.result ? (
                        <Badge className={`text-xs border-none ${RESULT_CFG[c.result]?.cls ?? ""}`}>
                          {RESULT_CFG[c.result]?.label ?? c.result}
                        </Badge>
                      ) : (
                        <span className="text-xs text-zinc-300">—</span>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-zinc-400">Nenhum critério avaliado ainda.</p>
            )}
            {check.notes && (
              <p className="text-xs text-zinc-400 italic mt-2">Obs: {check.notes}</p>
            )}
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold font-outfit text-zinc-900">Controle de Qualidade</h1>
          <p className="text-sm text-zinc-500">Inspeções de lotes recebidos e ordens de produção concluídas.</p>
        </div>
        <Button variant="outline" size="sm" onClick={loadAll} className="h-9 gap-1 text-zinc-400">
          <RefreshCw className="w-4 h-4" />
        </Button>
      </div>

      {/* KPIs */}
      {dashboard && (
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
          {[
            { label: "Pendentes",       value: String(dashboard.pending_count),   color: "amber",   icon: Clock },
            { label: "Aprovados/Mês",   value: String(dashboard.approved_month),  color: "emerald", icon: CheckCircle2 },
            { label: "Reprovados/Mês",  value: String(dashboard.rejected_month),  color: "red",     icon: XCircle },
            { label: "Quarentena/Mês",  value: String(dashboard.quarantine_month),color: "purple",  icon: AlertTriangle },
            {
              label: "Taxa Aprovação",
              value: dashboard.approval_rate !== null ? `${dashboard.approval_rate}%` : "—",
              color: (dashboard.approval_rate ?? 0) >= 80 ? "emerald" : "amber",
              icon: ShieldCheck,
            },
          ].map(kpi => (
            <div key={kpi.label}
              className="bg-white rounded-xl border border-zinc-100 shadow-sm p-4 flex items-center gap-3">
              <div className={`w-9 h-9 rounded-full shrink-0 flex items-center justify-center bg-${kpi.color}-50`}>
                <kpi.icon className={`w-4 h-4 text-${kpi.color}-600`} />
              </div>
              <div>
                <p className="text-[10px] text-zinc-400 uppercase tracking-wider">{kpi.label}</p>
                <p className="text-base font-bold text-zinc-900">{kpi.value}</p>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Tabs */}
      <div className="flex gap-1 bg-zinc-100 rounded-full p-1 w-fit">
        {(["pending", "history", "nc"] as const).map(tab => (
          <button key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
              activeTab === tab ? "bg-white shadow text-zinc-900" : "text-zinc-400 hover:text-zinc-600"
            }`}>
            {tab === "pending" ? `Pendentes${dashboard ? ` (${dashboard.pending_count})` : ""}` :
             tab === "history" ? "Histórico" : "Não-Conformidades"}
          </button>
        ))}
      </div>

      {/* ── Tab: Pendentes ───────────────────────────── */}
      {activeTab === "pending" && (
        loading ? (
          <div className="text-center py-16 text-zinc-400">Carregando...</div>
        ) : (dashboard?.pending_list ?? []).length === 0 ? (
          <div className="text-center py-16 bg-white rounded-xl border border-dashed border-zinc-200">
            <ShieldCheck className="w-12 h-12 text-zinc-200 mx-auto mb-3" />
            <p className="text-zinc-400 font-medium">Nenhuma inspeção pendente!</p>
            <p className="text-zinc-300 text-sm mt-1">
              Crie inspeções ao receber lotes ou concluir produções.
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {(dashboard?.pending_list ?? []).map(c => renderCheck(c, true))}
          </div>
        )
      )}

      {/* ── Tab: Histórico ───────────────────────────── */}
      {activeTab === "history" && (
        <div className="space-y-4">
          <div className="flex gap-2 flex-wrap">
            {["all", "approved", "rejected", "quarantine"].map(s => (
              <button key={s}
                onClick={() => setStatusFilter(s)}
                className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-colors ${
                  statusFilter === s
                    ? "bg-primary text-white border-primary"
                    : "bg-white text-zinc-500 border-zinc-200 hover:border-zinc-300"
                }`}>
                {s === "all" ? "Todas" : STATUS_CFG[s]?.label ?? s}
              </button>
            ))}
          </div>

          {loading ? (
            <div className="text-center py-16 text-zinc-400">Carregando...</div>
          ) : filtered.length === 0 ? (
            <div className="text-center py-16 bg-white rounded-xl border border-dashed border-zinc-200">
              <Eye className="w-10 h-10 text-zinc-200 mx-auto mb-2" />
              <p className="text-zinc-400">Nenhuma inspeção encontrada.</p>
            </div>
          ) : (
            <div className="space-y-3">
              {filtered.map(c => renderCheck(c, false))}
            </div>
          )}
        </div>
      )}

      {/* ── Tab: Não-Conformidades ───────────────────── */}
      {activeTab === "nc" && (
        <div className="space-y-4">
          <div className="flex items-center gap-3 flex-wrap">
            <span className="text-sm text-zinc-500">Período:</span>
            {NC_PERIODS.map(p => (
              <button key={p.value}
                onClick={() => setNcPeriod(p.value)}
                className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-colors ${
                  ncPeriod === p.value
                    ? "bg-primary text-white border-primary"
                    : "bg-white text-zinc-500 border-zinc-200 hover:border-zinc-300"
                }`}>
                {p.label}
              </button>
            ))}
          </div>

          {ncReport && (
            <>
              {/* Resumo */}
              <div className="grid grid-cols-3 gap-3">
                {[
                  { label: "Total NC",     value: ncReport.total,       color: "zinc" },
                  { label: "Reprovados",   value: ncReport.rejected,    color: "red" },
                  { label: "Quarentena",   value: ncReport.quarantine,  color: "purple" },
                ].map(kpi => (
                  <div key={kpi.label}
                    className="bg-white rounded-xl border border-zinc-200 shadow-sm p-4 text-center">
                    <p className={`text-2xl font-bold text-${kpi.color}-600`}>{kpi.value}</p>
                    <p className="text-xs text-zinc-400 mt-1">{kpi.label}</p>
                  </div>
                ))}
              </div>

              {/* Critérios com mais falhas */}
              {ncReport.criteria_stats.length > 0 && (
                <div className="bg-white rounded-xl border border-zinc-200 shadow-sm p-5">
                  <h3 className="font-semibold text-zinc-800 text-sm mb-3">Critérios com mais Falhas</h3>
                  <div className="space-y-2">
                    {ncReport.criteria_stats.map((cs, i) => (
                      <div key={i} className="flex items-center gap-3">
                        <span className="text-xs text-zinc-400 w-4 shrink-0">{i + 1}</span>
                        <div className="flex-1 text-sm text-zinc-700">{cs.criterion_label}</div>
                        <Badge className="bg-red-100 text-red-600 border-none text-xs">
                          {cs.fail_count} falha{cs.fail_count > 1 ? "s" : ""}
                        </Badge>
                        <div className="w-24 h-1.5 bg-zinc-100 rounded-full overflow-hidden">
                          <div className="h-full bg-red-400 rounded-full"
                            style={{
                              width: `${Math.min((cs.fail_count / (ncReport.criteria_stats[0]?.fail_count ?? 1)) * 100, 100)}%`
                            }} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Lista de NCs */}
              {ncReport.checks.length > 0 && (
                <div className="space-y-3">
                  <h3 className="font-semibold text-zinc-700 text-sm">
                    Inspeções reprovadas / em quarentena ({ncReport.period.from} → {ncReport.period.to})
                  </h3>
                  {ncReport.checks.map(c => renderCheck(c, false))}
                </div>
              )}

              {ncReport.total === 0 && (
                <div className="text-center py-12 bg-white rounded-xl border border-dashed border-zinc-200">
                  <CheckCircle2 className="w-10 h-10 text-emerald-200 mx-auto mb-2" />
                  <p className="text-emerald-500 font-medium">Sem não-conformidades no período!</p>
                </div>
              )}
            </>
          )}
        </div>
      )}

      {/* ── Modal de Avaliação ────────────────────────── */}
      <Dialog open={isEvalOpen} onOpenChange={setIsEvalOpen}>
        <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
          <form onSubmit={handleEvaluate}>
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2">
                <ClipboardList className="w-5 h-5 text-primary" /> Avaliação de Qualidade
              </DialogTitle>
              <DialogDescription>
                {selectedCheck?.check_type === "receipt" ? "Inspeção de Recebimento" : "Inspeção de Produção"}
              </DialogDescription>
            </DialogHeader>

            <div className="mt-4 border border-zinc-150 rounded-xl bg-zinc-50/50 p-4 space-y-2 text-xs">
              <div className="flex justify-between items-center text-zinc-400">
                <span>Documento/Lote:</span>
                <span className="font-mono font-semibold text-zinc-600">
                  {selectedCheck?.checkable?.code || selectedCheck?.checkable?.internal_code || selectedCheck?.checkable?.batch_number || (selectedCheck?.checkable?.id ? `#${selectedCheck.checkable.id}` : "")}
                </span>
              </div>
              
              {selectedCheck?.check_type === "production" && selectedCheck?.checkable && (
                <div className="text-zinc-700 leading-relaxed">
                  <span className="font-semibold text-zinc-800">Produzido:</span> {selectedCheck.checkable.product?.name || "—"} 
                  {selectedCheck.checkable.outputs && selectedCheck.checkable.outputs.length > 0 ? (
                    <span className="text-zinc-500">
                      {" · "} 
                      {selectedCheck.checkable.outputs.map((out: any) => `${out.quantity}x ${out.itemable?.name || "un"}`).join(" + ")}
                    </span>
                  ) : selectedCheck.checkable.actual_yield ? (
                    <span className="text-zinc-500"> · {selectedCheck.checkable.actual_yield} un</span>
                  ) : null}
                  {selectedCheck.checkable.duration_minutes ? ` (Tempo: ${selectedCheck.checkable.duration_minutes} min)` : ""}
                </div>
              )}

              {selectedCheck?.check_type === "receipt" && selectedCheck?.checkable && (
                <div className="text-zinc-700 leading-relaxed">
                  <span className="font-semibold text-zinc-800">Recebido:</span>{" "}
                  {selectedCheck.checkable.raw_material 
                    ? `${selectedCheck.checkable.raw_material.name} (${selectedCheck.checkable.quantity_received} ${selectedCheck.checkable.raw_material.unit})`
                    : "Lote de matéria-prima"}
                  {selectedCheck.checkable.supplier && ` · Fornecedor: ${selectedCheck.checkable.supplier.name}`}
                </div>
              )}
            </div>

            <div className="space-y-5 py-4">
              {/* Critérios */}
              <div>
                <Label className="mb-3 block font-semibold">Critérios de Avaliação</Label>
                <div className="space-y-2">
                  {evalCriteria.map((c, i) => {
                    const orig = selectedCheck?.criteria.find(cr => cr.id === c.id);
                    return (
                      <div key={c.id}
                        className="rounded-lg border border-zinc-200 bg-zinc-50 p-3 grid grid-cols-12 gap-2 items-start">
                        <div className="col-span-4">
                          <p className="text-sm font-medium text-zinc-700">{orig?.criterion_label}</p>
                        </div>
                        <div className="col-span-3">
                          <Select value={c.result}
                            onValueChange={v => updateCriterion(c.id, "result", v)}>
                            <SelectTrigger className="h-8 text-xs">
                              <SelectValue placeholder="Resultado..." />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="pass">✅ Aprovado</SelectItem>
                              <SelectItem value="conditional">⚠️ Condicional</SelectItem>
                              <SelectItem value="fail">❌ Reprovado</SelectItem>
                              <SelectItem value="na">⚪ Não se Aplica</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="col-span-2">
                          <Input className="h-8 text-xs" placeholder="Valor..."
                            value={c.measured_value}
                            onChange={e => updateCriterion(c.id, "measured_value", e.target.value)} />
                        </div>
                        <div className="col-span-3">
                          <Input className="h-8 text-xs" placeholder="Obs..."
                            value={c.notes}
                            onChange={e => updateCriterion(c.id, "notes", e.target.value)} />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Decisão */}
              <div>
                <Label className="mb-2 block font-semibold">Decisão Final *</Label>
                <div className="flex gap-2">
                  {(["approved", "quarantine", "rejected"] as const).map(d => (
                    <button key={d} type="button"
                      onClick={() => setEvalDecision(d)}
                      className={`flex-1 py-2.5 rounded-lg border text-sm font-medium transition-all ${
                        evalDecision === d
                          ? d === "approved"   ? "bg-emerald-600 text-white border-emerald-600"
                          : d === "rejected"   ? "bg-red-600 text-white border-red-600"
                          :                      "bg-purple-600 text-white border-purple-600"
                          : "bg-white text-zinc-500 border-zinc-200 hover:border-zinc-300"
                      }`}>
                      {d === "approved" ? "✅ Aprovar" : d === "rejected" ? "❌ Reprovar" : "⚠️ Quarentena"}
                    </button>
                  ))}
                </div>
              </div>

              {/* Motivo (se não aprovado) */}
              {evalDecision !== "approved" && (
                <div className="grid gap-2">
                  <Label>Motivo *</Label>
                  <Textarea rows={2} value={evalRejReason}
                    onChange={e => setEvalRejReason(e.target.value)}
                    placeholder="Descreva o motivo da reprovação ou quarentena..." />
                </div>
              )}

              <div className="grid gap-2">
                <Label>Observações Gerais</Label>
                <Textarea rows={2} value={evalNotes}
                  onChange={e => setEvalNotes(e.target.value)}
                  placeholder="Anotações adicionais sobre a inspeção..." />
              </div>
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsEvalOpen(false)}>Cancelar</Button>
              <Button type="submit"
                className={
                  evalDecision === "approved"   ? "bg-emerald-600 hover:bg-emerald-700" :
                  evalDecision === "rejected"   ? "bg-red-600 hover:bg-red-700" :
                                                  "bg-purple-600 hover:bg-purple-700"
                }>
                Confirmar Avaliação
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
