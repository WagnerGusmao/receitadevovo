<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Rewards\Models\LoyaltyLevel;
use App\Modules\Rewards\Models\LoyaltyTransaction;
use App\Modules\Rewards\Models\LoyaltyReward;
use App\Modules\Rewards\Models\LoyaltyRedemption;
use Database\Seeders\LoyaltySeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LoyaltySystemTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        // Seed standard loyalty levels
        $this->seed(LoyaltySeeder::class);
    }

    public function test_user_starts_at_base_level()
    {
        $user = User::create([
            'name' => 'Alice Client',
            'email' => 'alice@test.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
        ]);

        $this->assertEquals(0, $user->loyalty_points_balance);
        $this->assertEquals(0, $user->loyalty_lifetime_points);
        $this->assertNotNull($user->loyalty_level);
        $this->assertEquals('Semente de Alecrim', $user->loyalty_level->name);
    }

    public function test_points_are_awarded_on_order_delivery()
    {
        $user = User::create([
            'name' => 'Alice Client',
            'email' => 'alice@test.com',
            'password' => bcrypt('password123'),
            'is_admin' => true,
            'whatsapp' => '11999999999',
        ]);

        $order = Order::create([
            'user_id' => $user->id,
            'order_number' => 'ORD-12345678',
            'total' => 250.75,
            'shipping_address' => 'Rua Teste, 123',
            'payment_method' => 'pix',
            'status' => 'pending',
        ]);

        // Award points by changing status to delivered
        $this->actingAs($user)
            ->patchJson("/api/ecommerce/orders/{$order->id}/status", [
                'status' => 'delivered',
            ])
            ->assertStatus(200);

        // Verify points
        $user->refresh();
        $this->assertEquals(250, $user->loyalty_points_balance);
        $this->assertEquals(250, $user->loyalty_lifetime_points);

        // Verify level upgrade to Brotinho de Hortelã (needs >= 200 points)
        $this->assertEquals('Brotinho de Hortelã', $user->loyalty_level->name);
    }

    public function test_points_are_deducted_when_delivered_order_is_cancelled()
    {
        $user = User::create([
            'name' => 'Alice Client',
            'email' => 'alice@test.com',
            'password' => bcrypt('password123'),
            'is_admin' => true,
            'whatsapp' => '11999999999',
        ]);

        $order = Order::create([
            'user_id' => $user->id,
            'order_number' => 'ORD-12345678',
            'total' => 250.00,
            'shipping_address' => 'Rua Teste, 123',
            'payment_method' => 'pix',
            'status' => 'delivered',
        ]);

        // First award points
        app(\App\Modules\Rewards\Services\LoyaltyService::class)->awardPointsForOrder($order);
        $this->assertEquals(250, $user->loyalty_points_balance);

        // Cancel order
        $this->actingAs($user)
            ->patchJson("/api/ecommerce/orders/{$order->id}/status", [
                'status' => 'cancelled',
            ])
            ->assertStatus(200);

        // Verify estorno
        $user->refresh();
        $this->assertEquals(0, $user->loyalty_points_balance);
        $this->assertCount(2, $user->loyaltyTransactions);
    }

    public function test_level_discount_applies_on_checkout()
    {
        $user = User::create([
            'name' => 'Alice Client',
            'email' => 'alice@test.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
        ]);

        // Manually add points to user to make them "Brotinho de Hortelã" (5% discount)
        LoyaltyTransaction::create([
            'user_id' => $user->id,
            'points' => 300,
            'description' => 'Pontos manuais de teste',
        ]);

        $this->assertEquals('Brotinho de Hortelã', $user->loyalty_level->name);

        $product = Product::create([
            'name' => 'Chá de Lavanda',
            'price' => 100.00,
            'stock' => 10,
            'is_active' => true,
            'description' => 'Chá delicioso',
        ]);

        // Place order
        $response = $this->actingAs($user)
            ->postJson('/api/ecommerce/orders', [
                'items' => [
                    [
                        'id' => $product->id,
                        'type' => 'product',
                        'quantity' => 1,
                    ],
                ],
                'shipping_address' => 'Rua Teste, 123',
                'payment_method' => 'pix',
            ]);

        $response->assertStatus(201);
        
        // Verify discount: 100.00 - 5% = 95.00
        $order = Order::findOrFail($response->json('data.id'));
        $this->assertEquals(95.00, $order->total);
    }

    public function test_redeem_rewards()
    {
        $user = User::create([
            'name' => 'Alice Client',
            'email' => 'alice@test.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
        ]);

        // Grant points
        LoyaltyTransaction::create([
            'user_id' => $user->id,
            'points' => 200,
            'description' => 'Bônus',
        ]);

        $reward = LoyaltyReward::create([
            'title' => 'Cupom de Desconto R$ 10',
            'description' => 'Desconto extra',
            'points_cost' => 150,
            'reward_code' => 'COUPON150',
            'is_active' => true,
        ]);

        // Redeem reward
        $response = $this->actingAs($user)
            ->postJson("/api/rewards/redeem/{$reward->id}")
            ->assertStatus(201);

        $this->assertEquals('COUPON150', $response->json('data.reward_code'));

        $user->refresh();
        $this->assertEquals(50, $user->loyalty_points_balance);
        $this->assertEquals(200, $user->loyalty_lifetime_points); // Lifetime points remains 200
    }
}
