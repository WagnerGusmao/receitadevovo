<?php

namespace App\Modules\AI\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\AI\Services\AIService;
use Illuminate\Http\Request;

class AIController extends Controller
{
    protected $aiService;

    public function __construct(AIService $aiService)
    {
        $this->aiService = $aiService;
    }

    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string|max:500',
        ]);

        $advice = $this->aiService->getAdvice($request->message);

        return $this->success($advice);
    }
}
