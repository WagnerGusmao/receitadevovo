<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Wellness\Models\Benefit;

class BenefitSeeder extends Seeder
{
    public function run(): void
    {
        $benefits = [
            [
                'name' => 'Relaxamento',
                'slug' => 'relaxamento',
                'description' => 'Promove relaxamento muscular e mental, aliviando tensões do dia a dia',
                'icon' => '😌',
            ],
            [
                'name' => 'Digestão',
                'slug' => 'digestao',
                'description' => 'Auxilia no processo digestivo, reduzindo desconfortos estomacais',
                'icon' => '🌿',
            ],
            [
                'name' => 'Sono',
                'slug' => 'sono',
                'description' => 'Melhora a qualidade do sono e facilita o adormecer naturalmente',
                'icon' => '😴',
            ],
            [
                'name' => 'Ansiedade',
                'slug' => 'ansiedade',
                'description' => 'Reduz sintomas de ansiedade e promove bem-estar emocional',
                'icon' => '🧘',
            ],
            [
                'name' => 'Imunidade',
                'slug' => 'imunidade',
                'description' => 'Fortalece o sistema imunológico e aumenta as defesas do corpo',
                'icon' => '🛡️',
            ],
            [
                'name' => 'Energia',
                'slug' => 'energia',
                'description' => 'Aumenta a energia e disposição sem causar agitação',
                'icon' => '⚡',
            ],
            [
                'name' => 'Foco',
                'slug' => 'foco',
                'description' => 'Melhora concentração e clareza mental',
                'icon' => '🎯',
            ],
            [
                'name' => 'Anti-inflamatório',
                'slug' => 'anti-inflamatorio',
                'description' => 'Reduz processos inflamatórios no organismo',
                'icon' => '💊',
            ],
            [
                'name' => 'Detox',
                'slug' => 'detox',
                'description' => 'Auxilia na eliminação de toxinas e purificação do organismo',
                'icon' => '🌱',
            ],
            [
                'name' => 'Antioxidante',
                'slug' => 'antioxidante',
                'description' => 'Combate radicais livres e previne envelhecimento precoce',
                'icon' => '✨',
            ],
            [
                'name' => 'Circulação',
                'slug' => 'circulacao',
                'description' => 'Melhora a circulação sanguínea e saúde cardiovascular',
                'icon' => '❤️',
            ],
            [
                'name' => 'Respiratório',
                'slug' => 'respiratorio',
                'description' => 'Auxilia no sistema respiratório e desobstrução das vias aéreas',
                'icon' => '🌬️',
            ],
            [
                'name' => 'Memória',
                'slug' => 'memoria',
                'description' => 'Melhora memória e funções cognitivas',
                'icon' => '🧠',
            ],
            [
                'name' => 'TPM',
                'slug' => 'tpm',
                'description' => 'Alivia sintomas da tensão pré-menstrual',
                'icon' => '🌸',
            ],
            [
                'name' => 'Menopausa',
                'slug' => 'menopausa',
                'description' => 'Auxilia no equilíbrio hormonal durante a menopausa',
                'icon' => '🦋',
            ],
            [
                'name' => 'Pele',
                'slug' => 'pele',
                'description' => 'Promove saúde da pele e aparência jovem',
                'icon' => '💆',
            ],
            [
                'name' => 'Cabelo',
                'slug' => 'cabelo',
                'description' => 'Fortalece cabelos e estimula crescimento',
                'icon' => '💇',
            ],
            [
                'name' => 'Dor',
                'slug' => 'dor',
                'description' => 'Alivia dores musculares e articulares',
                'icon' => '💪',
            ],
            [
                'name' => 'Colesterol',
                'slug' => 'colesterol',
                'description' => 'Auxilia no controle dos níveis de colesterol',
                'icon' => '📉',
            ],
            [
                'name' => 'Diabetes',
                'slug' => 'diabetes',
                'description' => 'Ajuda no controle glicêmico',
                'icon' => '🩺',
            ],
            [
                'name' => 'Peso',
                'slug' => 'peso',
                'description' => 'Auxilia no controle de peso e metabolismo',
                'icon' => '⚖️',
            ],
            [
                'name' => 'Hormonal',
                'slug' => 'hormonal',
                'description' => 'Promove equilíbrio hormonal',
                'icon' => '⚖️',
            ],
            [
                'name' => 'Aphrodisíaco',
                'slug' => 'aphrodisiaco',
                'description' => 'Estimula libido e vitalidade sexual',
                'icon' => '❤️‍🔥',
            ],
            [
                'name' => 'Antiespasmódico',
                'slug' => 'antiespamodico',
                'description' => 'Alivia espasmos e cólicas',
                'icon' => '🌀',
            ],
            [
                'name' => 'Diurético',
                'slug' => 'diuretico',
                'description' => 'Auxilia na eliminação de líquidos',
                'icon' => '💧',
            ],
            [
                'name' => 'Cicatrizante',
                'slug' => 'cicatrizante',
                'description' => 'Acelera cicatrização de feridas',
                'icon' => '🩹',
            ],
            [
                'name' => 'Expectorante',
                'slug' => 'expectorante',
                'description' => 'Facilita eliminação de secreções pulmonares',
                'icon' => '🫁',
            ],
            [
                'name' => 'Calmante',
                'slug' => 'calmante',
                'description' => 'Acalma o sistema nervoso',
                'icon' => '🕊️',
            ],
            [
                'name' => 'Antibacteriano',
                'slug' => 'antibacteriano',
                'description' => 'Combate bactérias e infecções',
                'icon' => '🦠',
            ],
            [
                'name' => 'Adaptógeno',
                'slug' => 'adaptogeno',
                'description' => 'Aumenta resistência ao estresse físico e mental',
                'icon' => '🌟',
            ],
        ];

        foreach ($benefits as $benefit) {
            Benefit::updateOrCreate(
                ['slug' => $benefit['slug']],
                $benefit
            );
        }

        $this->command->info('✅ 30 benefícios criados com sucesso!');
    }
}
