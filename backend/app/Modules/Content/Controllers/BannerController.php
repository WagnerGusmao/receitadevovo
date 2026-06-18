<?php

namespace App\Modules\Content\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Content\Models\Banner;
use Illuminate\Http\Request;

class BannerController extends Controller
{
    /** List all banners (Admin overview or debug). */
    public function index()
    {
        $banners = Banner::orderBy('sort_order')->orderBy('created_at', 'desc')->get();
        return $this->success($banners);
    }

    /** List active banners for frontend. ?page_target=home */
    public function activeBanners(Request $request)
    {
        $target = $request->query('page_target', 'home');
        
        $banners = Banner::where('is_active', true)
            ->where('page_target', $target)
            ->orderBy('sort_order')
            ->get();

        return $this->success($banners);
    }

    /** Store a new banner. */
    public function store(Request $request)
    {
        $request->validate([
            'image_desktop'  => 'required|string',
            'image_mobile'   => 'nullable|string',
            'image_fit'      => 'sometimes|string|in:cover,contain',
            'image_position' => 'sometimes|string|in:center,top,bottom,left,right',
            'title'          => 'nullable|string|max:255',
            'subtitle'       => 'nullable|string|max:255',
            'description'    => 'nullable|string|max:1000',
            'button_text'    => 'nullable|string|max:100',
            'button_url'     => 'nullable|string|max:255',
            'page_target'    => 'sometimes|string|max:100',
            'is_active'      => 'sometimes|boolean',
            'sort_order'     => 'sometimes|integer',
        ]);

        $banner = Banner::create($request->all());

        return $this->success($banner, 'Banner criado com sucesso', 201);
    }

    /** Show a single banner. */
    public function show($id)
    {
        $banner = Banner::findOrFail($id);
        return $this->success($banner);
    }

    /** Update a banner. */
    public function update(Request $request, $id)
    {
        $banner = Banner::findOrFail($id);

        $request->validate([
            'image_desktop'  => 'sometimes|string',
            'image_mobile'   => 'nullable|string',
            'image_fit'      => 'sometimes|string|in:cover,contain',
            'image_position' => 'sometimes|string|in:center,top,bottom,left,right',
            'title'          => 'nullable|string|max:255',
            'subtitle'       => 'nullable|string|max:255',
            'description'    => 'nullable|string|max:1000',
            'button_text'    => 'nullable|string|max:100',
            'button_url'     => 'nullable|string|max:255',
            'page_target'    => 'sometimes|string|max:100',
            'is_active'      => 'sometimes|boolean',
            'sort_order'     => 'sometimes|integer',
        ]);

        $banner->update($request->all());

        return $this->success($banner, 'Banner atualizado com sucesso');
    }

    /** Delete a banner. */
    public function destroy($id)
    {
        $banner = Banner::findOrFail($id);
        $banner->delete();

        return $this->success([], 'Banner excluído com sucesso');
    }
}
