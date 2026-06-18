<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Wellness\Models\Emotion;

class EmotionSeeder extends Seeder
{
    public function run(): void
    {
        $emotions = [
            [
                'name' => 'Estresse',
                'slug' => 'estresse',
                'description' => 'Sensação de tensão, pressão ou sobrecarga emocional',
                'color' => '#FF6B6B',
            ],
            [
                'name' => 'Ansiedade',
                'slug' => 'ansiedade',
                'description' => 'Preocupação excessiva, inquietação e nervosismo',
                'color' => '#FFD93D',
            ],
            [
                'name' => 'Tristeza',
                'slug' => 'tristeza',
                'description' => 'Sentimento de melancolia, desânimo ou pesar',
                'color' => '#6C5CE7',
            ],
            [
                'name' => 'Raiva',
                'slug' => 'raiva',
                'description' => 'Irritação, frustração ou sentimento de injustiça',
                'color' => '#E74C3C',
            ],
            [
                'name' => 'Medo',
                'slug' => 'medo',
                'description' => 'Sensação de perigo, insegurança ou apreensão',
                'color' => '#95A5A6',
            ],
            [
                'name' => 'Cansaço',
                'slug' => 'cansaco',
                'description' => 'Fadiga física ou mental, exaustão',
                'color' => '#A29BFE',
            ],
            [
                'name' => 'Insônia',
                'slug' => 'insonia',
                'description' => 'Dificuldade para dormir ou manter o sono',
                'color' => '#2C3E50',
            ],
            [
                'name' => 'Agitação',
                'slug' => 'agitacao',
                'description' => 'Inquietude, hiperatividade mental ou física',
                'color' => '#FD79A8',
            ],
            [
                'name' => 'Desânimo',
                'slug' => 'desanimo',
                'description' => 'Falta de motivação, energia ou interesse',
                'color' => '#636E72',
            ],
            [
                'name' => 'Solidão',
                'slug' => 'solidao',
                'description' => 'Sentimento de isolamento ou falta de conexão',
                'color' => '#74B9FF',
            ],
            [
                'name' => 'Confusão Mental',
                'slug' => 'confusao-mental',
                'description' => 'Dificuldade de concentração ou clareza de pensamento',
                'color' => '#DFE6E9',
            ],
            [
                'name' => 'Luto',
                'slug' => 'luto',
                'description' => 'Processo de perda e elaboração de despedida',
                'color' => '#2D3436',
            ],
            [
                'name' => 'Culpa',
                'slug' => 'culpa',
                'description' => 'Sentimento de responsabilidade por algo negativo',
                'color' => '#A29BFE',
            ],
            [
                'name' => 'Vergonha',
                'slug' => 'vergonha',
                'description' => 'Sensação de inadequação ou exposição negativa',
                'color' => '#FFEAA7',
            ],
            [
                'name' => 'Impaciência',
                'slug' => 'impaciencia',
                'description' => 'Dificuldade em esperar ou tolerar demoras',
                'color' => '#FF7675',
            ],
        ];

        foreach ($emotions as $emotion) {
            Emotion::updateOrCreate(
                ['slug' => $emotion['slug']],
                $emotion
            );
        }

        $this->command->info('✅ 15 emoções criadas com sucesso!');
    }
}
