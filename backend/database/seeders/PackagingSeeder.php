<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\Category;

class PackagingSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Criar ou obter a categoria de Embalagens
        $category = Category::updateOrCreate(
            ['slug' => 'embalagens-e-presentes'],
            [
                'name' => 'Embalagens & Presentes',
                'slug' => 'embalagens-e-presentes',
                'description' => 'Embalagens especiais, sacolas de presente e cestas decorativas para seus rituais.',
            ]
        );

        // 2. Criar os produtos de embalagem
        $packagingProducts = [
            [
                'name' => 'Sacola de Presente Kraft',
                'slug' => 'embalagem-presente-sacola',
                'description' => 'Sacola de papel Kraft premium decorada com fita de cetim e tag personalizada de vovó.',
                'short_description' => 'Sacola premium com fita de cetim',
                'price' => 5.00,
                'stock' => 9999,
                'featured_image' => '/imagem/embalagem-sacola.jpg', // Caminho padrão/mock
                'is_active' => true,
                'category_id' => $category->id,
            ],
            [
                'name' => 'Cesta Especial Decorada',
                'slug' => 'embalagem-presente-cesta',
                'description' => 'Cesta decorada especial com palha, laço e arranjo de flores secas. Perfeita para presentear com elegância.',
                'short_description' => 'Cesta com palha, laço e flores secas',
                'price' => 25.00,
                'stock' => 9999,
                'featured_image' => '/imagem/embalagem-cesta.jpg', // Caminho padrão/mock
                'is_active' => true,
                'category_id' => $category->id,
            ],
        ];

        foreach ($packagingProducts as $prod) {
            Product::updateOrCreate(
                ['slug' => $prod['slug']],
                $prod
            );
        }

        $this->command->info('✅ Embalagens de presente semeadas com sucesso!');
    }
}
