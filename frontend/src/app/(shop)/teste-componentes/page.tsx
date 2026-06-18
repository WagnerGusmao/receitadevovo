"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { Checkbox } from "@/components/ui/checkbox"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { toast } from "@/lib/toast"
import { Sparkles, Leaf, Heart, Package } from "lucide-react"

export default function TesteComponentesPage() {
  const [formData, setFormData] = useState({
    nome: "",
    email: "",
    categoria: "",
    descricao: "",
    entrega: "standard",
    termos: false,
    newsletter: false,
  })

  const [errors, setErrors] = useState<Record<string, string>>({})
  const [isSubmitting, setIsSubmitting] = useState(false)

  const validateForm = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.nome.trim()) {
      newErrors.nome = "Nome é obrigatório"
    }

    if (!formData.email.trim()) {
      newErrors.email = "Email é obrigatório"
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Email inválido"
    }

    if (!formData.categoria) {
      newErrors.categoria = "Selecione uma categoria"
    }

    if (!formData.termos) {
      newErrors.termos = "Você deve aceitar os termos"
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!validateForm()) {
      toast.error("Erro de validação", "Por favor, corrija os erros no formulário.")
      return
    }

    setIsSubmitting(true)

    const promise = new Promise((resolve) => {
      setTimeout(() => {
        resolve({ success: true })
      }, 2000)
    })

    toast.promise(promise, {
      loading: "Enviando formulário...",
      success: "Formulário enviado com sucesso!",
      error: "Erro ao enviar formulário",
    })

    await promise

    setIsSubmitting(false)
    
    console.log("Dados do formulário:", formData)
  }

  const handleReset = () => {
    setFormData({
      nome: "",
      email: "",
      categoria: "",
      descricao: "",
      entrega: "standard",
      termos: false,
      newsletter: false,
    })
    setErrors({})
    toast.info("Formulário limpo", "Todos os campos foram resetados.")
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-bege-light via-background to-bege-light py-12">
      <div className="container mx-auto px-4 max-w-5xl">
        <div className="mb-8 text-center">
          <Badge variant="sage" size="lg" className="mb-4">
            Teste de Componentes UI
          </Badge>
          <h1 className="text-4xl font-heading font-semibold text-terra mb-4">
            Sistema de Design - Receita de Vovó
          </h1>
          <p className="text-lg text-marrom-suave max-w-2xl mx-auto">
            Teste interativo de todos os componentes UI implementados com a paleta oficial.
          </p>
        </div>

        <div className="grid lg:grid-cols-3 gap-6 mb-8">
          <Card variant="elevated" className="text-center">
            <CardContent className="pt-6">
              <div className="w-12 h-12 mx-auto mb-3 rounded-full bg-sage/10 flex items-center justify-center">
                <Package className="w-6 h-6 text-sage" />
              </div>
              <h3 className="font-semibold text-terra mb-1">14 Componentes</h3>
              <p className="text-sm text-marrom-suave">Prontos para produção</p>
            </CardContent>
          </Card>

          <Card variant="elevated" className="text-center">
            <CardContent className="pt-6">
              <div className="w-12 h-12 mx-auto mb-3 rounded-full bg-dourado/10 flex items-center justify-center">
                <Sparkles className="w-6 h-6 text-dourado" />
              </div>
              <h3 className="font-semibold text-terra mb-1">100% Acessível</h3>
              <p className="text-sm text-marrom-suave">Radix UI + ARIA</p>
            </CardContent>
          </Card>

          <Card variant="elevated" className="text-center">
            <CardContent className="pt-6">
              <div className="w-12 h-12 mx-auto mb-3 rounded-full bg-success/10 flex items-center justify-center">
                <Heart className="w-6 h-6 text-success" />
              </div>
              <h3 className="font-semibold text-terra mb-1">Design System</h3>
              <p className="text-sm text-marrom-suave">Paleta consistente</p>
            </CardContent>
          </Card>
        </div>

        <Card variant="elevated" size="lg">
          <CardHeader>
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-sage/10 flex items-center justify-center">
                <Leaf className="w-5 h-5 text-sage" />
              </div>
              <div>
                <CardTitle className="text-2xl">Formulário Completo</CardTitle>
                <CardDescription>
                  Teste todos os componentes em ação
                </CardDescription>
              </div>
            </div>
          </CardHeader>

          <form onSubmit={handleSubmit}>
            <CardContent className="space-y-6">
              <div className="grid md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <Label htmlFor="nome" required>
                    Nome Completo
                  </Label>
                  <Input
                    id="nome"
                    placeholder="Digite seu nome"
                    value={formData.nome}
                    onChange={(e) => setFormData({ ...formData, nome: e.target.value })}
                    error={!!errors.nome}
                  />
                  {errors.nome && (
                    <p className="text-sm text-error">{errors.nome}</p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="email" required>
                    Email
                  </Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="seu@email.com"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    error={!!errors.email}
                  />
                  {errors.email && (
                    <p className="text-sm text-error">{errors.email}</p>
                  )}
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="categoria" required>
                  Categoria de Interesse
                </Label>
                <Select
                  value={formData.categoria}
                  onValueChange={(value) => setFormData({ ...formData, categoria: value })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione uma categoria" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="chas">Chás Medicinais</SelectItem>
                    <SelectItem value="oleos">Óleos Essenciais</SelectItem>
                    <SelectItem value="kits">Kits de Autocuidado</SelectItem>
                    <SelectItem value="sabedoria">Sabedoria & Blog</SelectItem>
                  </SelectContent>
                </Select>
                {errors.categoria && (
                  <p className="text-sm text-error">{errors.categoria}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="descricao">
                  Mensagem
                </Label>
                <Textarea
                  id="descricao"
                  placeholder="Conte-nos mais sobre seu interesse..."
                  rows={4}
                  value={formData.descricao}
                  onChange={(e) => setFormData({ ...formData, descricao: e.target.value })}
                />
              </div>

              <div className="space-y-3">
                <Label>Método de Entrega</Label>
                <RadioGroup
                  value={formData.entrega}
                  onValueChange={(value) => setFormData({ ...formData, entrega: value })}
                >
                  <div className="space-y-3">
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="standard" id="standard" />
                      <Label htmlFor="standard" className="font-normal">
                        Entrega Padrão (5-7 dias úteis) - Grátis
                      </Label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="express" id="express" />
                      <Label htmlFor="express" className="font-normal">
                        Entrega Expressa (2-3 dias úteis) - R$ 15,00
                      </Label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="same-day" id="same-day" />
                      <Label htmlFor="same-day" className="font-normal">
                        Entrega no Mesmo Dia - R$ 30,00
                      </Label>
                    </div>
                  </div>
                </RadioGroup>
              </div>

              <div className="space-y-3 border-t border-bege pt-4">
                <div className="flex items-start space-x-2">
                  <Checkbox
                    id="termos"
                    checked={formData.termos}
                    onCheckedChange={(checked) =>
                      setFormData({ ...formData, termos: checked as boolean })
                    }
                  />
                  <div className="grid gap-1.5 leading-none">
                    <Label
                      htmlFor="termos"
                      className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                    >
                      Aceito os termos e condições *
                    </Label>
                    <p className="text-sm text-marrom-suave">
                      Concordo com os{" "}
                      <Dialog>
                        <DialogTrigger asChild>
                          <button className="text-sage hover:underline">
                            termos de uso
                          </button>
                        </DialogTrigger>
                        <DialogContent>
                          <DialogHeader>
                            <DialogTitle>Termos de Uso</DialogTitle>
                            <DialogDescription>
                              Leia nossos termos e condições de uso.
                            </DialogDescription>
                          </DialogHeader>
                          <div className="space-y-4 text-sm text-marrom-suave">
                            <p>
                              Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                              Praesent commodo cursus magna, vel scelerisque nisl
                              consectetur et.
                            </p>
                            <p>
                              Sed posuere consectetur est at lobortis. Donec sed odio
                              dui. Nullam quis risus eget urna mollis ornare vel eu leo.
                            </p>
                          </div>
                          <DialogFooter>
                            <Button variant="sage">Entendi</Button>
                          </DialogFooter>
                        </DialogContent>
                      </Dialog>
                    </p>
                    {errors.termos && (
                      <p className="text-sm text-error">{errors.termos}</p>
                    )}
                  </div>
                </div>

                <div className="flex items-center space-x-2">
                  <Checkbox
                    id="newsletter"
                    checked={formData.newsletter}
                    onCheckedChange={(checked) =>
                      setFormData({ ...formData, newsletter: checked as boolean })
                    }
                  />
                  <Label
                    htmlFor="newsletter"
                    className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                  >
                    Quero receber novidades e ofertas por email
                  </Label>
                </div>
              </div>
            </CardContent>

            <CardFooter className="flex gap-3">
              <Button
                type="button"
                variant="outline"
                className="flex-1"
                onClick={handleReset}
                disabled={isSubmitting}
              >
                Limpar
              </Button>
              <Button
                type="submit"
                variant="sage"
                className="flex-1 gap-2"
                disabled={isSubmitting}
              >
                <Sparkles className="w-4 h-4" />
                Enviar Formulário
              </Button>
            </CardFooter>
          </form>
        </Card>

        <div className="mt-8 grid md:grid-cols-3 gap-4">
          <Button variant="sage" className="w-full" onClick={() => toast.success("Sucesso!", "Ação realizada com sucesso")}>
            Toast Sucesso
          </Button>
          <Button variant="destructive" className="w-full" onClick={() => toast.error("Erro!", "Algo deu errado")}>
            Toast Erro
          </Button>
          <Button variant="dourado" className="w-full" onClick={() => toast.warning("Aviso!", "Atenção necessária")}>
            Toast Aviso
          </Button>
        </div>
      </div>
    </div>
  )
}
