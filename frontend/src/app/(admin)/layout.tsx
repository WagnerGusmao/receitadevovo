"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { cn } from "@/lib/utils";
import { LayoutDashboard, Package, Leaf, FileText, LogOut, ShoppingBag, TrendingUp, Archive, FlaskConical, Truck, Layers, Beaker, Factory, BarChart3, ShoppingCart, DollarSign, ShieldCheck, Sparkles, Users, Tag, Store, PackageCheck, Mail, Building2, Clock, Menu, X, Image } from "lucide-react";
import { Toaster } from "sonner";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { apiFetch } from "@/services/api";
import { Logo } from "@/components/Logo";

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const { user, isAuthenticated } = useAuthStore();
  const [pendingCount, setPendingCount] = useState(0);
  const [isMobileOpen, setIsMobileOpen] = useState(false);

  useEffect(() => {
    if (!isAuthenticated || !user?.is_admin) {
      router.push("/login");
      return;
    }

    async function fetchPending() {
      try {
        const res = await apiFetch("/ecommerce/orders/pending-fulfillment");
        setPendingCount(res.data?.length || 0);
      } catch {
        // silently ignore
      }
    }
    fetchPending();
    const interval = setInterval(fetchPending, 60000); // refresh every 60s
    return () => clearInterval(interval);
  }, [isAuthenticated, user, router]);

  // Close sidebar drawer automatically when navigating to a new path
  useEffect(() => {
    setIsMobileOpen(false);
  }, [pathname]);

  const menuGroups = [
    {
      label: "Vendas",
      items: [
        { href: "/admin", label: "Painel Geral", icon: LayoutDashboard },
        { href: "/admin/dashboard", label: "Vendas e Métricas", icon: TrendingUp },
        { href: "/admin/fulfillment", label: "Separação e Envio", icon: PackageCheck, badge: pendingCount },
        { href: "/admin/pedidos", label: "Pedidos", icon: ShoppingBag },
        { href: "/admin/pedidos-balcao", label: "Venda Balcão", icon: Store },
        { href: "/admin/comodato", label: "Comodatos", icon: Building2 },
        { href: "/admin/estoque", label: "Estoque Produtos", icon: Archive },
        { href: "/admin/produtos", label: "Produtos", icon: Package },
        { href: "/admin/categorias", label: "Categorias", icon: Tag },
        { href: "/admin/kits", label: "Kits", icon: Package },
        { href: "/admin/wellness", label: "Wellness / Ervas", icon: Leaf },
        { href: "/admin/blog", label: "Blog", icon: FileText },
        { href: "/admin/banners", label: "Banners", icon: Image },
        { href: "/admin/fidelidade", label: "Fidelidade", icon: Sparkles },
        { href: "/admin/newsletter", label: "Newsletter", icon: Mail },
      ],
    },
    {
      label: "ERP Artesanal",
      items: [
        { href: "/admin/materias-primas", label: "Matérias-Primas", icon: FlaskConical },
        { href: "/admin/entrada-inteligente", label: "Entrada Inteligente", icon: Sparkles },
        { href: "/admin/compras", label: "Compras", icon: ShoppingCart },
        { href: "/admin/fornecedores", label: "Fornecedores", icon: Truck },
        { href: "/admin/lotes", label: "Lotes", icon: Layers },
        { href: "/admin/receitas", label: "Receitas & Fórmulas", icon: Beaker },
        { href: "/admin/producao", label: "Produção", icon: Factory },
        { href: "/admin/qualidade", label: "Qualidade", icon: ShieldCheck },
        { href: "/admin/financeiro", label: "Financeiro", icon: DollarSign },
        { href: "/admin/financeiro/parcelas", label: "Controle de Parcelas", icon: Clock },
        { href: "/admin/analytics", label: "Analytics", icon: BarChart3 },
      ],
    },
    {
      label: "Sistema",
      items: [
        { href: "/admin/usuarios", label: "Usuários", icon: Users },
      ],
    },
  ];

  const sidebarContent = (
    <div className="flex flex-col h-full bg-white">
      <div className="h-20 flex items-center px-6 border-b border-zinc-100 justify-between">
        <Link href="/admin" className="flex items-center shrink-0 transition-transform hover:scale-[1.02] active:scale-[0.98]">
          <Logo variant="horizontal" size="sm" />
        </Link>
        <button
          onClick={() => setIsMobileOpen(false)}
          className="lg:hidden p-2 rounded-lg hover:bg-zinc-100 text-zinc-500 transition-colors"
          title="Fechar menu"
        >
          <X className="w-5 h-5" />
        </button>
      </div>
      
      <nav className="flex-1 p-4 space-y-4 overflow-y-auto">
        {menuGroups.map((group) => (
          <div key={group.label}>
            <p className="text-[10px] font-bold text-zinc-400 uppercase tracking-widest px-4 mb-1">
              {group.label}
            </p>
            <div className="space-y-0.5">
              {group.items.map((item: any) => (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-colors",
                    pathname === item.href
                      ? "bg-primary/10 text-primary"
                      : "text-zinc-500 hover:bg-zinc-50 hover:text-zinc-900"
                  )}
                >
                  <item.icon className="w-4 h-4" />
                  <span className="flex-1">{item.label}</span>
                  {item.badge > 0 && (
                    <span className="flex h-5 w-5 items-center justify-center rounded-full bg-amber-500 text-[10px] font-bold text-white">
                      {item.badge > 9 ? "9+" : item.badge}
                    </span>
                  )}
                </Link>
              ))}
            </div>
          </div>
        ))}
      </nav>

      <div className="p-4 border-t border-zinc-100">
        <Link 
          href="/login" 
          className="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium text-destructive hover:bg-destructive/5"
        >
          <LogOut className="w-5 h-5" />
          Sair
        </Link>
      </div>
    </div>
  );

  return (
    <div className="flex min-h-screen bg-zinc-50">
      <Toaster position="top-right" richColors />
      
      {/* Desktop Sidebar */}
      <aside className="hidden lg:flex w-64 border-r border-zinc-200 flex-col shrink-0 bg-white">
        {sidebarContent}
      </aside>

      {/* Mobile Sidebar (Drawer) */}
      {isMobileOpen && (
        <>
          <div 
            className="fixed inset-0 bg-black/40 backdrop-blur-sm z-40 lg:hidden animate-in fade-in duration-200"
            onClick={() => setIsMobileOpen(false)}
            aria-hidden="true"
          />
          <aside className="fixed inset-y-0 left-0 w-64 bg-white z-50 flex flex-col lg:hidden shadow-2xl animate-in slide-in-from-left duration-300">
            {sidebarContent}
          </aside>
        </>
      )}

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0">
        <header className="h-20 bg-white border-b border-zinc-200 flex items-center justify-between px-4 lg:px-8">
          <div className="flex items-center gap-3 lg:gap-4">
            <button
              onClick={() => setIsMobileOpen(true)}
              className="lg:hidden p-2 rounded-lg hover:bg-zinc-100 text-zinc-600 transition-colors"
              title="Abrir menu"
            >
              <Menu className="w-6 h-6" />
            </button>
            <Logo variant="horizontal" size="sm" className="hidden sm:block lg:hidden" />
            <span className="hidden sm:block lg:hidden h-6 w-px bg-zinc-200" />
            <h2 className="text-base lg:text-lg font-semibold text-zinc-900">Painel de Controle</h2>
          </div>
          <div className="flex items-center gap-3 lg:gap-4">
            <span className="hidden sm:inline text-sm text-zinc-500">{user?.email || "receitadevovo@receitadevovo.com.br"}</span>
            <div className="w-9 h-9 lg:w-10 lg:h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
              {user?.name ? user.name[0].toUpperCase() : "V"}
            </div>
          </div>
        </header>
        <div className="p-4 lg:p-8">
          {children}
        </div>
      </main>
    </div>
  );
}
