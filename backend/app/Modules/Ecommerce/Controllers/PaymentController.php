<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\InventoryMovement;
use App\Modules\Ecommerce\Services\MercadoPagoService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    protected MercadoPagoService $mpService;

    public function __construct(MercadoPagoService $mpService)
    {
        $this->mpService = $mpService;
    }

    /**
     * Recebe notificações Webhook e IPN do Mercado Pago.
     */
    public function webhook(Request $request)
    {
        Log::info('Webhook do Mercado Pago recebido', [
            'query' => $request->query(),
            'body' => $request->all()
        ]);

        $paymentId = null;
        $type = null;

        // 1. Verificar se é o formato JSON mais recente do Webhook
        if ($request->has('type') && $request->input('type') === 'payment') {
            $type = 'payment';
            $paymentId = $request->input('data.id');
        } 
        // 2. Verificar se é o formato IPN antigo via Query Parameters
        elseif ($request->has('topic') && $request->input('topic') === 'payment') {
            $type = 'payment';
            $paymentId = $request->input('id');
        }

        // Se a notificação não for sobre um pagamento, apenas retornar sucesso (200 OK)
        if ($type !== 'payment' || empty($paymentId)) {
            Log::info('Webhook ignorado (tipo de notificação irrelevante ou ID ausente)', [
                'type' => $type,
                'payment_id' => $paymentId
            ]);
            return response()->json(['success' => true, 'message' => 'Notification ignored.'], 200);
        }

        try {
            // Consultar a API do Mercado Pago para obter detalhes reais do pagamento (evita fraudes de payload)
            $paymentDetails = $this->mpService->getPaymentDetails($paymentId);
            $externalReference = $paymentDetails['external_reference'] ?? null;
            $mpStatus = $paymentDetails['status'] ?? 'pending';

            if (empty($externalReference)) {
                Log::warning('Notificação do Mercado Pago sem external_reference correspondente', [
                    'payment_id' => $paymentId
                ]);
                return response()->json(['success' => false, 'message' => 'No order reference found.'], 400);
            }

            // Buscar o pedido com base no código de referência externo
            $order = Order::where('order_number', $externalReference)->first();

            if (!$order) {
                Log::warning('Pedido correspondente ao webhook não encontrado', [
                    'external_reference' => $externalReference,
                    'payment_id' => $paymentId
                ]);
                return response()->json(['success' => false, 'message' => 'Order not found.'], 404);
            }

            // Atualizar o status de pagamento e o status do pedido
            DB::transaction(function () use ($order, $mpStatus, $paymentId) {
                $oldStatus = $order->status;
                $oldPaymentStatus = $order->payment_status;

                // Salvar dados do pagamento no pedido
                $order->update([
                    'payment_id' => $paymentId,
                    'payment_status' => $mpStatus,
                ]);

                // Mapear status do Mercado Pago para os status internos da loja
                if ($mpStatus === 'approved') {
                    if ($oldStatus === 'pending') {
                        $order->update(['status' => 'processing']);
                        Log::info("Pedido #{$order->order_number} marcado como PAGO (processing).");
                    }
                } elseif (in_array($mpStatus, ['cancelled', 'rejected', 'refunded', 'charged_back'])) {
                    // Se o pedido era pendente ou em processamento e foi cancelado/estornado, devolvemos estoque
                    if (in_array($oldStatus, ['pending', 'processing'])) {
                        $order->update(['status' => 'cancelled']);
                        
                        // Restaura o estoque de todos os itens do pedido
                        $order->load('items.itemable');
                        foreach ($order->items as $item) {
                            $model = $item->itemable;
                            if ($model) {
                                $model->increment('stock', $item->quantity);
                                
                                InventoryMovement::create([
                                    'itemable_type' => $item->itemable_type,
                                    'itemable_id' => $item->itemable_id,
                                    'type' => 'in',
                                    'quantity' => $item->quantity,
                                    'reason' => 'cancelled_order_webhook',
                                    'order_id' => $order->id,
                                ]);
                            }
                        }
                        
                        Log::info("Pedido #{$order->order_number} CANCELADO via webhook do Mercado Pago. Estoque devolvido.");
                    }
                }
            });

            return response()->json(['success' => true, 'message' => 'Webhook processed successfully.']);

        } catch (\Exception $e) {
            Log::error('Erro ao processar Webhook do Mercado Pago', [
                'payment_id' => $paymentId,
                'error' => $e->getMessage()
            ]);
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}
