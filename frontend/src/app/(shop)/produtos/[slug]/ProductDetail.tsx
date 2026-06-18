"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { ecommerceService } from "@/modules/ecommerce/services/ecommerce";
import { useCartStore } from "@/modules/ecommerce/store/cartStore";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { ShoppingCart, ArrowLeft, Star, ShieldCheck, Leaf, Recycle, Minus, Plus } from "lucide-react";
import { toast, Toaster } from "sonner";
import { Badge } from "@/components/ui/badge";

export default function ProductDetail({ slug }: { slug: string }) {
  const router = useRouter();
  const [product, setProduct] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [quantity, setQuantity] = useState(1);
  const [activeImage, setActiveImage] = useState<string | null>(null);
  const [selectedVariant, setSelectedVariant] = useState<any>(null);
  const addItem = useCartStore((state) => state.addItem);

  useEffect(() => {
    async function loadProduct() {
      try {
        const data = await ecommerceService.getProduct(slug);
        setProduct(data.data);
        if (data.data?.featured_image) {
          setActiveImage(data.data.featured_image);
        }
        if (data.data?.variants && data.data.variants.length > 0) {
          setSelectedVariant(data.data.variants[0]);
        }
      } catch (error) {
        console.error("Error loading product", error);
        router.push("/produtos");
      } finally {
        setLoading(false);
      }
    }
    loadProduct();
  }, [slug, router]);

  const handleAddToCart = () => {
    if (!product) return;
    
    if (product.variants && product.variants.length > 0 && !selectedVariant) {
      toast.error("Por favor, selecione um tamanho.");
      return;
    }

    const itemToAdd = selectedVariant ? {
      id: selectedVariant.id,
      name: selectedVariant.name,
      price: parseFloat(selectedVariant.price),
      quantity: quantity,
      image: product.featured_image || "🌿",
      type: 'variant' as const,
      is_on_demand: product.is_on_demand,
      lead_time_days: product.lead_time_days
    } : {
      id: product.id,
      name: product.name,
      price: parseFloat(product.price),
      quantity: quantity,
      image: product.featured_image || "🌿",
      type: 'product' as const,
      is_on_demand: product.is_on_demand,
      lead_time_days: product.lead_time_days
    };

    addItem(itemToAdd);
    toast.success(`${itemToAdd.name} adicionado ao seu ritual!`);
  };

  if (loading) {
    return (
      <div className="container mx-auto px-6 py-12 lg:py-20 max-w-6xl">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20">
          <Skeleton className="aspect-square w-full rounded-3xl" />
          <div className="space-y-6">
            <Skeleton className="h-10 w-3/4" />
            <Skeleton className="h-6 w-1/4" />
            <Skeleton className="h-32 w-full" />
            <Skeleton className="h-14 w-full" />
          </div>
        </div>
      </div>
    );
  }

  if (!product) return null;

  return (
    <div className="min-h-screen bg-background pb-20">
      <Toaster position="bottom-right" richColors />
      
      {/* Product Navigation */}
      <div className="container mx-auto px-6 py-8 max-w-6xl">
        <Button 
          variant="ghost" 
          onClick={() => router.push("/produtos")}
          className="group text-muted-foreground hover:text-primary p-0 h-auto font-medium"
        >
          <ArrowLeft className="w-4 h-4 mr-2 group-hover:-translate-x-1 transition-transform" />
          Voltar para a Farmácia Natural
        </Button>
      </div>

      <div className="container mx-auto px-6 max-w-6xl">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 items-start">
          
          {/* Product Media */}
          <div className="space-y-6">
            <div className="aspect-square bg-cream/30 rounded-3xl flex items-center justify-center shadow-inner relative overflow-hidden border border-beige/20">
              {activeImage ? (
                <img 
                  src={activeImage} 
                  alt={product.name} 
                  className="w-full h-full object-cover animate-in fade-in zoom-in duration-500" 
                />
              ) : (
                <span className="text-[150px] animate-in zoom-in duration-700 select-none">🧼</span>
              )}
              <div className="absolute top-6 left-6 flex gap-2">
                <Badge className="bg-white/80 backdrop-blur text-primary border-beige/30 text-xs py-1.5 px-4 rounded-full font-bold uppercase tracking-widest">
                  Feito à Mão
                </Badge>
                {product.is_on_demand && (
                  <Badge className="bg-amber-600 text-white border-none text-xs py-1.5 px-4 rounded-full font-bold uppercase tracking-widest">
                    Sob Encomenda
                  </Badge>
                )}
              </div>
            </div>
            
            {/* Gallery Miniatures */}
            {product.all_images && product.all_images.length > 1 && (
              <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-thin">
                {product.all_images.map((img: string, idx: number) => (
                  <button
                    key={idx}
                    type="button"
                    onClick={() => setActiveImage(img)}
                    className={`relative w-20 h-20 rounded-2xl overflow-hidden border-2 transition-all flex-shrink-0 ${
                      activeImage === img ? 'border-primary shadow-md scale-95' : 'border-beige/40 opacity-70 hover:opacity-100'
                    }`}
                  >
                    <img src={img} alt={`${product.name} - ${idx + 1}`} className="w-full h-full object-cover" />
                  </button>
                ))}
              </div>
            )}
            
            <div className="grid grid-cols-3 gap-4">
              <div className="bg-white p-4 rounded-2xl border border-beige/50 text-center space-y-2">
                <Leaf className="w-6 h-6 mx-auto text-primary" />
                <p className="text-[10px] font-bold uppercase text-zinc-400">100% Vegano</p>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-beige/50 text-center space-y-2">
                <Recycle className="w-6 h-6 mx-auto text-primary" />
                <p className="text-[10px] font-bold uppercase text-zinc-400">Embalagem Eco</p>
              </div>
              <div className="bg-white p-4 rounded-2xl border border-beige/50 text-center space-y-2">
                <ShieldCheck className="w-6 h-6 mx-auto text-primary" />
                <p className="text-[10px] font-bold uppercase text-zinc-400">Puro & Ético</p>
              </div>
            </div>
          </div>

          {/* Product Info */}
          <div className="space-y-8 animate-in slide-in-from-bottom-4 duration-700">
            <div className="space-y-4">
              <div className="flex items-center gap-2 text-amber-500">
                <div className="flex">
                  {[1, 2, 3, 4, 5].map((s) => <Star key={s} className="w-4 h-4 fill-current" />)}
                </div>
                <span className="text-xs font-bold text-zinc-400 uppercase tracking-tighter">(48 avaliações)</span>
              </div>
              
              <h1 className="text-4xl lg:text-5xl font-bold font-outfit text-zinc-900 leading-tight">
                {product.name}
              </h1>
              
              <p className="text-3xl font-outfit font-bold text-primary">
                {selectedVariant ? (
                  <>
                    {selectedVariant.old_price && (
                      <span className="text-sm text-zinc-400 line-through mr-2">
                        R$ {parseFloat(selectedVariant.old_price).toFixed(2)}
                      </span>
                    )}
                    R$ {parseFloat(selectedVariant.price).toFixed(2)}
                  </>
                ) : (
                  <>
                    {product.old_price && (
                      <span className="text-sm text-zinc-400 line-through mr-2">
                        R$ {parseFloat(product.old_price).toFixed(2)}
                      </span>
                    )}
                    R$ {parseFloat(product.price).toFixed(2)}
                  </>
                )}
              </p>
            </div>

            <div className="space-y-4">
              {product.description
                .split(/\n\n+/)
                .filter((para: string) => para.trim() !== "")
                .map((para: string, i: number) => (
                  <p key={i} className="text-zinc-600 text-lg leading-relaxed font-inter">
                    {para.split(/\n/).map((line: string, j: number, arr: string[]) => (
                      <span key={j}>
                        {line}
                        {j < arr.length - 1 && <br />}
                      </span>
                    ))}
                  </p>
                ))}
            </div>

            {/* Ingredients/Tags */}
            <div className="flex flex-wrap gap-2">
              {product.herbs?.map((herb: any) => (
                <Badge key={herb.id} variant="outline" className="bg-olive/5 border-primary/20 text-primary py-1.5 px-4 rounded-full">
                  🍃 {herb.name}
                </Badge>
              ))}
            </div>

            {/* Seletor de tamanhos */}
            {product.variants && product.variants.length > 0 && (
              <div className="space-y-3 pt-6 border-t border-beige/20 animate-in fade-in duration-300">
                <p className="text-xs font-bold text-zinc-400 uppercase tracking-wider">Escolha o Tamanho</p>
                <div className="flex flex-wrap gap-2">
                  {product.variants.map((v: any) => {
                    const cleanName = v.name.replace(product.name + ' - ', '');
                    return (
                      <button
                        key={v.id}
                        type="button"
                        onClick={() => setSelectedVariant(v)}
                        className={`px-5 py-2.5 rounded-2xl border-2 font-medium text-sm font-outfit transition-all duration-200 ${
                          selectedVariant?.id === v.id
                            ? 'border-primary bg-primary text-white shadow-md scale-95'
                            : 'border-beige/40 bg-white text-zinc-600 hover:border-beige'
                        }`}
                      >
                        {cleanName} - R$ {parseFloat(v.price).toFixed(2)}
                      </button>
                    );
                  })}
                </div>
              </div>
            )}

            {product.is_on_demand && product.lead_time_days > 0 && (
              <div className="bg-amber-50/40 border border-amber-200/30 rounded-2xl p-5 flex gap-4 items-center">
                <span className="text-2xl">🕒</span>
                <div className="space-y-0.5 text-left">
                  <span className="font-bold text-amber-800 text-xs uppercase tracking-wider block font-outfit">Produção sob Encomenda</span>
                  <p className="text-xs text-amber-700 leading-relaxed font-inter">
                    Este item é preparado de forma artesanal sob demanda e estará pronto para envio em até <strong>{product.lead_time_days} {product.lead_time_days === 1 ? 'dia útil' : 'dias úteis'}</strong>.
                  </p>
                </div>
              </div>
            )}

            {/* Purchase Actions */}
            <div className="pt-8 space-y-4">
              <div className="flex items-center gap-6">
                <div className="flex items-center border-2 border-beige rounded-2xl h-14 bg-white overflow-hidden">
                  <button 
                    onClick={() => setQuantity(Math.max(1, quantity - 1))}
                    className="px-6 hover:bg-cream transition-colors border-r border-beige"
                  >
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="px-8 font-outfit font-bold text-xl">{quantity}</span>
                  <button 
                    onClick={() => setQuantity(quantity + 1)}
                    className="px-6 hover:bg-cream transition-colors border-l border-beige"
                  >
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
                
                <Button 
                  onClick={handleAddToCart}
                  className="flex-1 h-14 bg-primary hover:bg-olive text-white rounded-2xl text-lg font-outfit shadow-lg shadow-primary/20 transition-all hover:scale-[1.02] active:scale-95"
                >
                  <ShoppingCart className="w-5 h-5 mr-3" /> Adicionar ao Ritual
                </Button>
              </div>
              
              <p className="text-[10px] text-center text-muted-foreground uppercase tracking-[0.2em] pt-2">
                Entrega artesanal em todo o Brasil • Pagamento Seguro
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
