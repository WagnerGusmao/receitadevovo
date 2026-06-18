<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::all();
        return $this->success($categories);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'slug' => 'nullable|string|unique:categories,slug',
        ]);

        $category = Category::create($request->all());

        return $this->success($category, 'Categoria criada com sucesso', 201);
    }

    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'slug' => 'sometimes|required|string|unique:categories,slug,' . $id,
        ]);

        $category->update($request->all());

        return $this->success($category, 'Categoria atualizada com sucesso');
    }

    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();

        return $this->success([], 'Categoria excluída com sucesso');
    }
}
