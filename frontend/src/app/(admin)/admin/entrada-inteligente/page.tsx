"use client";

import { useCallback, useEffect, useRef, useState, useMemo } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { toast } from "sonner";
import {
  Brain, Upload, ClipboardList, CheckCircle2, AlertTriangle,
  Loader2, FileText, ImageIcon, RefreshCw, ChevronRight, Plus, Trash2,
  PackageCheck, Sparkles, ArrowRight, Info, SkipForward, Clock,
} from "lucide-react";

// ─── Types ────────────────────────────────────────────────────────────────────

type Step = "select" | "manual" | "upload" | "processing" | "review" | "done";

type RawMaterial = { id: number; name: string; unit: string; category?: string; average_cost?: number };
type Supplier    = { id: number; name: string };

type SessionSummary = {
  id: number;
  status: string;
  status_label: string;
  document_type: string;
  document_original_name: string | null;
  supplier_name_raw: string | null;
  purchase_date: string | null;
  document_number: string | null;
  items_count: number;
  confirmed_items_count: number;
  created_at: string;
};

type MatchSuggestion = { raw_material_id: number; name: string; unit: string; confidence: number };

type SmartInputItem = {
  id: number;
  description_raw: string;
  quantity: number;
  unit_raw: string;
  unit_normalized: string | null;
  unit_price: number | null;
  total_price: number | null;
  raw_material_id: number | null;
  match_confidence: number | null;
  confidence_level: "high" | "medium" | "low" | "none";
  match_suggestions: MatchSuggestion[];
  batch_number: string | null;
  expires_at: string | null;
  manufactured_at: string | null;
  is_confirmed: boolean;
  is_skipped: boolean;
  is_new_material: boolean;
  new_material_category: string | null;
  notes: string | null;
  raw_material?: RawMaterial;
};

type SmartInputSession = {
  id: number;
  status: "pending" | "processing" | "needs_review" | "confirmed" | "completed" | "failed";
  status_label: string;
  document_type: "image" | "pdf" | "manual";
  document_original_name: string | null;
  supplier_id: number | null;
  supplier_name_raw: string | null;
  purchase_date: string | null;
  document_number: string | null;
  total_value: number | null;
  error_message: string | null;
  notes: string | null;
  items: SmartInputItem[];
  supplier?: Supplier;
};

const UNITS = ["g", "kg", "ml", "L", "un", "oz", "cx"];

const emptyManualItem = {
  id: "",
  description_raw: "", quantity: "1", unit_raw: "un",
  unit_price: "", raw_material_id: "", batch_number: "",
  expires_at: "", notes: "",
};

// ─── Helper Components ────────────────────────────────────────────────────────

function ConfidenceBadge({ level, score }: { level: string; score: number | null }) {
  if (!score) return <Badge variant="outline" className="text-zinc-400 border-zinc-200">Sem match</Badge>;
  const pct = Math.round(score * 100);
  if (level === "high")   return <Badge className="bg-emerald-100 text-emerald-700 border-none">{pct}%</Badge>;
  if (level === "medium") return <Badge className="bg-amber-100 text-amber-700 border-none">{pct}%</Badge>;
  return <Badge className="bg-red-100 text-red-600 border-none">{pct}%</Badge>;
}

function StatusBadge({ status, label }: { status: string; label: string }) {
  const map: Record<string, string> = {
    pending:      "bg-zinc-100 text-zinc-600",
    processing:   "bg-blue-100 text-blue-700",
    needs_review: "bg-amber-100 text-amber-700",
    confirmed:    "bg-violet-100 text-violet-700",
    completed:    "bg-emerald-100 text-emerald-700",
    failed:       "bg-red-100 text-red-700",
  };
  return <Badge className={`${map[status] ?? "bg-zinc-100 text-zinc-600"} border-none`}>{label}</Badge>;
}

// ─── Main Component ───────────────────────────────────────────────────────────

export default function EntradaInteligentePage() {
  const [step, setStep] = useState<Step>("select");
  const [session, setSession] = useState<SmartInputSession | null>(null);
  const [materials, setMaterials] = useState<RawMaterial[]>([]);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);

  // Manual entry state
  const [manualSupplier, setManualSupplier]   = useState("");
  const [manualDate, setManualDate]           = useState("");
  const [manualDocNum, setManualDocNum]       = useState("");
  const [manualNotes, setManualNotes]         = useState("");
  const [manualItems, setManualItems]         = useState([{ ...emptyManualItem, id: Math.random().toString(36).substring(2, 9) }]);
  const [savingManual, setSavingManual]       = useState(false);

  // Upload state
  const [dragOver, setDragOver]     = useState(false);
  const [file, setFile]             = useState<File | null>(null);
  const [filePreview, setFilePreview] = useState<string | null>(null);
  const [uploading, setUploading]   = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  // Review state
  const [sessionMeta, setSessionMeta] = useState<{
    supplier_id: string; purchase_date: string; document_number: string;
  }>({ supplier_id: "", purchase_date: "", document_number: "" });
  const [confirming, setConfirming] = useState(false);
  const [expandedItem, setExpandedItem] = useState<number | null>(null);

  // History state
  const [history, setHistory]           = useState<SessionSummary[]>([]);
  const [loadingHistory, setLoadingHistory] = useState(false);

  // Polling ref
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // New Supplier modal state
  const [isSupplierModalOpen, setIsSupplierModalOpen] = useState(false);
  const [supplierForm, setSupplierForm] = useState({
    name: "",
    cnpj: "",
    email: "",
    phone: "",
  });
  const [savingSupplier, setSavingSupplier] = useState(false);
  const [supplierSource, setSupplierSource] = useState<"manual" | "review">("manual");

  const openNewSupplierModal = (source: "manual" | "review", prefilledName = "") => {
    setSupplierSource(source);
    setSupplierForm({
      name: prefilledName,
      cnpj: "",
      email: "",
      phone: "",
    });
    setIsSupplierModalOpen(true);
  };

  const handleCreateSupplier = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!supplierForm.name.trim()) {
      toast.error("O nome do fornecedor é obrigatório.");
      return;
    }
    setSavingSupplier(true);
    try {
      const res = await apiFetch("/inventory/suppliers", {
        method: "POST",
        body: JSON.stringify({
          name: supplierForm.name,
          cnpj: supplierForm.cnpj || null,
          email: supplierForm.email || null,
          phone: supplierForm.phone || null,
          is_active: true,
        }),
      });

      if (res.data) {
        const newSupplier = res.data;
        setSuppliers(prev => [...prev, newSupplier]);
        
        if (supplierSource === "manual") {
          setManualSupplier(String(newSupplier.id));
        } else {
          setSessionMeta(prev => ({ ...prev, supplier_id: String(newSupplier.id) }));
        }

        toast.success("Fornecedor cadastrado com sucesso!");
        setIsSupplierModalOpen(false);
      } else {
        toast.error(res.message || "Erro ao cadastrar fornecedor.");
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao cadastrar fornecedor.");
    } finally {
      setSavingSupplier(false);
    }
  };

  // ── Load background data ────────────────────────────────────────────────────

  useEffect(() => {
    Promise.all([
      apiFetch("/inventory/raw-materials"),
      apiFetch("/inventory/suppliers"),
    ]).then(([mRes, sRes]) => {
      setMaterials(mRes.data ?? []);
      setSuppliers(sRes.data ?? []);
    }).catch(() => {});
    loadHistory();
  }, []);  // eslint-disable-line react-hooks/exhaustive-deps

  // ── Polling ─────────────────────────────────────────────────────────────────

  const startPolling = useCallback((sessionId: number) => {
    if (pollRef.current) clearInterval(pollRef.current);
    pollRef.current = setInterval(async () => {
      try {
        const res = await apiFetch(`/smartinventory/sessions/${sessionId}`);
        const s: SmartInputSession = res.data;
        setSession(s);
        if (!["pending", "processing"].includes(s.status)) {
          clearInterval(pollRef.current!);
          if (s.status === "needs_review") {
            setSessionMeta({
              supplier_id:     String(s.supplier_id ?? ""),
              purchase_date:   s.purchase_date ?? "",
              document_number: s.document_number ?? "",
            });
            setStep("review");
          } else if (s.status === "failed") {
            toast.error(`Falha no processamento: ${s.error_message}`);
            setStep("upload");
          }
        }
      } catch { clearInterval(pollRef.current!); }
    }, 2500);
  }, []);

  useEffect(() => () => { if (pollRef.current) clearInterval(pollRef.current); }, []);

  // ── Upload ───────────────────────────────────────────────────────────────────

  function handleFileDrop(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(false);
    const dropped = e.dataTransfer.files[0];
    if (dropped) selectFile(dropped);
  }

  function selectFile(f: File) {
    const allowed = ["image/jpeg", "image/png", "image/webp", "application/pdf"];
    if (!allowed.includes(f.type)) {
      toast.error("Formato não suportado. Use JPG, PNG, WEBP ou PDF.");
      return;
    }
    if (f.size > 10 * 1024 * 1024) {
      toast.error("Arquivo muito grande. Tamanho máximo: 10 MB.");
      return;
    }
    setFile(f);
    if (f.type.startsWith("image/")) {
      setFilePreview(URL.createObjectURL(f));
    } else {
      setFilePreview(null);
    }
  }

  async function handleUpload() {
    if (!file) return;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append("document", file);

      const token = localStorage.getItem("auth_token");
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000/api"}/smartinventory/sessions/upload`,
        {
          method: "POST",
          headers: {
            Accept: "application/json",
            ...(token ? { Authorization: `Bearer ${token}` } : {}),
          },
          body: formData,
        }
      );
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || "Erro no upload");

      const s: SmartInputSession = data.data;
      setSession(s);
      setStep("processing");
      startPolling(s.id);
      toast.success("Documento enviado! Analisando com IA...");
    } catch (err: any) {
      toast.error(err.message || "Erro ao enviar documento");
    } finally {
      setUploading(false);
    }
  }

  // ── Manual submit ────────────────────────────────────────────────────────────

  async function handleManualSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (manualItems.every(i => !i.description_raw.trim())) {
      toast.error("Adicione ao menos um item.");
      return;
    }
    setSavingManual(true);
    try {
      const payload = {
        supplier_id:     manualSupplier || null,
        purchase_date:   manualDate || null,
        document_number: manualDocNum || null,
        notes:           manualNotes || null,
        items: manualItems
          .filter(i => i.description_raw.trim())
          .map(i => ({
            description_raw: i.description_raw,
            quantity:        parseFloat(i.quantity) || 1,
            unit_raw:        i.unit_raw,
            unit_price:      i.unit_price ? parseFloat(i.unit_price) : null,
            raw_material_id: i.raw_material_id ? parseInt(i.raw_material_id) : null,
            batch_number:    i.batch_number || null,
            expires_at:      i.expires_at || null,
            notes:           i.notes || null,
          })),
      };

      const res = await apiFetch("/smartinventory/sessions/manual", {
        method: "POST",
        body: JSON.stringify(payload),
      });

      const s: SmartInputSession = res.data;
      setSession(s);
      setSessionMeta({
        supplier_id:     String(s.supplier_id ?? manualSupplier ?? ""),
        purchase_date:   s.purchase_date ?? manualDate,
        document_number: s.document_number ?? manualDocNum,
      });
      setStep("review");
      toast.success("Itens carregados. Revise antes de confirmar.");
    } catch (err: any) {
      toast.error(err.message || "Erro ao criar sessão manual");
    } finally {
      setSavingManual(false);
    }
  }

  // ── Review helpers ────────────────────────────────────────────────────────────

  async function patchItem(itemId: number, data: Record<string, unknown>) {
    if (!session) return;
    try {
      const res = await apiFetch(`/smartinventory/sessions/${session.id}/items/${itemId}`, {
        method: "PATCH",
        body: JSON.stringify(data),
      });
      setSession(prev => prev ? {
        ...prev,
        items: prev.items.map(i => i.id === itemId ? res.data : i),
      } : prev);
      if (data.is_confirmed || data.is_skipped) {
        setExpandedItem(null);
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao atualizar item");
    }
  }

  async function patchSession(data: Record<string, unknown>) {
    if (!session) return;
    try {
      await apiFetch(`/smartinventory/sessions/${session.id}`, {
        method: "PATCH",
        body: JSON.stringify(data),
      });
    } catch { /* silently ignore */ }
  }

  async function handleConfirm() {
    if (!session) return;

    // Persist session meta before confirming
    await patchSession({
      supplier_id:     sessionMeta.supplier_id ? parseInt(sessionMeta.supplier_id) : null,
      purchase_date:   sessionMeta.purchase_date || null,
      document_number: sessionMeta.document_number || null,
    });

    setConfirming(true);
    try {
      await apiFetch(`/smartinventory/sessions/${session.id}/confirm`, { method: "POST" });
      setStep("done");
      toast.success("Estoque atualizado com sucesso!");
      loadHistory();
    } catch (err: any) {
      toast.error(err.message || "Erro ao confirmar entrada");
    } finally {
      setConfirming(false);
    }
  }

  async function loadHistory() {
    setLoadingHistory(true);
    try {
      const res = await apiFetch("/smartinventory/sessions?per_page=8");
      setHistory(res.data?.data ?? []);
    } catch { /* silent */ } finally {
      setLoadingHistory(false);
    }
  }

  async function resumeSession(id: number) {
    try {
      const res = await apiFetch(`/smartinventory/sessions/${id}`);
      const s: SmartInputSession = res.data;
      setSession(s);
      setSessionMeta({
        supplier_id:     String(s.supplier_id ?? ""),
        purchase_date:   s.purchase_date ?? "",
        document_number: s.document_number ?? "",
      });
      if (s.status === "needs_review") {
        setStep("review");
      } else if (["pending", "processing"].includes(s.status)) {
        setStep("processing");
        startPolling(s.id);
      }
    } catch { toast.error("Não foi possível retomar a sessão."); }
  }

  async function reprocessSession(id: number) {
    try {
      const res = await apiFetch(`/smartinventory/sessions/${id}/reprocess`, { method: "POST" });
      const s: SmartInputSession = res.data;
      setSession(s);
      setStep("processing");
      startPolling(s.id);
      toast.success("Reprocessamento iniciado.");
    } catch (err: any) { toast.error(err.message || "Erro ao reprocessar."); }
  }

  async function deleteSession(id: number) {
    if (!confirm("Excluir esta entrada do histórico? Esta ação não pode ser desfeita.")) return;
    try {
      await apiFetch(`/smartinventory/sessions/${id}`, { method: "DELETE" });
      setHistory(prev => prev.filter(s => s.id !== id));
      toast.success("Entrada excluída.");
    } catch (err: any) { toast.error(err.message || "Erro ao excluir."); }
  }

  function resetAll() {
    setStep("select");
    setSession(null);
    setFile(null);
    setFilePreview(null);
    setManualItems([{ ...emptyManualItem, id: Math.random().toString(36).substring(2, 9) }]);
    setManualSupplier(""); setManualDate(""); setManualDocNum(""); setManualNotes("");
    setSessionMeta({ supplier_id: "", purchase_date: "", document_number: "" });
    setExpandedItem(null);
  }

  const pendingItems   = session?.items?.filter(i => !i.is_confirmed && !i.is_skipped) ?? [];
  const confirmedCount = session?.items?.filter(i => i.is_confirmed).length ?? 0;
  const allResolved    = session ? pendingItems.length === 0 : false;

  // ─────────────────────────────────────────────────────────────────────────────
  // RENDER
  // ─────────────────────────────────────────────────────────────────────────────

  return (
    <div className="space-y-6 max-w-5xl">

      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold font-outfit text-zinc-900 flex items-center gap-2">
          <Sparkles className="w-6 h-6 text-primary" />
          Entrada de Matéria-Prima
        </h1>
        <p className="text-sm text-zinc-500 mt-1">
          Lance entradas manualmente ou deixe a IA extrair as informações da nota fiscal.
        </p>
      </div>

      {/* ── STEP: SELECT MODE ─────────────────────────────────────────────────── */}
      {step === "select" && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* Manual */}
          <button
            onClick={() => setStep("manual")}
            className="group text-left bg-white border-2 border-zinc-200 hover:border-primary rounded-2xl p-6 transition-all"
          >
            <div className="w-12 h-12 rounded-xl bg-zinc-100 group-hover:bg-primary/10 flex items-center justify-center mb-4 transition-colors">
              <ClipboardList className="w-6 h-6 text-zinc-500 group-hover:text-primary transition-colors" />
            </div>
            <h2 className="font-semibold text-zinc-900 text-lg mb-1">Entrada Manual</h2>
            <p className="text-sm text-zinc-500">
              Informe matéria-prima, quantidade, fornecedor e custo diretamente. Funciona sem internet e sem IA.
            </p>
            <div className="mt-4 flex items-center text-primary text-sm font-medium gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
              Começar <ChevronRight className="w-4 h-4" />
            </div>
          </button>

          {/* Smart / IA */}
          <button
            onClick={() => setStep("upload")}
            className="group text-left bg-white border-2 border-zinc-200 hover:border-primary rounded-2xl p-6 transition-all"
          >
            <div className="w-12 h-12 rounded-xl bg-violet-50 group-hover:bg-primary/10 flex items-center justify-center mb-4 transition-colors">
              <Brain className="w-6 h-6 text-violet-500 group-hover:text-primary transition-colors" />
            </div>
            <h2 className="font-semibold text-zinc-900 text-lg mb-1 flex items-center gap-2">
              Entrada Inteligente
              <Badge className="bg-violet-100 text-violet-700 border-none text-[10px] px-1.5">IA</Badge>
            </h2>
            <p className="text-sm text-zinc-500">
              Fotografe ou faça upload da nota fiscal. A IA extrai os dados automaticamente para revisão.
            </p>
            <div className="mt-4 flex items-center text-primary text-sm font-medium gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
              Enviar documento <ChevronRight className="w-4 h-4" />
            </div>
          </button>
        </div>
      )}

      {/* ── STEP: MANUAL ──────────────────────────────────────────────────────── */}
      {step === "manual" && (
        <form onSubmit={handleManualSubmit} className="space-y-6">
          <div className="bg-white rounded-2xl border border-zinc-200 p-6 space-y-4">
            <h2 className="font-semibold text-zinc-900">Informações da Compra</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="space-y-1.5">
                <div className="flex items-center justify-between">
                  <Label>Fornecedor</Label>
                  <button
                    type="button"
                    onClick={() => openNewSupplierModal("manual")}
                    className="text-xs text-primary hover:underline flex items-center gap-1 font-medium"
                  >
                    <Plus className="w-3 h-3" /> Novo
                  </button>
                </div>
                <Select value={manualSupplier} onValueChange={setManualSupplier}>
                  <SelectTrigger><SelectValue placeholder="Selecionar..." /></SelectTrigger>
                  <SelectContent>
                    {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1.5">
                <Label>Data da Compra</Label>
                <Input type="date" value={manualDate} onChange={e => setManualDate(e.target.value)} />
              </div>
              <div className="space-y-1.5">
                <Label>Nº Documento / NF</Label>
                <Input placeholder="ex.: 00123" value={manualDocNum} onChange={e => setManualDocNum(e.target.value)} />
              </div>
            </div>
            <div className="space-y-1.5">
              <Label>Observações</Label>
              <Input placeholder="Observações gerais desta entrada..." value={manualNotes} onChange={e => setManualNotes(e.target.value)} />
            </div>
          </div>

          <div className="bg-white rounded-2xl border border-zinc-200 p-6 space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="font-semibold text-zinc-900">Itens da Entrada</h2>
              <Button type="button" variant="outline" size="sm" onClick={() => setManualItems(p => [{ ...emptyManualItem, id: Math.random().toString(36).substring(2, 9) }, ...p])}>
                <Plus className="w-3.5 h-3.5 mr-1" /> Adicionar item
              </Button>
            </div>

            {manualItems.map((item, idx) => (
              <div key={item.id} className="grid grid-cols-12 gap-2 items-end p-3 bg-zinc-50 rounded-xl">
                <div className="col-span-12 md:col-span-4 space-y-1">
                  <Label className="text-xs">Matéria-Prima</Label>
                  <Select value={item.raw_material_id}
                    onValueChange={v => setManualItems(p => p.map(x => x.id === item.id ? { ...x, raw_material_id: v, description_raw: materials.find(m => m.id === parseInt(v))?.name ?? x.description_raw } : x))}>
                    <SelectTrigger className="h-8 text-xs"><SelectValue placeholder="Selecionar MP..." /></SelectTrigger>
                    <SelectContent>
                      {materials.map(m => <SelectItem key={m.id} value={String(m.id)}>{m.name} ({m.unit})</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
                <div className="col-span-6 md:col-span-2 space-y-1">
                  <Label className="text-xs">Quantidade</Label>
                  <Input className="h-8 text-xs" type="number" step="0.001" min="0.001" value={item.quantity}
                    onChange={e => setManualItems(p => p.map(x => x.id === item.id ? { ...x, quantity: e.target.value } : x))} />
                </div>
                <div className="col-span-6 md:col-span-1 space-y-1">
                  <Label className="text-xs">Unidade</Label>
                  <Select value={item.unit_raw} onValueChange={v => setManualItems(p => p.map(x => x.id === item.id ? { ...x, unit_raw: v } : x))}>
                    <SelectTrigger className="h-8 text-xs"><SelectValue /></SelectTrigger>
                    <SelectContent>{UNITS.map(u => <SelectItem key={u} value={u}>{u}</SelectItem>)}</SelectContent>
                  </Select>
                </div>
                <div className="col-span-6 md:col-span-2 space-y-1">
                  <Label className="text-xs">Custo Unit. (R$)</Label>
                  <Input className="h-8 text-xs" type="number" step="0.01" min="0" placeholder="0,00"
                    value={item.unit_price}
                    onChange={e => setManualItems(p => p.map(x => x.id === item.id ? { ...x, unit_price: e.target.value } : x))} />
                </div>
                <div className="col-span-6 md:col-span-2 space-y-1">
                  <Label className="text-xs">Lote / Validade</Label>
                  <Input className="h-8 text-xs" placeholder="Lote ou validade"
                    value={item.batch_number}
                    onChange={e => setManualItems(p => p.map(x => x.id === item.id ? { ...x, batch_number: e.target.value } : x))} />
                </div>
                <div className="col-span-12 md:col-span-1 flex justify-end">
                  <Button type="button" variant="ghost" size="sm" className="text-zinc-400 hover:text-red-500 h-8 w-8 p-0"
                    onClick={() => setManualItems(p => p.filter(x => x.id !== item.id))}
                    disabled={manualItems.length === 1}>
                    <Trash2 className="w-3.5 h-3.5" />
                  </Button>
                </div>
              </div>
            ))}
          </div>

          <div className="flex gap-3">
            <Button type="button" variant="outline" onClick={resetAll}>Cancelar</Button>
            <Button type="submit" disabled={savingManual} className="bg-primary">
              {savingManual ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : <ArrowRight className="w-4 h-4 mr-2" />}
              Continuar para Revisão
            </Button>
          </div>
        </form>
      )}

      {/* ── STEP: UPLOAD ──────────────────────────────────────────────────────── */}
      {step === "upload" && (
        <div className="space-y-6">
          <div
            onDragOver={e => { e.preventDefault(); setDragOver(true); }}
            onDragLeave={() => setDragOver(false)}
            onDrop={handleFileDrop}
            onClick={() => fileRef.current?.click()}
            className={`cursor-pointer rounded-2xl border-2 border-dashed p-10 text-center transition-all
              ${dragOver ? "border-primary bg-primary/5" : "border-zinc-300 bg-white hover:border-primary/60 hover:bg-zinc-50"}`}
          >
            <input ref={fileRef} type="file" accept="image/*,.pdf" className="hidden"
              onChange={e => { if (e.target.files?.[0]) selectFile(e.target.files[0]); }} />
            {file ? (
              <div className="space-y-3">
                {filePreview ? (
                  <img src={filePreview} alt="preview" className="max-h-48 mx-auto rounded-lg object-contain" />
                ) : (
                  <div className="w-16 h-16 mx-auto rounded-xl bg-zinc-100 flex items-center justify-center">
                    <FileText className="w-8 h-8 text-zinc-500" />
                  </div>
                )}
                <p className="font-medium text-zinc-900">{file.name}</p>
                <p className="text-xs text-zinc-400">{(file.size / 1024).toFixed(0)} KB</p>
                <Button type="button" variant="ghost" size="sm" className="text-zinc-400"
                  onClick={e => { e.stopPropagation(); setFile(null); setFilePreview(null); }}>
                  Trocar arquivo
                </Button>
              </div>
            ) : (
              <div className="space-y-3">
                <div className="w-16 h-16 mx-auto rounded-xl bg-zinc-100 flex items-center justify-center">
                  <Upload className="w-7 h-7 text-zinc-400" />
                </div>
                <p className="font-medium text-zinc-700">Arraste aqui ou clique para selecionar</p>
                <p className="text-xs text-zinc-400">JPG, PNG, WEBP ou PDF — máximo 10 MB</p>
                <div className="flex items-center justify-center gap-4 text-xs text-zinc-400 pt-1">
                  <span className="flex items-center gap-1"><ImageIcon className="w-3 h-3" /> Foto da nota</span>
                  <span className="flex items-center gap-1"><FileText className="w-3 h-3" /> DANFE / PDF</span>
                </div>
              </div>
            )}
          </div>

          <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 flex gap-3 items-start">
            <Info className="w-4 h-4 text-amber-600 mt-0.5 flex-shrink-0" />
            <p className="text-sm text-amber-800">
              A IA extrai os dados automaticamente. <strong>Você revisará e confirmará</strong> cada item antes de qualquer lançamento no estoque.
            </p>
          </div>

          <div className="flex gap-3">
            <Button variant="outline" onClick={resetAll}>Voltar</Button>
            <Button disabled={!file || uploading} onClick={handleUpload} className="bg-primary">
              {uploading ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : <Brain className="w-4 h-4 mr-2" />}
              Analisar com IA
            </Button>
          </div>
        </div>
      )}

      {/* ── STEP: PROCESSING ─────────────────────────────────────────────────── */}
      {step === "processing" && (
        <div className="bg-white rounded-2xl border border-zinc-200 p-12 text-center space-y-5">
          <div className="w-20 h-20 mx-auto rounded-2xl bg-violet-50 flex items-center justify-center">
            <Brain className="w-10 h-10 text-violet-500 animate-pulse" />
          </div>
          <div>
            <p className="font-semibold text-zinc-900 text-lg">Analisando documento...</p>
            <p className="text-sm text-zinc-500 mt-1">
              A IA está lendo e extraindo os dados da nota fiscal. Isso leva alguns segundos.
            </p>
          </div>
          <div className="flex items-center justify-center gap-2 text-sm text-zinc-400">
            <Loader2 className="w-4 h-4 animate-spin" />
            {session?.status_label ?? "Processando"}
          </div>
          {session?.document_original_name && (
            <p className="text-xs text-zinc-400">{session.document_original_name}</p>
          )}
        </div>
      )}

      {/* ── STEP: REVIEW ─────────────────────────────────────────────────────── */}
      {step === "review" && session && (
        <ReviewStep
          session={session}
          sessionMeta={sessionMeta}
          setSessionMeta={setSessionMeta}
          materials={materials}
          suppliers={suppliers}
          expandedItem={expandedItem}
          setExpandedItem={setExpandedItem}
          patchItem={patchItem}
          allResolved={allResolved}
          confirmedCount={confirmedCount}
          pendingCount={pendingItems.length}
          confirming={confirming}
          onConfirm={handleConfirm}
          onBack={resetAll}
          openNewSupplierModal={openNewSupplierModal}
        />
      )}

      {/* ── STEP: DONE ────────────────────────────────────────────────────────── */}
      {step === "done" && (
        <div className="bg-white rounded-2xl border border-emerald-200 p-12 text-center space-y-5">
          <div className="w-20 h-20 mx-auto rounded-2xl bg-emerald-50 flex items-center justify-center">
            <PackageCheck className="w-10 h-10 text-emerald-500" />
          </div>
          <div>
            <p className="font-semibold text-zinc-900 text-xl">Entrada registrada!</p>
            <p className="text-sm text-zinc-500 mt-1">
              O estoque e o custo médio ponderado foram atualizados com sucesso.
            </p>
          </div>
          <div className="flex items-center justify-center gap-3 pt-2">
            <Button variant="outline" onClick={() => window.location.href = "/admin/materias-primas"}>
              Ver Matérias-Primas
            </Button>
            <Button className="bg-primary" onClick={resetAll}>
              <Plus className="w-4 h-4 mr-2" /> Nova Entrada
            </Button>
          </div>
        </div>
      )}
      {/* ── HISTORY PANEL (visible on select + done screens) ─────────────────── */}
      {["select", "done"].includes(step) && (
        <div className="bg-white rounded-2xl border border-zinc-200 overflow-hidden">
          <div className="flex items-center justify-between px-5 py-3 border-b border-zinc-100">
            <h3 className="font-semibold text-zinc-900 text-sm flex items-center gap-2">
              <Clock className="w-4 h-4 text-zinc-400" /> Entradas Recentes
            </h3>
            <Button variant="ghost" size="sm" className="h-7 text-xs text-zinc-400" onClick={loadHistory}>
              <RefreshCw className={`w-3 h-3 mr-1 ${loadingHistory ? "animate-spin" : ""}`} /> Atualizar
            </Button>
          </div>

          {loadingHistory && history.length === 0 ? (
            <div className="p-6 text-center">
              <Loader2 className="w-5 h-5 animate-spin text-zinc-300 mx-auto" />
            </div>
          ) : history.length === 0 ? (
            <div className="p-6 text-center text-sm text-zinc-400">
              Nenhuma entrada registrada ainda.
            </div>
          ) : (
            <div className="divide-y divide-zinc-100">
              {history.map(s => (
                <div key={s.id} className="flex items-center gap-3 px-5 py-3 hover:bg-zinc-50 transition-colors">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="text-sm font-medium text-zinc-900">
                        {s.document_number ? `NF ${s.document_number}` : `Entrada #${s.id}`}
                      </span>
                      <StatusBadge status={s.status} label={s.status_label} />
                    </div>
                    <p className="text-xs text-zinc-400 mt-0.5">
                      {s.supplier_name_raw ?? "Fornecedor não identificado"}
                      {s.purchase_date ? ` · ${new Date(s.purchase_date + "T00:00:00").toLocaleDateString("pt-BR")}` : ""}
                      {" · "}{s.items_count} {s.items_count === 1 ? "item" : "itens"}
                    </p>
                  </div>
                  <div className="flex items-center gap-1.5 flex-shrink-0">
                    {s.status === "needs_review" && (
                      <Button size="sm" variant="outline" className="h-7 text-xs"
                        onClick={() => resumeSession(s.id)}>
                        Retomar
                      </Button>
                    )}
                    {s.status === "failed" && (
                      <Button size="sm" variant="outline" className="h-7 text-xs text-amber-600 border-amber-300"
                        onClick={() => reprocessSession(s.id)}>
                        <RefreshCw className="w-3 h-3 mr-1" /> Reprocessar
                      </Button>
                    )}
                    {s.status === "completed" && (
                      <span className="text-xs text-emerald-600 flex items-center gap-1">
                        <CheckCircle2 className="w-3.5 h-3.5" />
                        {s.confirmed_items_count} item(s) no estoque
                      </span>
                    )}
                    {s.status !== "completed" && (
                      <Button size="sm" variant="ghost" className="h-7 w-7 p-0 text-zinc-400 hover:text-red-500"
                        title="Excluir entrada"
                        onClick={() => deleteSession(s.id)}>
                        <Trash2 className="w-3.5 h-3.5" />
                      </Button>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Modal de Cadastro Rápido de Fornecedor */}
      <Dialog open={isSupplierModalOpen} onOpenChange={setIsSupplierModalOpen}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle className="font-outfit flex items-center gap-2">
              <Plus className="w-5 h-5 text-primary" />
              Novo Fornecedor
            </DialogTitle>
            <DialogDescription>
              Cadastre um novo fornecedor de forma rápida para continuar o lançamento.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleCreateSupplier} className="space-y-4 py-2">
            <div className="space-y-1.5">
              <Label htmlFor="supplier-name">Nome / Razão Social</Label>
              <Input
                id="supplier-name"
                required
                placeholder="Ex: Distribuidora de Essências Ltda"
                value={supplierForm.name}
                onChange={e => setSupplierForm(prev => ({ ...prev, name: e.target.value }))}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="supplier-cnpj">CNPJ (opcional)</Label>
              <Input
                id="supplier-cnpj"
                placeholder="00.000.000/0000-00"
                value={supplierForm.cnpj}
                onChange={e => setSupplierForm(prev => ({ ...prev, cnpj: e.target.value }))}
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div className="space-y-1.5">
                <Label htmlFor="supplier-email">E-mail (opcional)</Label>
                <Input
                  id="supplier-email"
                  type="email"
                  placeholder="fornecedor@email.com"
                  value={supplierForm.email}
                  onChange={e => setSupplierForm(prev => ({ ...prev, email: e.target.value }))}
                />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="supplier-phone">Telefone (opcional)</Label>
                <Input
                  id="supplier-phone"
                  placeholder="(00) 00000-0000"
                  value={supplierForm.phone}
                  onChange={e => setSupplierForm(prev => ({ ...prev, phone: e.target.value }))}
                />
              </div>
            </div>
            <DialogFooter className="pt-2">
              <Button type="button" variant="outline" onClick={() => setIsSupplierModalOpen(false)}>
                Cancelar
              </Button>
              <Button type="submit" disabled={savingSupplier} className="bg-primary">
                {savingSupplier ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : null}
                Salvar Fornecedor
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}

// ─── Review Step (extracted for clarity) ─────────────────────────────────────

function ReviewStep({
  session, sessionMeta, setSessionMeta, materials, suppliers,
  expandedItem, setExpandedItem, patchItem,
  allResolved, confirmedCount, pendingCount,
  confirming, onConfirm, onBack, openNewSupplierModal,
}: {
  session: SmartInputSession;
  sessionMeta: { supplier_id: string; purchase_date: string; document_number: string };
  setSessionMeta: React.Dispatch<React.SetStateAction<{ supplier_id: string; purchase_date: string; document_number: string }>>;
  materials: RawMaterial[];
  suppliers: Supplier[];
  expandedItem: number | null;
  setExpandedItem: (id: number | null) => void;
  patchItem: (id: number, data: Record<string, unknown>) => Promise<void>;
  allResolved: boolean;
  confirmedCount: number;
  pendingCount: number;
  confirming: boolean;
  onConfirm: () => void;
  onBack: () => void;
  openNewSupplierModal: (source: "manual" | "review", prefilledName?: string) => void;
}) {
  return (
    <div className="space-y-5">
      {/* Session meta */}
      <div className="bg-white rounded-2xl border border-zinc-200 p-5 space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="font-semibold text-zinc-900">Informações da Compra</h2>
          <StatusBadge status={session.status} label={session.status_label} />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <Label className="text-xs">Fornecedor</Label>
              <button
                type="button"
                onClick={() => openNewSupplierModal("review", session.supplier_name_raw ?? "")}
                className="text-xs text-primary hover:underline flex items-center gap-1 font-medium"
              >
                <Plus className="w-3 h-3" /> Cadastrar Novo
              </button>
            </div>
            <Select value={sessionMeta.supplier_id} onValueChange={v => setSessionMeta(p => ({ ...p, supplier_id: v }))}>
              <SelectTrigger className="h-9 text-sm">
                <SelectValue placeholder={session.supplier_name_raw ?? "Selecionar..."} />
              </SelectTrigger>
              <SelectContent>
                {suppliers.map(s => <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>)}
              </SelectContent>
            </Select>
            {session.supplier_name_raw && (
              <div className="flex items-center justify-between text-xs text-zinc-400 mt-0.5">
                <span>Extraído: "{session.supplier_name_raw}"</span>
                {!suppliers.some(s => s.name.toLowerCase() === session.supplier_name_raw?.toLowerCase()) && !sessionMeta.supplier_id && (
                  <button
                    type="button"
                    onClick={() => openNewSupplierModal("review", session.supplier_name_raw ?? "")}
                    className="text-[10px] text-violet-600 hover:text-violet-800 font-semibold underline"
                  >
                    Cadastrar Fornecedor
                  </button>
                )}
              </div>
            )}
          </div>
          <div className="space-y-1.5">
            <Label className="text-xs">Data da Compra</Label>
            <Input type="date" className="h-9 text-sm" value={sessionMeta.purchase_date}
              onChange={e => setSessionMeta(p => ({ ...p, purchase_date: e.target.value }))} />
          </div>
          <div className="space-y-1.5">
            <Label className="text-xs">Nº Documento / NF</Label>
            <Input className="h-9 text-sm" placeholder="Número da nota" value={sessionMeta.document_number}
              onChange={e => setSessionMeta(p => ({ ...p, document_number: e.target.value }))} />
          </div>
        </div>
      </div>

      {/* Progress bar */}
      <div className="bg-white rounded-2xl border border-zinc-200 p-4 flex items-center gap-4">
        <div className="flex-1">
          <div className="flex justify-between text-xs text-zinc-500 mb-1.5">
            <span>{confirmedCount} confirmado(s)</span>
            <span>{pendingCount} pendente(s)</span>
          </div>
          <div className="h-2 bg-zinc-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-primary rounded-full transition-all"
              style={{ width: session.items.length ? `${(confirmedCount / session.items.length) * 100}%` : "0%" }}
            />
          </div>
        </div>
        {allResolved && (
          <div className="flex items-center gap-1 text-sm text-emerald-600 font-medium">
            <CheckCircle2 className="w-4 h-4" /> Todos revisados
          </div>
        )}
      </div>

      {/* Items */}
      <div className="space-y-2">
        {session.items.map(item => (
          <ItemRow
            key={`${item.id}-${item.is_confirmed}-${item.is_skipped}`}
            item={item}
            materials={materials}
            expanded={expandedItem === item.id}
            onToggle={() => setExpandedItem(expandedItem === item.id ? null : item.id)}
            onPatch={data => patchItem(item.id, data)}
          />
        ))}
      </div>

      {/* Footer actions */}
      <div className="flex items-center justify-between pt-2">
        <Button variant="outline" onClick={onBack}>Cancelar</Button>
        <Button
          onClick={onConfirm}
          disabled={!allResolved || confirmedCount === 0 || confirming}
          className="bg-primary min-w-36"
        >
          {confirming
            ? <><Loader2 className="w-4 h-4 animate-spin mr-2" /> Registrando...</>
            : <><PackageCheck className="w-4 h-4 mr-2" /> Confirmar Entrada ({confirmedCount})</>}
        </Button>
      </div>
    </div>
  );
}

// ─── Item Row ─────────────────────────────────────────────────────────────────

function ItemRow({
  item, materials, expanded, onToggle, onPatch,
}: {
  item: SmartInputItem;
  materials: RawMaterial[];
  expanded: boolean;
  onToggle: () => void;
  onPatch: (data: Record<string, unknown>) => void;
}) {
  const existingCategories = useMemo(() => {
    const cats = new Set<string>();
    materials.forEach(m => {
      if (m.category && m.category.trim()) {
        cats.add(m.category.trim());
      }
    });
    return Array.from(cats).sort();
  }, [materials]);

  const [localQty, setLocalQty]         = useState(String(item.quantity));
  const [localPrice, setLocalPrice]     = useState(String(item.unit_price ?? ""));
  const [localUnit, setLocalUnit]       = useState(item.unit_normalized ?? item.unit_raw ?? "un");
  const [localBatch, setLocalBatch]     = useState(item.batch_number ?? "");
  const [localExpiry, setLocalExpiry]   = useState(item.expires_at ?? "");
  const [localMpId, setLocalMpId]       = useState(String(item.raw_material_id ?? ""));
  const [isNewMp, setIsNewMp]           = useState(item.is_new_material);
  const [newMpCat, setNewMpCat]         = useState(item.new_material_category ?? "");
  const [localNewMatName, setLocalNewMatName] = useState(item.description_raw);

  const [isCustomCategory, setIsCustomCategory] = useState(
    item.new_material_category 
      ? !existingCategories.includes(item.new_material_category) 
      : false
  );

  const skipped    = item.is_skipped;
  const confirmed  = item.is_confirmed;

  function rowBg() {
    if (skipped)   return "bg-zinc-50 opacity-60 border-zinc-200";
    if (confirmed) return "bg-emerald-50 border-emerald-200";
    if (item.confidence_level === "none" || !item.raw_material_id)
      return "bg-red-50 border-red-200";
    if (item.confidence_level === "low")
      return "bg-amber-50 border-amber-200";
    return "bg-white border-zinc-200";
  }

  const selectedMaterial = materials.find(m => String(m.id) === localMpId);
  const avgCost = selectedMaterial?.average_cost;
  const enteredPrice = localPrice ? parseFloat(localPrice) : null;
  const priceVariancePct = avgCost && enteredPrice && avgCost > 0
    ? ((enteredPrice - avgCost) / avgCost) * 100
    : null;
  const hasPriceWarning = priceVariancePct !== null && Math.abs(priceVariancePct) >= 15;

  function commitAndConfirm() {
    onPatch({
      raw_material_id:       isNewMp ? null : (localMpId ? parseInt(localMpId) : null),
      description_raw:       isNewMp ? localNewMatName : item.description_raw,
      quantity:              parseFloat(localQty) || item.quantity,
      unit_normalized:       localUnit,
      unit_price:            localPrice ? parseFloat(localPrice) : null,
      batch_number:          localBatch || null,
      expires_at:            localExpiry || null,
      is_new_material:       isNewMp,
      new_material_category: newMpCat || null,
      is_confirmed:          true,
      is_skipped:            false,
    });
  }

  return (
    <div className={`rounded-xl border transition-all ${rowBg()}`}>
      {/* Summary row */}
      <div className="flex items-center gap-3 p-4 cursor-pointer" onClick={onToggle}>
        <div className="flex-1 min-w-0">
          <p className="font-medium text-zinc-900 text-sm truncate">{item.description_raw}</p>
          <p className="text-xs text-zinc-500 mt-0.5">
            {item.quantity} {item.unit_normalized ?? item.unit_raw}
            {item.unit_price ? ` · R$ ${item.unit_price.toFixed(2)}/un` : ""}
          </p>
        </div>

        <div className="flex items-center gap-2 flex-shrink-0">
          {item.raw_material && !isNewMp && (
            <span className="text-xs bg-zinc-100 text-zinc-600 rounded px-2 py-0.5 hidden md:block truncate max-w-32">
              {item.raw_material.name}
            </span>
          )}
          {isNewMp && (
            <Badge className="bg-violet-100 text-violet-700 border-none text-xs">Nova MP</Badge>
          )}
          <ConfidenceBadge level={item.confidence_level} score={item.match_confidence} />
          {confirmed && <CheckCircle2 className="w-4 h-4 text-emerald-500" />}
          {skipped  && <SkipForward className="w-4 h-4 text-zinc-400" />}
        </div>
      </div>

      {/* Expanded editor */}
      {expanded && (
        <div className="border-t border-zinc-200 p-4 space-y-4">
          {/* Matching */}
          <div className="space-y-2">
            <div className="flex items-center gap-2">
              <Label className="text-xs font-semibold">Matéria-Prima Correspondente</Label>
              <label className="flex items-center gap-1.5 text-xs text-violet-700 cursor-pointer ml-auto">
                <input type="checkbox" checked={isNewMp} onChange={e => setIsNewMp(e.target.checked)} className="w-3 h-3" />
                Criar nova MP
              </label>
            </div>

            {isNewMp ? (
              <div className="grid grid-cols-2 gap-2">
                <div className="flex flex-col gap-1">
                  <Label className="text-[10px] text-zinc-400">Nome da Matéria-Prima</Label>
                  <Input className="h-8 text-xs" placeholder="Nome da nova matéria-prima"
                    value={localNewMatName} onChange={e => setLocalNewMatName(e.target.value)} />
                </div>
                <div className="flex flex-col gap-1">
                  <Label className="text-[10px] text-zinc-400">Categoria</Label>
                  {!isCustomCategory ? (
                    <select
                      value={newMpCat}
                      onChange={e => {
                        if (e.target.value === "__NEW__") {
                          setIsCustomCategory(true);
                          setNewMpCat("");
                        } else {
                          setNewMpCat(e.target.value);
                        }
                      }}
                      className="flex h-8 w-full rounded-md border border-zinc-200 bg-white px-2 py-1 text-xs focus-visible:outline-none focus:ring-1 focus:ring-zinc-950"
                    >
                      <option value="">-- selecione ou crie --</option>
                      {existingCategories.map((cat: string) => (
                        <option key={cat} value={cat}>{cat}</option>
                      ))}
                      <option value="__NEW__">➕ Criar nova categoria...</option>
                    </select>
                  ) : (
                    <div className="flex gap-1">
                      <Input 
                        className="h-8 text-xs flex-1" 
                        placeholder="Nome da categoria"
                        value={newMpCat} 
                        onChange={e => setNewMpCat(e.target.value)} 
                        autoFocus
                      />
                      <Button 
                        type="button" 
                        variant="ghost" 
                        className="h-8 px-2 text-[10px] text-zinc-400 hover:text-zinc-600"
                        onClick={() => {
                          setIsCustomCategory(false);
                          setNewMpCat("");
                        }}
                      >
                        Cancelar
                      </Button>
                    </div>
                  )}
                </div>
              </div>
            ) : (
              <div>
                <Select value={localMpId} onValueChange={setLocalMpId}>
                  <SelectTrigger className="h-8 text-xs">
                    <SelectValue placeholder="Selecionar matéria-prima..." />
                  </SelectTrigger>
                  <SelectContent>
                    {materials.map(m => (
                      <SelectItem key={m.id} value={String(m.id)}>
                        {m.name} ({m.unit})
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>

                {/* Match suggestions */}
                {item.match_suggestions?.length > 0 && (
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    <span className="text-[10px] text-zinc-400 self-center">Sugestões:</span>
                    {item.match_suggestions.slice(0, 3).map(s => (
                      <button key={s.raw_material_id} type="button"
                        onClick={() => setLocalMpId(String(s.raw_material_id))}
                        className={`text-[10px] px-2 py-0.5 rounded border transition-colors
                          ${localMpId === String(s.raw_material_id)
                            ? "bg-primary text-white border-primary"
                            : "bg-white text-zinc-600 border-zinc-300 hover:border-primary"}`}
                      >
                        {s.name} <span className="opacity-60">{Math.round(s.confidence * 100)}%</span>
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Qty / Unit / Price */}
          <div className="grid grid-cols-3 gap-2">
            <div className="space-y-1">
              <Label className="text-xs">Quantidade</Label>
              <Input className="h-8 text-xs" type="number" step="0.001" min="0.001"
                value={localQty} onChange={e => setLocalQty(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label className="text-xs">Unidade</Label>
              <Select value={localUnit} onValueChange={setLocalUnit}>
                <SelectTrigger className="h-8 text-xs"><SelectValue /></SelectTrigger>
                <SelectContent>
                  {["g", "kg", "ml", "L", "un", "oz", "cx"].map(u =>
                    <SelectItem key={u} value={u}>{u}</SelectItem>
                  )}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1">
              <Label className="text-xs">Custo Unit. (R$)</Label>
              <Input className="h-8 text-xs" type="number" step="0.01" min="0" placeholder="0,00"
                value={localPrice} onChange={e => setLocalPrice(e.target.value)} />
              {hasPriceWarning && avgCost && (
                <p className={`text-[10px] flex items-center gap-0.5 mt-0.5 ${
                  priceVariancePct! > 0 ? "text-red-500" : "text-emerald-600"
                }`}>
                  <AlertTriangle className="w-2.5 h-2.5" />
                  {priceVariancePct! > 0 ? "+" : ""}{priceVariancePct!.toFixed(0)}% vs custo médio (R$ {avgCost.toFixed(2)})
                </p>
              )}
            </div>
          </div>

          {/* Batch / Expiry */}
          <div className="grid grid-cols-2 gap-2">
            <div className="space-y-1">
              <Label className="text-xs">Nº do Lote</Label>
              <Input className="h-8 text-xs" placeholder="Lote do fornecedor"
                value={localBatch} onChange={e => setLocalBatch(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label className="text-xs">Validade</Label>
              <Input className="h-8 text-xs" type="date"
                value={localExpiry} onChange={e => setLocalExpiry(e.target.value)} />
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-2 pt-1">
            <Button type="button" size="sm"
              disabled={!isNewMp && !localMpId}
              onClick={commitAndConfirm}
              className="bg-primary h-7 text-xs">
              <CheckCircle2 className="w-3.5 h-3.5 mr-1" /> Confirmar item
            </Button>
            <Button type="button" variant="outline" size="sm" className="h-7 text-xs"
              onClick={() => onPatch({ is_skipped: true, is_confirmed: false })}>
              <SkipForward className="w-3.5 h-3.5 mr-1" /> Ignorar
            </Button>
            {(item.is_confirmed || item.is_skipped) && (
              <Button type="button" variant="ghost" size="sm" className="h-7 text-xs text-zinc-400"
                onClick={() => onPatch({ is_confirmed: false, is_skipped: false })}>
                Reabrir
              </Button>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
