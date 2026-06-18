<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Services\MelhorEnvioService;
use Illuminate\Http\Request;

class ShippingController extends Controller
{
    /**
     * Calcula as taxas de frete para os itens e CEP informados.
     */
    public function calculateRates(Request $request, MelhorEnvioService $service)
    {
        $request->validate([
            'zipcode' => 'required|string',
            'items' => 'required|array|min:1',
            'items.*.id' => 'required',
            'items.*.type' => 'required|string|in:product,variant,kit',
            'items.*.quantity' => 'required|integer|min:1',
        ], [
            'zipcode.required' => 'O CEP de destino é obrigatório.',
            'items.required' => 'Os itens do carrinho são obrigatórios para o cálculo.',
            'items.array' => 'Os itens devem ser enviados em formato de lista.',
        ]);

        try {
            $rates = $service->calculateRates($request->items, $request->zipcode);
            return $this->success($rates, 'Cotação de frete realizada com sucesso.');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 422);
        }
    }
}
