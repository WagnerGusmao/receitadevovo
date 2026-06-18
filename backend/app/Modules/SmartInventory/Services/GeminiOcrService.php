<?php

namespace App\Modules\SmartInventory\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class GeminiOcrService
{
    private const API_BASE = 'https://generativelanguage.googleapis.com/v1beta/models/';

    private const EXTRACTION_PROMPT = <<<'PROMPT'
Você é um sistema especializado em extração de dados de notas fiscais e documentos de compra brasileiros.

Analise o documento fornecido e extraia TODOS os itens comprados.

Retorne APENAS um JSON válido (sem markdown, sem texto extra, sem ```json) com esta estrutura exata:
{
  "supplier": "nome do fornecedor ou null",
  "purchase_date": "YYYY-MM-DD ou null",
  "document_number": "número do documento, NF ou cupom fiscal ou null",
  "total_value": número ou null,
  "items": [
    {
      "description": "descrição exata do produto como está no documento",
      "quantity": número,
      "unit": "unidade de medida (g, kg, ml, L, un, cx, pç, etc)",
      "unit_price": número ou null,
      "total_price": número ou null
    }
  ]
}

Regras importantes:
- Extraia TODOS os itens listados, sem excepção
- Mantenha a descrição exatamente como está no documento
- Converta datas para formato YYYY-MM-DD
- Use ponto como separador decimal
- Valores monetários sem símbolo de moeda
- Se não identificar um campo, use null
- Retorne APENAS o JSON, nenhum texto adicional antes ou depois
PROMPT;

    public function extractFromFile(string $storagePath, string $mimeType): array
    {
        $apiKey = config('services.gemini.key');
        $model  = config('services.gemini.model', 'gemini-2.0-flash');
        $apiUrl = self::API_BASE . $model . ':generateContent';

        if (!$apiKey) {
            throw new \RuntimeException('GEMINI_API_KEY não configurado. Configure a variável de ambiente para usar extração inteligente.');
        }

        $fileContent = Storage::get($storagePath);
        if (!$fileContent) {
            throw new \RuntimeException("Arquivo não encontrado: {$storagePath}");
        }

        $base64 = base64_encode($fileContent);

        $payload = [
            'contents' => [
                [
                    'parts' => [
                        [
                            'inline_data' => [
                                'mime_type' => $mimeType,
                                'data'      => $base64,
                            ],
                        ],
                        [
                            'text' => self::EXTRACTION_PROMPT,
                        ],
                    ],
                ],
            ],
            'generationConfig' => [
                'temperature'     => 0.1,
                'maxOutputTokens' => 4096,
            ],
        ];

        $response = Http::timeout(120)
            ->connectTimeout(15)
            ->withoutVerifying()
            ->withQueryParameters(['key' => $apiKey])
            ->post($apiUrl, $payload);

        if ($response->failed()) {
            $errorBody = $response->json();
            $errorMsg  = $errorBody['error']['message'] ?? $response->body();
            Log::error('GeminiOcrService: API error', ['status' => $response->status(), 'error' => $errorMsg]);
            throw new \RuntimeException("Erro na API Gemini: {$errorMsg}");
        }

        $rawText = $response->json('candidates.0.content.parts.0.text', '');

        Log::info('GeminiOcrService: raw response', ['chars' => strlen($rawText)]);

        return $this->parseResponse($rawText);
    }

    /**
     * Extrai e valida o JSON da resposta do Gemini.
     */
    private function parseResponse(string $rawText): array
    {
        $text = trim($rawText);

        // Remove markdown code fences se presentes
        $text = preg_replace('/^```(?:json)?\s*/i', '', $text);
        $text = preg_replace('/\s*```$/i', '', $text);
        $text = trim($text);

        $data = json_decode($text, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            // Tenta extrair apenas o bloco JSON com regex
            if (preg_match('/\{.*\}/s', $text, $matches)) {
                $data = json_decode($matches[0], true);
            }
        }

        if (!is_array($data)) {
            throw new \RuntimeException('A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.');
        }

        // Garante a estrutura mínima
        return [
            'supplier'        => $data['supplier'] ?? null,
            'purchase_date'   => $data['purchase_date'] ?? null,
            'document_number' => $data['document_number'] ?? null,
            'total_value'     => isset($data['total_value']) ? (float) $data['total_value'] : null,
            'items'           => $this->normalizeItems($data['items'] ?? []),
        ];
    }

    private function normalizeItems(array $items): array
    {
        return array_values(array_filter(
            array_map(function (array $item): ?array {
                if (empty($item['description'])) {
                    return null;
                }
                return [
                    'description' => trim($item['description']),
                    'quantity'    => max(0.001, (float) ($item['quantity'] ?? 1)),
                    'unit'        => trim($item['unit'] ?? 'un'),
                    'unit_price'  => isset($item['unit_price']) && $item['unit_price'] !== null ? (float) $item['unit_price'] : null,
                    'total_price' => isset($item['total_price']) && $item['total_price'] !== null ? (float) $item['total_price'] : null,
                ];
            }, $items)
        ));
    }

    /**
     * Determina o MIME type a partir da extensão do arquivo.
     */
    public static function mimeFromExtension(string $extension): string
    {
        return match (strtolower($extension)) {
            'pdf'        => 'application/pdf',
            'png'        => 'image/png',
            'jpg', 'jpeg' => 'image/jpeg',
            'webp'       => 'image/webp',
            default      => 'image/jpeg',
        };
    }
}
