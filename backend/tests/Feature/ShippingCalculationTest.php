<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Services\MelhorEnvioService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class ShippingCalculationTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;
    protected Product $product;
    protected MelhorEnvioService $shippingService;

    protected function setUp(): void
    {
        parent::setUp();

        config([
            'services.melhorenvio.access_token' => 'REAL-ACCESS-TOKEN',
            'services.melhorenvio.env' => 'sandbox',
            'services.melhorenvio.from_zipcode' => '01001000',
            // Configurar mercado pago para evitar falhas de constructor
            'services.mercadopago.access_token' => 'MOCK-MP-TOKEN'
        ]);

        $this->user = User::create([
            'name' => 'Cliente Teste',
            'email' => 'cliente@test.com',
            'password' => bcrypt('password123'),
            'cpf' => '98765432109',
            'phone' => '11988888888',
            'whatsapp' => '11988888888'
        ]);

        $this->product = Product::create([
            'name' => 'Chá de Erva Doce',
            'slug' => 'cha-de-erva-doce',
            'description' => 'Delicioso chá natural.',
            'price' => 15.00,
            'stock' => 10,
            'is_active' => true,
        ]);

        $this->shippingService = new MelhorEnvioService();
    }

    /**
     * Teste de cálculo de frete diretamente no serviço com HTTP fake.
     */
    public function test_can_calculate_shipping_rates_from_service(): void
    {
        Http::fake([
            'https://sandbox.melhorenvio.com.br/api/v2/me/shipment/calculate' => Http::response([
                [
                    'id' => 1,
                    'name' => 'PAC',
                    'price' => '18.50',
                    'delivery_time' => 6,
                    'company' => [
                        'id' => 1,
                        'name' => 'Correios',
                        'picture' => 'https://sandbox.melhorenvio.com.br/images/correios.png'
                    ]
                ],
                [
                    'id' => 2,
                    'name' => 'SEDEX',
                    'price' => '25.90',
                    'delivery_time' => 2,
                    'company' => [
                        'id' => 1,
                        'name' => 'Correios',
                        'picture' => 'https://sandbox.melhorenvio.com.br/images/correios.png'
                    ]
                ]
            ], 200)
        ]);

        $items = [
            [
                'id' => $this->product->id,
                'type' => 'product',
                'quantity' => 2
            ]
        ];

        $rates = $this->shippingService->calculateRates($items, '02030040');

        $this->assertCount(2, $rates);
        $this->assertEquals('PAC', $rates[0]['name']);
        $this->assertEquals(18.50, $rates[0]['price']);
        $this->assertEquals('SEDEX', $rates[1]['name']);
        $this->assertEquals(25.90, $rates[1]['price']);

        Http::assertSent(function ($request) {
            return $request->url() === 'https://sandbox.melhorenvio.com.br/api/v2/me/shipment/calculate' &&
                $request['to']['postal_code'] === '02030040' &&
                $request['products'][0]['id'] === (string) $this->product->id &&
                $request['products'][0]['quantity'] === 2;
        });
    }

    /**
     * Teste do endpoint de cálculo de frete protegido por autenticação.
     */
    public function test_endpoint_requires_authentication(): void
    {
        $response = $this->postJson('/api/ecommerce/shipping/calculate', [
            'zipcode' => '02030040',
            'items' => [
                ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1]
            ]
        ]);

        $response->assertStatus(401);
    }

    /**
     * Teste do endpoint com dados válidos e resposta simulada (mock).
     */
    public function test_can_calculate_shipping_from_endpoint(): void
    {
        Http::fake([
            'https://sandbox.melhorenvio.com.br/api/v2/me/shipment/calculate' => Http::response([
                [
                    'id' => 3,
                    'name' => 'Jadlog .Package',
                    'price' => '14.20',
                    'delivery_time' => 4,
                    'company' => [
                        'id' => 2,
                        'name' => 'Jadlog',
                        'picture' => 'https://sandbox.melhorenvio.com.br/images/jadlog.png'
                    ]
                ]
            ], 200)
        ]);

        $response = $this->actingAs($this->user, 'sanctum')
            ->postJson('/api/ecommerce/shipping/calculate', [
                'zipcode' => '02030040',
                'items' => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 1]
                ]
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('status', 'success')
            ->assertJsonPath('data.0.name', 'Jadlog .Package')
            ->assertJsonPath('data.0.price', 14.20);
    }

    /**
     * Teste se a criação do pedido persiste o frete e atualiza o total da compra e Mercado Pago.
     */
    public function test_can_create_order_with_shipping_cost_added(): void
    {
        // Fake para a API de pagamentos do Mercado Pago (Pix)
        Http::fake([
            'https://api.mercadopago.com/v1/payments' => Http::response([
                'id' => 999999,
                'status' => 'pending',
                'point_of_interaction' => [
                    'transaction_data' => [
                        'qr_code' => 'mock-pix-code',
                        'qr_code_base64' => 'mock-qr-base64'
                    ]
                ],
                'date_of_expiration' => '2026-06-12T11:00:00.000Z'
            ], 201)
        ]);

        // Produto custa 15.00 * 2 = 30.00. Frete = 14.20. Total deve ser 44.20.
        $response = $this->actingAs($this->user, 'sanctum')
            ->postJson('/api/ecommerce/orders', [
                'items' => [
                    ['id' => $this->product->id, 'type' => 'product', 'quantity' => 2]
                ],
                'shipping_address' => 'Rua Destino, 456 - CEP: 02030-040',
                'shipping_method' => 'Jadlog - Jadlog .Package',
                'shipping_cost' => 14.20,
                'payment_method' => 'pix'
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('status', 'success');

        // Verificar no Banco de Dados
        $order = Order::first();
        $this->assertNotNull($order);
        $this->assertEquals(44.20, (float) $order->total); // 30.00 de produtos + 14.20 de frete
        $this->assertEquals(14.20, (float) $order->freight_value);
        $this->assertEquals('Jadlog - Jadlog .Package', $order->shipping_method);

        // Garantir que enviamos o valor correto com frete somado para o Mercado Pago
        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.mercadopago.com/v1/payments' &&
                (float) $request['transaction_amount'] === 44.20;
        });
    }
}
