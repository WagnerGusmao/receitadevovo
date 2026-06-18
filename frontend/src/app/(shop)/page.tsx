"use client";

import { useEffect, useState, useCallback } from "react";
import { apiFetch } from "@/services/api";
import { Hero } from "@/components/Hero";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  Sparkles, Leaf, Heart, ChevronLeft, ChevronRight, 
  ArrowRight, BookOpen, ShoppingBag, Calendar, Star, ShieldCheck
} from "lucide-react";
import Link from "next/link";

interface Banner {
  id: number;
  title: string | null;
  subtitle: string | null;
  description: string | null;
  image_desktop: string;
  image_mobile: string | null;
  image_fit: string;
  image_position: string;
  button_text: string | null;
  button_url: string | null;
  page_target: string;
  is_active: boolean;
  sort_order: number;
}

interface Review {
  id: number;
  rating: number;
  comment: string | null;
  is_verified_purchase: boolean;
  user?: {
    id: number;
    name: string;
    avatar_path: string | null;
  };
  product?: {
    id: number;
    name: string;
    slug: string;
    price: string;
    featured_image: string | null;
  };
  created_at: string;
}

interface Post {
  id: number;
  title: string;
  slug: string;
  excerpt: string;
  featured_image: string | null;
  created_at: string;
  user?: { name: string };
  category?: { name: string };
  product?: {
    id: number;
    name: string;
    slug: string;
    price: string;
    featured_image: string | null;
  };
}

export default function Home() {
  const [banners, setBanners] = useState<Banner[]>([]);
  const [posts, setPosts] = useState<Post[]>([]);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [currentSlide, setCurrentSlide] = useState(0);
  const [loading, setLoading] = useState(true);

  // Load active banners, featured posts and reviews
  useEffect(() => {
    async function loadData() {
      try {
        const [bannersRes, postsRes, reviewsRes] = await Promise.all([
          apiFetch("/content/banners/active?page_target=home"),
          apiFetch("/content/posts/home"),
          apiFetch("/ecommerce/reviews/home"),
        ]);
        setBanners(bannersRes.data || []);
        setPosts(postsRes.data || []);
        setReviews(reviewsRes.data || []);
      } catch (error) {
        console.error("Erro ao carregar dados da Home", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  // Slide Auto-advance (every 5 seconds)
  useEffect(() => {
    if (banners.length <= 1) return;
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % banners.length);
    }, 5000);
    return () => clearInterval(timer);
  }, [banners]);

  const handlePrevSlide = useCallback(() => {
    if (banners.length === 0) return;
    setCurrentSlide((prev) => (prev - 1 + banners.length) % banners.length);
  }, [banners]);

  const handleNextSlide = useCallback(() => {
    if (banners.length === 0) return;
    setCurrentSlide((prev) => (prev + 1) % banners.length);
  }, [banners]);

  return (
    <div className="min-h-screen bg-gradient-to-b from-bege-light via-background to-bege-light">
      
      {/* ── SEÇÃO HERO / CARROSSEL ────────────────────────── */}
      {loading ? (
        <div className="min-h-[500px] flex items-center justify-center bg-bege-light/30">
          <div className="text-center space-y-3">
            <div className="w-10 h-10 border-4 border-sage border-t-transparent rounded-full animate-spin mx-auto" />
            <p className="text-sm text-marrom-suave font-medium">Nutrindo sua experiência natural...</p>
          </div>
        </div>
      ) : banners.length > 0 ? (
        <section className="relative w-full h-[540px] md:h-[600px] overflow-hidden group bg-creme">
          {/* Slides Container */}
          <div className="relative w-full h-full">
            {banners.map((banner, index) => {
              const isActive = index === currentSlide;
              return (
                <div
                  key={banner.id}
                  className={`absolute inset-0 w-full h-full transition-all duration-700 ease-in-out flex flex-col md:block
                    ${isActive ? "opacity-100 scale-100 z-10" : "opacity-0 scale-95 z-0 pointer-events-none"}`}
                >
                  {/* Background Image Container */}
                  <div className="relative w-full h-[240px] md:h-full md:absolute md:inset-0 overflow-hidden shrink-0">
                    {/* Blurred background (sits behind contain mode empty areas) */}
                    {banner.image_fit === 'contain' && (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={banner.image_desktop}
                        alt=""
                        className="absolute inset-0 w-full h-full object-cover blur-2xl opacity-40 scale-110"
                      />
                    )}
                    
                    <picture className="absolute inset-0 w-full h-full">
                      {banner.image_mobile && (
                        <source media="(max-width: 768px)" srcSet={banner.image_mobile} />
                      )}
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img
                        src={banner.image_desktop}
                        alt={banner.title || "Banner Receita de Vovó"}
                        className={`w-full h-full transition-all duration-300
                          ${banner.image_fit === 'contain' ? 'object-contain' : 'object-cover'}
                          ${
                            banner.image_position === 'top' ? 'object-top' :
                            banner.image_position === 'bottom' ? 'object-bottom' :
                            banner.image_position === 'left' ? 'object-left' :
                            banner.image_position === 'right' ? 'object-right' :
                            'object-center'
                          }`}
                      />
                    </picture>
                  </div>

                  {/* Dark overlay for readability */}
                  <div className="hidden md:block absolute inset-0 bg-black/10" />

                  {/* Glassmorphic Info Panel */}
                  <div className="relative flex-1 flex items-center justify-center p-4 md:p-8 md:absolute md:inset-y-0 md:left-12 lg:md:left-24 md:w-auto md:justify-start z-20 bg-[#f7f4ec] md:bg-transparent">
                    <div className="bg-transparent md:backdrop-blur-md md:bg-white/75 border-none md:border md:border-bege/40 p-2 md:p-8 rounded-2xl md:shadow-2xl max-w-md text-center md:text-left space-y-3 md:space-y-4 transition-transform duration-500 delay-100 transform translate-y-0">
                      {banner.subtitle && (
                        <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-sage uppercase tracking-wider">
                          <Sparkles className="w-3.5 h-3.5" /> {banner.subtitle}
                        </span>
                      )}
                      
                      {banner.title && (
                        <h1 className="text-xl md:text-4xl font-heading font-bold text-terra leading-tight">
                          {banner.title}
                        </h1>
                      )}

                      {banner.description && (
                        <p className="text-xs md:text-base text-marrom-suave leading-relaxed line-clamp-2 md:line-clamp-none">
                          {banner.description}
                        </p>
                      )}

                      {banner.button_text && banner.button_url && (
                        <div className="pt-1 md:pt-2">
                          <Button 
                            variant="sage" 
                            size="default"
                            className="bg-[#7c6f45] hover:bg-[#635837] text-white shadow-md font-medium px-6 py-2 h-auto text-sm md:text-base md:px-8 md:py-3"
                            asChild
                          >
                            <a href={banner.button_url}>{banner.button_text}</a>
                          </Button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          {/* Navigation Arrows */}
          {banners.length > 1 && (
            <>
              <button
                onClick={handlePrevSlide}
                className="absolute left-4 top-[120px] md:top-1/2 -translate-y-1/2 z-20 p-2 rounded-full bg-white/40 hover:bg-white/80 text-terra transition-all shadow-md group-hover:opacity-100 opacity-0 md:opacity-0"
                title="Slide anterior"
              >
                <ChevronLeft className="w-4 h-4 md:w-5 md:h-5" />
              </button>
              <button
                onClick={handleNextSlide}
                className="absolute right-4 top-[120px] md:top-1/2 -translate-y-1/2 z-20 p-2 rounded-full bg-white/40 hover:bg-white/80 text-terra transition-all shadow-md group-hover:opacity-100 opacity-0 md:opacity-0"
                title="Próximo slide"
              >
                <ChevronRight className="w-4 h-4 md:w-5 md:h-5" />
              </button>

              {/* Dots Indicators */}
              <div className="absolute bottom-4 md:bottom-6 left-1/2 -translate-x-1/2 flex gap-2 z-20">
                {banners.map((_, index) => (
                  <button
                    key={index}
                    onClick={() => setCurrentSlide(index)}
                    className={`h-2 rounded-full transition-all duration-300
                      ${index === currentSlide ? "w-5 bg-[#7c6f45]" : "w-2 bg-zinc-300 hover:bg-zinc-400 md:bg-white/60 md:hover:bg-white"}`}
                    title={`Ir para slide ${index + 1}`}
                  />
                ))}
              </div>
            </>
          )}
        </section>
      ) : (
        // Fallback Hero Component
        <Hero
          subtitle="Ancestralidade & Wellness"
          title="Sabedoria das Ervas, Tecnologia do Bem-Estar"
          description="Um ecossistema digital de autocuidado natural, onde a tradição milenar encontra a inovação para nutrir seu corpo e alma."
          primaryAction={{
            label: "Explorar Experiência",
            href: "/produtos"
          }}
          secondaryAction={{
            label: "Conhecer Rituais",
            href: "/ervas"
          }}
          variant="centered"
          size="large"
        />
      )}

      {/* ── SEÇÃO RECURSOS / DIFERENCIAIS ────────────────── */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4 md:px-8">
          <div className="text-center mb-12">
            <Badge variant="sage" size="lg" className="mb-4">
              Por que escolher Receita de Vovó
            </Badge>
            <h2 className="text-3xl md:text-4xl font-heading font-semibold text-terra mb-4">
              Autocuidado Ancestral com Tecnologia
            </h2>
            <p className="text-lg text-marrom-suave max-w-2xl mx-auto">
              Produtos artesanais veganos que honram a tradição e promovem bem-estar genuíno
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8 max-w-6xl mx-auto">
            <Card variant="elevated" size="lg" className="text-center hover:scale-105 transition-transform border-bege bg-white">
              <CardContent className="pt-8">
                <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-sage/10 flex items-center justify-center">
                  <Leaf className="w-8 h-8 text-sage" />
                </div>
                <CardTitle className="mb-3 text-xl font-heading text-terra">100% Natural</CardTitle>
                <CardDescription className="text-base text-marrom-suave">
                  Ervas medicinais cuidadosamente selecionadas, cultivadas com respeito à natureza e tradição
                </CardDescription>
              </CardContent>
            </Card>

            <Card variant="elevated" size="lg" className="text-center hover:scale-105 transition-transform border-bege bg-white">
              <CardContent className="pt-8">
                <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-dourado/10 flex items-center justify-center">
                  <Sparkles className="w-8 h-8 text-dourado" />
                </div>
                <CardTitle className="mb-3 text-xl font-heading text-terra">Artesanal</CardTitle>
                <CardDescription className="text-base text-marrom-suave">
                  Cada produto é feito à mão com intenção, amor e conhecimento ancestral transmitido por gerações
                </CardDescription>
              </CardContent>
            </Card>

            <Card variant="elevated" size="lg" className="text-center hover:scale-105 transition-transform border-bege bg-white">
              <CardContent className="pt-8">
                <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-terracota/10 flex items-center justify-center">
                  <Heart className="w-8 h-8 text-terracota" />
                </div>
                <CardTitle className="mb-3 text-xl font-heading text-terra">Bem-Estar</CardTitle>
                <CardDescription className="text-base text-marrom-suave">
                  Promovemos autocuidado holístico que nutre corpo, mente e espírito de forma integrada
                </CardDescription>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* ── SEÇÃO SABEDORIA DA VOVÓ (POSTS DO BLOG) ───────── */}
      {!loading && posts.length > 0 && (
        <section className="py-20 bg-[#fbf9f4] border-t border-b border-bege/30">
          <div className="container mx-auto px-4 md:px-8">
            <div className="text-center mb-12">
              <Badge className="bg-[#7c6f45]/10 text-[#7c6f45] border-[#7c6f45]/20 shadow-none mb-4" size="lg">
                Conselhos & Rituais
              </Badge>
              <h2 className="text-3xl md:text-4xl font-heading font-semibold text-terra mb-4">
                Sabedoria da Vovó
              </h2>
              <p className="text-lg text-marrom-suave max-w-2xl mx-auto">
                Aprenda a aplicar a medicina tradicional das ervas na sua rotina com nossos guias educativos.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
              {posts.map((post) => (
                <div 
                  key={post.id} 
                  className="bg-white rounded-2xl border border-bege shadow-sm hover:shadow-md transition-all overflow-hidden flex flex-col justify-between"
                >
                  {/* Post Image Banner */}
                  <Link href={`/blog/${post.slug}`} className="block relative aspect-video bg-zinc-100 overflow-hidden group">
                    {post.featured_image ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img 
                        src={post.featured_image} 
                        alt={post.title} 
                        className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-500"
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-bege">
                        <BookOpen className="w-12 h-12" />
                      </div>
                    )}
                    <div className="absolute top-3 left-3">
                      <Badge className="bg-[#7c6f45] text-white border-none uppercase text-[9px] font-bold">
                        {post.category?.name || "Rituais"}
                      </Badge>
                    </div>
                  </Link>

                  {/* Post Text Details */}
                  <div className="p-6 flex-1 flex flex-col justify-between space-y-4">
                    <div className="space-y-2">
                      <div className="flex items-center gap-1.5 text-xs text-zinc-400">
                        <Calendar className="w-3.5 h-3.5" />
                        <span>{new Date(post.created_at).toLocaleDateString("pt-BR", { day: 'numeric', month: 'short' })}</span>
                        <span>·</span>
                        <span>Por {post.user?.name || "Vovó"}</span>
                      </div>
                      
                      <Link href={`/blog/${post.slug}`} className="block">
                        <h3 className="font-heading font-semibold text-terra text-lg hover:text-[#635837] transition-colors leading-snug line-clamp-2">
                          {post.title}
                        </h3>
                      </Link>
                      
                      <p className="text-sm text-marrom-suave/80 line-clamp-3 leading-relaxed">
                        {post.excerpt}
                      </p>
                    </div>

                    <Link 
                      href={`/blog/${post.slug}`}
                      className="inline-flex items-center gap-1.5 text-xs font-semibold text-[#7c6f45] hover:text-[#635837] transition-colors group/link"
                    >
                      Ler artigo completo 
                      <ArrowRight className="w-3.5 h-3.5 group-hover/link:translate-x-1 transition-transform" />
                    </Link>
                  </div>

                  {/* Related Linked Product Card (Linked Commerce) */}
                  {post.product && (
                    <div className="px-6 pb-6 pt-2 border-t border-bege/40 bg-zinc-50/50">
                      <div className="bg-white border border-bege/40 rounded-xl p-3 flex items-center justify-between gap-3 shadow-inner-sm">
                        <div className="flex items-center gap-3 min-w-0">
                          <div className="w-12 h-12 rounded-lg bg-bege-light/20 border border-bege/30 overflow-hidden flex items-center justify-center shrink-0">
                            {post.product.featured_image ? (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img 
                                src={post.product.featured_image} 
                                alt={post.product.name} 
                                className="object-cover w-full h-full"
                              />
                            ) : (
                              <ShoppingBag className="w-5 h-5 text-zinc-300" />
                            )}
                          </div>
                          <div className="min-w-0">
                            <span className="font-medium text-xs text-zinc-800 block truncate">{post.product.name}</span>
                            <span className="font-semibold text-sm text-[#7c6f45] block">
                              R$ {parseFloat(post.product.price).toFixed(2)}
                            </span>
                          </div>
                        </div>

                        <Button 
                          size="sm" 
                          variant="sage"
                          className="h-8 px-3 bg-[#7c6f45] hover:bg-[#635837] text-white text-xs gap-1 font-medium shrink-0"
                          asChild
                        >
                          <Link href={`/produtos/${post.product.slug}`}>
                            Comprar
                          </Link>
                        </Button>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* ── SEÇÃO DEPOIMENTOS / PROVA SOCIAL ────────────── */}
      {!loading && reviews.length > 0 && (
        <section className="py-20 bg-background border-t border-bege/35">
          <div className="container mx-auto px-4 md:px-8">
            <div className="text-center mb-12">
              <Badge variant="sage" size="lg" className="mb-4">
                Experiências Reais
              </Badge>
              <h2 className="text-3xl md:text-4xl font-heading font-semibold text-terra mb-4">
                O que dizem sobre nós
              </h2>
              <p className="text-lg text-marrom-suave max-w-2xl mx-auto">
                Confira os relatos de bem-estar compartilhados por quem vivencia o autocuidado Receita de Vovó.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
              {reviews.map((review) => (
                <div 
                  key={review.id} 
                  className="bg-white rounded-2xl border border-bege shadow-sm p-6 flex flex-col justify-between hover:shadow-md transition-shadow duration-300"
                >
                  <div className="space-y-4">
                    {/* Stars and Verified Purchase */}
                    <div className="flex justify-between items-center">
                      <div className="flex gap-0.5 text-amber-400">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <Star 
                            key={i} 
                            className={`w-4 h-4 ${i < review.rating ? 'fill-amber-400 text-amber-400' : 'text-zinc-200'}`} 
                          />
                        ))}
                      </div>
                      {review.is_verified_purchase && (
                        <span className="inline-flex items-center gap-1 text-[10px] font-bold text-emerald-600 bg-emerald-50 border border-emerald-100 rounded-full px-2 py-0.5 uppercase tracking-wide">
                          <ShieldCheck className="w-3.5 h-3.5" /> Compra Verificada
                        </span>
                      )}
                    </div>

                    {/* Review Comment */}
                    <p className="text-sm text-marrom-suave italic leading-relaxed">
                      "{review.comment || "Sem comentários por extenso, apenas avaliação com nota."}"
                    </p>
                  </div>

                  {/* Customer and Product info */}
                  <div className="mt-6 pt-4 border-t border-bege/30 space-y-3">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-bege flex items-center justify-center font-bold text-[#7c6f45] text-sm shrink-0">
                        {review.user?.name ? review.user.name[0].toUpperCase() : "C"}
                      </div>
                      <div>
                        <span className="font-semibold text-xs text-zinc-800 block">
                          {review.user?.name || "Cliente Satisfeito"}
                        </span>
                        <span className="text-[10px] text-zinc-400">
                          {new Date(review.created_at).toLocaleDateString("pt-BR")}
                        </span>
                      </div>
                    </div>

                    {review.product && (
                      <Link 
                        href={`/produtos/${review.product.slug}`}
                        className="flex items-center gap-2 bg-[#fbf9f4] border border-bege/40 hover:border-sage/40 rounded-lg p-2 transition-colors duration-200"
                      >
                        <div className="w-7 h-7 bg-white rounded border border-bege/40 overflow-hidden flex items-center justify-center shrink-0">
                          {review.product.featured_image ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img 
                              src={review.product.featured_image} 
                              alt={review.product.name} 
                              className="object-cover w-full h-full"
                            />
                          ) : (
                            <ShoppingBag className="w-4 h-4 text-zinc-300" />
                          )}
                        </div>
                        <span className="text-[10px] font-medium text-marrom-suave truncate hover:text-[#7c6f45] block">
                          Avaliação sobre: <strong className="text-zinc-800 font-semibold">{review.product.name}</strong>
                        </span>
                      </Link>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* ── SEÇÃO INCENTIVO FINAL / CTA ─────────────────── */}
      <section className="py-20 bg-gradient-to-r from-sage/10 via-creme to-dourado/10">
        <div className="container mx-auto px-4 md:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-heading font-semibold text-terra mb-6">
            Comece Sua Jornada de Bem-Estar
          </h2>
          <p className="text-lg text-marrom-suave mb-8 max-w-2xl mx-auto">
            Descubra produtos naturais e rituais ancestrais personalizados para seu momento de vida
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button variant="sage" size="lg" asChild>
              <a href="/produtos">Ver Produtos</a>
            </Button>
            <Button variant="outline" size="lg" asChild>
              <a href="/ervas">Explorar Ervas</a>
            </Button>
          </div>
        </div>
      </section>
    </div>
  );
}
