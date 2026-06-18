<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class LoyaltySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \Illuminate\Support\Facades\DB::table('loyalty_levels')->insert([
            [
                'name' => 'Semente de Alecrim',
                'min_points' => 0,
                'discount_percentage' => 0.00,
                'badge_icon' => 'seed',
                'description' => 'Começo da sua jornada de bem-estar natural.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Brotinho de Hortelã',
                'min_points' => 200,
                'discount_percentage' => 5.00,
                'badge_icon' => 'leaf',
                'description' => 'Você está florescendo! Ganhe 5% de desconto em rituais de compra.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Arbusto de Lavanda',
                'min_points' => 500,
                'discount_percentage' => 10.00,
                'badge_icon' => 'flower',
                'description' => 'Um aroma suave e marcante. Ganhe 10% de desconto em rituais de compra.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Árvore de Sálvia',
                'min_points' => 1500,
                'discount_percentage' => 15.00,
                'badge_icon' => 'tree',
                'description' => 'A sabedoria máxima da natureza. Ganhe 15% de desconto em todas as suas compras.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
