<?php

namespace App\Modules\Wellness\Database\Seeders;

use App\Modules\Wellness\Models\Benefit;
use App\Modules\Wellness\Models\Emotion;
use App\Modules\Wellness\Models\Herb;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class WellnessSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Limpar tabelas de ervas e pivôs com segurança
        Schema::disableForeignKeyConstraints();
        DB::table('benefit_herb')->truncate();
        DB::table('emotion_herb')->truncate();
        DB::table('herbs')->truncate();
        Schema::enableForeignKeyConstraints();

        // 2. Garantir que os benefícios principais existam na base
        $benefits = [
            'relaxamento'       => ['name' => 'Relaxamento', 'description' => 'Ajuda a acalmar o corpo e a mente.'],
            'energia'           => ['name' => 'Energia', 'description' => 'Proporciona vigor e disposição.'],
            'foco'              => ['name' => 'Foco', 'description' => 'Melhora a concentração e clareza mental.'],
            'digestao'          => ['name' => 'Digestão', 'description' => 'Auxilia no processo digestivo e trato estomacal.'],
            'sono'              => ['name' => 'Sono', 'description' => 'Combate a insônia e melhora a qualidade do sono.'],
            'ansiedade'         => ['name' => 'Ansiedade', 'description' => 'Reduz a agitação mental e preocupação excessiva.'],
            'imunidade'         => ['name' => 'Imunidade', 'description' => 'Fortalece as defesas naturais do organismo.'],
            'anti-inflamatorio' => ['name' => 'Anti-inflamatório', 'description' => 'Combate inflamações no corpo.'],
            'circulacao'        => ['name' => 'Circulação', 'description' => 'Estimula e melhora o fluxo circulatório.'],
            'respiratorio'      => ['name' => 'Respiratório', 'description' => 'Alivia vias aéreas e melhora a respiração.'],
            'memoria'           => ['name' => 'Memória', 'description' => 'Melhora a cognição e retenção de lembranças.'],
            'tpm'               => ['name' => 'TPM', 'description' => 'Alivia dores e oscilações de humor pré-menstruais.'],
            'menopausa'         => ['name' => 'Menopausa', 'description' => 'Ameniza calorões e instabilidades da menopausa.'],
            'pele'              => ['name' => 'Pele', 'description' => 'Auxilia na hidratação, cicatrização e regeneração da pele.'],
            'dor'               => ['name' => 'Dor', 'description' => 'Ajuda a aliviar dores musculares, de cabeça e articulares.'],
            'diuretico'         => ['name' => 'Diurético', 'description' => 'Estimula a eliminação de líquidos e toxinas.'],
            'cicatrizante'      => ['name' => 'Cicatrizante', 'description' => 'Acelera a cicatrização de feridas e queimaduras.'],
            'expectorante'      => ['name' => 'Expectorante', 'description' => 'Facilita a eliminação de secreções pulmonares.'],
            'calmante'          => ['name' => 'Calmante', 'description' => 'Atua no sistema nervoso acalmando agitações.'],
            'antibacteriano'    => ['name' => 'Antibacteriano', 'description' => 'Auxilia no combate a bactérias nocivas.'],
            'hormonal'          => ['name' => 'Hormonal', 'description' => 'Auxilia na regulação e balanço hormonal.'],
        ];

        $benefitModels = [];
        foreach ($benefits as $slug => $data) {
            $benefitModels[$slug] = Benefit::firstOrCreate(
                ['slug' => $slug],
                ['name' => $data['name'], 'description' => $data['description']]
            );
        }

        // 3. Garantir emoções básicas
        $emotions = [
            'ansiedade' => ['name' => 'Ansiedade', 'description' => 'Para momentos de agitação e preocupação.'],
            'cansaco'   => ['name' => 'Cansaço', 'description' => 'Para quando o corpo pede descanso.'],
            'alegria'   => ['name' => 'Alegria', 'description' => 'Para celebrar e elevar o espírito.'],
            'tristeza'  => ['name' => 'Tristeza', 'description' => 'Para momentos de recolhimento e conforto.'],
            'estresse'  => ['name' => 'Estresse', 'description' => 'Para desacelerar e aliviar pressões.'],
        ];

        $emotionModels = [];
        foreach ($emotions as $slug => $data) {
            $emotionModels[$slug] = Emotion::firstOrCreate(
                ['name' => $data['name']],
                ['description' => $data['description']]
            );
        }

        // 4. Carregar todas as 100 ervas a partir dos arquivos JSON modulares
        $dataDir = __DIR__ . '/data';
        $jsonFiles = [
            $dataDir . '/herbs_initial.json',
            $dataDir . '/herbs_batch_1.json',
            $dataDir . '/herbs_batch_2.json',
            $dataDir . '/herbs_batch_3.json',
            $dataDir . '/herbs_batch_4.json',
            $dataDir . '/herbs_batch_5.json',
            $dataDir . '/herbs_batch_6.json',
        ];

        $herbsData = [];
        $seenNames = [];
        $seenSlugs = [];
        foreach ($jsonFiles as $file) {
            if (file_exists($file)) {
                $content = file_get_contents($file);
                $decoded = json_decode($content, true);
                if (is_array($decoded)) {
                    foreach ($decoded as $h) {
                        $nameClean = mb_strtolower(trim($h['name']));
                        $slugClean = mb_strtolower(trim($h['slug']));
                        if (!in_array($nameClean, $seenNames) && !in_array($slugClean, $seenSlugs)) {
                            $seenNames[] = $nameClean;
                            $seenSlugs[] = $slugClean;
                            $herbsData[] = $h;
                        }
                    }
                }
            }
        }

        // 5. Inserir dados e anexar os relacionamentos de benefícios e emoções dinamicamente
        foreach ($herbsData as $h) {
            $herb = Herb::create([
                'name'              => $h['name'],
                'scientific_name'   => $h['scientific_name'] ?? null,
                'aliases'           => $h['aliases'] ?? null,
                'slug'              => $h['slug'],
                'description'       => $h['description'],
                'contraindications' => $h['contraindications'] ?? null,
                'how_to_use'        => $h['how_to_use'] ?? null,
                'bath_instructions' => $h['bath_instructions'] ?? null,
                'incense_usage'     => $h['incense_usage'] ?? null,
                'image_path'        => $h['image_path'] ?? '/images/herbs/folha.png',
                'source_type'       => $h['source_type'] ?? 'popular',
                'sources'           => $h['sources'] ?? null
            ]);

            // Anexar benefícios
            $bIds = [];
            if (!empty($h['benefits']) && is_array($h['benefits'])) {
                foreach ($h['benefits'] as $bSlug) {
                    if (isset($benefitModels[$bSlug])) {
                        $bIds[] = $benefitModels[$bSlug]->id;
                    }
                }
            }
            if (!empty($bIds)) {
                $herb->benefits()->attach($bIds);
            }

            // Anexar emoções
            $eIds = [];
            if (!empty($h['emotions']) && is_array($h['emotions'])) {
                foreach ($h['emotions'] as $eSlug) {
                    if (isset($emotionModels[$eSlug])) {
                        $eIds[] = $emotionModels[$eSlug]->id;
                    }
                }
            }
            if (!empty($eIds)) {
                $herb->emotions()->attach($eIds);
            }
        }
    }
}
