"use client";

import { useEffect, useState } from "react";
import { wellnessService } from "@/modules/wellness/services/wellness";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Search, Sparkles, Wind, BookOpen, Coffee, Flame, Heart, Info, Droplet } from "lucide-react";
import { Dialog, DialogContent, DialogTitle, DialogDescription } from "@/components/ui/dialog";

export default function HerbsPage() {
  const [herbs, setHerbs] = useState<any[]>([]);
  const [benefits, setBenefits] = useState<any[]>([]);
  const [emotions, setEmotions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeBenefit, setActiveBenefit] = useState<string | null>(null);
  const [activeEmotion, setActiveEmotion] = useState<string | null>(null);
  const [selectedHerb, setSelectedHerb] = useState<any | null>(null);

  // Search State
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const [perPage, setPerPage] = useState(25);
  const [totalItems, setTotalItems] = useState(0);
  const [lastPage, setLastPage] = useState(1);

  // Debounce search term
  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedSearch(search);
      setCurrentPage(1);
    }, 400);

    return () => {
      clearTimeout(handler);
    };
  }, [search]);

  useEffect(() => {
    async function loadInitialData() {
      try {
        const [bData, eData] = await Promise.all([
          wellnessService.getBenefits(),
          wellnessService.getEmotions(),
        ]);
        setBenefits(bData.data);
        setEmotions(eData.data);
      } catch (error) {
        console.error("Error loading filters", error);
      }
    }
    loadInitialData();
  }, []);

  useEffect(() => {
    async function loadHerbs() {
      setLoading(true);
      try {
        const params: any = {
          page: currentPage,
          per_page: perPage,
        };
        if (activeBenefit) params.benefit = activeBenefit;
        if (activeEmotion) params.emotion = activeEmotion;
        if (debouncedSearch) params.search = debouncedSearch;
        
        const data = await wellnessService.getHerbs(params);
        const responseData = data.data;
        if (Array.isArray(responseData)) {
          setHerbs(responseData);
          setTotalItems(responseData.length);
          setLastPage(1);
        } else if (responseData && Array.isArray(responseData.data)) {
          setHerbs(responseData.data);
          setTotalItems(responseData.total || 0);
          setLastPage(responseData.last_page || 1);
        }
      } catch (error) {
        console.error("Error loading herbs", error);
      } finally {
        setLoading(false);
      }
    }
    loadHerbs();
  }, [activeBenefit, activeEmotion, debouncedSearch, currentPage, perPage]);

  return (
    <div className="min-h-screen bg-background p-8">
      <div className="container mx-auto max-w-6xl space-y-12">
        {/* Header */}
        <div className="text-center space-y-4 max-w-2xl mx-auto">
          <h1 className="text-4xl font-bold font-outfit text-primary">Conhecimento Herbal</h1>
          <p className="text-lg text-muted-foreground font-inter">
            Explore as propriedades das ervas e descubra como a natureza pode auxiliar no seu bem-estar diário.
          </p>
        </div>

        {/* Filters */}
        <div className="space-y-6 bg-white/50 p-6 rounded-2xl border border-beige/50 shadow-sm">
          {/* Barra de Busca Premium */}
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-marrom-suave w-5 h-5" />
            <input
              type="text"
              placeholder="Buscar ervas por nome popular, científico, apelidos ou propriedades..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full bg-white border border-bege/60 rounded-xl pl-12 pr-16 py-3 text-base text-terra placeholder:text-marrom-suave/50 focus:outline-none focus:border-sage focus:ring-1 focus:ring-sage transition-all shadow-inner-sm"
            />
            {search && (
              <button 
                type="button"
                onClick={() => setSearch("")}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-xs font-semibold text-marrom-suave hover:text-terra transition-colors"
              >
                Limpar
              </button>
            )}
          </div>

          <div className="space-y-3">
            <div className="flex items-center gap-2 text-primary font-semibold text-sm uppercase tracking-wider">
              <Sparkles className="w-4 h-4" />
              <span>O que você busca? (Benefícios)</span>
            </div>
            <div className="flex flex-nowrap overflow-x-auto scrollbar-none gap-2 pb-2 -mx-6 px-6 md:mx-0 md:px-0 md:flex-wrap md:overflow-x-visible">
              <Badge 
                variant={activeBenefit === null ? "default" : "outline"}
                className="cursor-pointer px-4 py-1.5 rounded-full shrink-0"
                onClick={() => {
                  setActiveBenefit(null);
                  setCurrentPage(1);
                }}
              >
                Todos
              </Badge>
              {benefits.map((b) => (
                <Badge 
                  key={b.slug}
                  variant={activeBenefit === b.slug ? "default" : "outline"}
                  className="cursor-pointer px-4 py-1.5 rounded-full shrink-0"
                  onClick={() => {
                    setActiveBenefit(b.slug);
                    setCurrentPage(1);
                  }}
                >
                  {b.name}
                </Badge>
              ))}
            </div>
          </div>

          <div className="space-y-3 border-t border-beige/30 pt-4">
            <div className="flex items-center gap-2 text-primary font-semibold text-sm uppercase tracking-wider">
              <Wind className="w-4 h-4" />
              <span>Como você se sente? (Emoções)</span>
            </div>
            <div className="flex flex-nowrap overflow-x-auto scrollbar-none gap-2 pb-2 -mx-6 px-6 md:mx-0 md:px-0 md:flex-wrap md:overflow-x-visible">
              <Badge 
                variant={activeEmotion === null ? "default" : "outline"}
                className="cursor-pointer px-4 py-1.5 rounded-full shrink-0"
                onClick={() => {
                  setActiveEmotion(null);
                  setCurrentPage(1);
                }}
              >
                Geral
              </Badge>
              {emotions.map((e) => (
                <Badge 
                  key={e.slug}
                  variant={activeEmotion === e.slug ? "default" : "outline"}
                  className="cursor-pointer px-4 py-1.5 rounded-full shrink-0"
                  onClick={() => {
                    setActiveEmotion(e.slug);
                    setCurrentPage(1);
                  }}
                >
                  {e.name}
                </Badge>
              ))}
            </div>
          </div>
        </div>

        {/* Count Indicator */}
        <div className="flex justify-between items-center border-b border-bege/35 pb-3">
          <span className="text-xs text-marrom-suave font-medium font-inter">
            {totalItems > 0 ? (
              <>
                Mostrando <strong className="text-terra font-bold font-outfit text-sm">{Math.min((currentPage - 1) * perPage + 1, totalItems)}-{Math.min(currentPage * perPage, totalItems)}</strong> de <strong className="text-terra font-bold font-outfit text-sm">{totalItems}</strong> {totalItems === 1 ? 'erva sagrada' : 'ervas sagradas'}
              </>
            ) : (
              "Nenhuma erva encontrada"
            )}
          </span>
          {loading && <span className="text-[11px] text-muted-foreground animate-pulse font-inter">Atualizando catálogo...</span>}
        </div>

        {/* Herb Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {loading ? (
            Array.from({ length: 6 }).map((_, i) => (
              <Card key={i} className="border-beige/50 overflow-hidden">
                <Skeleton className="h-48 w-full" />
                <CardHeader>
                  <Skeleton className="h-6 w-3/4" />
                  <Skeleton className="h-4 w-1/2" />
                </CardHeader>
              </Card>
            ))
          ) : herbs.length > 0 ? (
            herbs.map((herb, index) => {
              const imageUrl = herb.image_path
                ? herb.image_path.startsWith("http")
                  ? herb.image_path
                  : herb.image_path.startsWith("/storage")
                    ? `http://localhost:8000${herb.image_path}`
                    : herb.image_path
                : null;

              return (
                <Card 
                  key={herb.id} 
                  className="border-beige/50 hover:shadow-lg hover:-translate-y-1 hover:border-primary/20 cursor-pointer transition-all duration-300 group flex flex-col h-full bg-white/70 backdrop-blur-md overflow-hidden"
                  onClick={() => setSelectedHerb(herb)}
                >
                  <div className="h-48 bg-cream/50 relative overflow-hidden flex items-center justify-center border-b border-beige/20 shrink-0">
                    {imageUrl ? (
                      <img 
                        src={imageUrl} 
                        alt={herb.name} 
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700 ease-out"
                      />
                    ) : (
                      <div className="w-16 h-16 rounded-full bg-olive/10 flex items-center justify-center text-olive group-hover:scale-110 transition-transform duration-500">
                        <span className="text-4xl">🌿</span>
                      </div>
                    )}

                    {/* Lineage Badge Overlay */}
                    {herb.source_type && (
                      <div className="absolute top-3 right-3 z-10">
                        <Badge 
                          className={`text-[8px] px-2.5 py-1 font-bold uppercase tracking-wider border-none rounded-full shadow-sm backdrop-blur-md text-white ${
                            herb.source_type === "popular" 
                              ? "bg-amber-600/90 hover:bg-amber-600/90" 
                              : herb.source_type === "scientific"
                                ? "bg-blue-600/90 hover:bg-blue-600/90"
                                : "bg-emerald-600/90 hover:bg-emerald-600/90"
                          }`}
                        >
                          {herb.source_type === "popular" 
                            ? "📜 Popular" 
                            : herb.source_type === "scientific" 
                              ? "🔬 Científica" 
                              : "🍃 Integrativa"}
                        </Badge>
                      </div>
                    )}
                  </div>
                  <CardHeader className="p-5 pb-3">
                    <div className="flex justify-between items-start">
                      <div>
                        <CardTitle className="font-outfit text-primary text-xl font-bold">{herb.name}</CardTitle>
                        {herb.scientific_name && (
                          <CardDescription className="italic text-xs text-olive/80 font-medium">
                            {herb.scientific_name}
                          </CardDescription>
                        )}
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent className="p-5 pt-0 flex-1 flex flex-col justify-between space-y-4">
                    <div className="space-y-3">
                      <p className="text-sm text-muted-foreground line-clamp-3 leading-relaxed">
                        {herb.description}
                      </p>
                      <div className="flex flex-wrap gap-1.5 pt-2">
                        {herb.benefits?.map((b: any) => (
                          <span key={b.id} className="text-[9px] bg-olive/10 text-olive px-2.5 py-1 rounded-full font-bold uppercase tracking-wider">
                            {b.name}
                          </span>
                        ))}
                      </div>
                    </div>

                    <div className="space-y-3 pt-3 border-t border-beige/20">
                      {/* Sources bibliography */}
                      {herb.sources && (
                        <div className="flex flex-col gap-0.5 text-[10px] text-muted-foreground leading-normal">
                          <span className="font-bold text-primary text-[9px] uppercase tracking-wider">
                            📚 Fonte de Referência:
                          </span>
                          <span className="italic line-clamp-1 leading-relaxed">{herb.sources}</span>
                        </div>
                      )}
                      
                      <div className="text-primary font-bold text-xs flex items-center gap-1 group-hover:underline">
                        <span>Ver guia completo</span>
                        <span className="transition-transform group-hover:translate-x-1 duration-200">→</span>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })
          ) : (
            <div className="col-span-full py-20 text-center space-y-4">
              <Search className="w-12 h-12 text-muted-foreground/30 mx-auto" />
              <p className="text-muted-foreground">Nenhuma erva encontrada para esta combinação de busca e filtros.</p>
              <Button variant="link" onClick={() => { setActiveBenefit(null); setActiveEmotion(null); setSearch(""); setCurrentPage(1); }}>
                Limpar filtros
              </Button>
            </div>
          )}
        </div>

        {/* Pagination Controls */}
        {!loading && totalItems > 0 && (
          <div className="flex flex-col sm:flex-row items-center justify-between gap-6 bg-white/40 backdrop-blur-md p-4 px-6 rounded-2xl border border-beige/40 shadow-sm mt-8">
            {/* Per Page Selector */}
            <div className="flex items-center gap-3">
              <span className="text-xs text-marrom-suave font-medium font-inter">Itens por página:</span>
              <div className="flex bg-cream/30 p-0.5 rounded-xl border border-beige/20">
                {[25, 50, 100].map((size) => (
                  <button
                    key={size}
                    onClick={() => {
                      setPerPage(size);
                      setCurrentPage(1);
                    }}
                    className={`px-3 py-1 text-xs font-semibold rounded-lg font-outfit transition-all duration-300 ${
                      perPage === size
                        ? "bg-primary text-white shadow-sm"
                        : "text-muted-foreground hover:text-primary hover:bg-cream/50"
                    }`}
                  >
                    {size}
                  </button>
                ))}
              </div>
            </div>

            {/* Page Buttons */}
            {lastPage > 1 && (
              <div className="flex items-center gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                  disabled={currentPage === 1}
                  className="border-beige/50 text-marrom-suave font-medium font-inter text-xs px-3 h-9 rounded-xl hover:bg-cream/40 hover:text-primary transition-all duration-300 disabled:opacity-40"
                >
                  ← Anterior
                </Button>

                <div className="flex items-center gap-1.5">
                  {Array.from({ length: lastPage }, (_, i) => i + 1).map((page) => (
                    <button
                      key={page}
                      onClick={() => setCurrentPage(page)}
                      className={`w-9 h-9 text-xs font-bold rounded-xl font-outfit transition-all duration-300 flex items-center justify-center ${
                        currentPage === page
                          ? "bg-primary text-white shadow-sm"
                          : "border border-transparent text-muted-foreground hover:border-beige/50 hover:bg-cream/30 hover:text-primary"
                      }`}
                    >
                      {page}
                    </button>
                  ))}
                </div>

                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage((prev) => Math.min(prev + 1, lastPage))}
                  disabled={currentPage === lastPage}
                  className="border-beige/50 text-marrom-suave font-medium font-inter text-xs px-3 h-9 rounded-xl hover:bg-cream/40 hover:text-primary transition-all duration-300 disabled:opacity-40"
                >
                  Próximo →
                </Button>
              </div>
            )}
          </div>
        )}

        {/* Disclaimer Banner */}
        <div className="bg-cream/40 rounded-3xl p-6 md:p-8 border border-beige/50 max-w-4xl mx-auto text-center space-y-3 mt-16 shadow-sm">
          <div className="w-10 h-10 rounded-full bg-amber-50 flex items-center justify-center text-amber-600 mx-auto border border-amber-100">
            <span className="text-lg">⚠️</span>
          </div>
          <h3 className="font-outfit text-primary font-bold text-lg">Aviso de Responsabilidade</h3>
          <p className="text-xs text-muted-foreground max-w-2xl mx-auto leading-relaxed">
            As informações contidas neste catálogo de ervas têm caráter meramente educativo, tradicional e informativo. 
            O uso de plantas medicinais, chás e rituais é uma prática complementar e <strong>não substitui de forma alguma</strong> 
            a consulta, diagnóstico, prescrição ou tratamento por profissionais de saúde qualificados. 
            Sempre consulte seu médico antes de iniciar qualquer terapia herbal de ingestão.
          </p>
        </div>

        {/* Selected Herb Detail Modal */}
        {selectedHerb && (
          <Dialog open={!!selectedHerb} onOpenChange={(open) => !open && setSelectedHerb(null)}>
            <DialogContent className="max-w-4xl w-[92vw] max-h-[90vh] overflow-y-auto bg-bege-light border-bege rounded-3xl shadow-2xl p-0 gap-0 scrollbar-thin scrollbar-thumb-bege/50 scrollbar-track-transparent">
              {/* Widescreen Hero Header */}
              <div className="relative h-[240px] md:h-[300px] w-full overflow-hidden shrink-0 border-b border-bege/20 flex items-center justify-center bg-cream/40">
                {selectedHerb.image_path ? (
                  <img 
                    src={selectedHerb.image_path.startsWith("http")
                      ? selectedHerb.image_path
                      : selectedHerb.image_path.startsWith("/storage")
                        ? `http://localhost:8000${selectedHerb.image_path}`
                        : selectedHerb.image_path} 
                    alt={selectedHerb.name} 
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-20 h-20 rounded-full bg-olive/10 flex items-center justify-center text-olive">
                    <span className="text-5xl">🌿</span>
                  </div>
                )}

                {/* Absolute Black-to-transparent overlay mask */}
                <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/40 to-transparent z-10" />

                {/* Top Overlays */}
                {selectedHerb.source_type && (
                  <div className="absolute top-4 left-4 z-20">
                    <Badge 
                      className={`text-[9px] px-3 py-1 font-bold uppercase tracking-wider border-none rounded-full shadow-md text-white ${
                        selectedHerb.source_type === "popular" 
                          ? "bg-amber-600/90" 
                          : selectedHerb.source_type === "scientific"
                            ? "bg-blue-600/90"
                            : "bg-emerald-600/90"
                      }`}
                    >
                      {selectedHerb.source_type === "popular" 
                        ? "📜 Popular" 
                        : selectedHerb.source_type === "scientific" 
                          ? "🔬 Científica" 
                          : "🍃 Integrativa"}
                    </Badge>
                  </div>
                )}

                {/* Bottom Overlay Title & Scientific Name */}
                <div className="absolute bottom-0 left-0 right-0 p-6 md:p-8 z-20 space-y-1">
                  <DialogTitle className="text-3xl md:text-4xl font-bold font-heading text-white tracking-tight drop-shadow-md">
                    {selectedHerb.name}
                  </DialogTitle>
                  {selectedHerb.scientific_name && (
                    <p className="italic text-bege-light/90 text-sm md:text-base font-semibold font-inter drop-shadow-sm">
                      {selectedHerb.scientific_name}
                    </p>
                  )}
                  {selectedHerb.aliases && (
                    <p className="text-xs text-bege-light/80 font-medium font-inter drop-shadow-sm mt-1">
                      <strong className="text-bege-light/95">Também conhecida como:</strong> {selectedHerb.aliases}
                    </p>
                  )}
                </div>
              </div>

              {/* Body Content */}
              <div className="p-6 md:p-8 space-y-8">
                
                {/* Row 1: Description & Core Attributes */}
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
                  {/* Description */}
                  <div className="lg:col-span-7 space-y-4">
                    <div className="space-y-2">
                      <span className="text-[10px] font-bold text-terra uppercase tracking-wider block">Sobre a Erva</span>
                      <DialogDescription className="text-sm md:text-base text-marrom-suave leading-relaxed font-inter font-normal border-l-2 border-terra/30 pl-4">
                        {selectedHerb.description}
                      </DialogDescription>
                    </div>

                    {selectedHerb.contraindications && (
                      <div className="bg-amber-50/50 border border-amber-200/50 rounded-2xl p-4 md:p-5 flex gap-3.5 items-start hover:bg-amber-50/70 transition-all duration-300">
                        <div className="w-8 h-8 rounded-xl bg-amber-600/10 flex items-center justify-center text-amber-700 shrink-0">
                          <Info className="w-4.5 h-4.5" />
                        </div>
                        <div className="space-y-1">
                          <span className="font-bold text-amber-800 uppercase tracking-wider text-[10px] block">Contraindicações e Cuidados</span>
                          <p className="text-xs text-marrom-suave leading-relaxed font-inter">{selectedHerb.contraindications}</p>
                        </div>
                      </div>
                    )}
                  </div>

                  {/* Attributes/Tags panel */}
                  <div className="lg:col-span-5 bg-cream/20 border border-bege/35 rounded-2xl p-4 md:p-5 space-y-4">
                    {selectedHerb.benefits && selectedHerb.benefits.length > 0 && (
                      <div className="space-y-1.5">
                        <span className="text-[10px] font-bold text-terra uppercase tracking-wider block">Benefícios Físicos</span>
                        <div className="flex flex-wrap gap-1.5">
                          {selectedHerb.benefits.map((b: any) => (
                            <Badge key={b.id} className="text-[9px] bg-olive/15 hover:bg-olive/20 text-olive px-2.5 py-0.5 rounded-full font-bold uppercase tracking-wider border-none">
                              {b.name}
                            </Badge>
                          ))}
                        </div>
                      </div>
                    )}

                    {selectedHerb.emotions && selectedHerb.emotions.length > 0 && (
                      <div className="space-y-1.5 border-t border-bege/20 pt-3">
                        <span className="text-[10px] font-bold text-terra uppercase tracking-wider block">Apoio Emocional</span>
                        <div className="flex flex-wrap gap-1.5">
                          {selectedHerb.emotions.map((e: any) => (
                            <Badge key={e.id} className="text-[9px] bg-rose-600/15 hover:bg-rose-600/20 text-rose-700 px-2.5 py-0.5 rounded-full font-bold uppercase tracking-wider border-none">
                              {e.name}
                            </Badge>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                </div>

                {/* Row 2: Rituals Grid */}
                <div className="space-y-4">
                  <h4 className="text-xs font-bold text-terra uppercase tracking-wider flex items-center gap-1.5 border-b border-bege/30 pb-2">
                    <Sparkles className="w-3.5 h-3.5 text-olive" />
                    <span>Guia Fitoenergético & Ritual Completo</span>
                  </h4>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    {/* Card Tea */}
                    {selectedHerb.how_to_use && (
                      <div className="bg-emerald-50/40 hover:bg-emerald-50/60 border border-emerald-100/50 p-5 rounded-2xl transition-all duration-300 space-y-3 flex flex-col hover:shadow-sm">
                        <div className="flex items-center gap-2 text-emerald-800 font-bold text-sm">
                          <div className="w-7 h-7 rounded-lg bg-emerald-600/10 flex items-center justify-center text-emerald-700">
                            <Coffee className="w-4 h-4" />
                          </div>
                          <span>🍵 Preparo & Ingestão</span>
                        </div>
                        <div className="text-xs text-marrom-suave whitespace-pre-line leading-relaxed font-inter flex-1">
                          {selectedHerb.how_to_use}
                        </div>
                      </div>
                    )}

                    {/* Card Bath */}
                    {selectedHerb.bath_instructions && (
                      <div className="bg-blue-50/40 hover:bg-blue-50/60 border border-blue-100/50 p-5 rounded-2xl transition-all duration-300 space-y-3 flex flex-col hover:shadow-sm">
                        <div className="flex items-center gap-2 text-blue-800 font-bold text-sm">
                          <div className="w-7 h-7 rounded-lg bg-blue-600/10 flex items-center justify-center text-blue-700">
                            <Droplet className="w-4 h-4" />
                          </div>
                          <span>🛁 Banho Energético</span>
                        </div>
                        <div className="text-xs text-marrom-suave whitespace-pre-line leading-relaxed font-inter flex-1">
                          {selectedHerb.bath_instructions}
                        </div>
                      </div>
                    )}

                    {/* Card Incense */}
                    {selectedHerb.incense_usage && (
                      <div className="bg-amber-50/40 hover:bg-amber-50/60 border border-amber-100/50 p-5 rounded-2xl transition-all duration-300 space-y-3 flex flex-col hover:shadow-sm">
                        <div className="flex items-center gap-2 text-amber-800 font-bold text-sm">
                          <div className="w-7 h-7 rounded-lg bg-amber-600/10 flex items-center justify-center text-amber-700">
                            <Flame className="w-4 h-4" />
                          </div>
                          <span>🔥 Defumação</span>
                        </div>
                        <div className="text-xs text-marrom-suave whitespace-pre-line leading-relaxed font-inter flex-1">
                          {selectedHerb.incense_usage}
                        </div>
                      </div>
                    )}
                  </div>
                </div>

                {/* Row 3: References bibliography */}
                {selectedHerb.sources && (
                  <div className="bg-cream/35 border border-dashed border-bege/50 p-4 rounded-xl space-y-1.5">
                    <div className="flex items-center gap-2 text-terra font-bold text-[10px] uppercase tracking-wider">
                      <BookOpen className="w-3.5 h-3.5 text-olive" />
                      <span>📚 Referências Bibliográficas & Científicas</span>
                    </div>
                    <div className="text-xs italic text-marrom-suave leading-relaxed font-inter">
                      {selectedHerb.sources}
                    </div>
                  </div>
                )}
              </div>
            </DialogContent>
          </Dialog>
        )}
      </div>
    </div>
  );
}
