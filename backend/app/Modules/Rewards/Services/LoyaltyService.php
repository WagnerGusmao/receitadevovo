<?php

namespace App\Modules\Rewards\Services;

use App\Modules\Ecommerce\Models\Order;
use App\Modules\Rewards\Models\LoyaltyTransaction;

class LoyaltyService
{
    /**
     * Award points to a user when their order is delivered.
     */
    public function awardPointsForOrder(Order $order): void
    {
        // Calculate points based on total (floor of total)
        $points = (int) floor($order->total);

        if ($points <= 0) {
            return;
        }

        // Check if points were already awarded to prevent duplicates
        $exists = LoyaltyTransaction::where('order_id', $order->id)
            ->where('points', '>', 0)
            ->exists();

        if ($exists) {
            return;
        }

        LoyaltyTransaction::create([
            'user_id' => $order->user_id,
            'order_id' => $order->id,
            'points' => $points,
            'description' => "Sementes acumuladas no ritual de compra #{$order->order_number}",
        ]);
    }

    /**
     * Deduct points if a delivered order gets cancelled.
     */
    public function deductPointsForCancelledOrder(Order $order): void
    {
        // Check if points were awarded
        $awardedTransaction = LoyaltyTransaction::where('order_id', $order->id)
            ->where('points', '>', 0)
            ->first();

        if (!$awardedTransaction) {
            return;
        }

        // Check if deduction was already made
        $deductedExists = LoyaltyTransaction::where('order_id', $order->id)
            ->where('points', '<', 0)
            ->exists();

        if ($deductedExists) {
            return;
        }

        LoyaltyTransaction::create([
            'user_id' => $order->user_id,
            'order_id' => $order->id,
            'points' => -$awardedTransaction->points,
            'description' => "Estorno de sementes devido ao cancelamento do ritual #{$order->order_number}",
        ]);
    }
}
