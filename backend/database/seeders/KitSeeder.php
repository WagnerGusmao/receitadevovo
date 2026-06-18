<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Ecommerce\Models\Kit;
use App\Modules\Ecommerce\Models\Product;

class KitSeeder extends Seeder
{
    public function run(): void
    {
        $kits = [
            [
                'name' => 'Kit Bem-Estar Completo',
                'slug' => 'kit-bem-estar-completo',
                'description' => 'Experiência completa de autocuidado com nossos chás mais populares. Inclui Camomila, Lavanda, Hortelã, Alecrim e Gengibre.',
                'short_description' => '5 chás essenciais para seu ritual diário',
                'price' => 109.90,
                'original_price' => 129.50,
                'stock' => 50,
                'featured_image' => '/images/kits/bem-estar-completo.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-camomila-premium',
                    'cha-de-lavanda-organica',
                    'cha-de-hortela-refrescante',
                    'cha-de-alecrim-revigorante',
                    'cha-de-gengibre-poderoso',
                ],
            ],
            [
                'name' => 'Kit Noites Tranquilas',
                'slug' => 'kit-noites-tranquilas',
                'description' => 'Tudo que você precisa para noites de sono profundo e reparador. Camomila, Lavanda e o Blend Sono Tranquilo.',
                'short_description' => 'Para noites de sono profundo',
                'price' => 79.90,
                'original_price' => 89.70,
                'stock' => 60,
                'featured_image' => '/images/kits/noites-tranquilas.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-camomila-premium',
                    'cha-de-lavanda-organica',
                    'blend-sono-tranquilo',
                ],
            ],
            [
                'name' => 'Kit Energia & Foco',
                'slug' => 'kit-energia-foco',
                'description' => 'Para dias produtivos e cheios de energia. Alecrim, Chá Verde e Blend Energia Natural.',
                'short_description' => 'Energia sustentada ao longo do dia',
                'price' => 84.90,
                'original_price' => 91.70,
                'stock' => 55,
                'featured_image' => '/images/kits/energia-foco.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-alecrim-revigorante',
                    'cha-verde-energizante',
                    'blend-energia-natural',
                ],
            ],
            [
                'name' => 'Kit Detox Renovação',
                'slug' => 'kit-detox-renovacao',
                'description' => 'Renove seu corpo de dentro para fora. Hibisco, Chá Verde e Blend Detox Completo para purificação total.',
                'short_description' => 'Desintoxicação e renovação corporal',
                'price' => 89.90,
                'original_price' => 94.70,
                'stock' => 45,
                'featured_image' => '/images/kits/detox-renovacao.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-hibisco-detox',
                    'cha-verde-energizante',
                    'blend-detox-completo',
                ],
            ],
            [
                'name' => 'Kit Digestão Saudável',
                'slug' => 'kit-digestao-saudavel',
                'description' => 'Para um sistema digestivo em perfeito equilíbrio. Hortelã, Boldo e Blend Digestão Perfeita.',
                'short_description' => 'Sistema digestivo em equilíbrio',
                'price' => 69.90,
                'original_price' => 71.70,
                'stock' => 65,
                'featured_image' => '/images/kits/digestao-saudavel.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-hortela-refrescante',
                    'cha-de-boldo-digestivo',
                    'blend-digestao-perfeita',
                ],
            ],
            [
                'name' => 'Kit Imunidade Plus',
                'slug' => 'kit-imunidade-plus',
                'description' => 'Fortaleça suas defesas naturais. Gengibre, Canela e Blend Imunidade Forte.',
                'short_description' => 'Fortalece defesas do organismo',
                'price' => 86.90,
                'original_price' => 92.70,
                'stock' => 48,
                'featured_image' => '/images/kits/imunidade-plus.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-gengibre-poderoso',
                    'cha-de-canela-aquecedor',
                    'blend-imunidade-forte',
                ],
            ],
            [
                'name' => 'Kit Ansiedade Zero',
                'slug' => 'kit-ansiedade-zero',
                'description' => 'Para acalmar a mente e reduzir ansiedade. Camomila, Erva-Cidreira e Lavanda.',
                'short_description' => 'Acalma mente e reduz ansiedade',
                'price' => 74.90,
                'original_price' => 78.70,
                'stock' => 52,
                'featured_image' => '/images/kits/ansiedade-zero.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-camomila-premium',
                    'cha-de-erva-cidreira-calmante',
                    'cha-de-lavanda-organica',
                ],
            ],
            [
                'name' => 'Kit Iniciante Receita de Vovó',
                'slug' => 'kit-iniciante-receita-de-vovo',
                'description' => 'Perfeito para quem está começando. Experimente nossos 3 chás mais populares.',
                'short_description' => 'Ideal para começar sua jornada',
                'price' => 59.90,
                'original_price' => 67.70,
                'stock' => 70,
                'featured_image' => '/images/kits/iniciante.jpg',
                'is_active' => true,
                'products' => [
                    'cha-de-camomila-premium',
                    'cha-de-hortela-refrescante',
                    'cha-de-gengibre-poderoso',
                ],
            ],
        ];

        foreach ($kits as $kitData) {
            $kit = Kit::updateOrCreate(
                ['slug' => $kitData['slug']],
                [
                    'name' => $kitData['name'],
                    'slug' => $kitData['slug'],
                    'description' => $kitData['description'],
                    'short_description' => $kitData['short_description'],
                    'price' => $kitData['price'],
                    'original_price' => $kitData['original_price'],
                    'stock' => $kitData['stock'],
                    'featured_image' => $kitData['featured_image'],
                    'is_active' => $kitData['is_active'],
                ]
            );

            // Relacionar produtos
            if (!empty($kitData['products'])) {
                $productIds = Product::whereIn('slug', $kitData['products'])->pluck('id');
                $kit->products()->sync($productIds);
            }
        }

        $this->command->info('✅ 8 kits criados com sucesso!');
    }
}
