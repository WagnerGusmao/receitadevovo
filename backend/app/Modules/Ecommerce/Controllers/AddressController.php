<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Address;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    /**
     * List all addresses for the authenticated user.
     */
    public function index(Request $request)
    {
        $addresses = $request->user()->addresses()->orderBy('is_default', 'desc')->get();
        return $this->success($addresses);
    }

    /**
     * Store a new address for the authenticated user.
     */
    public function store(Request $request)
    {
        if ($request->has('cpf')) {
            $request->merge(['cpf' => preg_replace('/\D/', '', $request->input('cpf'))]);
        }
        if ($request->has('phone')) {
            $request->merge(['phone' => preg_replace('/\D/', '', $request->input('phone'))]);
        }
        if ($request->has('zipcode')) {
            $request->merge(['zipcode' => preg_replace('/\D/', '', $request->input('zipcode'))]);
        }
        if ($request->has('cep')) {
            $request->merge(['cep' => preg_replace('/\D/', '', $request->input('cep'))]);
        }

        $validated = $request->validate([
            'label' => 'nullable|string|max:50',
            'recipient_name' => 'required|string|max:255',
            'cpf' => 'required|string|size:11', // Apenas dígitos
            'phone' => 'required|string|min:10|max:11', // 10 ou 11 dígitos
            'zipcode' => 'required|string|size:8', // Apenas dígitos
            'cep' => 'nullable|string|max:9', // Compatibilidade
            'street' => 'required|string|max:255',
            'number' => 'required|string|max:20',
            'complement' => 'nullable|string|max:255',
            'neighborhood' => 'required|string|max:100',
            'city' => 'required|string|max:100',
            'state' => 'required|string|size:2',
            'reference' => 'nullable|string|max:255',
            'is_default' => 'boolean',
        ], [
            'recipient_name.required' => 'Nome do destinatário é obrigatório',
            'cpf.required' => 'CPF é obrigatório',
            'cpf.size' => 'CPF deve conter 11 dígitos',
            'phone.required' => 'Telefone é obrigatório',
            'phone.min' => 'Telefone deve ter no mínimo 10 dígitos',
            'zipcode.required' => 'CEP é obrigatório',
            'zipcode.size' => 'CEP deve conter 8 dígitos',
        ]);

        // Remover formatação
        $validated['cpf'] = preg_replace('/\D/', '', $validated['cpf']);
        $validated['phone'] = preg_replace('/\D/', '', $validated['phone']);
        $validated['zipcode'] = preg_replace('/\D/', '', $validated['zipcode']);
        
        // Sincronizar cep e zipcode
        if (!isset($validated['cep'])) {
            $validated['cep'] = $validated['zipcode'];
        }

        $address = $request->user()->addresses()->create($validated);

        return $this->success($address, 'Endereço cadastrado com sucesso', 201);
    }

    /**
     * Show a specific address.
     */
    public function show(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);
        return $this->success($address);
    }

    /**
     * Update an address.
     */
    public function update(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);

        if ($request->has('cpf')) {
            $request->merge(['cpf' => preg_replace('/\D/', '', $request->input('cpf'))]);
        }
        if ($request->has('phone')) {
            $request->merge(['phone' => preg_replace('/\D/', '', $request->input('phone'))]);
        }
        if ($request->has('zipcode')) {
            $request->merge(['zipcode' => preg_replace('/\D/', '', $request->input('zipcode'))]);
        }
        if ($request->has('cep')) {
            $request->merge(['cep' => preg_replace('/\D/', '', $request->input('cep'))]);
        }

        $validated = $request->validate([
            'label' => 'sometimes|string|max:50',
            'recipient_name' => 'sometimes|string|max:255',
            'cpf' => 'sometimes|string|size:11',
            'phone' => 'sometimes|string|min:10|max:11',
            'zipcode' => 'sometimes|string|size:8',
            'cep' => 'sometimes|string|max:9',
            'street' => 'sometimes|string|max:255',
            'number' => 'sometimes|string|max:20',
            'complement' => 'nullable|string|max:255',
            'neighborhood' => 'sometimes|string|max:100',
            'city' => 'sometimes|string|max:100',
            'state' => 'sometimes|string|size:2',
            'reference' => 'nullable|string|max:255',
            'is_default' => 'boolean',
        ]);

        // Remover formatação se fornecido
        if (isset($validated['cpf'])) {
            $validated['cpf'] = preg_replace('/\D/', '', $validated['cpf']);
        }
        if (isset($validated['phone'])) {
            $validated['phone'] = preg_replace('/\D/', '', $validated['phone']);
        }
        if (isset($validated['zipcode'])) {
            $validated['zipcode'] = preg_replace('/\D/', '', $validated['zipcode']);
        }

        $address->update($validated);

        return $this->success($address, 'Endereço atualizado com sucesso');
    }

    /**
     * Remove an address.
     */
    public function destroy(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);
        $address->delete();

        return $this->success([], 'Endereço removido com sucesso');
    }

    /**
     * Set an address as default.
     */
    public function setDefault(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);
        $address->update(['is_default' => true]);

        return $this->success($address, 'Endereço definido como padrão');
    }

    /**
     * Look up a zipcode using ViaCEP.
     */
    public function lookupZipcode(Request $request, $cep, \App\Modules\Ecommerce\Services\ViaCepService $viaCepService)
    {
        $cleaned = preg_replace('/\D/', '', $cep);
        
        if (strlen($cleaned) !== 8) {
            return $this->error('CEP inválido. Deve conter exatamente 8 dígitos.', 400);
        }

        $addressData = $viaCepService->lookup($cleaned);

        if (!$addressData) {
            return $this->error('CEP não encontrado.', 404);
        }

        return $this->success($addressData);
    }
}
