"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Label } from "@/components/ui/label"
import { toast } from "@/lib/toast"

export default function ExemplosPage() {
  const [termsAccepted, setTermsAccepted] = useState(false)
  const [notifications, setNotifications] = useState(false)
  const [deliveryMethod, setDeliveryMethod] = useState("standard")

  const handleSuccessToast = () => {
    toast.success("Ação concluída!", "Seu produto foi adicionado ao carrinho com sucesso.")
  }

  const handleErrorToast = () => {
    toast.error("Erro ao processar", "Não foi possível adicionar o produto ao carrinho. Tente novamente.")
  }

  const handleWarningToast = () => {
    toast.warning("Atenção!", "Seu estoque está acabando. Considere reabastecer.")
  }

  const handleInfoToast = () => {
    toast.info("Informação", "Você tem 3 novos pedidos para processar.")
  }

  const handlePromiseToast = () => {
    const promise = new Promise((resolve) => {
      setTimeout(() => resolve({ name: "Dados salvos" }), 2000)
    })

    toast.promise(promise, {
      loading: "Salvando dados...",
      success: "Dados salvos com sucesso!",
      error: "Erro ao salvar dados",
    })
  }

  return (
    <div className="container mx-auto px-4 py-12 max-w-4xl">
      <div className="mb-8">
        <Badge variant="sage" size="lg" className="mb-4">
          Componentes UI
        </Badge>
        <h1 className="text-4xl font-heading font-semibold text-terra mb-4">
          Exemplos de Toast/Notifications
        </h1>
        <p className="text-lg text-marrom-suave">
          Teste os diferentes tipos de notificações disponíveis no sistema.
        </p>
      </div>

      <div className="grid gap-6">
        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Toast de Sucesso</CardTitle>
            <CardDescription>
              Use para confirmar ações bem-sucedidas
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="sage" onClick={handleSuccessToast}>
              Mostrar Toast de Sucesso
            </Button>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Toast de Erro</CardTitle>
            <CardDescription>
              Use para indicar erros ou problemas
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="destructive" onClick={handleErrorToast}>
              Mostrar Toast de Erro
            </Button>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Toast de Aviso</CardTitle>
            <CardDescription>
              Use para alertas e avisos importantes
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="dourado" onClick={handleWarningToast}>
              Mostrar Toast de Aviso
            </Button>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Toast de Informação</CardTitle>
            <CardDescription>
              Use para mensagens informativas
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="outline" onClick={handleInfoToast}>
              Mostrar Toast de Info
            </Button>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Toast com Promise</CardTitle>
            <CardDescription>
              Use para operações assíncronas com feedback de loading
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="terra" onClick={handlePromiseToast}>
              Mostrar Toast com Promise
            </Button>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Checkbox</CardTitle>
            <CardDescription>
              Use para seleções múltiplas ou aceitar termos
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center space-x-2">
              <Checkbox 
                id="terms" 
                checked={termsAccepted}
                onCheckedChange={(checked) => setTermsAccepted(checked as boolean)}
              />
              <Label 
                htmlFor="terms" 
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
              >
                Aceito os termos e condições
              </Label>
            </div>

            <div className="flex items-center space-x-2">
              <Checkbox 
                id="notifications" 
                checked={notifications}
                onCheckedChange={(checked) => setNotifications(checked as boolean)}
              />
              <Label 
                htmlFor="notifications" 
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
              >
                Receber notificações por email
              </Label>
            </div>

            <div className="flex items-center space-x-2">
              <Checkbox id="disabled" disabled />
              <Label 
                htmlFor="disabled" 
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
              >
                Opção desabilitada
              </Label>
            </div>

            <div className="pt-2 text-sm text-marrom-suave">
              <p>Termos: {termsAccepted ? "✓ Aceito" : "✗ Não aceito"}</p>
              <p>Notificações: {notifications ? "✓ Ativadas" : "✗ Desativadas"}</p>
            </div>
          </CardContent>
        </Card>

        <Card variant="elevated">
          <CardHeader>
            <CardTitle>Radio Group</CardTitle>
            <CardDescription>
              Use para seleção única entre múltiplas opções
            </CardDescription>
          </CardHeader>
          <CardContent>
            <RadioGroup value={deliveryMethod} onValueChange={setDeliveryMethod}>
              <div className="space-y-3">
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="standard" id="standard" />
                  <Label htmlFor="standard" className="font-normal">
                    Entrega padrão (5-7 dias úteis) - Grátis
                  </Label>
                </div>
                
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="express" id="express" />
                  <Label htmlFor="express" className="font-normal">
                    Entrega expressa (2-3 dias úteis) - R$ 15,00
                  </Label>
                </div>
                
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="same-day" id="same-day" />
                  <Label htmlFor="same-day" className="font-normal">
                    Entrega no mesmo dia - R$ 30,00
                  </Label>
                </div>

                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="disabled" id="disabled-radio" disabled />
                  <Label htmlFor="disabled-radio" className="font-normal opacity-50">
                    Opção indisponível
                  </Label>
                </div>
              </div>
            </RadioGroup>

            <div className="mt-4 pt-4 border-t border-bege">
              <p className="text-sm text-marrom-suave">
                Método selecionado: <span className="font-semibold text-terra">{deliveryMethod}</span>
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
