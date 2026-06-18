<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Order;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\ProductVariant;
use App\Modules\Ecommerce\Models\Kit;
use App\Modules\Ecommerce\Models\InventoryMovement;
use App\Modules\Ecommerce\Models\OrderInstallment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required',
            'items.*.type' => 'required|in:product,kit,variant',
            'items.*.quantity' => 'required|integer|min:1',
            'shipping_address' => 'required|string',
            'shipping_method' => 'nullable|string|max:100',
            'shipping_cost' => 'nullable|numeric|min:0',
            'payment_method' => 'required|string',
        ]);

        try {
            $order = DB::transaction(function () use ($request) {
                $total = 0;
                $itemsToCreate = [];

                foreach ($request->items as $item) {
                    if ($item['type'] === 'product') {
                        $model = Product::findOrFail($item['id']);
                        $itemType = Product::class;
                    } elseif ($item['type'] === 'variant') {
                        $model = ProductVariant::findOrFail($item['id']);
                        $itemType = ProductVariant::class;
                    } else {
                        $model = Kit::findOrFail($item['id']);
                        $itemType = Kit::class;
                    }

                    if ($model->stock < $item['quantity']) {
                        throw new \Exception("Estoque insuficiente para o item: {$model->name}");
                    }
                    $model->decrement('stock', $item['quantity']);

                    $subtotal = $model->price * $item['quantity'];
                    $total += $subtotal;

                    $itemsToCreate[] = [
                        'itemable_id' => $model->id,
                        'itemable_type' => $itemType,
                        'quantity' => $item['quantity'],
                        'price' => $model->price,
                    ];
                }

                $user = $request->user();
                $loyaltyLevel = $user->loyalty_level;
                if ($loyaltyLevel && $loyaltyLevel->discount_percentage > 0) {
                    $discount = ($total * $loyaltyLevel->discount_percentage) / 100;
                    $total = max(0, $total - $discount);
                }

                $shippingCost = (float) ($request->shipping_cost ?? 0);
                $finalTotal = $total + $shippingCost;

                $order = Order::create([
                    'user_id' => $user->id,
                    'order_number' => 'ORD-' . strtoupper(Str::random(8)),
                    'total' => $finalTotal,
                    'shipping_address' => $request->shipping_address,
                    'shipping_method' => $request->shipping_method,
                    'freight_value' => $shippingCost,
                    'payment_method' => $request->payment_method,
                    'status' => 'pending',
                ]);

                foreach ($itemsToCreate as $itemData) {
                    $itemData['order_id'] = $order->id;
                    OrderItem::create($itemData);

                    InventoryMovement::create([
                        'itemable_type' => $itemData['itemable_type'],
                        'itemable_id' => $itemData['itemable_id'],
                        'type' => 'out',
                        'quantity' => $itemData['quantity'],
                        'reason' => 'sale',
                        'order_id' => $order->id,
                    ]);
                }

                // Integração Mercado Pago
                if (in_array($request->payment_method, ['pix', 'credit_card', 'boleto'])) {
                    try {
                        $mpService = app(\App\Modules\Ecommerce\Services\MercadoPagoService::class);
                        if ($request->payment_method === 'pix') {
                            $mpData = $mpService->createPixPayment($order, $user);
                            $order->update([
                                'payment_id' => $mpData['payment_id'],
                                'payment_status' => $mpData['status'],
                                'payment_pix_qr' => $mpData['qr_code_base64'],
                                'payment_pix_code' => $mpData['qr_code'],
                                'payment_pix_expiration' => $mpData['expiration_date'] ? \Illuminate\Support\Carbon::parse($mpData['expiration_date']) : null,
                            ]);
                        } elseif ($request->payment_method === 'boleto') {
                            $mpData = $mpService->createBoletoPayment($order, $user);
                            $order->update([
                                'payment_id' => $mpData['payment_id'],
                                'payment_status' => $mpData['status'],
                                'payment_pix_code' => $mpData['barcode'], // reutilizando coluna de código de pagamento para a linha digitável do boleto
                                'payment_link' => $mpData['pdf_url'],     // link do PDF do boleto
                                'payment_pix_expiration' => $mpData['expiration_date'] ? \Illuminate\Support\Carbon::parse($mpData['expiration_date']) : null,
                            ]);
                        } elseif ($request->payment_method === 'credit_card') {
                            $mpData = $mpService->createCheckoutPreference($order, $user);
                            $order->update([
                                'payment_link' => $mpData['payment_link'],
                                'payment_status' => 'pending',
                            ]);
                        }
                    } catch (\Exception $e) {
                        throw new \Exception("Erro ao processar pagamento com Mercado Pago: " . $e->getMessage());
                    }
                }

                return $order;
            });

            return $this->success($order->load('items.itemable'), 'Pedido criado com sucesso', 201);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    public function index(Request $request)
    {
        $query = Order::with(['items.itemable', 'user']);

        // If not admin, only show own orders
        if (!$request->user()->is_admin) {
            $query->where('user_id', $request->user()->id);
        }

        $orders = $query->orderBy('created_at', 'desc')->get();

        return $this->success($orders);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,processing,shipped,delivered,cancelled',
        ]);

        try {
            $order = DB::transaction(function () use ($request, $id) {
                $order = Order::with('items.itemable')->findOrFail($id);
                $oldStatus = $order->status;
                $newStatus = $request->status;

                if ($oldStatus !== 'cancelled' && $newStatus === 'cancelled') {
                    // Restaura estoque
                    foreach ($order->items as $item) {
                        $model = $item->itemable;
                        if ($model) {
                            $model->increment('stock', $item->quantity);
                            
                            InventoryMovement::create([
                                'itemable_type' => $item->itemable_type,
                                'itemable_id' => $item->itemable_id,
                                'type' => 'in',
                                'quantity' => $item->quantity,
                                'reason' => 'cancelled_order',
                                'order_id' => $order->id,
                            ]);
                        }
                    }
                } elseif ($oldStatus === 'cancelled' && $newStatus !== 'cancelled') {
                    // Re-deduz estoque se "des-cancelar"
                    foreach ($order->items as $item) {
                        $model = $item->itemable;
                        if ($model) {
                            if ($model->stock < $item->quantity) {
                                throw new \Exception("Estoque insuficiente para reativar o pedido (Item: {$model->name})");
                            }
                            $model->decrement('stock', $item->quantity);
                            
                            InventoryMovement::create([
                                'itemable_type' => $item->itemable_type,
                                'itemable_id' => $item->itemable_id,
                                'type' => 'out',
                                'quantity' => $item->quantity,
                                'reason' => 'sale',
                                'order_id' => $order->id,
                            ]);
                        }
                    }
                }

                $order->update(['status' => $newStatus]);

                if ($newStatus === 'delivered') {
                    app(\App\Modules\Rewards\Services\LoyaltyService::class)->awardPointsForOrder($order);
                } elseif ($newStatus === 'cancelled' && $oldStatus === 'delivered') {
                    app(\App\Modules\Rewards\Services\LoyaltyService::class)->deductPointsForCancelledOrder($order);
                }

                return $order;
            });

            return $this->success($order, "Status do pedido atualizado para: {$request->status}");
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
    public function storeCounter(Request $request)
    {
        $request->validate([
            'items'          => 'required|array|min:1',
            'items.*.id'     => 'required|integer',
            'items.*.type'   => 'required|in:product,kit,variant',
            'items.*.quantity' => 'required|integer|min:1',
            'payment_method' => 'required|string',
            // Cliente cadastrado OU avulso
            'user_id'        => 'nullable|exists:users,id',
            'customer_name'  => 'nullable|string|max:255',
            'customer_phone' => 'nullable|string|max:50',
            // Extras
            'discount_amount' => 'nullable|numeric|min:0',
            'shipping_address' => 'nullable|string',
            'notes'          => 'nullable|string',
            'status'         => 'nullable|string|in:pending,delivered',
            
            // Retroativo/Histórico
            'is_retroactive'   => 'nullable|boolean',
            'retroactive_date' => 'nullable|date',
            'adjust_inventory' => 'nullable|boolean',
            'award_points'     => 'nullable|boolean',

            // Parcelas (se payment_method for 'installments')
            'installments'                       => 'nullable|array',
            'installments.*.installment_number' => 'required|integer',
            'installments.*.amount'             => 'required|numeric|min:0',
            'installments.*.due_date'           => 'required|date',
            'installments.*.status'             => 'required|string|in:pending,paid',
            'installments.*.payment_method'     => 'nullable|string',
        ]);

        // Precisa de pelo menos um dos dois: usuário cadastrado ou nome avulso
        if (!$request->user_id && !$request->customer_name) {
            return $this->error('Informe o cliente cadastrado ou o nome do cliente avulso.', 422);
        }

        try {
            $order = DB::transaction(function () use ($request) {
                $total = 0;
                $itemsToCreate = [];
                
                $isRetroactive = $request->boolean('is_retroactive', false);
                $adjustInventory = $request->boolean('adjust_inventory', true);
                
                // Se for histórico retroativo, por padrão não reduz estoque a menos que explicitado
                if ($isRetroactive && !$request->has('adjust_inventory')) {
                    $adjustInventory = false;
                }

                foreach ($request->items as $item) {
                    if ($item['type'] === 'product') {
                        $model = Product::findOrFail($item['id']);
                    } elseif ($item['type'] === 'variant') {
                        $model = ProductVariant::findOrFail($item['id']);
                    } else {
                        $model = Kit::findOrFail($item['id']);
                    }

                    if ($adjustInventory) {
                        if ($model->stock < $item['quantity']) {
                            throw new \Exception("Estoque insuficiente: {$model->name} (disponível: {$model->stock})");
                        }
                        $model->decrement('stock', $item['quantity']);
                    }

                    $subtotal = $model->price * $item['quantity'];
                    $total += $subtotal;

                    $itemsToCreate[] = [
                        'itemable_id'   => $model->id,
                        'itemable_type' => get_class($model),
                        'quantity'      => $item['quantity'],
                        'price'         => $model->price,
                    ];
                }

                // Aplicar desconto manual
                $discountAmount = (float) ($request->discount_amount ?? 0);
                $finalTotal = max(0, $total - $discountAmount);

                if ($request->payment_method === 'installments') {
                    if (!$request->installments || count($request->installments) === 0) {
                        throw new \Exception("Para a forma de pagamento 'Parcelado', envie as parcelas correspondentes.");
                    }
                    $installmentsSum = array_sum(array_column($request->installments, 'amount'));
                    if (abs($installmentsSum - $finalTotal) > 0.05) {
                        throw new \Exception("A soma das parcelas (R$ " . number_format($installmentsSum, 2) . ") deve ser igual ao total do pedido (R$ " . number_format($finalTotal, 2) . ").");
                    }
                }

                $orderData = [
                    'user_id'          => $request->user_id,
                    'customer_name'    => $request->customer_name,
                    'customer_phone'   => $request->customer_phone,
                    'order_number'     => 'BAL-' . strtoupper(Str::random(8)),
                    'total'            => $finalTotal,
                    'discount_amount'  => $discountAmount > 0 ? $discountAmount : null,
                    'status'           => $request->status ?? 'delivered',
                    'source'           => 'counter',
                    'payment_method'   => $request->payment_method,
                    'shipping_address' => $request->shipping_address,
                    'notes'            => $request->notes,
                ];

                // Se houver parcelas pendentes, o status inicial da venda balcão deve ser 'pending'
                if ($request->payment_method === 'installments') {
                    $hasPending = false;
                    foreach ($request->installments as $instData) {
                        if ($instData['status'] === 'pending') {
                            $hasPending = true;
                            break;
                        }
                    }
                    if ($hasPending) {
                        $orderData['status'] = 'pending';
                    }
                }

                // Criar instância sem salvar de imediato para setar datas se necessário
                $order = new Order($orderData);

                if ($isRetroactive && $request->retroactive_date) {
                    $date = \Illuminate\Support\Carbon::parse($request->retroactive_date);
                    $order->created_at = $date;
                    $order->updated_at = $date;
                }

                $order->save();

                // Salvar as parcelas
                if ($request->payment_method === 'installments') {
                    foreach ($request->installments as $instData) {
                        $paidAt = null;
                        if ($instData['status'] === 'paid') {
                            $paidAt = $isRetroactive && $request->retroactive_date 
                                ? $date 
                                : now();
                        }

                        $inst = new OrderInstallment([
                            'order_id' => $order->id,
                            'installment_number' => $instData['installment_number'],
                            'amount' => $instData['amount'],
                            'due_date' => $instData['due_date'],
                            'status' => $instData['status'],
                            'payment_method' => $instData['payment_method'] ?? null,
                            'paid_at' => $paidAt,
                        ]);

                        if ($isRetroactive && $request->retroactive_date) {
                            $inst->created_at = $date;
                            $inst->updated_at = $date;
                        }
                        $inst->save();
                    }
                }

                foreach ($itemsToCreate as $itemData) {
                    $itemData['order_id'] = $order->id;
                    $orderItem = new OrderItem($itemData);
                    
                    if ($isRetroactive && $request->retroactive_date) {
                        $orderItem->created_at = $date;
                        $orderItem->updated_at = $date;
                    }
                    $orderItem->save();

                    if ($adjustInventory) {
                        $movement = new InventoryMovement([
                            'itemable_type' => $itemData['itemable_type'],
                            'itemable_id'   => $itemData['itemable_id'],
                            'type'          => 'out',
                            'quantity'      => $itemData['quantity'],
                            'reason'        => 'sale',
                            'order_id'      => $order->id,
                        ]);
                        
                        if ($isRetroactive && $request->retroactive_date) {
                            $movement->created_at = $date;
                            $movement->updated_at = $date;
                        }
                        $movement->save();
                    }
                }

                // Conceder pontos de fidelidade se status for entregue ('delivered') e award_points for true
                $awardPoints = $request->boolean('award_points', true);
                if ($order->user_id && $order->status === 'delivered' && $awardPoints) {
                    app(\App\Modules\Rewards\Services\LoyaltyService::class)->awardPointsForOrder($order);
                    
                    // Se for data retroativa, precisamos também ajustar a data da transação de fidelidade gerada!
                    if ($isRetroactive && $request->retroactive_date) {
                        \App\Modules\Rewards\Models\LoyaltyTransaction::where('order_id', $order->id)
                            ->update([
                                'created_at' => $date,
                                'updated_at' => $date
                            ]);
                    }
                }

                return $order;
            });

            return $this->success(
                $order->load(['items.itemable', 'user']),
                'Pedido balcão registrado com sucesso!',
                201
            );
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /**
     * Retorna pedidos pendentes para o workflow de fulfillment,
     * ordenados do mais antigo para o mais recente.
     */
    public function pendingForFulfillment(Request $request)
    {
        $orders = Order::with(['items.itemable', 'user'])
            ->where('status', 'pending')
            ->orderBy('created_at', 'asc')
            ->get()
            ->map(function ($order) {
                $waitingHours = now()->diffInHours($order->created_at);
                $order->waiting_hours = $waitingHours;
                $order->waiting_label = $waitingHours < 1
                    ? 'Há poucos minutos'
                    : ($waitingHours < 24
                        ? "Há {$waitingHours}h"
                        : 'Há ' . now()->diffInDays($order->created_at) . ' dias');
                return $order;
            });

        return $this->success($orders);
    }

    /**
     * Marca o pedido como enviado, salvando tracking, peso, dimensões e frete.
     */
    public function markAsShipped(Request $request, $id)
    {
        $request->validate([
            'tracking_code'  => 'nullable|string|max:100',
            'weight_kg'      => 'nullable|numeric|min:0',
            'box_dimensions' => 'nullable|string|max:50',
            'freight_value'  => 'nullable|numeric|min:0',
        ]);

        try {
            $order = Order::findOrFail($id);

            if ($order->status !== 'pending' && $order->status !== 'processing') {
                return $this->error('Apenas pedidos pendentes ou em processamento podem ser marcados como enviados.', 422);
            }

            $order->update([
                'status'         => 'shipped',
                'tracking_code'  => $request->tracking_code,
                'shipped_at'     => now(),
                'weight_kg'      => $request->weight_kg,
                'box_dimensions' => $request->box_dimensions,
                'freight_value'  => $request->freight_value,
            ]);

            return $this->success($order->load(['items.itemable', 'user']), 'Pedido marcado como enviado!');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    public function updateOrder(Request $request, $id)
    {
        $request->validate([
            'items'          => 'required|array|min:1',
            'items.*.id'     => 'required|integer',
            'items.*.type'   => 'required|in:product,kit,variant',
            'items.*.quantity' => 'required|integer|min:1',
            'payment_method' => 'nullable|string',
            'customer_name'  => 'nullable|string|max:255',
            'customer_phone' => 'nullable|string|max:50',
            'discount_amount' => 'nullable|numeric|min:0',
            'shipping_address' => 'nullable|string',
            'notes'          => 'nullable|string',
            'status'         => 'nullable|string|in:pending,processing,shipped,delivered,cancelled',
        ]);

        try {
            $order = DB::transaction(function () use ($request, $id) {
                $order = Order::with('items.itemable')->findOrFail($id);

                if ($order->status === 'cancelled') {
                    throw new \Exception("Pedidos cancelados não podem ser editados.");
                }

                // 1. Devolver estoque de todos os itens antigos do pedido
                foreach ($order->items as $item) {
                    $model = $item->itemable;
                    if ($model) {
                        $model->increment('stock', $item->quantity);
                    }
                }

                // 2. Deduzir estoque dos novos itens e calcular subtotal
                $total = 0;
                $itemsToCreate = [];

                foreach ($request->items as $item) {
                    if ($item['type'] === 'product') {
                        $model = Product::findOrFail($item['id']);
                    } elseif ($item['type'] === 'variant') {
                        $model = ProductVariant::findOrFail($item['id']);
                    } else {
                        $model = Kit::findOrFail($item['id']);
                    }

                    if ($model->stock < $item['quantity']) {
                        throw new \Exception("Estoque insuficiente para o item: {$model->name} (disponível: {$model->stock})");
                    }

                    $model->decrement('stock', $item['quantity']);
                    $subtotal = $model->price * $item['quantity'];
                    $total += $subtotal;

                    $itemsToCreate[] = [
                        'itemable_id'   => $model->id,
                        'itemable_type' => get_class($model),
                        'quantity'      => $item['quantity'],
                        'price'         => $model->price,
                    ];
                }

                // Aplicar desconto manual se houver
                $discountAmount = (float) ($request->discount_amount ?? 0);
                $finalTotal = max(0, $total - $discountAmount);

                // Se houver usuário e não houver desconto manual, podemos manter ou aplicar desconto do nível de fidelidade
                if ($order->user_id && $discountAmount <= 0) {
                    $user = $order->user;
                    $loyaltyLevel = $user ? $user->loyalty_level : null;
                    if ($loyaltyLevel && $loyaltyLevel->discount_percentage > 0) {
                        $discount = ($total * $loyaltyLevel->discount_percentage) / 100;
                        $finalTotal = max(0, $total - $discount);
                    }
                }

                // 3. Atualizar os dados do pedido
                $order->update([
                    'customer_name'    => $request->has('customer_name') ? $request->customer_name : $order->customer_name,
                    'customer_phone'   => $request->has('customer_phone') ? $request->customer_phone : $order->customer_phone,
                    'total'            => $finalTotal,
                    'discount_amount'  => $discountAmount > 0 ? $discountAmount : null,
                    'payment_method'   => $request->payment_method ?? $order->payment_method,
                    'shipping_address' => $request->shipping_address ?? $order->shipping_address,
                    'notes'            => $request->notes ?? $order->notes,
                    'status'           => $request->status ?? $order->status,
                ]);

                // 4. Limpar itens antigos e registros de movimentação associados
                $order->items()->delete();
                InventoryMovement::where('order_id', $order->id)->delete();

                // 5. Salvar novos itens e criar movimentação de estoque correspondente
                foreach ($itemsToCreate as $itemData) {
                    $itemData['order_id'] = $order->id;
                    OrderItem::create($itemData);

                    InventoryMovement::create([
                        'itemable_type' => $itemData['itemable_type'],
                        'itemable_id'   => $itemData['itemable_id'],
                        'type'          => 'out',
                        'quantity'      => $itemData['quantity'],
                        'reason'        => 'sale',
                        'order_id'      => $order->id,
                    ]);
                }

                // 6. Recalcular pontos de fidelidade (apagar transações antigas e gerar de novo se estiver entregue)
                \App\Modules\Rewards\Models\LoyaltyTransaction::where('order_id', $order->id)->delete();
                if ($order->user_id && $order->status === 'delivered') {
                    app(\App\Modules\Rewards\Services\LoyaltyService::class)->awardPointsForOrder($order);
                }

                return $order;
            });

            return $this->success(
                $order->load(['items.itemable', 'user']),
                'Pedido atualizado com sucesso!'
            );
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    public function payInstallment(Request $request, $orderId, $installmentId)
    {
        $request->validate([
            'payment_method' => 'required|string|in:pix,cash',
            'paid_at' => 'nullable|date',
            'notes' => 'nullable|string',
        ]);

        try {
            $installment = OrderInstallment::where('order_id', $orderId)->findOrFail($installmentId);

            if ($installment->status === 'paid') {
                return $this->error('Esta parcela já está paga.', 422);
            }

            $paidAt = $request->paid_at ? \Illuminate\Support\Carbon::parse($request->paid_at) : now();

            $installment->update([
                'status' => 'paid',
                'payment_method' => $request->payment_method,
                'paid_at' => $paidAt,
                'notes' => $request->notes,
            ]);

            // Verificar se todas as parcelas foram pagas para atualizar o status do pedido para 'delivered'
            $hasPending = OrderInstallment::where('order_id', $orderId)
                ->where('status', 'pending')
                ->exists();

            if (!$hasPending) {
                Order::where('id', $orderId)->update(['status' => 'delivered']);
            }

            return $this->success($installment, 'Parcela baixada com sucesso!');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    public function listInstallments(Request $request)
    {
        $query = OrderInstallment::with('order.user')
            ->orderBy('due_date', 'asc');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('q')) {
            $q = $request->q;
            $query->whereHas('order', function ($oQuery) use ($q) {
                $oQuery->where('customer_name', 'like', "%{$q}%")
                       ->orWhere('order_number', 'like', "%{$q}%")
                       ->orWhereHas('user', function ($uQuery) use ($q) {
                           $uQuery->where('name', 'like', "%{$q}%");
                       });
            });
        }

        $installments = $query->get();
        return $this->success($installments);
    }
}
