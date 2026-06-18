<?php

namespace Database\Seeders;

use App\Modules\Auth\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Criar usuário admin
        User::firstOrCreate(
            ['email' => 'receitadevovo@receitadevovo.com.br'],
            [
                'name' => 'Vovó Artesã',
                'whatsapp' => '11999887766',
                'password' => Hash::make('vovo1234'),
                'is_admin' => true,
            ]
        );

        $this->command->info('🌿 Iniciando seeders do catálogo...');

        // Ordem de dependências:
        // 1. Benefits e Emotions (sem dependências)
        // 2. Herbs (depende de Benefits e Emotions)
        // 3. Products (depende de Herbs)
        // 4. Kits (depende de Products)
        
        $this->call([
            BenefitSeeder::class,
            EmotionSeeder::class,
            HerbSeeder::class,
            CategorySeeder::class,
            ProductSeeder::class,
            KitSeeder::class,
        ]);

        $this->command->info('✅ Catálogo completo populado com sucesso!');
        $this->command->info('📊 Total: 30 benefícios | 15 emoções | 25 ervas | 15 produtos | 8 kits');
    }
}
