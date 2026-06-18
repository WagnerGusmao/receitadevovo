"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { Logo } from "@/components/Logo";
import { Button } from "@/components/ui/button";
import { User, Sparkles } from "lucide-react";

import { CartDrawer } from "@/modules/ecommerce/components/CartDrawer";
import { MobileMenu } from "./MobileMenu";
import { useAuthStore } from "@/modules/auth/store/authStore";

const navLinks = [
  { href: "/", label: "Início" },
  { href: "/ervas", label: "Ervas" },
  { href: "/blog", label: "Sabedoria" },
  { href: "/produtos", label: "Loja" },
  { href: "/nossa-historia", label: "Nossa História" },
];

export function Navbar() {
  const pathname = usePathname();
  const { isAuthenticated, user } = useAuthStore();

  return (
    <nav className="sticky top-0 z-50 w-full border-b border-bege/60 bg-bege-light/95 backdrop-blur-lg shadow-sm transition-all duration-300">
      <div className="container mx-auto flex h-20 md:h-24 items-center justify-between gap-4 px-4 md:px-8">
        
        <Link 
          href="/" 
          className="flex items-center shrink-0 py-2 transition-transform hover:scale-105 active:scale-95"
        >
          <Logo 
            variant="horizontal" 
            size="xl"
            priority 
            className="hidden md:block"
          />
          <Logo 
            variant="badge" 
            size="xs"
            priority 
            className="block md:hidden"
          />
        </Link>

        {/* Desktop Navigation */}
        <div className="hidden md:flex items-center gap-8 lg:gap-10">
          {navLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={cn(
                "text-base font-semibold transition-colors py-2 px-1 whitespace-nowrap",
                pathname === link.href ? "text-sage border-b-2 border-sage" : "text-terra hover:text-sage"
              )}
            >
              {link.label}
            </Link>
          ))}
        </div>

        <div className="flex items-center gap-3 md:gap-4">
          <CartDrawer />
          
          {/* Mobile Menu */}
          <MobileMenu links={navLinks} />
          
          <div className="hidden md:flex items-center gap-3 md:gap-4">
            {isAuthenticated ? (
              <Link 
                href="/perfil" 
                className="group flex items-center gap-2.5 text-sm font-medium transition-all hover:scale-105"
              >
                <div className="w-9 h-9 rounded-full bg-sage/10 overflow-hidden flex items-center justify-center text-sage text-sm font-semibold border border-sage/20 group-hover:border-sage/40 group-hover:bg-sage/15 transition-all">
                  {user?.avatar_path ? (
                    <img 
                      src={user.avatar_path.startsWith("http") ? user.avatar_path : `http://localhost:8000/storage/${user.avatar_path}`} 
                      alt={user.name} 
                      className="w-full h-full object-cover" 
                    />
                  ) : (
                    <User className="w-4 h-4" />
                  )}
                </div>
                <span className="hidden lg:inline text-terra/80 group-hover:text-sage transition-colors">
                  Minha Conta
                </span>
              </Link>
            ) : (
              <Button 
                variant="ghostSage" 
                size="default" 
                asChild 
                className="hidden sm:inline-flex"
              >
                <Link href="/login">Entrar</Link>
              </Button>
            )}
            
            <Button 
              variant="sage" 
              size="default" 
              className="hidden lg:inline-flex gap-2 shadow-sm hover:shadow-md transition-all"
            >
              <Sparkles className="w-4 h-4" />
              Comunidade
            </Button>
          </div>
        </div>
      </div>
    </nav>
  );
}
