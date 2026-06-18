<?php

namespace App\Modules\Content\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Content\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::with(['category', 'user', 'product'])
            ->orderBy('created_at', 'desc')
            ->get();

        return $this->success($posts);
    }

    public function home()
    {
        $posts = Post::with(['category', 'user', 'product'])
            ->where('status', 'published')
            ->where('show_on_home', true)
            ->orderBy('home_order')
            ->orderBy('published_at', 'desc')
            ->get();

        return $this->success($posts);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'slug' => 'required|string|unique:posts',
            'category_id' => 'required|exists:post_categories,id',
            'linked_product_id' => 'nullable|exists:products,id',
            'show_on_home' => 'sometimes|boolean',
            'home_order' => 'sometimes|integer',
        ]);

        $post = Post::create(array_merge($request->all(), [
            'user_id' => auth()->id() ?? 1, // Fallback for dev
            'status' => 'published',
            'published_at' => now(),
        ]));

        return $this->success($post, 'Artigo publicado com sucesso', 201);
    }

    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);
        
        $request->validate([
            'title' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|unique:posts,slug,' . $id,
            'category_id' => 'sometimes|exists:post_categories,id',
            'linked_product_id' => 'nullable|exists:products,id',
            'show_on_home' => 'sometimes|boolean',
            'home_order' => 'sometimes|integer',
        ]);

        $post->update($request->all());

        return $this->success($post, 'Artigo atualizado com sucesso');
    }

    public function destroy($id)
    {
        $post = Post::findOrFail($id);
        $post->delete();

        return $this->success([], 'Artigo excluído com sucesso');
    }

    public function show($slug)
    {
        $post = Post::with(['category', 'user', 'product'])
            ->where('slug', $slug)
            ->where('status', 'published')
            ->firstOrFail();

        return $this->success($post);
    }
}
