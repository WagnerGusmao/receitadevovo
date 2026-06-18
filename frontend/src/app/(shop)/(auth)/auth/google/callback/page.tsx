"use client";

import { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import { apiFetch } from "@/services/api";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { toast, Toaster } from "sonner";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { formatWhatsApp, removeFormat, validatePhone } from "@/lib/masks";
import { Loader2, Mail, Phone } from "lucide-react";

function GoogleCallbackHandler() {
  const router = useRouter();
  const searchParams = useSearchParams();
  
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState<"processing" | "needs_whatsapp" | "error">("processing");
  const [whatsapp, setWhatsapp] = useState("");
  const [consent, setConsent] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  // Dados do Google guardados para o registro final
  const [googleData, setGoogleData] = useState({
    email: "",
    name: "",
    google_id: "",
  });

  useEffect(() => {
    const code = searchParams.get("code");
    if (!code) {
      setStatus("error");
      setErrorMsg("Código de autorização do Google ausente.");
      setLoading(false);
      return;
    }

    exchangeCode(code);
  }, [searchParams]);

  async function exchangeCode(code: string) {
    try {
      const response = await apiFetch("/auth/google/callback", {
        method: "POST",
        body: JSON.stringify({ code }),
      });

      if (response.status === "success" && response.data) {
        const { status: authStatus, user, access_token, email, name, google_id } = response.data;

        if (authStatus === "logged_in") {
          // Efetua login direto
          useAuthStore.getState().setAuth(user, access_token);
          toast.success("Login realizado com sucesso! Bem-vindo(a) de volta.");
          
          if (user.is_admin) {
            router.push("/admin");
          } else {
            router.push("/");
          }
        } else if (authStatus === "needs_whatsapp") {
          // Novo usuário, solicita WhatsApp
          setGoogleData({ email, name, google_id });
          setStatus("needs_whatsapp");
          setLoading(false);
        }
      } else {
        throw new Error(response.message || "Erro ao autenticar com o Google.");
      }
    } catch (err: any) {
      console.error(err);
      setStatus("error");
      setErrorMsg(err.message || "Erro na comunicação com o servidor.");
      setLoading(false);
    }
  }

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    const whatsappDigits = removeFormat(whatsapp);
    
    if (!validatePhone(whatsappDigits)) {
      toast.error("Por favor, insira um número de WhatsApp válido com DDD.");
      return;
    }

    if (!consent) {
      toast.error("Você deve aceitar a Política de Privacidade para continuar.");
      return;
    }

    setSubmitting(true);
    try {
      const response = await apiFetch("/auth/google/register", {
        method: "POST",
        body: JSON.stringify({
          ...googleData,
          whatsapp: whatsappDigits,
          consent: true,
        }),
      });

      if (response.status === "success" && response.data) {
        const { user, access_token } = response.data;
        useAuthStore.getState().setAuth(user, access_token);
        toast.success("Cadastro concluído! Bem-vindo(a) à comunidade.");
        router.push("/");
      } else {
        throw new Error(response.message || "Erro ao concluir cadastro.");
      }
    } catch (err: any) {
      toast.error(err.message || "Ocorreu um erro ao salvar suas informações.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-6">
      <Toaster position="top-right" richColors />

      {loading && (
        <div className="text-center space-y-4">
          <Loader2 className="w-12 h-12 text-primary animate-spin mx-auto" />
          <h2 className="text-xl font-medium text-zinc-700">Autenticando com o Google...</h2>
          <p className="text-sm text-zinc-400">Por favor, aguarde alguns instantes.</p>
        </div>
      )}

      {!loading && status === "needs_whatsapp" && (
        <Card className="w-full max-w-md border-beige shadow-lg bg-white/80 backdrop-blur animate-in fade-in duration-500">
          <CardHeader className="space-y-1">
            <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary mb-4">
              <Phone className="w-6 h-6" />
            </div>
            <CardTitle className="text-2xl font-bold font-outfit text-zinc-950">Quase lá!</CardTitle>
            <CardDescription className="text-zinc-500">
              Olá, <strong>{googleData.name}</strong>! Precisamos do seu WhatsApp para enviar atualizações de pedidos e rituais de bem-estar.
            </CardDescription>
          </CardHeader>
          <form onSubmit={handleRegister}>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="whatsapp">Número de WhatsApp</Label>
                <div className="relative">
                  <Input
                    id="whatsapp"
                    placeholder="(00) 00000-0000"
                    type="tel"
                    maxLength={15}
                    value={whatsapp}
                    onChange={(e) => setWhatsapp(formatWhatsApp(e.target.value))}
                    required
                    disabled={submitting}
                    className="border-beige h-12 bg-white/50 focus:ring-primary focus-visible:ring-primary/20"
                  />
                </div>
                <p className="text-xs text-zinc-400">
                  Garantimos que seus dados estão protegidos e não enviaremos spam.
                </p>
              </div>
              
              <div className="flex items-start space-x-2 pt-2">
                <Checkbox 
                  id="consent" 
                  checked={consent}
                  onCheckedChange={(checked) => setConsent(!!checked)}
                  disabled={submitting}
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
            </CardContent>
            <CardFooter className="pt-2 flex flex-col gap-3">
              <Button
                type="submit"
                disabled={submitting}
                className="w-full bg-primary hover:bg-olive text-white h-12 font-outfit text-base transition-all duration-300"
              >
                {submitting ? "Finalizando cadastro..." : "Concluir Cadastro"}
              </Button>
              <Button
                type="button"
                variant="ghost"
                onClick={() => router.push("/login")}
                className="text-zinc-500 hover:text-zinc-700 w-full"
              >
                Voltar
              </Button>
            </CardFooter>
          </form>
        </Card>
      )}

      {!loading && status === "error" && (
        <Card className="w-full max-w-md border-red-100 shadow-lg bg-white">
          <CardHeader className="space-y-1">
            <CardTitle className="text-xl font-bold text-red-600">Erro de Autenticação</CardTitle>
            <CardDescription className="text-zinc-500">
              Não foi possível concluir o login com o Google.
            </CardDescription>
          </CardHeader>
          <CardContent className="text-sm text-zinc-600 bg-red-50/50 p-4 rounded-lg mx-6 border border-red-100">
            {errorMsg}
          </CardContent>
          <CardFooter className="pt-6 flex justify-center">
            <Button
              onClick={() => router.push("/login")}
              className="bg-primary hover:bg-olive text-white h-11 px-8 font-outfit"
            >
              Voltar para a página de Login
            </Button>
          </CardFooter>
        </Card>
      )}
    </div>
  );
}

export default function GoogleCallbackPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-background flex items-center justify-center p-6">
        <div className="text-center space-y-4">
          <Loader2 className="w-12 h-12 text-primary animate-spin mx-auto" />
          <h2 className="text-xl font-medium text-zinc-700">Autenticando...</h2>
        </div>
      </div>
    }>
      <GoogleCallbackHandler />
    </Suspense>
  );
}
