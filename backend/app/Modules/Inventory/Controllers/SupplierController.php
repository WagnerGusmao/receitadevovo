<?php

namespace App\Modules\Inventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Inventory\Models\Supplier;
use Illuminate\Http\Request;

class SupplierController extends Controller
{
    public function index()
    {
        $suppliers = Supplier::withCount('rawMaterials')
            ->orderBy('name')
            ->get();

        return $this->success($suppliers);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'cnpj'         => 'nullable|string|max:18|unique:suppliers,cnpj',
            'contact_name' => 'nullable|string|max:255',
            'email'        => 'nullable|email|max:255',
            'phone'        => 'nullable|string|max:20',
            'website'      => 'nullable|string|max:255',
            'address'      => 'nullable|string|max:255',
            'instagram'    => 'nullable|string|max:255',
            'notes'        => 'nullable|string',
            'is_active'    => 'boolean',
        ]);

        $supplier = Supplier::create($validated);

        return $this->success($supplier, 'Fornecedor cadastrado com sucesso', 201);
    }

    public function show($id)
    {
        $supplier = Supplier::with(['rawMaterials', 'batches.rawMaterial'])
            ->findOrFail($id);

        return $this->success($supplier);
    }

    public function update(Request $request, $id)
    {
        $supplier = Supplier::findOrFail($id);

        $validated = $request->validate([
            'name'         => 'sometimes|string|max:255',
            'cnpj'         => 'nullable|string|max:18|unique:suppliers,cnpj,' . $id,
            'contact_name' => 'nullable|string|max:255',
            'email'        => 'nullable|email|max:255',
            'phone'        => 'nullable|string|max:20',
            'website'      => 'nullable|string|max:255',
            'address'      => 'nullable|string|max:255',
            'instagram'    => 'nullable|string|max:255',
            'notes'        => 'nullable|string',
            'is_active'    => 'boolean',
        ]);

        $supplier->update($validated);

        return $this->success($supplier, 'Fornecedor atualizado com sucesso');
    }

    public function destroy($id)
    {
        $supplier = Supplier::findOrFail($id);
        $supplier->delete();

        return $this->success([], 'Fornecedor removido');
    }
}
