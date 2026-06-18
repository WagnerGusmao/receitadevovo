<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Services\MercadoPagoService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class MercadoPagoIntegrationTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;
    protected Order $order;
    protected MercadoPagoService $mpService;

    protected function setUp(): void
    {
        parent::setUp();

        // Configurar credenciais fictícias de teste
        config(['services.mercadopago.access_token' => 'TEST-ACCESS-TOKEN']);

        // Criar usuário e pedido para os testes
        $this->user = User::create([
            'name' => 'João Silva',
            'email' => 'joao@example.com',
            'password' => bcrypt('password123'),
            'cpf' => '12345678909',
            'phone' => '11999999999',
            'whatsapp' => '11999999999'
        ]);

        $this->order = Order::create([
            'user_id' => $this->user->id,
            'order_number' => 'ORD-TEST1234',
            'total' => 150.00,
            'payment_method' => 'pix',
            'status' => 'pending',
            'shipping_address' => 'Rua Teste, 123 - São Paulo - SP | CEP: 01000-000'
        ]);

        $this->mpService = new MercadoPagoService();
    }

    /**
     * Teste de criação de pagamento PIX no MercadoPagoService.
     */
    public function test_can_create_pix_payment_successfully(): void
    {
        Http::fake([
            'https://api.mercadopago.com/v1/payments' => Http::response([
                'id' => 987654321,
                'status' => 'pending',
                'point_of_interaction' => [
                    'transaction_data' => [
                        'qr_code' => 'mock-pix-copia-e-cola-code',
                        'qr_code_base64' => 'mock-qr-code-base64-string'
                    ]
                ],
                'date_of_expiration' => '2026-06-12T11:00:00.000Z'
            ], 201)
        ]);

        $result = $this->mpService->createPixPayment($this->order, $this->user);

        $this->assertEquals('987654321', $result['payment_id']);
        $this->assertEquals('pending', $result['status']);
        $this->assertEquals('mock-pix-copia-e-cola-code', $result['qr_code']);
        $this->assertEquals('mock-qr-code-base64-string', $result['qr_code_base64']);
        $this->assertEquals('2026-06-12T11:00:00.000Z', $result['expiration_date']);

        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.mercadopago.com/v1/payments' &&
                $request['transaction_amount'] === 150.00 &&
                $request['payment_method_id'] === 'pix' &&
                $request['payer']['email'] === 'joao@example.com';
        });
    }

    /**
     * Teste de criação de pagamento Boleto no MercadoPagoService.
     */
    public function test_can_create_boleto_payment_successfully(): void
    {
        Http::fake([
            'https://api.mercadopago.com/v1/payments' => Http::response([
                'id' => 987654322,
                'status' => 'pending',
                'transaction_details' => [
                    'barcode' => [
                        'content' => '23793391266000001500007200000500900012345678900'
                    ],
                    'external_resource_url' => 'https://www.mercadopago.com.br/payments/987654322/ticket'
                ],
                'date_of_expiration' => '2026-06-15T11:00:00.000Z'
            ], 201)
        ]);

        $result = $this->mpService->createBoletoPayment($this->order, $this->user);

        $this->assertEquals('987654322', $result['payment_id']);
        $this->assertEquals('pending', $result['status']);
        $this->assertEquals('23793391266000001500007200000500900012345678900', $result['barcode']);
        $this->assertEquals('https://www.mercadopago.com.br/payments/987654322/ticket', $result['pdf_url']);
        $this->assertEquals('2026-06-15T11:00:00.000Z', $result['expiration_date']);

        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.mercadopago.com/v1/payments' &&
                $request['transaction_amount'] === 150.00 &&
                $request['payment_method_id'] === 'bolbradesco' &&
                $request['payer']['address']['federal_unit'] === 'SP';
        });
    }

    /**
     * Teste de criação de preferência de Checkout Pro no MercadoPagoService.
     */
    public function test_can_create_checkout_preference_successfully(): void
    {
        Http::fake([
            'https://api.mercadopago.com/checkout/preferences' => Http::response([
                'id' => 'pref-123456',
                'sandbox_init_point' => 'https://sandbox.mercadopago.com.br/checkout/v1/redirect?pref_id=pref-123456',
                'init_point' => 'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=pref-123456'
            ], 201)
        ]);

        $result = $this->mpService->createCheckoutPreference($this->order, $this->user);

        $this->assertEquals('pref-123456', $result['preference_id']);
        // Como o app env do PHPUnit por padrão é local ou testing, deve usar o sandbox_init_point
        $this->assertStringContainsString('sandbox', $result['payment_link']);
    }

    /**
     * Teste de recebimento de webhook de pagamento aprovado.
     */
    public function test_webhook_approves_order_successfully(): void
    {
        // Mock do detalhe do pagamento na API
        Http::fake([
            'https://api.mercadopago.com/v1/payments/987654321' => Http::response([
                'id' => 987654321,
                'status' => 'approved',
                'external_reference' => 'ORD-TEST1234'
            ], 200)
        ]);

        // Simular webhook no controller
        $response = $this->postJson('/api/ecommerce/payments/webhook', [
            'type' => 'payment',
            'data' => [
                'id' => '987654321'
            ]
        ]);

        $response->assertStatus(200);
        $response->assertJsonPath('success', true);

        // Verificar no banco de dados se o pedido foi atualizado
        $this->assertDatabaseHas('orders', [
            'id' => $this->order->id,
            'status' => 'processing',
            'payment_id' => '987654321',
            'payment_status' => 'approved'
        ]);
    }

    /**
     * Teste de recebimento de webhook de pagamento cancelado/rejeitado com devolução de estoque.
     */
    public function test_webhook_cancels_order_and_restores_stock(): void
    {
        // Criar produto com estoque
        $product = Product::create([
            'name' => 'Chá de Erva Doce',
            'slug' => 'cha-de-erva-doce',
            'description' => 'Chá calmante de erva doce.',
            'price' => 20.00,
            'stock' => 5,
            'is_active' => true
        ]);

        // Adicionar item ao pedido
        OrderItem::create([
            'order_id' => $this->order->id,
            'itemable_id' => $product->id,
            'itemable_type' => Product::class,
            'quantity' => 2,
            'price' => 20.00
        ]);

        // Mock do detalhe do pagamento cancelado
        Http::fake([
            'https://api.mercadopago.com/v1/payments/987654321' => Http::response([
                'id' => 987654321,
                'status' => 'cancelled',
                'external_reference' => 'ORD-TEST1234'
            ], 200)
        ]);

        // Simular webhook
        $response = $this->postJson('/api/ecommerce/payments/webhook', [
            'type' => 'payment',
            'data' => [
                'id' => '987654321'
            ]
        ]);

        $response->assertStatus(200);

        // Verificar se o pedido foi cancelado
        $this->assertDatabaseHas('orders', [
            'id' => $this->order->id,
            'status' => 'cancelled',
            'payment_id' => '987654321',
            'payment_status' => 'cancelled'
        ]);

        // Verificar se o estoque do produto foi devolvido (+2)
        $product->refresh();
        $this->assertEquals(7, $product->stock);
    }
}
