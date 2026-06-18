<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Wellness\Models\Herb;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $products = [
            [
                'name' => 'Chá de Camomila Premium',
                'slug' => 'cha-de-camomila-premium',
                'description' => 'Flores de camomila selecionadas para momentos de tranquilidade. Ideal para relaxar após um dia agitado e promover um sono reparador.',
                'short_description' => 'Flores selecionadas para relaxamento e sono tranquilo',
                'price' => 19.90,
                'old_price' => 24.90,
                'discount_percent' => 20,
                'stock' => 150,
                'featured_image' => '/images/products/cha-camomila.jpg',
                'images' => [
                    '/images/products/cha-camomila-2.jpg',
                    '/images/products/cha-camomila-3.jpg',
                    '/images/products/cha-camomila-4.jpg',
                ],
                'is_active' => true,
                'herbs' => ['camomila'],
            ],
            [
                'name' => 'Chá de Lavanda Orgânica',
                'slug' => 'cha-de-lavanda-organica',
                'description' => 'Flores de lavanda orgânicas com aroma suave e relaxante. Perfeito para antes de dormir e momentos de autocuidado.',
                'short_description' => 'Flores orgânicas para sono profundo e relaxamento',
                'price' => 24.90,
                'old_price' => 29.90,
                'discount_percent' => 17,
                'stock' => 100,
                'featured_image' => '/images/products/cha-lavanda.jpg',
                'images' => [
                    '/images/products/cha-lavanda-2.jpg',
                    '/images/products/cha-lavanda-3.jpg',
                ],
                'is_active' => true,
                'herbs' => ['lavanda'],
            ],
            [
                'name' => 'Chá de Hortelã Refrescante',
                'slug' => 'cha-de-hortela-refrescante',
                'description' => 'Folhas de hortelã frescas e aromáticas. Excelente para digestão e refrescar o hálito naturalmente.',
                'short_description' => 'Folhas aromáticas para digestão e frescor',
                'price' => 19.90,
                'stock' => 200,
                'featured_image' => '/images/products/cha-hortela.jpg',
                'is_active' => true,
                'herbs' => ['hortela'],
            ],
            [
                'name' => 'Chá de Alecrim Revigorante',
                'slug' => 'cha-de-alecrim-revigorante',
                'description' => 'Folhas de alecrim que estimulam memória e concentração. Perfeito para começar o dia com energia e foco.',
                'short_description' => 'Estimula memória, concentração e energia vital',
                'price' => 22.90,
                'stock' => 120,
                'featured_image' => '/images/products/cha-alecrim.jpg',
                'is_active' => true,
                'herbs' => ['alecrim'],
            ],
            [
                'name' => 'Chá de Gengibre Poderoso',
                'slug' => 'cha-de-gengibre-poderoso',
                'description' => 'Raiz de gengibre desidratada com sabor marcante. Fortalece imunidade e aquece o corpo nos dias frios.',
                'short_description' => 'Raiz poderosa para imunidade e vitalidade',
                'price' => 27.90,
                'stock' => 130,
                'featured_image' => '/images/products/cha-gengibre.jpg',
                'is_active' => true,
                'herbs' => ['gengibre'],
            ],
            [
                'name' => 'Chá de Erva-Cidreira Calmante',
                'slug' => 'cha-de-erva-cidreira-calmante',
                'description' => 'Folhas de erva-cidreira com aroma cítrico delicado. Acalma ansiedade e tensão nervosa naturalmente.',
                'short_description' => 'Aroma cítrico para ansiedade e tensão',
                'price' => 23.90,
                'stock' => 140,
                'featured_image' => '/images/products/cha-erva-cidreira.jpg',
                'is_active' => true,
                'herbs' => ['erva-cidreira'],
            ],
            [
                'name' => 'Chá de Hibisco Detox',
                'slug' => 'cha-de-hibisco-detox',
                'description' => 'Flores de hibisco ricas em antioxidantes. Auxilia no controle do peso e desintoxicação do organismo.',
                'short_description' => 'Flores antioxidantes para detox e vitalidade',
                'price' => 21.90,
                'old_price' => 26.90,
                'discount_percent' => 19,
                'promo_end' => now()->addDays(7), // Promoção por 7 dias
                'stock' => 160,
                'featured_image' => '/images/products/cha-hibisco.jpg',
                'images' => [
                    '/images/products/cha-hibisco-2.jpg',
                    '/images/products/cha-hibisco-3.jpg',
                    '/images/products/cha-hibisco-4.jpg',
                    '/images/products/cha-hibisco-5.jpg',
                ],
                'is_active' => true,
                'herbs' => ['hibisco'],
            ],
            [
                'name' => 'Chá Verde Energizante',
                'slug' => 'cha-verde-energizante',
                'description' => 'Folhas de chá verde premium ricas em antioxidantes. Acelera metabolismo e promove energia sustentada.',
                'short_description' => 'Antioxidantes para energia e metabolismo',
                'price' => 31.90,
                'stock' => 110,
                'featured_image' => '/images/products/cha-verde.jpg',
                'is_active' => true,
                'herbs' => ['cha-verde'],
            ],
            [
                'name' => 'Chá de Boldo Digestivo',
                'slug' => 'cha-de-boldo-digestivo',
                'description' => 'Folhas de boldo tradicionais para auxiliar digestão. Ideal após refeições pesadas.',
                'short_description' => 'Tradicional para digestão e bem-estar',
                'price' => 18.90,
                'stock' => 180,
                'featured_image' => '/images/products/cha-boldo.jpg',
                'is_active' => true,
                'herbs' => ['boldo'],
            ],
            [
                'name' => 'Chá de Canela Aquecedor',
                'slug' => 'cha-de-canela-aquecedor',
                'description' => 'Paus de canela aromáticos que aquecem o corpo e regulam açúcar no sangue.',
                'short_description' => 'Aquece o corpo e regula glicemia',
                'price' => 25.90,
                'stock' => 125,
                'featured_image' => '/images/products/cha-canela.jpg',
                'is_active' => true,
                'herbs' => ['canela'],
            ],
            [
                'name' => 'Blend Sono Tranquilo',
                'slug' => 'blend-sono-tranquilo',
                'description' => 'Combinação de camomila, lavanda e erva-cidreira para uma noite de sono profundo e reparador.',
                'short_description' => 'Blend especial para sono profundo',
                'price' => 34.90,
                'stock' => 90,
                'featured_image' => '/images/products/blend-sono.jpg',
                'is_active' => true,
                'herbs' => ['camomila', 'lavanda', 'erva-cidreira'],
            ],
            [
                'name' => 'Blend Digestão Perfeita',
                'slug' => 'blend-digestao-perfeita',
                'description' => 'Mix de hortelã, boldo e erva-doce para digestão leve e sem desconfortos.',
                'short_description' => 'Mix para digestão sem desconfortos',
                'price' => 32.90,
                'stock' => 95,
                'featured_image' => '/images/products/blend-digestao.jpg',
                'is_active' => true,
                'herbs' => ['hortela', 'boldo', 'erva-doce'],
            ],
            [
                'name' => 'Blend Energia Natural',
                'slug' => 'blend-energia-natural',
                'description' => 'Combinação de gengibre, alecrim e chá verde para energia sustentada ao longo do dia.',
                'short_description' => 'Energia natural sem agitação',
                'price' => 36.90,
                'stock' => 85,
                'featured_image' => '/images/products/blend-energia.jpg',
                'is_active' => true,
                'herbs' => ['gengibre', 'alecrim', 'cha-verde'],
            ],
            [
                'name' => 'Blend Imunidade Forte',
                'slug' => 'blend-imunidade-forte',
                'description' => 'Mix de gengibre, equinácea e cúrcuma para fortalecer defesas naturais do corpo.',
                'short_description' => 'Fortalece imunidade naturalmente',
                'price' => 38.90,
                'stock' => 80,
                'featured_image' => '/images/products/blend-imunidade.jpg',
                'is_active' => true,
                'herbs' => ['gengibre', 'equinacea', 'curcuma'],
            ],
            [
                'name' => 'Blend Detox Completo',
                'slug' => 'blend-detox-completo',
                'description' => 'Hibisco, dente-de-leão e cavalinha para desintoxicação profunda e renovação.',
                'short_description' => 'Desintoxica e renova o organismo',
                'price' => 35.90,
                'stock' => 88,
                'featured_image' => '/images/products/blend-detox.jpg',
                'is_active' => true,
                'herbs' => ['hibisco', 'dente-de-leao', 'cavalinha'],
            ],
        ];

        $category = \App\Modules\Ecommerce\Models\Category::where('slug', 'chas-e-infusoes')->first();
        $categoryId = $category ? $category->id : null;

        foreach ($products as $productData) {
            $product = Product::updateOrCreate(
                ['slug' => $productData['slug']],
                [
                    'name' => $productData['name'],
                    'slug' => $productData['slug'],
                    'description' => $productData['description'],
                    'short_description' => $productData['short_description'],
                    'price' => $productData['price'],
                    'stock' => $productData['stock'],
                    'featured_image' => $productData['featured_image'],
                    'is_active' => $productData['is_active'],
                    'category_id' => $categoryId,
                ]
            );

            // Relacionar ervas
            if (!empty($productData['herbs'])) {
                $herbIds = Herb::whereIn('slug', $productData['herbs'])->pluck('id');
                $product->herbs()->sync($herbIds);
            }
        }

        $this->command->info('✅ 15 produtos criados com sucesso!');
    }
}
