<?php

namespace App\Modules\Wellness\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Wellness\Models\Benefit;
use App\Modules\Wellness\Models\Emotion;
use App\Modules\Wellness\Models\Herb;
use Illuminate\Http\Request;

class WellnessController extends Controller
{
    public function index(Request $request)
    {
        $query = Herb::with(['benefits', 'emotions']);

        if ($request->filled('search')) {
            $search = '%' . $request->search . '%';
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', $search)
                  ->orWhere('scientific_name', 'like', $search)
                  ->orWhere('aliases', 'like', $search)
                  ->orWhere('description', 'like', $search);
            });
        }

        if ($request->has('benefit')) {
            $query->whereHas('benefits', function ($q) use ($request) {
                $q->where('slug', $request->benefit);
            });
        }

        if ($request->has('emotion')) {
            $query->whereHas('emotions', function ($q) use ($request) {
                $q->where('slug', $request->emotion);
            });
        }

        if ($request->has('page') || $request->has('per_page')) {
            $perPage = $request->integer('per_page', 25);
            if (!in_array($perPage, [25, 50, 100])) {
                $perPage = 25;
            }
            return $this->success($query->paginate($perPage));
        }

        return $this->success($query->get());
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'              => 'required|string|max:255',
            'slug'              => 'required|string|unique:herbs',
            'scientific_name'   => 'nullable|string|max:255',
            'aliases'           => 'nullable|string',
            'description'       => 'required|string',
            'contraindications' => 'nullable|string',
            'how_to_use'        => 'nullable|string',
            'bath_instructions' => 'nullable|string',
            'incense_usage'     => 'nullable|string',
            'image_path'        => 'nullable|string|max:255',
            'source_type'       => 'nullable|string|in:popular,scientific,integrative',
            'sources'           => 'nullable|string',
        ]);

        $herb = Herb::create($request->all());

        if ($request->has('benefit_ids')) {
            $herb->benefits()->sync($request->benefit_ids);
        }

        return $this->success($herb->load('benefits'), 'Erva cadastrada com sucesso', 201);
    }

    public function update(Request $request, $id)
    {
        $herb = Herb::findOrFail($id);
        
        $request->validate([
            'name'              => 'sometimes|string|max:255',
            'slug'              => 'sometimes|string|unique:herbs,slug,' . $id,
            'scientific_name'   => 'nullable|string|max:255',
            'aliases'           => 'nullable|string',
            'description'       => 'sometimes|string',
            'contraindications' => 'nullable|string',
            'how_to_use'        => 'nullable|string',
            'bath_instructions' => 'nullable|string',
            'incense_usage'     => 'nullable|string',
            'image_path'        => 'nullable|string|max:255',
            'source_type'       => 'nullable|string|in:popular,scientific,integrative',
            'sources'           => 'nullable|string',
        ]);

        $herb->update($request->all());

        if ($request->has('benefit_ids')) {
            $herb->benefits()->sync($request->benefit_ids);
        }

        return $this->success($herb->load('benefits'), 'Erva atualizada com sucesso');
    }

    public function destroy($id)
    {
        $herb = Herb::findOrFail($id);
        $herb->delete();

        return $this->success([], 'Erva excluída com sucesso');
    }

    public function benefits()
    {
        return $this->success(Benefit::all());
    }

    public function emotions()
    {
        return $this->success(Emotion::all());
    }
}
