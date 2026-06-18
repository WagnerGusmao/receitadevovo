<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\Category;
use Database\Seeders\LoyaltySeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CounterOrderTest extends TestCase
{
    use RefreshDatabase;

    private $admin;
    private $customer;
    private $product;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(LoyaltySeeder::class);

        $this->admin = User::create([
            'name'     => 'Admin',
            'email'    => 'admin@test.com',
            'password' => bcrypt('password'),
            'whatsapp' => '11999990000',
            'is_admin' => true,
        ]);

        $this->customer = User::create([
            'name'     => 'Cliente',
            'email'    => 'cliente@test.com',
            'password' => bcrypt('password'),
            'whatsapp' => '11888880000',
        ]);

        $this->product = Product::create([
            'name'        => 'Chá de Camomila',
            'slug'        => 'cha-de-camomila-test',
            'description' => 'Produto de teste',
            'price'       => 25.00,
            'stock'       => 50,
            'is_active'   => true,
        ]);
    }

    public function test_admin_can_create_counter_order_with_registered_customer()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'user_id'        => $this->customer->id,
                'payment_method' => 'pix',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 2],
                ],
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.source', 'counter')
            ->assertJsonPath('data.status', 'delivered');

        $this->assertDatabaseHas('orders', [
            'user_id' => $this->customer->id,
            'source'  => 'counter',
            'status'  => 'delivered',
            'total'   => 50.00,
        ]);

        // Estoque foi deduzido
        $this->assertEquals(48, $this->product->fresh()->stock);

        // Pontos foram creditados imediatamente
        $this->customer->refresh();
        $this->assertGreaterThan(0, $this->customer->loyalty_points_balance);
    }

    public function test_admin_can_create_counter_order_with_anonymous_customer()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'customer_name'  => 'Maria da Feira',
                'customer_phone' => '11777770000',
                'payment_method' => 'dinheiro',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1],
                ],
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.customer_name', 'Maria da Feira')
            ->assertJsonPath('data.source', 'counter');

        $this->assertDatabaseHas('orders', [
            'customer_name'  => 'Maria da Feira',
            'customer_phone' => '11777770000',
            'source'         => 'counter',
        ]);
    }

    public function test_counter_order_applies_manual_discount()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'customer_name'   => 'Cliente Especial',
                'payment_method'  => 'cartao_debito',
                'discount_amount' => 5.00,
                'items'           => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1],
                ],
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.total', 20.00)      // 25 - 5 = 20
            ->assertJsonPath('data.discount_amount', 5.00);
    }

    public function test_counter_order_fails_without_customer_info()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'payment_method' => 'pix',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1],
                ],
            ]);

        $response->assertStatus(422);
    }

    public function test_counter_order_fails_with_insufficient_stock()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'customer_name'  => 'Cliente',
                'payment_method' => 'pix',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 999],
                ],
            ]);

        $response->assertStatus(422);
        // Estoque não deve ter sido alterado
        $this->assertEquals(50, $this->product->fresh()->stock);
    }

    public function test_non_admin_cannot_create_counter_order()
    {
        $response = $this->actingAs($this->customer)
            ->postJson('/api/ecommerce/counter-orders', [
                'customer_name'  => 'Cliente',
                'payment_method' => 'pix',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1],
                ],
            ]);

        $response->assertStatus(403);
    }

    public function test_counter_order_number_starts_with_bal()
    {
        $response = $this->actingAs($this->admin)
            ->postJson('/api/ecommerce/counter-orders', [
                'customer_name'  => 'Cliente Teste',
                'payment_method' => 'pix',
                'items'          => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1],
                ],
            ]);

        $response->assertStatus(201);
        $this->assertStringStartsWith('BAL-', $response->json('data.order_number'));
    }
}
