<?php

namespace App\Modules\AI\Services;

use App\Modules\Wellness\Models\Herb;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Inventory\Models\Recipe;
use App\Modules\Content\Models\Post;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AIService
{
    /**
     * Get a contextual response based on user input and internal database.
     */
    public function getAdvice(string $message)
    {
        // 1. Identify intent / keywords and search the DB (RAG)
        $context = $this->searchContext($message);
        
        // 2. Build the RAG Context text
        $contextText = "";

        if ($context['herbs']->isNotEmpty()) {
            $contextText .= "ERVAS E BENEFÍCIOS CADASTRADOS NO SITE:\n";
            foreach ($context['herbs'] as $herb) {
                $benefitsList = $herb->benefits->pluck('name')->implode(', ');
                $contextText .= "- Erva: {$herb->name}\n  Descrição: {$herb->description}\n  Benefícios: {$benefitsList}\n\n";
            }
        }

        if ($context['recipes']->isNotEmpty()) {
            $contextText .= "RECEITAS E RITUAIS NATURAIS INTERNOS:\n";
            foreach ($context['recipes'] as $recipe) {
                $contextText .= "- Receita: {$recipe->name}\n  Descrição: {$recipe->description}\n  Modo de Preparo/Instruções: {$recipe->instructions}\n\n";
            }
        }

        if ($context['posts']->isNotEmpty()) {
            $contextText .= "ARTIGOS E DICAS DO NOSSO BLOG:\n";
            foreach ($context['posts'] as $post) {
                $contextText .= "- Artigo: {$post->title}\n  Resumo: {$post->excerpt}\n  Conteúdo: " . Str::limit($post->content, 300) . "\n\n";
            }
        }

        // 3. Build related products collection to suggest
        $herbIds = $context['herbs']->pluck('id')->toArray();
        $productsFromHerbs = Product::whereHas('herbs', function($q) use ($herbIds) {
            $q->whereIn('herbs.id', $herbIds);
        })->where('is_active', true)->get();

        $productsFromRecipes = $context['recipes']->pluck('product')->filter()->unique('id');
        $relatedProducts = $productsFromHerbs->concat($productsFromRecipes)->unique('id')->values();

        // 4. Check API Key
        $apiKey = config('services.gemini.key');
        $model = config('services.gemini.model', 'gemini-2.0-flash');

        if (!$apiKey) {
            Log::warning('VovoChat: GEMINI_API_KEY não configurada. Usando fallback estático.');
            return $this->fallbackAdvice($context, $message);
        }

        // 5. Call Gemini API with System Prompt and Context
        $apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent";

        $systemPrompt = "Você é a 'Vovó', uma sábia e carinhosa senhora conhecedora de ervas, chás e rituais ancestrais de autocuidado natural.\n" .
            "Seu tom de conversa é extremamente doce, acolhedor, calmo e amoroso. Trate o usuário com palavras afetuosas (ex: 'meu querido', 'minha querida', 'meu bem', 'meu neto/neta').\n" .
            "Instruções:\n" .
            "1. Responda ao que o usuário contou sobre como se sente utilizando primeiramente as informações do CONTEXTO interno fornecido (ervas, receitas ou artigos de blog do nosso site). Se encontrar receitas ou ervas ali, sugira e indique um ritual com elas de forma simples e acolhedora.\n" .
            "2. Se não houver nada correspondente no contexto, você pode usar seu conhecimento geral consolidado sobre chás tradicionais, infusões e autocuidado para oferecer uma dica segura e reconfortante.\n" .
            "3. REGRA DE SEGURANÇA CRÍTICA: Nunca diagnostique doenças, não prometa curas rápidas/milagrosas e sempre lembre, com jeitinho de avó, de que seus conselhos são complementares e não substituem o médico profissional. Diga que é essencial consultar um médico se os sintomas persistirem.\n" .
            "4. Se a mensagem do usuário for totalmente fora do tema (ex: tecnologia, carros, finanças, código), decline com carinho, dizendo que você é apenas uma avó que conhece os segredos das ervas e do bem-estar, e prefere não opinar sobre coisas tão complicadas do mundo moderno.\n" .
            "5. Mantenha a resposta com comprimento moderado, calorosa e reconfortante.";

        $payload = [
            'contents' => [
                [
                    'role' => 'user',
                    'parts' => [
                        ['text' => $message]
                    ]
                ]
            ],
            'systemInstruction' => [
                'parts' => [
                    ['text' => $systemPrompt . "\n\nCONTEXTO INTERNO:\n" . (empty($contextText) ? "Nenhuma informação cadastrada no banco para este tema." : $contextText)]
                ]
            ],
            'generationConfig' => [
                'temperature' => 0.7,
                'maxOutputTokens' => 1200,
            ]
        ];

        try {
            $response = Http::timeout(30)
                ->withoutVerifying()
                ->withQueryParameters(['key' => $apiKey])
                ->post($apiUrl, $payload);

            if ($response->successful()) {
                $text = $response->json('candidates.0.content.parts.0.text', '');
                if (!empty(trim($text))) {
                    return [
                        'text' => trim($text),
                        'suggested_herbs' => $context['herbs']->take(2)->values(),
                        'related_products' => $relatedProducts->take(3)->values()
                    ];
                }
            }
            
            Log::error('Gemini API call failed for VovoChat: ' . $response->body());
        } catch (\Exception $e) {
            Log::error('Gemini API exception in AIService: ' . $e->getMessage());
        }

        return $this->fallbackAdvice($context, $message);
    }

    private function searchContext(string $message)
    {
        $words = explode(' ', Str::lower($message));
        $keywords = [];
        foreach ($words as $word) {
            $cleaned = preg_replace('/[^\p{L}\p{N}\s]/u', '', trim($word));
            if (mb_strlen($cleaned) > 3) {
                $keywords[] = $cleaned;
            }
        }

        if (empty($keywords)) {
            return [
                'herbs' => collect(),
                'recipes' => collect(),
                'posts' => collect(),
            ];
        }

        // Search Herbs
        $herbs = Herb::where(function($q) use ($keywords) {
            foreach ($keywords as $kw) {
                $q->orWhere('name', 'like', "%{$kw}%")
                  ->orWhere('description', 'like', "%{$kw}%");
            }
        })->with('benefits')->get();

        // Search Recipes
        $recipes = Recipe::where('is_active', true)
            ->where(function($q) use ($keywords) {
                foreach ($keywords as $kw) {
                    $q->orWhere('name', 'like', "%{$kw}%")
                      ->orWhere('description', 'like', "%{$kw}%")
                      ->orWhere('instructions', 'like', "%{$kw}%");
                }
            })->with('product')->get();

        // Search Posts (published only)
        $posts = Post::where('status', 'published')
            ->where(function($q) use ($keywords) {
                foreach ($keywords as $kw) {
                    $q->orWhere('title', 'like', "%{$kw}%")
                      ->orWhere('excerpt', 'like', "%{$kw}%")
                      ->orWhere('content', 'like', "%{$kw}%");
                }
            })->get();

        return [
            'herbs' => $herbs,
            'recipes' => $recipes,
            'posts' => $posts,
        ];
    }

    /**
     * Fallback response in case of API failure or missing keys.
     */
    private function fallbackAdvice(array $context, string $message): array
    {
        $herbs = $context['herbs'];
        $recipes = $context['recipes'];

        $herbIds = $herbs->pluck('id')->toArray();
        $productsFromHerbs = Product::whereHas('herbs', function($q) use ($herbIds) {
            $q->whereIn('herbs.id', $herbIds);
        })->where('is_active', true)->get();

        $productsFromRecipes = $recipes->pluck('product')->filter()->unique('id');
        $relatedProducts = $productsFromHerbs->concat($productsFromRecipes)->unique('id')->values();

        if ($herbs->isEmpty() && $recipes->isEmpty()) {
            return [
                'text' => "Oh, meu querido(a)... sinto que você busca um conforto ou equilíbrio, mas a vovó não encontrou a receitinha exata em seu caderno agora. Às vezes a resposta está no silêncio, em respirar bem fundo e beber um copo de água morna. Lembre-se sempre de conversar com um médico de verdade se não estiver bem, viu? Por que não explora nossas ervas com calma?",
                'suggested_herbs' => [],
                'related_products' => []
            ];
        }

        $suggestionText = "";

        if ($herbs->isNotEmpty()) {
            $mainHerb = $herbs->first();
            $suggestionText = "A terra nos deu a **{$mainHerb->name}**, que é maravilhosa para trazer calma e conforto. Prepare uma infusão morna com muito carinho, respire o vaporzinho e sinta o acolhimento.";
        } else {
            $mainRecipe = $recipes->first();
            $suggestionText = "A vovó tem a receita perfeita chamada **{$mainRecipe->name}**. Ela foi pensada justamente para ajudar você a reencontrar o equilíbrio e a calmaria.";
        }

        $text = "Oh, meu bem... Para isso que você me contou, a vovó tem uma sugestão. {$suggestionText} Lembre-se sempre de que essas dicas são complementares e não substituem uma consulta com o seu médico, está bem?";

        return [
            'text' => $text,
            'suggested_herbs' => $herbs->take(2)->values(),
            'related_products' => $relatedProducts->take(3)->values()
        ];
    }
}

