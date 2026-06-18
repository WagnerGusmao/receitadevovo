<?php

namespace App\Modules\SmartInventory\Services;

use App\Modules\Inventory\Models\RawMaterial;
use Illuminate\Support\Collection;

class MaterialMatchingService
{
    private const CONFIDENCE_THRESHOLD = 0.30;
    private const TOP_RESULTS = 3;

    /**
     * Unidades conhecidas mapeadas para formas normalizadas.
     */
    private const UNIT_MAP = [
        'grama'     => 'g',  'gramas' => 'g',
        'kilograma' => 'kg', 'quilograma' => 'kg', 'quilogramas' => 'kg',
        'mililitro' => 'ml', 'mililitros' => 'ml',
        'litro'     => 'L',  'litros' => 'L',
        'unidade'   => 'un', 'unidades' => 'un', 'peca' => 'un', 'pecas' => 'un',
        'caixa'     => 'cx', 'frasco' => 'un', 'pote' => 'un', 'sache' => 'un',
    ];

    /**
     * Retorna as top-N matérias-primas correspondentes para uma descrição extraída.
     *
     * @return array<int, array{raw_material_id: int, name: string, unit: string, confidence: float}>
     */
    public function findMatches(string $description, int $limit = self::TOP_RESULTS): array
    {
        $normalized = $this->normalize($description);

        if (empty($normalized)) {
            return [];
        }

        $materials = RawMaterial::where('is_active', true)->get(['id', 'name', 'unit', 'category']);

        $scored = $materials->map(function (RawMaterial $material) use ($normalized): array {
            $materialNorm = $this->normalize($material->name);
            $confidence   = $this->score($normalized, $materialNorm);

            return [
                'raw_material_id' => $material->id,
                'name'            => $material->name,
                'unit'            => $material->unit,
                'confidence'      => $confidence,
            ];
        })
        ->filter(fn(array $r) => $r['confidence'] >= self::CONFIDENCE_THRESHOLD)
        ->sortByDesc('confidence')
        ->values()
        ->take($limit)
        ->toArray();

        return $scored;
    }

    /**
     * Normaliza uma string para comparação.
     */
    public function normalize(string $text): string
    {
        $text = mb_strtolower($text, 'UTF-8');

        // Remove acentos via transliteração
        if (function_exists('transliterator_transliterate')) {
            $text = transliterator_transliterate('Any-Latin; Latin-ASCII', $text);
        } else {
            $text = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $text) ?: $text;
        }

        // Remove caracteres especiais exceto letras, números e espaços
        $text = preg_replace('/[^a-z0-9\s]/', ' ', $text);

        // Colapsa espaços múltiplos
        $text = preg_replace('/\s+/', ' ', trim($text));

        return $text;
    }

    /**
     * Calcula score de similaridade entre dois textos normalizados (0.0 – 1.0).
     */
    private function score(string $a, string $b): float
    {
        if ($a === $b) {
            return 1.0;
        }

        // similar_text percentage
        similar_text($a, $b, $simPercent);
        $simScore = $simPercent / 100;

        // Levenshtein normalizado
        $maxLen  = max(strlen($a), strlen($b));
        $leven   = $maxLen > 0 ? (1 - levenshtein($a, $b) / $maxLen) : 0;

        // Média ponderada: similar_text tem mais peso
        $base = ($simScore * 0.6) + ($leven * 0.4);

        // Bônus por palavras em comum
        $wordsA = array_filter(explode(' ', $a), fn(string $w) => strlen($w) > 2);
        $wordsB = explode(' ', $b);

        $commonWords = 0;
        foreach ($wordsA as $word) {
            if (in_array($word, $wordsB, true)) {
                $commonWords++;
            }
        }

        $wordBonus = count($wordsA) > 0
            ? ($commonWords / count($wordsA)) * 0.20
            : 0;

        return min(1.0, round($base + $wordBonus, 4));
    }

    /**
     * Normaliza unidade de medida extraída para o padrão do sistema.
     */
    public function normalizeUnit(string $unit): ?string
    {
        $u = strtolower(trim($unit));

        // Já está no formato padrão
        if (in_array($u, ['g', 'kg', 'ml', 'L', 'un', 'oz', 'cx'])) {
            return $u === 'l' ? 'L' : $u;
        }

        return self::UNIT_MAP[$u] ?? null;
    }
}
