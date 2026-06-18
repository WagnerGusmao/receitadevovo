"use client";

import { useEffect, useState } from "react";
import { useAuthStore } from "@/modules/auth/store/authStore";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { 
  Award, 
  Sparkles, 
  Gift, 
  Lock, 
  Unlock, 
  Copy, 
  Check, 
  ChevronRight, 
  Info, 
  Coins, 
  Flame, 
  Heart,
  TrendingUp
} from "lucide-react";
import Link from "next/link";

interface LoyaltyLevel {
  id: number;
  name: string;
  min_points: number;
  discount_percentage: number;
  badge_icon: string;
  description: string;
}

interface LoyaltyReward {
  id: number;
  title: string;
  description: string;
  points_cost: number;
  reward_code: string;
  is_active: boolean;
}

interface LoyaltyRedemption {
  id: number;
  reward_code: string;
  reward: LoyaltyReward;
  created_at: string;
}

interface LoyaltyOffer {
  id: number;
  product: {
    id: number;
    name: string;
    price: number;
    image_path?: string;
  };
  level: LoyaltyLevel;
  special_price: number;
  description: string;
  is_unlocked: boolean;
  points_required: number;
}

interface ProfileData {
  points_balance: number;
  lifetime_points: number;
  current_level: LoyaltyLevel;
  next_level: LoyaltyLevel | null;
  points_needed: number;
  all_levels: LoyaltyLevel[];
}

export default function LoyaltyPage() {
  const { isAuthenticated, user } = useAuthStore();
  const [profile, setProfile] = useState<ProfileData | null>(null);
  const [rewards, setRewards] = useState<LoyaltyReward[]>([]);
  const [redemptions, setRedemptions] = useState<LoyaltyRedemption[]>([]);
  const [offers, setOffers] = useState<LoyaltyOffer[]>([]);
  const [history, setHistory] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [copiedCode, setCopiedCode] = useState<string | null>(null);
  const [redeemedCode, setRedeemedCode] = useState<string | null>(null);
  const [redeemedReward, setRedeemedReward] = useState<string | null>(null);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [profileRes, catalogRes, offersRes, historyRes] = await Promise.all([
        apiFetch("/rewards/profile"),
        apiFetch("/rewards/catalog"),
        apiFetch("/rewards/offers"),
        apiFetch("/rewards/history"),
      ]);

      if (profileRes && profileRes.status === "success") setProfile(profileRes.data);
      if (catalogRes && catalogRes.status === "success") {
        setRewards(catalogRes.data.rewards);
        setRedemptions(catalogRes.data.redemptions);
      }
      if (offersRes && offersRes.status === "success") setOffers(offersRes.data);
      if (historyRes && historyRes.status === "success") setHistory(historyRes.data);
    } catch (err) {
      console.error("Erro ao carregar dados de fidelidade:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (isAuthenticated) {
      fetchData();
    }
  }, [isAuthenticated]);

  const handleRedeem = async (rewardId: number, title: string) => {
    if (!confirm(`Deseja resgatar "${title}"?`)) return;

    try {
      const response = await apiFetch(`/rewards/redeem/${rewardId}`, {
        method: "POST",
      });

      if (response && response.status === "success") {
        setRedeemedCode(response.data.reward_code);
        setRedeemedReward(title);
        // Refresh local data
        fetchData();
      } else {
        alert(response.message || "Erro ao realizar o resgate.");
      }
    } catch (err) {
      console.error(err);
      alert("Erro ao processar o resgate.");
    }
  };

  const copyToClipboard = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedCode(code);
    setTimeout(() => setCopiedCode(null), 2000);
  };

  if (!isAuthenticated) {
    return (
      <div className="container mx-auto px-4 py-16 text-center max-w-lg">
        <div className="w-20 h-20 bg-sage/10 rounded-full flex items-center justify-center mx-auto mb-6 text-sage">
          <Award className="w-10 h-10" />
        </div>
        <h1 className="text-3xl font-bold text-terra mb-4 font-serif">Clube Sementes de Vovó</h1>
        <p className="text-terra/80 mb-8 leading-relaxed">
          Participe do nosso programa de fidelidade exclusivo! Ganhe Sementes (pontos) a cada ritual de compra, suba de nível para desbloquear descontos permanentes e resgate cupons especiais.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button variant="sage" size="lg" asChild>
            <Link href="/login">Entrar na minha Conta</Link>
          </Button>
          <Button variant="outline" size="lg" asChild>
            <Link href="/cadastro">Cadastrar-se Agora</Link>
          </Button>
        </div>
      </div>
    );
  }

  if (loading || !profile) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px] gap-4">
        <div className="w-10 h-10 border-4 border-sage border-t-transparent rounded-full animate-spin"></div>
        <p className="text-terra/70 font-medium">Cultivando seus dados de sementes...</p>
      </div>
    );
  }

  // Get level badge icon helper
  const getBadgeIcon = (iconName: string) => {
    switch (iconName) {
      case "seed": return <span className="text-3xl">🌱</span>;
      case "leaf": return <span className="text-3xl">🌿</span>;
      case "flower": return <span className="text-3xl">🌸</span>;
      case "tree": return <span className="text-3xl">🌳</span>;
      default: return <Award className="w-8 h-8 text-sage" />;
    }
  };

  return (
    <div className="container mx-auto px-4 py-10 md:py-16 max-w-6xl">
      
      {/* Redemptions Success Modal/Popup */}
      {redeemedCode && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm animate-fade-in">
          <div className="bg-bege-light border-2 border-sage/40 p-8 rounded-2xl max-w-md w-full shadow-2xl text-center relative">
            <div className="w-16 h-16 bg-sage/20 rounded-full flex items-center justify-center mx-auto mb-4 text-sage">
              <Sparkles className="w-8 h-8 animate-pulse" />
            </div>
            <h3 className="text-2xl font-bold text-terra font-serif mb-2">Resgate Realizado!</h3>
            <p className="text-terra/80 text-sm mb-6">
              Você trocou suas sementes por: <br/>
              <strong className="text-sage text-base">{redeemedReward}</strong>
            </p>
            <div className="bg-bege/30 border border-bege-dark/30 rounded-xl p-4 mb-6 flex items-center justify-between gap-4">
              <span className="font-mono font-bold text-lg text-terra tracking-wider">{redeemedCode}</span>
              <button 
                onClick={() => copyToClipboard(redeemedCode)}
                className="p-2 hover:bg-sage/10 rounded-lg text-sage transition-all"
              >
                {copiedCode === redeemedCode ? <Check className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
              </button>
            </div>
            <Button variant="sage" className="w-full" onClick={() => { setRedeemedCode(null); setRedeemedReward(null); }}>
              Fechar e Continuar
            </Button>
          </div>
        </div>
      )}

      {/* Header and Loyalty Card */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 mb-12 items-stretch">
        
        {/* Virtual Card */}
        <div className="lg:col-span-5 bg-gradient-to-br from-sage/95 via-sage-dark/95 to-terra/90 text-bege-light p-8 rounded-3xl shadow-xl flex flex-col justify-between relative overflow-hidden group min-h-[260px]">
          <div className="absolute top-0 right-0 w-48 h-48 bg-white/5 rounded-full blur-3xl -mr-10 -mt-10 group-hover:bg-white/10 transition-all duration-700"></div>
          
          <div className="flex justify-between items-start z-10">
            <div>
              <span className="text-xs uppercase tracking-wider text-bege-light/70 font-semibold">Cartão Fidelidade</span>
              <h2 className="text-2xl font-bold font-serif mt-1">{user?.name}</h2>
            </div>
            <div className="bg-bege-light/10 p-3 rounded-2xl border border-bege-light/20 shadow-inner">
              {getBadgeIcon(profile.current_level.badge_icon)}
            </div>
          </div>

          <div className="z-10 my-6">
            <span className="text-xs text-bege-light/60 uppercase tracking-widest">Nível Atual</span>
            <div className="text-xl font-bold flex items-center gap-2 mt-0.5 text-gold font-serif">
              <Sparkles className="w-5 h-5 text-gold animate-spin-slow" />
              {profile.current_level.name}
              {profile.current_level.discount_percentage > 0 && (
                <span className="bg-gold/20 text-gold text-xs px-2.5 py-0.5 rounded-full border border-gold/30">
                  {profile.current_level.discount_percentage}% OFF
                </span>
              )}
            </div>
          </div>

          <div className="flex justify-between items-end border-t border-bege-light/10 pt-4 z-10">
            <div>
              <span className="text-xs text-bege-light/60 uppercase">Saldo de Sementes</span>
              <div className="text-3xl font-black font-serif mt-1 tracking-tight flex items-center gap-2 text-bege-light">
                <Coins className="w-7 h-7 text-gold" />
                {profile.points_balance}
              </div>
            </div>
            <div className="text-right">
              <span className="text-xs text-bege-light/60 uppercase">Acumuladas</span>
              <p className="text-sm font-semibold text-bege-light/95">{profile.lifetime_points} sementes</p>
            </div>
          </div>
        </div>

        {/* Level Progression */}
        <div className="lg:col-span-7 bg-bege-light border border-bege/60 rounded-3xl p-8 shadow-sm flex flex-col justify-between">
          <div>
            <h1 className="text-3xl font-bold text-terra font-serif mb-2">Clube Sementes de Vovó</h1>
            <p className="text-terra/80 text-sm leading-relaxed mb-6">
              Cada R$ 1,00 gasto em nossa loja gera **1 Semente**. Acumule sementes para subir de nível e resgatar cupons de desconto incríveis no catálogo abaixo.
            </p>
          </div>

          {profile.next_level ? (
            <div className="bg-bege/30 p-6 rounded-2xl border border-bege/50">
              <div className="flex justify-between text-sm font-semibold text-terra mb-2">
                <span className="flex items-center gap-1.5">
                  <TrendingUp className="w-4 h-4 text-sage" /> Próximo Nível:
                </span>
                <span className="text-sage">{profile.next_level.name}</span>
              </div>
              <div className="w-full bg-bege-dark/20 h-4 rounded-full overflow-hidden mb-3 border border-bege-dark/10">
                <div 
                  className="bg-gradient-to-r from-sage to-sage-dark h-full rounded-full transition-all duration-1000 ease-out"
                  style={{ width: `${Math.min(100, (profile.lifetime_points / profile.next_level.min_points) * 100)}%` }}
                ></div>
              </div>
              <div className="flex justify-between text-xs text-terra/70 font-medium">
                <span>{profile.lifetime_points} de {profile.next_level.min_points} sementes acumuladas</span>
                <span className="text-sage font-bold">Faltam {profile.points_needed} sementes!</span>
              </div>
            </div>
          ) : (
            <div className="bg-sage/10 p-6 rounded-2xl border border-sage/20 flex items-center gap-4">
              <span className="text-3xl">👑</span>
              <div>
                <h4 className="font-bold text-sage-dark font-serif text-lg">Sabedoria Suprema Atingida!</h4>
                <p className="text-terra/80 text-sm mt-0.5">Você está no nível máximo do nosso clube. Aproveite 15% de desconto em tudo!</p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Grid of Sections */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-start">
        
        {/* Left Side: Catalog & Offers */}
        <div className="md:col-span-8 space-y-12">
          
          {/* Rewards Catalog */}
          <section>
            <div className="flex items-center gap-2.5 mb-6">
              <div className="p-2 bg-sage/10 rounded-xl text-sage">
                <Gift className="w-5 h-5" />
              </div>
              <h3 className="text-2xl font-bold text-terra font-serif">Catálogo de Recompensas</h3>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
              {rewards.length > 0 ? (
                rewards.map((reward) => {
                  const hasEnough = profile.points_balance >= reward.points_cost;
                  return (
                    <div 
                      key={reward.id} 
                      className={`bg-bege-light border rounded-2xl p-6 flex flex-col justify-between shadow-sm hover:shadow-md transition-all ${
                        hasEnough ? "border-sage/30 bg-white" : "border-bege/80 opacity-90"
                      }`}
                    >
                      <div>
                        <div className="flex justify-between items-start gap-2 mb-3">
                          <span className={`text-xs px-2.5 py-0.5 rounded-full font-bold flex items-center gap-1 ${
                            hasEnough ? "bg-sage/10 text-sage" : "bg-bege-dark/20 text-terra/60"
                          }`}>
                            <Coins className="w-3.5 h-3.5" />
                            {reward.points_cost} sementes
                          </span>
                        </div>
                        <h4 className="font-bold text-terra text-base font-serif mb-1.5">{reward.title}</h4>
                        <p className="text-terra/70 text-xs leading-relaxed mb-6">{reward.description}</p>
                      </div>

                      <Button 
                        variant={hasEnough ? "sage" : "outline"} 
                        className="w-full mt-auto"
                        disabled={!hasEnough}
                        onClick={() => handleRedeem(reward.id, reward.title)}
                      >
                        {hasEnough ? "Resgatar Recompensa" : "Sementes Insuficientes"}
                      </Button>
                    </div>
                  );
                })
              ) : (
                <div className="col-span-2 text-center py-8 text-terra/60 border border-dashed border-bege/80 rounded-2xl">
                  Nenhuma recompensa disponível para resgate no momento.
                </div>
              )}
            </div>
          </section>

          {/* Level Offers (Chamariz Vitrine) */}
          <section>
            <div className="flex items-center gap-2.5 mb-6">
              <div className="p-2 bg-sage/10 rounded-xl text-sage">
                <Sparkles className="w-5 h-5" />
              </div>
              <h3 className="text-2xl font-bold text-terra font-serif">Ofertas Exclusivas por Nível</h3>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
              {offers.length > 0 ? (
                offers.map((offer) => (
                  <div 
                    key={offer.id}
                    className={`bg-bege-light border rounded-2xl p-6 flex flex-col justify-between shadow-sm relative overflow-hidden transition-all ${
                      offer.is_unlocked 
                        ? "border-sage/40 bg-white" 
                        : "border-bege bg-bege/20 opacity-80"
                    }`}
                  >
                    {!offer.is_unlocked && (
                      <div className="absolute top-0 right-0 bg-terra text-bege-light text-xs font-bold py-1 px-3 rounded-bl-xl flex items-center gap-1 z-10 shadow-sm">
                        <Lock className="w-3 h-3" />
                        Nível {offer.level.name}
                      </div>
                    )}
                    {offer.is_unlocked && (
                      <div className="absolute top-0 right-0 bg-sage text-white text-xs font-bold py-1 px-3 rounded-bl-xl flex items-center gap-1 z-10 shadow-sm">
                        <Unlock className="w-3 h-3" />
                        Desbloqueado
                      </div>
                    )}

                    <div>
                      {offer.product.image_path ? (
                        <img 
                          src={`http://localhost:8000/storage/${offer.product.image_path}`}
                          alt={offer.product.name}
                          className="w-full h-32 object-cover rounded-xl mb-4 bg-bege-light"
                        />
                      ) : (
                        <div className="w-full h-32 bg-bege/40 rounded-xl mb-4 flex items-center justify-center text-terra/30">
                          Sem Imagem
                        </div>
                      )}
                      <h4 className="font-bold text-terra text-base font-serif mb-1">{offer.product.name}</h4>
                      <p className="text-terra/60 text-xs leading-relaxed mb-4">{offer.description}</p>
                      
                      <div className="flex items-baseline gap-2 mb-6">
                        <span className="text-sm line-through text-terra/50">R$ {offer.product.price.toFixed(2)}</span>
                        <span className="text-lg font-black text-sage">R$ {Number(offer.special_price).toFixed(2)}</span>
                      </div>
                    </div>

                    {offer.is_unlocked ? (
                      <Button variant="sage" className="w-full" asChild>
                        <Link href={`/produtos`}>Aproveitar Oferta</Link>
                      </Button>
                    ) : (
                      <div className="text-center py-2.5 px-4 bg-bege-dark/15 border border-bege-dark/10 rounded-xl text-xs font-semibold text-terra/70 flex items-center justify-center gap-2">
                        <Info className="w-4 h-4 text-terra/50" />
                        Exclusivo. Requer {offer.points_required} sementes acumuladas.
                      </div>
                    )}
                  </div>
                ))
              ) : (
                <div className="col-span-2 text-center py-8 text-terra/60 border border-dashed border-bege/80 rounded-2xl">
                  Nenhuma oferta especial disponível para o seu nível no momento.
                </div>
              )}
            </div>
          </section>

        </div>

        {/* Right Side: Levels & My Coupons */}
        <div className="md:col-span-4 space-y-12">
          
          {/* Active / Redemptions History */}
          <section className="bg-bege-light border border-bege/60 rounded-3xl p-6 shadow-sm">
            <h3 className="text-lg font-bold text-terra font-serif mb-4 flex items-center gap-2">
              <Gift className="w-5 h-5 text-sage" /> Meus Cupons
            </h3>
            
            <div className="space-y-4 max-h-[280px] overflow-y-auto pr-1">
              {redemptions.length > 0 ? (
                redemptions.map((redemption) => (
                  <div key={redemption.id} className="bg-white border border-bege/50 p-4 rounded-xl flex flex-col gap-2">
                    <div className="flex justify-between items-start">
                      <span className="text-xs font-bold text-terra/80 font-serif leading-tight">
                        {redemption.reward?.title || "Recompensa"}
                      </span>
                    </div>
                    <div className="bg-bege/30 rounded px-2.5 py-1.5 flex justify-between items-center gap-2 border border-bege/20">
                      <span className="font-mono text-xs font-bold text-terra">{redemption.reward_code}</span>
                      <button 
                        onClick={() => copyToClipboard(redemption.reward_code)}
                        className="text-xs text-sage hover:underline font-semibold flex items-center gap-0.5"
                      >
                        {copiedCode === redemption.reward_code ? "Copiado!" : "Copiar"}
                      </button>
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-terra/60 text-xs text-center py-6">Você ainda não resgatou nenhum cupom.</p>
              )}
            </div>
          </section>

          {/* Level List ("Chamariz") */}
          <section className="bg-bege-light border border-bege/60 rounded-3xl p-6 shadow-sm">
            <h3 className="text-lg font-bold text-terra font-serif mb-4 flex items-center gap-2">
              <Award className="w-5 h-5 text-sage" /> Níveis de Cultivo
            </h3>

            <div className="space-y-4">
              {profile.all_levels.map((level) => {
                const isCurrent = profile.current_level.id === level.id;
                const isPast = profile.lifetime_points >= level.min_points;
                
                return (
                  <div 
                    key={level.id} 
                    className={`relative p-4 rounded-2xl border transition-all ${
                      isCurrent 
                        ? "border-sage bg-white shadow-sm ring-1 ring-sage/30" 
                        : isPast 
                          ? "border-bege bg-white/40 opacity-80" 
                          : "border-bege/40 bg-bege/10 opacity-70"
                    }`}
                  >
                    <div className="flex items-start gap-3">
                      <div className="p-2 bg-bege/40 rounded-xl">
                        {getBadgeIcon(level.badge_icon)}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 justify-between">
                          <h4 className="font-bold text-terra text-sm truncate font-serif">{level.name}</h4>
                          {isCurrent && (
                            <span className="bg-sage text-white text-[9px] px-2 py-0.5 rounded-full font-bold">
                              Seu Nível
                            </span>
                          )}
                        </div>
                        <p className="text-terra/60 text-[10px] mt-0.5 leading-relaxed">{level.description}</p>
                        <div className="flex gap-3 mt-2 text-[10px] font-semibold text-terra/80">
                          <span>Requer: {level.min_points} sementes</span>
                          {level.discount_percentage > 0 && (
                            <span className="text-sage">Benefício: {level.discount_percentage}% OFF</span>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </section>

          {/* Point History */}
          <section className="bg-bege-light border border-bege/60 rounded-3xl p-6 shadow-sm">
            <h3 className="text-lg font-bold text-terra font-serif mb-4 flex items-center gap-2">
              <Coins className="w-5 h-5 text-sage" /> Extrato de Sementes
            </h3>

            <div className="space-y-3 max-h-[220px] overflow-y-auto pr-1">
              {history.length > 0 ? (
                history.map((tx) => (
                  <div key={tx.id} className="border-b border-bege/40 pb-2 last:border-0 last:pb-0 flex justify-between items-start gap-4">
                    <div>
                      <p className="text-xs text-terra font-semibold leading-tight">{tx.description}</p>
                      <span className="text-[10px] text-terra/50">
                        {new Date(tx.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "2-digit", year: "2-digit", hour: "2-digit", minute: "2-digit" })}
                      </span>
                    </div>
                    <span className={`text-xs font-bold shrink-0 ${tx.points > 0 ? "text-sage" : "text-red-500"}`}>
                      {tx.points > 0 ? `+${tx.points}` : tx.points}
                    </span>
                  </div>
                ))
              ) : (
                <p className="text-terra/60 text-xs text-center py-6">Nenhuma movimentação de sementes.</p>
              )}
            </div>
          </section>

        </div>
      </div>

    </div>
  );
}
