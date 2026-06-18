"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { authService } from "@/modules/auth/services/auth";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { toast, Toaster } from "sonner";
import { formatWhatsApp, removeFormat, validatePhone } from "@/lib/masks";
import { Eye, EyeOff } from "lucide-react";
import { apiFetch } from "@/services/api";

export default function RegisterPage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    whatsapp: "",
    password: "",
    password_confirmation: "",
    consent: false
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();

  const handleGoogleSignup = async () => {
    setIsLoading(true);
    try {
      const response = await apiFetch("/auth/google/redirect");
      if (response.data?.url) {
        window.location.href = response.data.url;
      } else {
        throw new Error("URL de redirecionamento inválida");
      }
    } catch (error: any) {
      toast.error(error.message || "Erro ao conectar com o Google");
      setIsLoading(false);
    }
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (formData.password !== formData.password_confirmation) {
      toast.error("As senhas não coincidem");
      return;
    }

    const whatsappDigits = removeFormat(formData.whatsapp);
    if (!validatePhone(whatsappDigits)) {
      toast.error("WhatsApp deve ter 10 ou 11 dígitos");
      return;
    }

    if (!formData.consent) {
      toast.error("Você deve aceitar a Política de Privacidade para continuar");
      return;
    }

    setIsLoading(true);
    try {
      const response = await authService.register({
        ...formData,
        whatsapp: whatsappDigits
      });
      
      const { user, access_token } = response.data;
      useAuthStore.getState().setAuth(user, access_token);

      toast.success("Bem-vindo à nossa comunidade artesanal!");
      router.push("/");
    } catch (error: any) {
      toast.error(error.message || "Erro ao realizar cadastro");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen bg-background">
      <Toaster position="top-right" richColors />
      
      {/* Left Side: Premium Image */}
      <div className="relative hidden w-1/2 lg:block">
        <Image
          src="/images/login-bg.png" // Using same premium bg
          alt="Natural Wellness"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 bg-olive/20 backdrop-blur-[2px]" />
        <div className="absolute bottom-16 left-16 text-white max-w-lg">
          <h1 className="text-5xl font-bold font-outfit mb-4">Inicie sua Jornada</h1>
          <p className="text-xl opacity-90 leading-relaxed font-inter">
            Junte-se a nós para receber sabedoria ancestral e rituais de autocuidado 
            diretamente no seu dia a dia.
          </p>
        </div>
      </div>

      {/* Right Side: Register Form */}
      <div className="flex w-full items-center justify-center p-8 lg:w-1/2">
        <div className="w-full max-w-md space-y-8 animate-in fade-in slide-in-from-right-4 duration-1000">
          <div className="text-center lg:hidden">
            <h1 className="text-4xl font-bold font-outfit text-primary mb-2">Receita de Vovó</h1>
          </div>
          
          <Card className="border-none shadow-none bg-transparent">
            <CardHeader className="space-y-1">
              <CardTitle className="text-3xl font-outfit text-foreground">Criar conta</CardTitle>
              <CardDescription className="text-base">
                Cadastre-se para começar seu ritual de bem-estar.
              </CardDescription>
            </CardHeader>
            <CardContent className="mt-4">
              <form onSubmit={handleRegister} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="name">Nome Completo</Label>
                  <Input 
                    id="name" 
                    placeholder="Seu nome" 
                    value={formData.name}
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    required 
                    className="bg-white/50 border-beige h-12"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="email">E-mail</Label>
                  <Input 
                    id="email" 
                    type="email" 
                    placeholder="exemplo@vovo.com" 
                    value={formData.email}
                    onChange={(e) => setFormData({...formData, email: e.target.value})}
                    required 
                    className="bg-white/50 border-beige h-12"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="whatsapp">WhatsApp</Label>
                  <Input 
                    id="whatsapp" 
                    type="tel" 
                    placeholder="(00) 00000-0000" 
                    value={formData.whatsapp}
                    onChange={(e) => setFormData({...formData, whatsapp: formatWhatsApp(e.target.value)})}
                    required 
                    maxLength={15}
                    className="bg-white/50 border-beige h-12"
                  />
                  <p className="text-xs text-muted-foreground">Usado para notificações de pedidos</p>
                </div>
                 <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="password">Senha</Label>
                    <div className="relative">
                      <Input 
                        id="password" 
                        type={showPassword ? "text" : "password"} 
                        value={formData.password}
                        onChange={(e) => setFormData({...formData, password: e.target.value})}
                        required 
                        className="bg-white/50 border-beige h-12 pr-10"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600 transition-colors"
                        title={showPassword ? "Ocultar senha" : "Mostrar senha"}
                      >
                        {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="password_confirmation">Confirmar</Label>
                    <div className="relative">
                      <Input 
                        id="password_confirmation" 
                        type={showConfirmPassword ? "text" : "password"} 
                        value={formData.password_confirmation}
                        onChange={(e) => setFormData({...formData, password_confirmation: e.target.value})}
                        required 
                        className="bg-white/50 border-beige h-12 pr-10"
                      />
                      <button
                        type="button"
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600 transition-colors"
                        title={showConfirmPassword ? "Ocultar senha" : "Mostrar senha"}
                      >
                        {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>
                </div>
                <div className="flex items-start space-x-2 my-4">
                  <Checkbox 
                    id="consent" 
                    checked={formData.consent}
                    onCheckedChange={(checked) => setFormData({...formData, consent: !!checked})}
                    className="mt-0.5 border-zinc-300 data-[state=checked]:bg-primary data-[state=checked]:border-primary"
                  />
                  <Label htmlFor="consent" className="text-sm font-normal leading-snug cursor-pointer select-none text-zinc-600">
                    Li e concordo com os{" "}
                    <Link href="/termos" target="_blank" className="font-semibold text-primary hover:underline">
                      Termos de Uso
                    </Link>
                    {" "}e a{" "}
                    <Link href="/politica-de-privacidade" target="_blank" className="font-semibold text-primary hover:underline">
                      Política de Privacidade
                    </Link>
                    .
                  </Label>
                </div>
                <Button 
                  className="w-full bg-primary hover:bg-olive-green text-white h-12 text-lg font-outfit mt-6 transition-all" 
                  disabled={isLoading}
                >
                  {isLoading ? "Processando..." : "Criar Minha Conta"}
                </Button>

                <div className="relative my-4">
                  <div className="absolute inset-0 flex items-center">
                    <div className="w-full border-t border-zinc-200"></div>
                  </div>
                  <div className="relative flex justify-center text-xs uppercase">
                    <span className="bg-white px-2 text-muted-foreground">ou continuar com</span>
                  </div>
                </div>

                <Button
                  type="button"
                  variant="outline"
                  onClick={handleGoogleSignup}
                  className="w-full border-zinc-200 text-zinc-700 hover:bg-zinc-50 h-12 flex items-center justify-center gap-3 font-outfit"
                  disabled={isLoading}
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24">
                    <path
                      fill="#EA4335"
                      d="M5.266 9.765A7.077 7.077 0 0 1 12 4.909c1.69 0 3.218.6 4.418 1.582l3.51-3.51C17.745 1.055 14.99 0 12 0 7.354 0 3.307 2.67 1.242 6.574l4.024 3.191z"
                    />
                    <path
                      fill="#4285F4"
                      d="M16.04 15.34c-1.07.727-2.43 1.168-4.04 1.168a7.07 7.07 0 0 1-6.734-4.856L1.242 14.84C3.307 18.746 7.354 21.417 12 21.417c2.99 0 5.745-1.055 7.927-2.927l-3.886-3.15z"
                    />
                    <path
                      fill="#34A853"
                      d="M12 21.417c4.646 0 8.693-2.67 10.758-6.574l-4.024-3.191a7.077 7.077 0 0 1-6.734 4.856c-1.61 0-2.97-.44-4.04-1.168l-3.886 3.15c2.182 1.872 4.937 2.927 7.927 2.927z"
                    />
                    <path
                      fill="#FBBC05"
                      d="M23.242 12c0-.682-.064-1.341-.182-1.977H12v3.745h6.3c-.272 1.436-1.08 2.65-2.26 3.44l3.886 3.15C22.187 18.49 23.242 15.5 23.242 12z"
                    />
                  </svg>
                  Criar conta com Google
                </Button>
              </form>
            </CardContent>
            <CardFooter className="flex flex-col space-y-4 text-center text-sm text-muted-foreground pt-4">
              <p>
                Já faz parte da nossa história?{" "}
                <Link href="/login" className="font-bold text-primary hover:underline">
                  Entrar na conta
                </Link>
              </p>
            </CardFooter>
          </Card>
        </div>
      </div>
    </div>
  );
}
