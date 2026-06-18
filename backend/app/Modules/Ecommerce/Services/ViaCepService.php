<?php

namespace App\Modules\Ecommerce\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class ViaCepService
{
    private const BASE_URL = 'https://viacep.com.br/ws/';

    /**
     * Busca dados do endereço a partir de um CEP.
     *
     * @param string $cep
     * @return array|null
     */
    public function lookup(string $cep): ?array
    {
        $cleanedCep = preg_replace('/\D/', '', $cep);

        if (strlen($cleanedCep) !== 8) {
            return null;
        }

        try {
            $response = Http::timeout(5)
                ->connectTimeout(3)
                ->withoutVerifying() // Evitar problemas de SSL locais
                ->get(self::BASE_URL . $cleanedCep . '/json/');

            if ($response->failed()) {
                Log::error('ViaCepService: Falha na requisição ao ViaCEP', [
                    'status' => $response->status(),
                    'cep' => $cleanedCep,
                ]);
                return null;
            }

            $data = $response->json();

            // ViaCEP retorna erro: true se não encontrar o CEP
            if (isset($data['erro']) && ($data['erro'] === true || $data['erro'] === 'true')) {
                return null;
            }

            return [
                'cep' => $data['cep'] ?? '',
                'logradouro' => $data['logradouro'] ?? '',
                'complemento' => $data['complemento'] ?? '',
                'bairro' => $data['bairro'] ?? '',
                'localidade' => $data['localidade'] ?? '',
                'uf' => $data['uf'] ?? '',
            ];
        } catch (\Throwable $e) {
            Log::error('ViaCepService: Exceção ao buscar CEP', [
                'cep' => $cleanedCep,
                'error' => $e->getMessage(),
            ]);
            return null;
        }
    }
}
