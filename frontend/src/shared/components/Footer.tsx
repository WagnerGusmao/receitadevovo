"use client";

import Link from "next/link";
import { useState } from "react";
import { apiFetch } from "@/services/api";
import { Logo } from "@/components/Logo";
import { Button } from "@/components/ui/button";
import { 
  Mail, 
  Phone, 
  MapPin, 
  Send,
  Heart,
  ChevronRight
} from "lucide-react";

// Ícone SVG personalizado do Instagram (pois ícones de marca não estão presentes nesta versão do lucide-react)
function InstagramIcon({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <rect width="20" height="20" x="2" y="2" rx="5" ry="5" />
      <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
      <line x1="17.5" x2="17.51" y1="6.5" y2="6.5" />
    </svg>
  );
}
import { toast } from "sonner";

export function Footer() {
  const [email, setEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubscribe = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email) return;
    
    setSubmitting(true);
    try {
      const response = await apiFetch("/newsletter/subscribe", {
        method: "POST",
        body: JSON.stringify({ email }),
      });
      toast.success(response.message || "Inscrição realizada com sucesso!", {
        description: "Você receberá nossas novidades e rituais de bem-estar por e-mail.",
      });
      setEmail("");
    } catch (error: any) {
      toast.error(error.message || "Ocorreu um erro ao realizar a inscrição.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <footer className="bg-terra text-bege-light/80 border-t border-bege/10">
      {/* Seção Principal */}
      <div className="container mx-auto px-6 py-16 md:py-20">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-10 lg:gap-8">
          
          {/* Coluna 1: Logo e Descrição */}
          <div className="lg:col-span-4 space-y-6">
            <Link href="/" className="inline-block transition-transform hover:scale-105 active:scale-95">
              {/* Logo horizontal com suas cores originais em um fundo bege claro para contraste */}
              <div className="bg-bege-light p-3.5 rounded-2xl inline-block shadow-md">
                <Logo variant="horizontal" size="md" />
              </div>
            </Link>
            <p className="text-base text-bege/70 leading-relaxed max-w-sm">
              Um ecossistema wellness onde a sabedoria ancestral das ervas e rituais tradicionais se unem para nutrir seu corpo e alma. Feito à mão com afeto e propósito.
            </p>
            <div className="flex items-center gap-3">
              <a 
                href="https://www.instagram.com/receitadevovoem/" 
                target="_blank" 
                rel="noreferrer" 
                className="w-10 h-10 rounded-full bg-bege-light/5 hover:bg-sage/20 hover:text-bege-light flex items-center justify-center transition-all duration-300 border border-bege-light/10 hover:border-sage/30 text-bege/60"
                aria-label="Instagram"
              >
                <InstagramIcon className="w-5 h-5" />
              </a>
              <a 
                href="mailto:receitadevovo@receitadevovo.com.br" 
                className="w-10 h-10 rounded-full bg-bege-light/5 hover:bg-sage/20 hover:text-bege-light flex items-center justify-center transition-all duration-300 border border-bege-light/10 hover:border-sage/30 text-bege/60"
                aria-label="E-mail"
              >
                <Mail className="w-5 h-5" />
              </a>
            </div>
          </div>

          {/* Coluna 2: Links de Navegação */}
          <div className="lg:col-span-2 space-y-6">
            <h4 className="text-lg font-heading font-semibold text-dourado uppercase tracking-wider">
              Navegação
            </h4>
            <ul className="space-y-3.5">
              {[
                { label: "Início", href: "/" },
                { label: "Ervas", href: "/ervas" },
                { label: "Sabedoria", href: "/blog" },
                { label: "Loja", href: "/produtos" },
                { label: "Nossa História", href: "/nossa-historia" },
              ].map((link) => (
                <li key={link.href}>
                  <Link 
                    href={link.href}
                    className="group flex items-center gap-1 text-bege/70 hover:text-dourado transition-colors text-base"
                  >
                    <ChevronRight className="w-3.5 h-3.5 opacity-0 group-hover:opacity-100 transition-opacity -ml-4 group-hover:ml-0 text-dourado" />
                    <span>{link.label}</span>
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Coluna 3: Contatos */}
          <div className="lg:col-span-3 space-y-6">
            <h4 className="text-lg font-heading font-semibold text-dourado uppercase tracking-wider">
              Contato
            </h4>
            <ul className="space-y-4">
              <li className="flex items-start gap-3">
                <MapPin className="w-5 h-5 text-sage shrink-0 mt-0.5" />
                <span className="text-bege/70 text-base leading-relaxed">
                  Barueri, São Paulo - Brasil
                </span>
              </li>
              <li className="flex items-center gap-3">
                <Phone className="w-5 h-5 text-sage shrink-0" />
                <a href="tel:+5511983957146" className="text-bege/70 hover:text-dourado transition-colors text-base">
                  (11) 98395-7146
                </a>
              </li>
              <li className="flex items-center gap-3">
                <Mail className="w-5 h-5 text-sage shrink-0" />
                <a href="mailto:receitadevovo@receitadevovo.com.br" className="text-bege/70 hover:text-dourado transition-colors text-base breakdown-all">
                  receitadevovo@receitadevovo.com.br
                </a>
              </li>
            </ul>
          </div>

          {/* Coluna 4: Newsletter */}
          <div className="lg:col-span-3 space-y-6">
            <h4 className="text-lg font-heading font-semibold text-dourado uppercase tracking-wider">
              Newsletter
            </h4>
            <p className="text-base text-bege/70 leading-relaxed">
              Inscreva-se para receber novos rituais, receitas exclusivas da vovó e novidades.
            </p>
            <form onSubmit={handleSubscribe} className="space-y-3">
              <div className="relative flex items-center">
                <input 
                  type="email" 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Seu melhor e-mail" 
                  required
                  disabled={submitting}
                  className="w-full bg-bege-light/5 border border-bege/20 rounded-xl px-4 py-3 text-base text-bege-light placeholder:text-bege/40 focus:outline-none focus:border-sage focus:ring-1 focus:ring-sage transition-all pr-12 disabled:opacity-50"
                />
                <button 
                  type="submit"
                  disabled={submitting}
                  className="absolute right-2 p-2 rounded-lg bg-sage hover:bg-folha text-bege-light transition-colors duration-200 disabled:opacity-50"
                  aria-label="Enviar inscrição"
                >
                  <Send className="w-4 h-4" />
                </button>
              </div>
            </form>
          </div>

        </div>
      </div>

      {/* Linha Divisória & Copyright */}
      <div className="border-t border-bege/10 bg-marrom-dark/20 py-8">
        <div className="container mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-4 text-center md:text-left text-sm text-bege/40">
          <p>
            © {new Date().getFullYear()} Receita de Vovó. Todos os direitos reservados.
          </p>
          <p className="flex items-center gap-1">
            Feito à mão com <Heart className="w-3.5 h-3.5 text-terracota fill-terracota" /> para um autocuidado ancestral.
          </p>
        </div>
      </div>
    </footer>
  );
}
