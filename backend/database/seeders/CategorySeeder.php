<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Ecommerce\Models\Category;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Chás & Infusões',
                'slug' => 'chas-e-infusoes',
                'description' => 'Chás e infusões de ervas selecionadas para saúde, relaxamento e bem-estar.',
            ],
            [
                'name' => 'Cosméticos Naturais',
                'slug' => 'cosmeticos-naturais',
                'description' => 'Sabonetes artesanais, pomadas e óleos essenciais com base em ervas medicinais.',
            ],
            [
                'name' => 'Acessórios & Utensílios',
                'slug' => 'acessorios-e-utensilios',
                'description' => 'Infusores, xícaras, bules e utensílios para preparar o seu ritual de chá.',
            ],
            [
                'name' => 'Kits & Presentes',
                'slug' => 'kits-e-presentes',
                'description' => 'Kits e presentes preparados com carinho e aroma especial de vovó.',
            ],
        ];

        foreach ($categories as $cat) {
            Category::updateOrCreate(
                ['slug' => $cat['slug']],
                $cat
            );
        }
    }
}
