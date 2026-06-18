<?php

namespace App\Modules\Ecommerce\Services;

use App\Modules\Ecommerce\Models\Order;
use App\Modules\Auth\Models\User;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class MercadoPagoService
{
    protected string $accessToken;
    protected string $baseUrl = 'https://api.mercadopago.com';

    public function __construct()
    {
        $this->accessToken = config('services.mercadopago.access_token', '');
    }

    /**
     * Retorna o cliente HTTP pré-configurado.
     */
    protected function client(): \Illuminate\Http\Client\PendingRequest
    {
        $client = Http::withToken($this->accessToken);
        
        // Em ambiente local, desabilitamos a verificação SSL para evitar erros de cURL (ex: no Windows/Laragon)
        if (config('app.env') === 'local') {
            $client = $client->withoutVerifying();
        }
        
        return $client;
    }

    /**
     * Cria um pagamento do tipo Pix.
     */
    public function createPixPayment(Order $order, User $user): array
    {
        if (empty($this->accessToken)) {
            Log::error('Mercado Pago Access Token não configurado.');
            throw new \Exception('Configuração de pagamento incompleta.');
        }

        // Se estiver usando chaves fictícias locais, simulamos uma resposta de sucesso
        if (app()->environment() !== 'testing' && str_contains($this->accessToken, 'fictitious')) {
            Log::info('Mercado Pago: Utilizando pagamento PIX simulado (credenciais fictícias).');
            return [
                'payment_id' => '1234567890',
                'status' => 'pending',
                'qr_code' => '00020101021226870014br.gov.bcb.pix2565mock-pix-key-receita-de-vovo5204000053039865405150.005802BR5925Receita de Vovo6009Sao Paulo62070503***6304abcd',
                'qr_code_base64' => 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
                'expiration_date' => now()->addDay()->toIso8601String(),
            ];
        }

        // Buscar CPF e telefone do usuário ou de seus endereços
        $address = $user->addresses()->where('is_default', true)->first() ?? $user->addresses()->first();
        $cpf = $address ? preg_replace('/\D/', '', $address->cpf) : preg_replace('/\D/', '', $user->cpf);
        $phone = $address ? preg_replace('/\D/', '', $address->phone) : preg_replace('/\D/', '', $user->phone ?? $user->whatsapp ?? '11999999999');

        if (empty($cpf)) {
            // Mercado Pago exige CPF válido para transações Pix no Brasil
            $cpf = '00000000000'; 
        }

        $names = explode(' ', $user->name);
        $firstName = $names[0] ?? 'Silva';
        $lastName = count($names) > 1 ? end($names) : 'Silva';

        $payload = [
            'transaction_amount' => (float) $order->total,
            'description' => "Pedido Receita de Vovó #{$order->order_number}",
            'payment_method_id' => 'pix',
            'external_reference' => (string) $order->order_number,
            'payer' => [
                'email' => $user->email,
                'first_name' => $firstName,
                'last_name' => $lastName,
                'identification' => [
                    'type' => 'CPF',
                    'number' => $cpf,
                ],
                'phone' => [
                    'area_code' => substr($phone, 0, 2) ?: '11',
                    'number' => substr($phone, 2) ?: '999999999',
                ]
            ],
        ];

        // Adiciona chave de idempotência para evitar transações duplicadas
        $idempotencyKey = Str::uuid()->toString();

        Log::info('Enviando requisição de pagamento PIX para Mercado Pago', [
            'order_id' => $order->id,
            'order_number' => $order->order_number,
            'idempotency_key' => $idempotencyKey
        ]);

        $response = $this->client()
            ->withHeaders(['X-Idempotency-Key' => $idempotencyKey])
            ->post("{$this->baseUrl}/v1/payments", $payload);

        if (!$response->successful()) {
            Log::error('Erro ao criar pagamento Pix no Mercado Pago', [
                'status' => $response->status(),
                'body' => $response->json()
            ]);
            throw new \Exception('Erro ao processar pagamento via Pix: ' . ($response->json()['message'] ?? 'Erro desconhecido'));
        }

        $data = $response->json();

        return [
            'payment_id' => (string) ($data['id'] ?? ''),
            'status' => $data['status'] ?? 'pending',
            'qr_code' => $data['point_of_interaction']['transaction_data']['qr_code'] ?? '',
            'qr_code_base64' => $data['point_of_interaction']['transaction_data']['qr_code_base64'] ?? '',
            'expiration_date' => $data['date_of_expiration'] ?? null,
        ];
    }

    /**
     * Cria um pagamento do tipo Boleto Bancário.
     */
    public function createBoletoPayment(Order $order, User $user): array
    {
        if (empty($this->accessToken)) {
            Log::error('Mercado Pago Access Token não configurado.');
            throw new \Exception('Configuração de pagamento incompleta.');
        }

        // Se estiver usando chaves fictícias locais, simulamos uma resposta de sucesso
        if (app()->environment() !== 'testing' && str_contains($this->accessToken, 'fictitious')) {
            Log::info('Mercado Pago: Utilizando pagamento BOLETO simulado (credenciais fictícias).');
            return [
                'payment_id' => '1234567891',
                'status' => 'pending',
                'barcode' => '23793391266000001500007200000500900012345678900',
                'pdf_url' => 'https://www.mercadopago.com.br/payments/1234567891/ticket',
                'expiration_date' => now()->addDays(3)->toIso8601String(),
            ];
        }

        // Buscar CPF, telefone e endereço do usuário ou de seus endereços
        $address = $user->addresses()->where('is_default', true)->first() ?? $user->addresses()->first();
        $cpf = $address ? preg_replace('/\D/', '', $address->cpf) : preg_replace('/\D/', '', $user->cpf);
        $phone = $address ? preg_replace('/\D/', '', $address->phone) : preg_replace('/\D/', '', $user->phone ?? $user->whatsapp ?? '11999999999');

        if (empty($cpf)) {
            $cpf = '00000000000';
        }

        $names = explode(' ', $user->name);
        $firstName = $names[0] ?? 'Silva';
        $lastName = count($names) > 1 ? end($names) : 'Silva';

        // O Mercado Pago exige dados de endereço estruturados para Boleto
        $street = $address ? $address->street : 'Avenida Paulista';
        $number = $address ? $address->number : '1000';
        $neighborhood = $address ? $address->neighborhood : 'Bela Vista';
        $city = $address ? $address->city : 'São Paulo';
        $state = $address ? $address->state : 'SP';
        $zipcode = $address ? preg_replace('/\D/', '', $address->zipcode) : '01311100';

        $payload = [
            'transaction_amount' => (float) $order->total,
            'description' => "Pedido Receita de Vovó #{$order->order_number}",
            'payment_method_id' => 'bolbradesco',
            'external_reference' => (string) $order->order_number,
            'payer' => [
                'email' => $user->email,
                'first_name' => $firstName,
                'last_name' => $lastName,
                'identification' => [
                    'type' => 'CPF',
                    'number' => $cpf,
                ],
                'address' => [
                    'zip_code' => $zipcode,
                    'street_name' => $street,
                    'street_number' => $number,
                    'neighborhood' => $neighborhood,
                    'city' => $city,
                    'federal_unit' => $state,
                ]
            ],
        ];

        $idempotencyKey = Str::uuid()->toString();

        Log::info('Enviando requisição de pagamento BOLETO para Mercado Pago', [
            'order_id' => $order->id,
            'order_number' => $order->order_number,
            'idempotency_key' => $idempotencyKey
        ]);

        $response = $this->client()
            ->withHeaders(['X-Idempotency-Key' => $idempotencyKey])
            ->post("{$this->baseUrl}/v1/payments", $payload);

        if (!$response->successful()) {
            Log::error('Erro ao criar pagamento Boleto no Mercado Pago', [
                'status' => $response->status(),
                'body' => $response->json()
            ]);
            throw new \Exception('Erro ao processar pagamento via Boleto: ' . ($response->json()['message'] ?? 'Erro desconhecido'));
        }

        $data = $response->json();

        return [
            'payment_id' => (string) ($data['id'] ?? ''),
            'status' => $data['status'] ?? 'pending',
            'barcode' => $data['transaction_details']['barcode']['content'] ?? '',
            'pdf_url' => $data['transaction_details']['external_resource_url'] ?? '',
            'expiration_date' => $data['date_of_expiration'] ?? null,
        ];
    }

    /**
     * Cria uma preferência de checkout (Checkout Pro) para pagamento com cartão.
     */
    public function createCheckoutPreference(Order $order, User $user): array
    {
        if (empty($this->accessToken)) {
            Log::error('Mercado Pago Access Token não configurado.');
            throw new \Exception('Configuração de pagamento incompleta.');
        }

        // Se estiver usando chaves fictícias locais, simulamos uma resposta de sucesso
        if (app()->environment() !== 'testing' && str_contains($this->accessToken, 'fictitious')) {
            Log::info('Mercado Pago: Utilizando Checkout Pro simulado (credenciais fictícias).');
            return [
                'preference_id' => 'pref-mock12345',
                'payment_link' => "http://localhost:3000/checkout?step=3&status=success",
            ];
        }

        $appUrl = config('app.url', 'http://localhost');
        // Para o frontend do NextJS que roda na porta 3000 localmente
        $frontendUrl = str_contains($appUrl, 'localhost') ? 'http://localhost:3000' : $appUrl;

        $payload = [
            'items' => [
                [
                    'title' => "Pedido Receita de Vovó #{$order->order_number}",
                    'quantity' => 1,
                    'unit_price' => (float) $order->total,
                    'currency_id' => 'BRL',
                ]
            ],
            'payer' => [
                'name' => $user->name,
                'email' => $user->email,
            ],
            'back_urls' => [
                'success' => "{$frontendUrl}/checkout?step=3&status=success",
                'failure' => "{$frontendUrl}/checkout?step=2&status=failure",
                'pending' => "{$frontendUrl}/checkout?step=3&status=pending",
            ],
            'auto_return' => 'approved',
            'external_reference' => (string) $order->order_number,
        ];

        Log::info('Enviando requisição de preferência de Checkout Pro para Mercado Pago', [
            'order_id' => $order->id,
            'order_number' => $order->order_number,
        ]);

        $response = $this->client()
            ->post("{$this->baseUrl}/checkout/preferences", $payload);

        if (!$response->successful()) {
            Log::error('Erro ao criar preferência de pagamento no Mercado Pago', [
                'status' => $response->status(),
                'body' => $response->json()
            ]);
            throw new \Exception('Erro ao processar checkout: ' . ($response->json()['message'] ?? 'Erro desconhecido'));
        }

        $data = $response->json();

        // Em sandbox, retornamos sandbox_init_point, em produção init_point
        $isSandbox = str_contains($this->accessToken, 'TEST-') || config('app.env') === 'local';
        $paymentLink = $isSandbox ? ($data['sandbox_init_point'] ?? '') : ($data['init_point'] ?? '');

        return [
            'preference_id' => (string) ($data['id'] ?? ''),
            'payment_link' => $paymentLink,
        ];
    }

    /**
     * Busca os detalhes de um pagamento pelo ID.
     */
    public function getPaymentDetails(string $paymentId): array
    {
        if (empty($this->accessToken)) {
            Log::error('Mercado Pago Access Token não configurado.');
            throw new \Exception('Configuração de pagamento incompleta.');
        }

        $response = $this->client()
            ->get("{$this->baseUrl}/v1/payments/{$paymentId}");

        if (!$response->successful()) {
            Log::error('Erro ao obter detalhes do pagamento no Mercado Pago', [
                'payment_id' => $paymentId,
                'status' => $response->status(),
                'body' => $response->json()
            ]);
            throw new \Exception('Erro ao consultar status do pagamento.');
        }

        return $response->json();
    }
}
