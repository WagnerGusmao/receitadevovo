<?php

namespace App\Modules\Rewards\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Rewards\Models\LoyaltyLevel;
use App\Modules\Rewards\Models\LoyaltyReward;
use App\Modules\Rewards\Models\LoyaltyRedemption;
use App\Modules\Rewards\Models\LoyaltyTransaction;
use App\Modules\Rewards\Models\LoyaltyOffer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserLoyaltyController extends Controller
{
    /**
     * Get user loyalty dashboard data.
     */
    public function profile(Request $request)
    {
        $user = $request->user();
        
        $currentLevel = $user->loyalty_level;
        $pointsBalance = $user->loyalty_points_balance;
        $lifetimePoints = $user->loyalty_lifetime_points;

        // Find next level
        $nextLevel = LoyaltyLevel::where('min_points', '>', $lifetimePoints)
            ->orderBy('min_points', 'asc')
            ->first();

        $pointsNeeded = 0;
        if ($nextLevel) {
            $pointsNeeded = $nextLevel->min_points - $lifetimePoints;
        }

        // List all levels
        $allLevels = LoyaltyLevel::orderBy('min_points', 'asc')->get();

        return $this->success([
            'points_balance' => $pointsBalance,
            'lifetime_points' => $lifetimePoints,
            'current_level' => $currentLevel,
            'next_level' => $nextLevel,
            'points_needed' => $pointsNeeded,
            'all_levels' => $allLevels,
        ]);
    }

    /**
     * Get loyalty transactions.
     */
    public function history(Request $request)
    {
        $transactions = $request->user()
            ->loyaltyTransactions()
            ->orderBy('created_at', 'desc')
            ->get();

        return $this->success($transactions);
    }

    /**
     * Get redeemable rewards catalog.
     */
    public function catalog(Request $request)
    {
        $rewards = LoyaltyReward::where('is_active', true)->get();
        $userRedemptions = $request->user()->loyaltyRedemptions()->with('reward')->get();

        return $this->success([
            'rewards' => $rewards,
            'redemptions' => $userRedemptions,
        ]);
    }

    /**
     * Redeem a reward coupon.
     */
    public function redeem(Request $request, $rewardId)
    {
        $user = $request->user();
        $reward = LoyaltyReward::where('is_active', true)->findOrFail($rewardId);

        if ($user->loyalty_points_balance < $reward->points_cost) {
            return $this->error("Saldo de sementes insuficiente. Você precisa de {$reward->points_cost} sementes.", 422);
        }

        try {
            $redemption = DB::transaction(function () use ($user, $reward) {
                // Deduct points
                LoyaltyTransaction::create([
                    'user_id' => $user->id,
                    'points' => -$reward->points_cost,
                    'description' => "Resgate da recompensa: {$reward->title}",
                ]);

                // Create redemption
                return LoyaltyRedemption::create([
                    'user_id' => $user->id,
                    'loyalty_reward_id' => $reward->id,
                    'reward_code' => $reward->reward_code,
                ]);
            });

            return $this->success($redemption, "Cupom resgatado com sucesso! Use o código {$reward->reward_code} em sua próxima compra.", 201);
        } catch (\Exception $e) {
            return $this->error("Erro ao realizar o resgate.", 500);
        }
    }

    /**
     * Get level-specific offers.
     */
    public function offers(Request $request)
    {
        $user = $request->user();
        $userLifetimePoints = $user->loyalty_lifetime_points;

        $offers = LoyaltyOffer::with(['product', 'level'])
            ->where('is_active', true)
            ->get()
            ->map(function ($offer) use ($userLifetimePoints) {
                $isUnlocked = $userLifetimePoints >= $offer->level->min_points;
                return [
                    'id' => $offer->id,
                    'product' => $offer->product,
                    'level' => $offer->level,
                    'special_price' => $offer->special_price,
                    'description' => $offer->description,
                    'is_unlocked' => $isUnlocked,
                    'points_required' => $offer->level->min_points,
                ];
            });

        return $this->success($offers);
    }
}
