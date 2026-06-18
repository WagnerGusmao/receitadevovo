"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { 
  Award, 
  Gift, 
  Sparkles, 
  Plus, 
  Edit2, 
  Trash2, 
  Check, 
  X,
  Coins,
  Percent,
  ChevronRight
} from "lucide-react";

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

interface LoyaltyOffer {
  id: number;
  product_id: number;
  loyalty_level_id: number;
  special_price: number;
  description: string;
  is_active: boolean;
  product?: {
    id: number;
    name: string;
    price: number;
  };
  level?: LoyaltyLevel;
}

interface Product {
  id: number;
  name: string;
  price: number;
}

export default function AdminLoyaltyPage() {
  const [activeTab, setActiveTab] = useState<"levels" | "rewards" | "offers">("levels");
  
  const [levels, setLevels] = useState<LoyaltyLevel[]>([]);
  const [rewards, setRewards] = useState<LoyaltyReward[]>([]);
  const [offers, setOffers] = useState<LoyaltyOffer[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  
  const [loading, setLoading] = useState(true);

  // Forms states
  const [isLevelModalOpen, setIsLevelModalOpen] = useState(false);
  const [selectedLevel, setSelectedLevel] = useState<LoyaltyLevel | null>(null);
  const [levelForm, setLevelForm] = useState({
    name: "",
    min_points: 0,
    discount_percentage: 0,
    badge_icon: "seed",
    description: ""
  });

  const [isRewardModalOpen, setIsRewardModalOpen] = useState(false);
  const [selectedReward, setSelectedReward] = useState<LoyaltyReward | null>(null);
  const [rewardForm, setRewardForm] = useState({
    title: "",
    description: "",
    points_cost: 50,
    reward_code: "",
    is_active: true
  });

  const [isOfferModalOpen, setIsOfferModalOpen] = useState(false);
  const [selectedOffer, setSelectedOffer] = useState<LoyaltyOffer | null>(null);
  const [offerForm, setOfferForm] = useState({
    product_id: "",
    loyalty_level_id: "",
    special_price: "",
    description: "",
    is_active: true
  });

  const loadData = async () => {
    try {
      setLoading(true);
      const [levelsRes, rewardsRes, offersRes, productsRes] = await Promise.all([
        apiFetch("/rewards/admin/levels"),
        apiFetch("/rewards/admin/catalog"),
        apiFetch("/rewards/admin/offers"),
        apiFetch("/ecommerce/products") // fetch all products
      ]);

      if (levelsRes.success) setLevels(levelsRes.data);
      if (rewardsRes.success) setRewards(rewardsRes.data);
      if (offersRes.success) setOffers(offersRes.data);
      if (productsRes.success) setProducts(productsRes.data.products || []);
    } catch (err) {
      console.error("Erro ao carregar dados do admin de fidelidade:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // CRUD Níveis
  const handleOpenLevelModal = (level?: LoyaltyLevel) => {
    if (level) {
      setSelectedLevel(level);
      setLevelForm({
        name: level.name,
        min_points: level.min_points,
        discount_percentage: Number(level.discount_percentage),
        badge_icon: level.badge_icon,
        description: level.description || ""
      });
    } else {
      setSelectedLevel(null);
      setLevelForm({
        name: "",
        min_points: 0,
        discount_percentage: 0,
        badge_icon: "seed",
        description: ""
      });
    }
    setIsLevelModalOpen(true);
  };

  const handleSaveLevel = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = selectedLevel 
        ? `/rewards/admin/levels/${selectedLevel.id}` 
        : "/rewards/admin/levels";
      const method = selectedLevel ? "PUT" : "POST";

      const res = await apiFetch(url, {
        method,
        body: JSON.stringify(levelForm)
      });

      if (res.success) {
        setIsLevelModalOpen(false);
        loadData();
      } else {
        alert(res.message || "Erro ao salvar nível.");
      }
    } catch (err) {
      console.error(err);
      alert("Erro ao processar requisição.");
    }
  };

  const handleDeleteLevel = async (id: number) => {
    if (!confirm("Deseja mesmo excluir este nível?")) return;
    try {
      const res = await apiFetch(`/rewards/admin/levels/${id}`, { method: "DELETE" });
      if (res.success) {
        loadData();
      } else {
        alert(res.message || "Erro ao excluir nível.");
      }
    } catch (err) {
      console.error(err);
    }
  };

  // CRUD Recompensas
  const handleOpenRewardModal = (reward?: LoyaltyReward) => {
    if (reward) {
      setSelectedReward(reward);
      setRewardForm({
        title: reward.title,
        description: reward.description || "",
        points_cost: reward.points_cost,
        reward_code: reward.reward_code,
        is_active: reward.is_active
      });
    } else {
      setSelectedReward(null);
      setRewardForm({
        title: "",
        description: "",
        points_cost: 100,
        reward_code: "",
        is_active: true
      });
    }
    setIsRewardModalOpen(true);
  };

  const handleSaveReward = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = selectedReward 
        ? `/rewards/admin/catalog/${selectedReward.id}` 
        : "/rewards/admin/catalog";
      const method = selectedReward ? "PUT" : "POST";

      const res = await apiFetch(url, {
        method,
        body: JSON.stringify(rewardForm)
      });

      if (res.success) {
        setIsRewardModalOpen(false);
        loadData();
      } else {
        alert(res.message || "Erro ao salvar recompensa.");
      }
    } catch (err) {
      console.error(err);
    }
  };

  const handleDeleteReward = async (id: number) => {
    if (!confirm("Deseja mesmo excluir esta recompensa?")) return;
    try {
      const res = await apiFetch(`/rewards/admin/catalog/${id}`, { method: "DELETE" });
      if (res.success) {
        loadData();
      } else {
        alert(res.message);
      }
    } catch (err) {
      console.error(err);
    }
  };

  // CRUD Ofertas de Nível
  const handleOpenOfferModal = (offer?: LoyaltyOffer) => {
    if (offer) {
      setSelectedOffer(offer);
      setOfferForm({
        product_id: String(offer.product_id),
        loyalty_level_id: String(offer.loyalty_level_id),
        special_price: String(offer.special_price),
        description: offer.description || "",
        is_active: offer.is_active
      });
    } else {
      setSelectedOffer(null);
      setOfferForm({
        product_id: products[0]?.id ? String(products[0].id) : "",
        loyalty_level_id: levels[0]?.id ? String(levels[0].id) : "",
        special_price: "",
        description: "",
        is_active: true
      });
    }
    setIsOfferModalOpen(true);
  };

  const handleSaveOffer = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const url = selectedOffer 
        ? `/rewards/admin/offers/${selectedOffer.id}` 
        : "/rewards/admin/offers";
      const method = selectedOffer ? "PUT" : "POST";

      const res = await apiFetch(url, {
        method,
        body: JSON.stringify(offerForm)
      });

      if (res.success) {
        setIsOfferModalOpen(false);
        loadData();
      } else {
        alert(res.message || "Erro ao salvar oferta.");
      }
    } catch (err) {
      console.error(err);
    }
  };

  const handleDeleteOffer = async (id: number) => {
    if (!confirm("Deseja mesmo remover esta oferta?")) return;
    try {
      const res = await apiFetch(`/rewards/admin/offers/${id}`, { method: "DELETE" });
      if (res.success) {
        loadData();
      } else {
        alert(res.message);
      }
    } catch (err) {
      console.error(err);
    }
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px] gap-4">
        <div className="w-10 h-10 border-4 border-sage border-t-transparent rounded-full animate-spin"></div>
        <p className="text-terra/70 font-medium">Buscando configurações do programa de fidelidade...</p>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-5xl">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold text-terra font-serif">Gerenciamento do Clube de Fidelidade</h1>
          <p className="text-terra/70 text-sm">Personalize níveis, cupons de recompensa e ofertas de fidelidade dos clientes.</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-bege/80 mb-8 gap-4">
        <button
          onClick={() => setActiveTab("levels")}
          className={`pb-3 text-sm font-semibold border-b-2 px-1 transition-all ${
            activeTab === "levels" ? "border-sage text-sage" : "border-transparent text-terra/60 hover:text-terra"
          }`}
        >
          Níveis de Fidelidade
        </button>
        <button
          onClick={() => setActiveTab("rewards")}
          className={`pb-3 text-sm font-semibold border-b-2 px-1 transition-all ${
            activeTab === "rewards" ? "border-sage text-sage" : "border-transparent text-terra/60 hover:text-terra"
          }`}
        >
          Catálogo de Recompensas
        </button>
        <button
          onClick={() => setActiveTab("offers")}
          className={`pb-3 text-sm font-semibold border-b-2 px-1 transition-all ${
            activeTab === "offers" ? "border-sage text-sage" : "border-transparent text-terra/60 hover:text-terra"
          }`}
        >
          Ofertas Especiais (Nível)
        </button>
      </div>

      {/* 1. LEVELS TAB */}
      {activeTab === "levels" && (
        <div className="space-y-6">
          <div className="flex justify-between items-center">
            <h3 className="text-xl font-bold text-terra font-serif flex items-center gap-2">
              <Award className="w-5 h-5 text-sage" /> Níveis de Cultivo
            </h3>
            <Button variant="sage" className="flex items-center gap-1.5" onClick={() => handleOpenLevelModal()}>
              <Plus className="w-4 h-4" /> Novo Nível
            </Button>
          </div>

          <div className="bg-white border border-bege/60 rounded-2xl overflow-hidden shadow-sm">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-bege-light border-b border-bege text-terra/70 text-xs font-bold uppercase">
                  <th className="p-4">Nível</th>
                  <th className="p-4">Pontos Mínimos</th>
                  <th className="p-4">Desconto</th>
                  <th className="p-4">Ícone</th>
                  <th className="p-4 text-right">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-bege/35 text-sm text-terra">
                {levels.map((level) => (
                  <tr key={level.id} className="hover:bg-bege-light/30">
                    <td className="p-4 font-bold">{level.name}</td>
                    <td className="p-4">{level.min_points} sementes</td>
                    <td className="p-4 text-sage font-semibold">{level.discount_percentage}% OFF</td>
                    <td className="p-4">
                      {level.badge_icon === "seed" && "🌱"}
                      {level.badge_icon === "leaf" && "🌿"}
                      {level.badge_icon === "flower" && "🌸"}
                      {level.badge_icon === "tree" && "🌳"}
                    </td>
                    <td className="p-4 text-right flex justify-end gap-2">
                      <Button variant="ghostSage" size="icon" onClick={() => handleOpenLevelModal(level)}>
                        <Edit2 className="w-4 h-4" />
                      </Button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="text-red-500 hover:text-red-700 hover:bg-red-50"
                        disabled={level.min_points === 0}
                        onClick={() => handleDeleteLevel(level.id)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 2. REWARDS TAB */}
      {activeTab === "rewards" && (
        <div className="space-y-6">
          <div className="flex justify-between items-center">
            <h3 className="text-xl font-bold text-terra font-serif flex items-center gap-2">
              <Gift className="w-5 h-5 text-sage" /> Cupons de Resgate
            </h3>
            <Button variant="sage" className="flex items-center gap-1.5" onClick={() => handleOpenRewardModal()}>
              <Plus className="w-4 h-4" /> Nova Recompensa
            </Button>
          </div>

          <div className="bg-white border border-bege/60 rounded-2xl overflow-hidden shadow-sm">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-bege-light border-b border-bege text-terra/70 text-xs font-bold uppercase">
                  <th className="p-4">Título</th>
                  <th className="p-4">Custo em Sementes</th>
                  <th className="p-4">Código do Cupom</th>
                  <th className="p-4">Status</th>
                  <th className="p-4 text-right">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-bege/35 text-sm text-terra">
                {rewards.map((reward) => (
                  <tr key={reward.id} className="hover:bg-bege-light/30">
                    <td className="p-4">
                      <p className="font-bold">{reward.title}</p>
                      <p className="text-xs text-terra/60">{reward.description}</p>
                    </td>
                    <td className="p-4 font-semibold text-sage">{reward.points_cost} sementes</td>
                    <td className="p-4 font-mono font-bold tracking-wider">{reward.reward_code}</td>
                    <td className="p-4">
                      <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                        reward.is_active ? "bg-sage/10 text-sage border border-sage/20" : "bg-red-100 text-red-700"
                      }`}>
                        {reward.is_active ? "Ativo" : "Inativo"}
                      </span>
                    </td>
                    <td className="p-4 text-right flex justify-end gap-2">
                      <Button variant="ghostSage" size="icon" onClick={() => handleOpenRewardModal(reward)}>
                        <Edit2 className="w-4 h-4" />
                      </Button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="text-red-500 hover:text-red-700 hover:bg-red-50"
                        onClick={() => handleDeleteReward(reward.id)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 3. OFFERS TAB */}
      {activeTab === "offers" && (
        <div className="space-y-6">
          <div className="flex justify-between items-center">
            <h3 className="text-xl font-bold text-terra font-serif flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-sage" /> Preços Especiais por Nível
            </h3>
            <Button variant="sage" className="flex items-center gap-1.5" onClick={() => handleOpenOfferModal()}>
              <Plus className="w-4 h-4" /> Nova Oferta de Nível
            </Button>
          </div>

          <div className="bg-white border border-bege/60 rounded-2xl overflow-hidden shadow-sm">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-bege-light border-b border-bege text-terra/70 text-xs font-bold uppercase">
                  <th className="p-4">Produto</th>
                  <th className="p-4">Nível Exigido</th>
                  <th className="p-4">Preço Original</th>
                  <th className="p-4">Preço de Nível</th>
                  <th className="p-4">Status</th>
                  <th className="p-4 text-right">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-bege/35 text-sm text-terra">
                {offers.map((offer) => (
                  <tr key={offer.id} className="hover:bg-bege-light/30">
                    <td className="p-4 font-bold">{offer.product?.name || "Produto Desconhecido"}</td>
                    <td className="p-4 text-sage font-semibold">{offer.level?.name || "Qualquer"}</td>
                    <td className="p-4 text-terra/60 line-through">R$ {Number(offer.product?.price || 0).toFixed(2)}</td>
                    <td className="p-4 text-sage font-black">R$ {Number(offer.special_price).toFixed(2)}</td>
                    <td className="p-4">
                      <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                        offer.is_active ? "bg-sage/10 text-sage border border-sage/20" : "bg-red-100 text-red-700"
                      }`}>
                        {offer.is_active ? "Ativo" : "Inativo"}
                      </span>
                    </td>
                    <td className="p-4 text-right flex justify-end gap-2">
                      <Button variant="ghostSage" size="icon" onClick={() => handleOpenOfferModal(offer)}>
                        <Edit2 className="w-4 h-4" />
                      </Button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="text-red-500 hover:text-red-700 hover:bg-red-50"
                        onClick={() => handleDeleteOffer(offer.id)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* LEVEL FORM MODAL */}
      {isLevelModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <form onSubmit={handleSaveLevel} className="bg-white border-2 border-sage/35 p-6 rounded-2xl max-w-md w-full shadow-xl">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-xl font-bold font-serif text-terra">
                {selectedLevel ? "Editar Nível" : "Criar Nível"}
              </h3>
              <button type="button" onClick={() => setIsLevelModalOpen(false)} className="text-terra/50 hover:text-terra">
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Nome do Nível</label>
                <Input 
                  required
                  value={levelForm.name} 
                  onChange={(e) => setLevelForm({...levelForm, name: e.target.value})}
                  placeholder="Ex: Brotinho de Hortelã" 
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-xs font-semibold text-terra uppercase block mb-1">Sementes Mínimas</label>
                  <Input 
                    type="number" 
                    required
                    min={0}
                    value={levelForm.min_points} 
                    onChange={(e) => setLevelForm({...levelForm, min_points: Number(e.target.value)})}
                  />
                </div>
                <div>
                  <label className="text-xs font-semibold text-terra uppercase block mb-1">Desconto (%)</label>
                  <Input 
                    type="number" 
                    required
                    min={0}
                    max={100}
                    value={levelForm.discount_percentage} 
                    onChange={(e) => setLevelForm({...levelForm, discount_percentage: Number(e.target.value)})}
                  />
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Ícone</label>
                <select 
                  className="w-full bg-white border border-bege rounded-lg p-2.5 text-sm text-terra"
                  value={levelForm.badge_icon}
                  onChange={(e) => setLevelForm({...levelForm, badge_icon: e.target.value})}
                >
                  <option value="seed">🌱 Semente (Seed)</option>
                  <option value="leaf">🌿 Folha (Leaf)</option>
                  <option value="flower">🌸 Flor (Flower)</option>
                  <option value="tree">🌳 Árvore (Tree)</option>
                </select>
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Descrição</label>
                <textarea 
                  className="w-full bg-white border border-bege rounded-lg p-2.5 text-sm text-terra h-20 resize-none"
                  value={levelForm.description}
                  onChange={(e) => setLevelForm({...levelForm, description: e.target.value})}
                  placeholder="Explique os benefícios deste nível..."
                />
              </div>
            </div>

            <div className="flex gap-3 justify-end mt-6">
              <Button type="button" variant="outline" onClick={() => setIsLevelModalOpen(false)}>Cancelar</Button>
              <Button type="submit" variant="sage">Salvar Nível</Button>
            </div>
          </form>
        </div>
      )}

      {/* REWARD FORM MODAL */}
      {isRewardModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <form onSubmit={handleSaveReward} className="bg-white border-2 border-sage/35 p-6 rounded-2xl max-w-md w-full shadow-xl">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-xl font-bold font-serif text-terra">
                {selectedReward ? "Editar Recompensa" : "Nova Recompensa"}
              </h3>
              <button type="button" onClick={() => setIsRewardModalOpen(false)} className="text-terra/50 hover:text-terra">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Título da Recompensa</label>
                <Input 
                  required
                  value={rewardForm.title} 
                  onChange={(e) => setRewardForm({...rewardForm, title: e.target.value})}
                  placeholder="Ex: Cupom de R$ 15 de Desconto" 
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-xs font-semibold text-terra uppercase block mb-1">Sementes Exigidas</label>
                  <Input 
                    type="number" 
                    required
                    min={1}
                    value={rewardForm.points_cost} 
                    onChange={(e) => setRewardForm({...rewardForm, points_cost: Number(e.target.value)})}
                  />
                </div>
                <div>
                  <label className="text-xs font-semibold text-terra uppercase block mb-1">Código do Cupom</label>
                  <Input 
                    required
                    value={rewardForm.reward_code} 
                    onChange={(e) => setRewardForm({...rewardForm, reward_code: e.target.value})}
                    placeholder="Ex: HORTELA15" 
                  />
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Descrição</label>
                <textarea 
                  className="w-full bg-white border border-bege rounded-lg p-2.5 text-sm text-terra h-20 resize-none"
                  value={rewardForm.description}
                  onChange={(e) => setRewardForm({...rewardForm, description: e.target.value})}
                  placeholder="Descreva as condições ou o prêmio..."
                />
              </div>

              <div className="flex items-center gap-2">
                <input 
                  type="checkbox" 
                  id="reward_active"
                  checked={rewardForm.is_active}
                  onChange={(e) => setRewardForm({...rewardForm, is_active: e.target.checked})}
                />
                <label htmlFor="reward_active" className="text-xs font-semibold text-terra uppercase cursor-pointer">
                  Disponível para Resgate (Ativo)
                </label>
              </div>
            </div>

            <div className="flex gap-3 justify-end mt-6">
              <Button type="button" variant="outline" onClick={() => setIsRewardModalOpen(false)}>Cancelar</Button>
              <Button type="submit" variant="sage">Salvar Recompensa</Button>
            </div>
          </form>
        </div>
      )}

      {/* OFFER FORM MODAL */}
      {isOfferModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <form onSubmit={handleSaveOffer} className="bg-white border-2 border-sage/35 p-6 rounded-2xl max-w-md w-full shadow-xl">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-xl font-bold font-serif text-terra">
                {selectedOffer ? "Editar Oferta" : "Nova Oferta"}
              </h3>
              <button type="button" onClick={() => setIsOfferModalOpen(false)} className="text-terra/50 hover:text-terra">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Selecione o Produto</label>
                <select 
                  className="w-full bg-white border border-bege rounded-lg p-2.5 text-sm text-terra"
                  value={offerForm.product_id}
                  onChange={(e) => setOfferForm({...offerForm, product_id: e.target.value})}
                >
                  {products.map(p => (
                    <option key={p.id} value={p.id}>{p.name} - R$ {Number(p.price).toFixed(2)}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Nível Mínimo para Desbloquear</label>
                <select 
                  className="w-full bg-white border border-bege rounded-lg p-2.5 text-sm text-terra"
                  value={offerForm.loyalty_level_id}
                  onChange={(e) => setOfferForm({...offerForm, loyalty_level_id: e.target.value})}
                >
                  {levels.map(l => (
                    <option key={l.id} value={l.id}>{l.name} (min {l.min_points} sementes)</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Preço Especial (R$)</label>
                <Input 
                  type="number"
                  step="0.01"
                  required
                  value={offerForm.special_price} 
                  onChange={(e) => setOfferForm({...offerForm, special_price: e.target.value})}
                  placeholder="Ex: 24.90" 
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-terra uppercase block mb-1">Chamada Promocional (Descrição)</label>
                <Input 
                  value={offerForm.description} 
                  onChange={(e) => setOfferForm({...offerForm, description: e.target.value})}
                  placeholder="Ex: Oferta exclusiva para o outono" 
                />
              </div>

              <div className="flex items-center gap-2">
                <input 
                  type="checkbox" 
                  id="offer_active"
                  checked={offerForm.is_active}
                  onChange={(e) => setOfferForm({...offerForm, is_active: e.target.checked})}
                />
                <label htmlFor="offer_active" className="text-xs font-semibold text-terra uppercase cursor-pointer">
                  Oferta Ativa (Visível na loja)
                </label>
              </div>
            </div>

            <div className="flex gap-3 justify-end mt-6">
              <Button type="button" variant="outline" onClick={() => setIsOfferModalOpen(false)}>Cancelar</Button>
              <Button type="submit" variant="sage">Salvar Oferta</Button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
