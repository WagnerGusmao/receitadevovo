"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { authService } from "@/modules/auth/services/auth";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { toast, Toaster } from "sonner";
import { Eye, EyeOff } from "lucide-react";
import { apiFetch } from "@/services/api";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();

  const handleGoogleLogin = async () => {
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

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const response = await authService.login({ email, password });
      
      const { user, access_token } = response.data;
      useAuthStore.getState().setAuth(user, access_token);

      toast.success(response.message || "Bem-vindo de volta!");
      
      if (user.is_admin) {
        router.push("/admin");
      } else {
        router.push("/");
      }
    } catch (error: any) {
      toast.error(error.message || "Erro ao realizar login");
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
          src="/images/login-bg.png"
          alt="Wellness Experience"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 bg-primary/20 backdrop-blur-[2px]" />
        <div className="absolute bottom-16 left-16 text-white max-w-lg">
          <h1 className="text-5xl font-bold font-outfit mb-4">Receita de Vovó</h1>
          <p className="text-xl opacity-90 leading-relaxed font-inter">
            Redescubra o equilíbrio através da ancestralidade e do autocuidado consciente. 
            Bem-vindo ao seu ritual de bem-estar.
          </p>
        </div>
      </div>

      {/* Right Side: Login Form */}
      <div className="flex w-full items-center justify-center p-8 lg:w-1/2">
        <div className="w-full max-w-md space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-1000">
          <div className="text-center lg:hidden">
            <h1 className="text-4xl font-bold font-outfit text-primary mb-2">Receita de Vovó</h1>
          </div>
          
          <Card className="border-none shadow-none bg-transparent">
            <CardHeader className="space-y-1">
              <CardTitle className="text-3xl font-outfit text-foreground">Entrar na conta</CardTitle>
              <CardDescription className="text-base">
                Insira seu e-mail e senha para acessar o ecossistema.
              </CardDescription>
            </CardHeader>
            <CardContent className="mt-4">
              <form onSubmit={handleLogin} className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="email">E-mail</Label>
                  <Input 
                    id="email" 
                    type="email" 
                    placeholder="exemplo@vovo.com" 
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required 
                    className="bg-white/50 border-beige h-12 focus:ring-primary"
                  />
                </div>
                 <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor="password">Senha</Label>
                    <Link href="/forgot-password" className="text-xs text-primary/70 hover:underline">
                      Esqueceu a senha?
                    </Link>
                  </div>
                  <div className="relative">
                    <Input 
                      id="password" 
                      type={showPassword ? "text" : "password"} 
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required 
                      className="bg-white/50 border-beige h-12 focus:ring-primary pr-10"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600 transition-colors"
                      title={showPassword ? "Ocultar senha" : "Mostrar senha"}
                    >
                      {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                    </button>
                  </div>
                </div>
                <Button 
                  className="w-full bg-primary hover:bg-olive-green text-white h-12 text-lg font-outfit transition-all duration-300 shadow-md hover:shadow-lg" 
                  disabled={isLoading}
                >
                  {isLoading ? "Validando acesso..." : "Entrar"}
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
                  onClick={handleGoogleLogin}
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
                  Entrar com Google
                </Button>
              </form>
            </CardContent>
            <CardFooter className="flex flex-col space-y-4 text-center text-sm text-muted-foreground pt-4">
              <p>
                Ainda não faz parte da comunidade?{" "}
                <Link href="/registro" className="font-bold text-primary hover:underline">
                  Criar conta artesanal
                </Link>
              </p>
            </CardFooter>
          </Card>
        </div>
      </div>
    </div>
  );
}
