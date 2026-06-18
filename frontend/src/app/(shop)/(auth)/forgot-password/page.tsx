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
import { toast, Toaster } from "sonner";
import { ArrowLeft, Mail, KeyRound, CheckCircle2, Lock, Eye, EyeOff } from "lucide-react";

export default function ForgotPasswordPage() {
  const [step, setStep] = useState<"request" | "reset">("request");
  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [devCode, setDevCode] = useState<string | null>(null);

  const router = useRouter();

  const handleSendCode = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email) {
      toast.error("Por favor, informe seu e-mail.");
      return;
    }

    setIsLoading(true);
    setDevCode(null);
    try {
      const response = await authService.forgotPassword(email);
      if (response.status === "success") {
        toast.success(response.message || "Código enviado com sucesso!");
        
        // In development/local environment, the API returns the code in the response
        if (response.data && response.data.code) {
          setDevCode(response.data.code);
        }
        
        setStep("reset");
      } else {
        toast.error(response.message || "Erro ao solicitar código de recuperação.");
      }
    } catch (error: any) {
      toast.error(error.message || "E-mail não encontrado ou erro de conexão.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!code || code.length !== 6) {
      toast.error("O código de verificação deve conter 6 dígitos.");
      return;
    }
    if (password.length < 8) {
      toast.error("A nova senha deve conter pelo menos 8 caracteres.");
      return;
    }
    if (password !== passwordConfirmation) {
      toast.error("A confirmação de senha não confere.");
      return;
    }

    setIsLoading(true);
    try {
      const response = await authService.resetPassword({
        email,
        code,
        password,
        password_confirmation: passwordConfirmation,
      });

      if (response.status === "success") {
        toast.success("Sua senha foi redefinida com sucesso!");
        
        // Wait a brief moment to let the user see the success message
        setTimeout(() => {
          router.push("/login");
        }, 2000);
      } else {
        toast.error(response.message || "Falha ao redefinir a senha.");
      }
    } catch (error: any) {
      toast.error(error.message || "Código incorreto, expirado ou erro no servidor.");
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
          alt="Recuperação de Senha"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 bg-primary/20 backdrop-blur-[2px]" />
        <div className="absolute bottom-16 left-16 text-white max-w-lg">
          <h1 className="text-5xl font-bold font-outfit mb-4">Receita de Vovó</h1>
          <p className="text-xl opacity-90 leading-relaxed font-inter">
            Redescubra o equilíbrio através da ancestralidade e do autocuidado consciente.
            Sua conta protegida e de fácil recuperação.
          </p>
        </div>
      </div>

      {/* Right Side: Form Content */}
      <div className="flex w-full items-center justify-center p-8 lg:w-1/2">
        <div className="w-full max-w-md space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-1000">
          <div className="text-center lg:hidden">
            <h1 className="text-4xl font-bold font-outfit text-primary mb-2">Receita de Vovó</h1>
          </div>

          <Card className="border-none shadow-none bg-transparent">
            {step === "request" ? (
              <>
                <CardHeader className="space-y-1">
                  <div className="flex items-center gap-2 mb-2 text-primary">
                    <KeyRound className="w-6 h-6" />
                  </div>
                  <CardTitle className="text-3xl font-outfit text-foreground">Recuperar Senha</CardTitle>
                  <CardDescription className="text-base">
                    Insira seu e-mail cadastrado. Nós enviaremos um código de 6 dígitos para redefinir sua senha.
                  </CardDescription>
                </CardHeader>
                <CardContent className="mt-4">
                  <form onSubmit={handleSendCode} className="space-y-6">
                    <div className="space-y-2">
                      <Label htmlFor="email">E-mail de Cadastro</Label>
                      <div className="relative">
                        <Mail className="absolute left-3.5 top-3.5 h-5 w-5 text-zinc-400" />
                        <Input
                          id="email"
                          type="email"
                          placeholder="seuemail@exemplo.com"
                          value={email}
                          onChange={(e) => setEmail(e.target.value)}
                          required
                          className="bg-white/50 border-beige h-12 pl-11 focus:ring-primary"
                        />
                      </div>
                    </div>
                    <Button
                      className="w-full bg-primary hover:bg-olive-green text-white h-12 text-lg font-outfit transition-all duration-300 shadow-md hover:shadow-lg"
                      disabled={isLoading}
                    >
                      {isLoading ? "Enviando código..." : "Enviar Código"}
                    </Button>
                  </form>
                </CardContent>
                <CardFooter className="flex flex-col space-y-4 text-center text-sm text-muted-foreground pt-4">
                  <p>
                    Lembrou da senha?{" "}
                    <Link href="/login" className="font-bold text-primary hover:underline inline-flex items-center gap-1">
                      <ArrowLeft className="w-3.5 h-3.5" /> Voltar ao Login
                    </Link>
                  </p>
                </CardFooter>
              </>
            ) : (
              <>
                <CardHeader className="space-y-1">
                  <div className="flex items-center gap-2 mb-2 text-emerald-600">
                    <CheckCircle2 className="w-6 h-6" />
                  </div>
                  <CardTitle className="text-3xl font-outfit text-foreground">Redefinir Senha</CardTitle>
                  <CardDescription className="text-base">
                    Enviamos um código de verificação para <strong>{email}</strong>. Digite-o abaixo junto com sua nova senha.
                  </CardDescription>
                </CardHeader>
                <CardContent className="mt-4">
                  <form onSubmit={handleResetPassword} className="space-y-6">
                    <div className="space-y-2">
                      <Label htmlFor="code">Código de Verificação (6 dígitos)</Label>
                      <Input
                        id="code"
                        type="text"
                        placeholder="000000"
                        maxLength={6}
                        value={code}
                        onChange={(e) => setCode(e.target.value.replace(/\D/g, ""))}
                        required
                        className="bg-white/50 border-beige h-12 text-center text-2xl font-bold tracking-widest focus:ring-primary"
                      />
                      {devCode && (
                        <div className="mt-2 p-2 bg-amber-50 border border-amber-200 rounded text-amber-800 text-xs text-center">
                          <strong>Ambiente Local:</strong> Use o código <code>{devCode}</code> (também disponível no log do backend)
                        </div>
                      )}
                    </div>

                     <div className="space-y-2">
                      <Label htmlFor="password">Nova Senha (mín. 8 caracteres)</Label>
                      <div className="relative">
                        <Lock className="absolute left-3.5 top-3.5 h-5 w-5 text-zinc-400" />
                        <Input
                          id="password"
                          type={showPassword ? "text" : "password"}
                          placeholder="••••••••"
                          value={password}
                          onChange={(e) => setPassword(e.target.value)}
                          required
                          className="bg-white/50 border-beige h-12 pl-11 pr-10 focus:ring-primary"
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

                    <div className="space-y-2">
                      <Label htmlFor="password_confirmation">Confirmar Nova Senha</Label>
                      <div className="relative">
                        <Lock className="absolute left-3.5 top-3.5 h-5 w-5 text-zinc-400" />
                        <Input
                          id="password_confirmation"
                          type={showConfirmPassword ? "text" : "password"}
                          placeholder="••••••••"
                          value={passwordConfirmation}
                          onChange={(e) => setPasswordConfirmation(e.target.value)}
                          required
                          className="bg-white/50 border-beige h-12 pl-11 pr-10 focus:ring-primary"
                        />
                        <button
                          type="button"
                          onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                          className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600 transition-colors"
                          title={showConfirmPassword ? "Ocultar senha" : "Mostrar senha"}
                        >
                          {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                        </button>
                      </div>
                    </div>

                    <Button
                      className="w-full bg-primary hover:bg-olive-green text-white h-12 text-lg font-outfit transition-all duration-300 shadow-md hover:shadow-lg"
                      disabled={isLoading}
                    >
                      {isLoading ? "Salvando nova senha..." : "Redefinir Senha"}
                    </Button>
                  </form>
                </CardContent>
                <CardFooter className="flex flex-col space-y-4 text-center text-sm text-muted-foreground pt-4">
                  <button
                    type="button"
                    onClick={() => setStep("request")}
                    className="text-primary hover:underline font-bold text-xs inline-flex items-center gap-1 mx-auto"
                  >
                    Não recebeu o código? Reenviar e-mail
                  </button>
                </CardFooter>
              </>
            )}
          </Card>
        </div>
      </div>
    </div>
  );
}
