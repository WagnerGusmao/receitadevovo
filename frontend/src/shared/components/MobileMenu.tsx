"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { X, Menu, Sparkles } from "lucide-react";
import { useAuthStore } from "@/modules/auth/store/authStore";

interface MobileMenuProps {
  links: Array<{ href: string; label: string }>;
}

export function MobileMenu({ links }: MobileMenuProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [mounted, setMounted] = useState(false);
  const pathname = usePathname();
  const { isAuthenticated } = useAuthStore();

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isOpen]);

  const closeMenu = () => setIsOpen(false);

  if (!mounted) {
    return (
      <button className="md:hidden p-2 rounded-lg opacity-0 pointer-events-none">
        <Menu className="w-6 h-6" />
      </button>
    );
  }

  return (
    <>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="md:hidden p-2 rounded-lg hover:bg-sage/10 transition-colors"
        aria-label={isOpen ? "Fechar menu" : "Abrir menu"}
      >
        {isOpen ? (
          <X className="w-6 h-6 text-terra" />
        ) : (
          <Menu className="w-6 h-6 text-terra" />
        )}
      </button>

      {isOpen && (
        <>
          <div 
            className="fixed inset-0 bg-terra/20 backdrop-blur-sm z-40 md:hidden"
            onClick={closeMenu}
            aria-hidden="true"
          />
          
          <div className="fixed top-20 md:top-24 left-0 right-0 bg-bege-light border-b border-bege shadow-lg z-50 md:hidden animate-in slide-in-from-top duration-300">
            <nav className="container mx-auto px-4 py-6 flex flex-col gap-4">
              {links.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  onClick={closeMenu}
                  className={cn(
                    "text-lg font-medium py-3 px-4 rounded-lg transition-all",
                    pathname === link.href
                      ? "bg-sage/10 text-sage border-l-4 border-sage"
                      : "text-terra/80 hover:bg-sage/5 hover:text-sage"
                  )}
                >
                  {link.label}
                </Link>
              ))}

              <div className="pt-4 border-t border-bege flex flex-col gap-3">
                {isAuthenticated ? (
                  <Button variant="outline" size="lg" asChild className="w-full">
                    <Link href="/perfil" onClick={closeMenu}>
                      Minha Conta
                    </Link>
                  </Button>
                ) : (
                  <Button variant="outline" size="lg" asChild className="w-full">
                    <Link href="/login" onClick={closeMenu}>
                      Entrar
                    </Link>
                  </Button>
                )}
                
                <Button variant="sage" size="lg" className="w-full gap-2">
                  <Sparkles className="w-5 h-5" />
                  Comunidade
                </Button>
              </div>
            </nav>
          </div>
        </>
      )}
    </>
  );
}
