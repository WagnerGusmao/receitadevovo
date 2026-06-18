<?php

namespace App\Modules\Rewards\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Rewards\Models\LoyaltyLevel;
use App\Modules\Rewards\Models\LoyaltyReward;
use App\Modules\Rewards\Models\LoyaltyOffer;
use Illuminate\Http\Request;

class AdminLoyaltyController extends Controller
{
    // ==========================================
    // CRUD NÍVEIS DE FIDELIDADE (LoyaltyLevel)
    // ==========================================

    public function listLevels()
    {
        $levels = LoyaltyLevel::orderBy('min_points', 'asc')->get();
        return $this->success($levels);
    }

    public function storeLevel(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'min_points' => 'required|integer|min:0|unique:loyalty_levels,min_points',
            'discount_percentage' => 'required|numeric|min:0|max:100',
            'badge_icon' => 'required|string|max:255',
            'description' => 'nullable|string',
        ], [
            'min_points.unique' => 'Já existe um nível configurado com esta pontuação mínima.',
        ]);

        $level = LoyaltyLevel::create($validated);
        return $this->success($level, 'Nível de fidelidade criado com sucesso', 201);
    }

    public function updateLevel(Request $request, $id)
    {
        $level = LoyaltyLevel::findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'min_points' => 'sometimes|required|integer|min:0|unique:loyalty_levels,min_points,' . $level->id,
            'discount_percentage' => 'sometimes|required|numeric|min:0|max:100',
            'badge_icon' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $level->update($validated);
        return $this->success($level, 'Nível de fidelidade atualizado com sucesso');
    }

    public function destroyLevel($id)
    {
        $level = LoyaltyLevel::findOrFail($id);

        // Prevent deleting the base level (0 points) to avoid breaking user logic
        if ($level->min_points === 0) {
            return $this->error('O nível inicial (0 pontos) não pode ser excluído.', 400);
        }

        $level->delete();
        return $this->success([], 'Nível de fidelidade excluído com sucesso');
    }

    // ==========================================
    // CRUD RECOMPENSAS (LoyaltyReward)
    // ==========================================

    public function listRewards()
    {
        $rewards = LoyaltyReward::orderBy('points_cost', 'asc')->get();
        return $this->success($rewards);
    }

    public function storeReward(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'points_cost' => 'required|integer|min:1',
            'reward_code' => 'required|string|max:50',
            'is_active' => 'boolean',
        ]);

        $reward = LoyaltyReward::create($validated);
        return $this->success($reward, 'Recompensa criada com sucesso', 201);
    }

    public function updateReward(Request $request, $id)
    {
        $reward = LoyaltyReward::findOrFail($id);

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'points_cost' => 'sometimes|required|integer|min:1',
            'reward_code' => 'sometimes|required|string|max:50',
            'is_active' => 'boolean',
        ]);

        $reward->update($validated);
        return $this->success($reward, 'Recompensa atualizada com sucesso');
    }

    public function destroyReward($id)
    {
        $reward = LoyaltyReward::findOrFail($id);
        $reward->delete();
        return $this->success([], 'Recompensa excluída com sucesso');
    }

    // ==========================================
    // CRUD OFERTAS DE NÍVEL (LoyaltyOffer)
    // ==========================================

    public function listOffers()
    {
        $offers = LoyaltyOffer::with(['product', 'level'])->get();
        return $this->success($offers);
    }

    public function storeOffer(Request $request)
    {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'loyalty_level_id' => 'required|exists:loyalty_levels,id',
            'special_price' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $offer = LoyaltyOffer::create($validated);
        return $this->success($offer->load(['product', 'level']), 'Oferta de nível criada com sucesso', 201);
    }

    public function updateOffer(Request $request, $id)
    {
        $offer = LoyaltyOffer::findOrFail($id);

        $validated = $request->validate([
            'product_id' => 'sometimes|required|exists:products,id',
            'loyalty_level_id' => 'sometimes|required|exists:loyalty_levels,id',
            'special_price' => 'sometimes|required|numeric|min:0',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $offer->update($validated);
        return $this->success($offer->load(['product', 'level']), 'Oferta de nível atualizada com sucesso');
    }

    public function destroyOffer($id)
    {
        $offer = LoyaltyOffer::findOrFail($id);
        $offer->delete();
        return $this->success([], 'Oferta de nível excluída com sucesso');
    }
}
