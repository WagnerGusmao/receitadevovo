"use client";

import { useEffect, useState, useMemo } from "react";
import Link from "next/link";
import { ecommerceService } from "@/modules/ecommerce/services/ecommerce";
import { useCartStore } from "@/modules/ecommerce/store/cartStore";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { Input } from "@/components/ui/input";
import { ShoppingCart, Star, Package, Search, FilterX, Eye, Lock, Sparkles } from "lucide-react";
import { toast, Toaster } from "sonner";
import { Badge } from "@/components/ui/badge";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { apiFetch } from "@/services/api";

export default function ProductsPage() {
  const [products, setProducts] = useState<any[]>([]);
  const [kits, setKits] = useState<any[]>([]);
  const [offers, setOffers] = useState<any[]>([]);
  const [apiCategories, setApiCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<number | null>(null);
  
  const { isAuthenticated } = useAuthStore();
  const addItem = useCartStore((state) => state.addItem);

  useEffect(() => {
    async function loadData() {
      try {
        const [prodData, catsData, offersData] = await Promise.all([
          ecommerceService.getProducts(),
          apiFetch("/ecommerce/categories"),
          isAuthenticated ? apiFetch("/rewards/offers") : Promise.resolve({ success: false, data: [] })
        ]);
        
        setProducts(prodData.data.products);
        setKits(prodData.data.kits);
        setApiCategories(catsData.data || []);
        if (offersData.success) {
          setOffers(offersData.data);
        }
      } catch (error) {
        console.error("Error loading products", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, [isAuthenticated]);

  const filteredProducts = useMemo(() => {
    return products.filter(p => {
      const matchesSearch = p.name.toLowerCase().includes(search.toLowerCase()) || 
                            p.description.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = selectedCategory === null || p.category?.id === selectedCategory;
      return matchesSearch && matchesCategory;
    });
  }, [products, search, selectedCategory]);

  const activeCategories = useMemo(() => {
    return apiCategories.filter(cat => 
      cat.slug !== 'embalagens-e-presentes' && products.some(p => p.category?.id === cat.id)
    );
  }, [apiCategories, products]);

  const handleAddToCart = (item: any, type: 'product' | 'kit' = 'product') => {
    let finalPrice = parseFloat(item.price);
    
    if (type === 'product') {
      const offer = offers.find(o => o.product.id === item.id);
      if (offer && offer.is_unlocked) {
        finalPrice = parseFloat(offer.special_price);
      }
    }

    addItem({
      id: item.id,
      name: item.name,
      price: finalPrice,
      quantity: 1,
      image: item.featured_image || (type === 'kit' ? '📦' : '🌿'),
      type: type,
      is_on_demand: item.is_on_demand,
      lead_time_days: item.lead_time_days
    });
    toast.success(`${item.name} adicionado ao carrinho!`, {
      icon: <ShoppingCart className="w-4 h-4" />,
    });
  };

  return (
    <div className="min-h-screen bg-background pb-20">
      <Toaster position="bottom-right" richColors />
      
      {/* Search & Filter Header */}
      <div className="bg-cream/30 border-b border-beige/20 py-12 px-8 mb-12">
        <div className="container mx-auto max-w-6xl space-y-8">
          <div className="max-w-2xl mx-auto text-center space-y-4">
            <h1 className="text-4xl font-bold font-outfit">Nossa Farmácia Natural</h1>
            <p className="text-zinc-500 font-inter">Explore rituais ancestrais e produtos feitos à mão com intenção.</p>
          </div>
          
          <div className="flex flex-col md:flex-row gap-6 items-center justify-between">
            <div className="relative w-full md:max-w-md">
              <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-zinc-400" />
              <Input 
                className="pl-12 h-14 rounded-full border-beige bg-white shadow-sm focus:ring-primary"
                placeholder="O que você busca hoje? (ex: lavanda, sabonete)"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
            
            <div className="flex gap-2 overflow-x-auto pb-2 w-full md:w-auto no-scrollbar">
              <button
                onClick={() => setSelectedCategory(null)}
                className={`px-6 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                  selectedCategory === null
                  ? 'bg-primary text-white shadow-md' 
                  : 'bg-white text-zinc-500 border border-beige/50 hover:bg-beige/10'
                }`}
              >
                Todos
              </button>
              {activeCategories.map((cat: any) => (
                <button
                  key={cat.id}
                  onClick={() => setSelectedCategory(cat.id)}
                  className={`px-6 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                    selectedCategory === cat.id
                    ? 'bg-primary text-white shadow-md' 
                    : 'bg-white text-zinc-500 border border-beige/50 hover:bg-beige/10'
                  }`}
                >
                  {cat.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto max-w-6xl px-8 space-y-20">
        
        {/* Kits Section - Only show if no filter/search is active or if search matches kit name */}
        {selectedCategory === null && kits.length > 0 && search === "" && (
          <div className="space-y-8 animate-in fade-in duration-700">
            <div className="flex items-center gap-3">
              <Star className="w-6 h-6 text-primary fill-primary" />
              <h2 className="text-3xl font-bold font-outfit text-foreground">Kits Especiais</h2>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {kits.map((kit) => (
                <Card key={kit.id} className="border-primary/10 bg-primary/[0.02] overflow-hidden flex flex-col md:flex-row hover:shadow-lg transition-all border-dashed border-2">
                  <div className="w-full md:w-1/3 bg-primary/5 flex items-center justify-center min-h-[200px] relative overflow-hidden">
                    {kit.featured_image ? (
                      <img 
                        src={kit.featured_image} 
                        alt={kit.name} 
                        className="w-full h-full object-cover" 
                      />
                    ) : (
                      <Package className="w-20 h-20 text-primary opacity-10" />
                    )}
                  </div>
                  <div className="p-8 space-y-4 flex-1">
                    <div className="flex justify-between items-start">
                      <CardTitle className="text-2xl font-outfit text-primary">{kit.name}</CardTitle>
                      <div className="flex gap-2">
                        {kit.is_on_demand && (
                          <Badge className="bg-amber-600 text-white border-none">Sob Encomenda</Badge>
                        )}
                        <Badge className="bg-primary/20 text-primary border-none">Kit</Badge>
                      </div>
                    </div>
                    <CardDescription className="font-inter text-zinc-600">{kit.description}</CardDescription>
                    <div className="flex flex-col">
                      <div className="text-3xl font-bold text-primary font-outfit">
                        R$ {parseFloat(kit.price).toFixed(2)}
                      </div>
                      {kit.is_on_demand && kit.lead_time_days > 0 && (
                        <span className="text-xs text-amber-700 font-medium mt-1">
                          🕒 Produção sob encomenda: {kit.lead_time_days} {kit.lead_time_days === 1 ? 'dia útil' : 'dias úteis'}
                        </span>
                      )}
                    </div>
                    <Button 
                      className="w-full bg-primary hover:bg-olive text-white h-12 rounded-full shadow-md hover:shadow-lg transition-all"
                      onClick={() => handleAddToCart(kit, 'kit')}
                    >
                      Adicionar Kit
                    </Button>
                  </div>
                </Card>
              ))}
            </div>
          </div>
        )}

        {/* Individual Products Section */}
        <div className="space-y-8">
          <div className="flex items-center gap-3">
            <Package className="w-6 h-6 text-primary" />
            <h2 className="text-3xl font-bold font-outfit text-foreground">
              {selectedCategory !== null
                ? `${apiCategories.find((c: any) => c.id === selectedCategory)?.name || ''}`
                : 'Todos os Produtos'}
            </h2>
          </div>
          
          {filteredProducts.length === 0 ? (
            <div className="py-20 text-center space-y-6 bg-zinc-50 rounded-3xl border-2 border-dashed border-zinc-200">
              <div className="w-20 h-20 bg-zinc-100 rounded-full flex items-center justify-center mx-auto text-zinc-400">
                <FilterX className="w-10 h-10" />
              </div>
              <div className="space-y-2">
                <h3 className="text-xl font-bold font-outfit">Nenhum ritual encontrado</h3>
                <p className="text-zinc-500">Tente ajustar sua busca ou categoria.</p>
              </div>
              <Button variant="outline" onClick={() => { setSearch(""); setSelectedCategory(null); }}>
                Limpar Filtros
              </Button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {loading ? (
                Array.from({ length: 6 }).map((_, i) => (
                  <Card key={i} className="border-beige/50 overflow-hidden">
                    <Skeleton className="h-56 w-full" />
                    <div className="p-6 space-y-4">
                      <Skeleton className="h-6 w-3/4" />
                      <Skeleton className="h-4 w-full" />
                      <Skeleton className="h-8 w-1/3" />
                    </div>
                  </Card>
                ))
              ) : filteredProducts.map((product) => (
                <Card key={product.id} className="border-beige/50 hover:shadow-2xl transition-all duration-500 bg-white group rounded-3xl overflow-hidden border-none shadow-sm">
                  <Link href={`/produtos/${product.slug}`}>
                    <div className="h-56 bg-cream/30 relative overflow-hidden flex items-center justify-center cursor-pointer">
                      {product.featured_image ? (
                        <img 
                          src={product.featured_image} 
                          alt={product.name} 
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700 animate-in fade-in duration-500" 
                        />
                      ) : (
                        <span className="text-8xl opacity-10 group-hover:scale-110 transition-transform duration-700 select-none">
                          🌿
                        </span>
                      )}
                      <div className="absolute top-4 left-4 flex flex-wrap gap-2">
                        {product.category && (
                          <Badge className="bg-white/80 backdrop-blur text-primary border-beige/20 text-[10px] uppercase tracking-widest font-bold">
                            {product.category.name}
                          </Badge>
                        )}
                        {product.is_on_demand && (
                          <Badge className="bg-amber-600 text-white border-none text-[10px] uppercase tracking-widest font-bold">
                            Sob Encomenda
                          </Badge>
                        )}
                      </div>
                    </div>
                  </Link>
                  <CardHeader className="pb-2">
                    <Link href={`/produtos/${product.slug}`}>
                      <CardTitle className="font-outfit text-2xl text-zinc-900 group-hover:text-primary transition-colors cursor-pointer">
                        {product.name}
                      </CardTitle>
                    </Link>
                    <CardDescription className="line-clamp-2 font-inter leading-relaxed">{product.description}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    {(() => {
                      const offer = offers.find(o => o.product.id === product.id);
                      if (offer) {
                        return (
                          <div className="space-y-1">
                            <div className="flex items-center gap-1 text-xs font-bold text-zinc-400">
                              <span>De R$ {parseFloat(product.price).toFixed(2)} por:</span>
                            </div>
                            <div className="text-3xl font-black text-sage font-outfit flex items-baseline gap-1.5">
                              R$ {parseFloat(offer.special_price).toFixed(2)}
                              <span className="text-[10px] text-zinc-400 font-normal">
                                {offer.is_unlocked ? "✓ Seu Nível" : `🔒 Nível ${offer.level.name}`}
                              </span>
                            </div>
                          </div>
                        );
                      }
                      return (
                        <div className="flex flex-col">
                          {product.old_price && (
                            <span className="text-sm text-zinc-400 line-through">
                              R$ {parseFloat(product.old_price).toFixed(2)}
                            </span>
                          )}
                          <div className="text-3xl font-bold text-primary font-outfit">
                            R$ {parseFloat(product.price).toFixed(2)}
                          </div>
                          {product.is_on_demand && product.lead_time_days > 0 && (
                            <span className="text-[11px] text-amber-700 font-semibold mt-1">
                              🕒 Envio em até {product.lead_time_days} {product.lead_time_days === 1 ? 'dia útil' : 'dias úteis'}
                            </span>
                          )}
                        </div>
                      );
                    })()}
                  </CardContent>
                  <CardFooter className="pt-0 flex gap-2">
                    <Link href={`/produtos/${product.slug}`} className="flex-1">
                      <Button 
                        variant="outline"
                        className="w-full border-primary/20 text-primary hover:bg-primary/5 h-12 rounded-2xl transition-all duration-300"
                      >
                        <Eye className="w-4 h-4 mr-2" /> Ver Detalhes
                      </Button>
                    </Link>
                    <Button 
                      className="flex-1 bg-zinc-900 hover:bg-primary text-white h-12 rounded-2xl transition-all duration-300 shadow-lg shadow-zinc-200 hover:shadow-primary/20"
                      onClick={() => handleAddToCart(product, 'product')}
                    >
                      <ShoppingCart className="w-4 h-4 mr-2" /> Adicionar
                    </Button>
                  </CardFooter>
                </Card>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
