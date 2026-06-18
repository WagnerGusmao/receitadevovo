<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Wellness\Models\Herb;
use App\Modules\Wellness\Models\Benefit;
use App\Modules\Wellness\Models\Emotion;

class HerbSeeder extends Seeder
{
    public function run(): void
    {
        $herbs = [
            [
                'name' => 'Camomila',
                'slug' => 'camomila',
                'scientific_name' => 'Matricaria chamomilla',
                'description' => 'Flor delicada conhecida por suas propriedades calmantes e digestivas. Usada há séculos para promover relaxamento e bem-estar.',
                'how_to_use' => 'Chá: 1 colher de sopa para 200ml de água. Infusão por 5-10 minutos. Tomar 2-3 vezes ao dia.',
                'image_path' => '/images/herbs/camomila.jpg',
                'benefits' => ['relaxamento', 'sono', 'digestao', 'ansiedade', 'calmante'],
                'emotions' => ['estresse', 'ansiedade', 'insonia', 'agitacao'],
            ],
            [
                'name' => 'Lavanda',
                'slug' => 'lavanda',
                'scientific_name' => 'Lavandula angustifolia',
                'description' => 'Flor aromática com propriedades relaxantes excepcionais. Promove sono tranquilo e equilíbrio emocional.',
                'how_to_use' => 'Chá: 1 colher de chá para 200ml de água. Infusão por 10 minutos. Ideal antes de dormir.',
                'image_path' => '/images/herbs/lavanda.jpg',
                'benefits' => ['sono', 'relaxamento', 'ansiedade', 'calmante', 'pele'],
                'emotions' => ['estresse', 'ansiedade', 'insonia', 'agitacao'],
            ],
            [
                'name' => 'Hortelã',
                'slug' => 'hortela',
                'scientific_name' => 'Mentha piperita',
                'description' => 'Erva refrescante que auxilia a digestão e proporciona sensação de frescor. Excelente para desconfortos estomacais.',
                'how_to_use' => 'Chá: 1 colher de sopa de folhas para 200ml de água. Infusão por 5 minutos após refeições.',
                'image_path' => '/images/herbs/hortela.jpg',
                'benefits' => ['digestao', 'respiratorio', 'energia', 'foco', 'anti-inflamatorio'],
                'emotions' => ['cansaco', 'confusao-mental', 'agitacao'],
            ],
            [
                'name' => 'Alecrim',
                'slug' => 'alecrim',
                'scientific_name' => 'Rosmarinus officinalis',
                'description' => 'Erva aromática que estimula memória e concentração. Conhecida por suas propriedades antioxidantes e revigorantes.',
                'how_to_use' => 'Chá: 1 colher de chá para 200ml de água. Infusão por 10 minutos. Tomar pela manhã.',
                'image_path' => '/images/herbs/alecrim.jpg',
                'benefits' => ['memoria', 'foco', 'energia', 'circulacao', 'antioxidante', 'cabelo'],
                'emotions' => ['cansaco', 'confusao-mental', 'desanimo'],
            ],
            [
                'name' => 'Gengibre',
                'slug' => 'gengibre',
                'scientific_name' => 'Zingiber officinale',
                'description' => 'Raiz poderosa com propriedades anti-inflamatórias e digestivas. Aquece o corpo e fortalece a imunidade.',
                'how_to_use' => 'Chá: 3-4 rodelas de gengibre para 500ml de água. Ferver por 10 minutos. Pode adicionar mel.',
                'image_path' => '/images/herbs/gengibre.jpg',
                'benefits' => ['imunidade', 'digestao', 'anti-inflamatorio', 'circulacao', 'respiratorio', 'dor'],
                'emotions' => ['cansaco', 'desanimo'],
            ],
            [
                'name' => 'Erva-Cidreira',
                'slug' => 'erva-cidreira',
                'scientific_name' => 'Melissa officinalis',
                'description' => 'Erva calmante com aroma cítrico. Excelente para ansiedade e tensão nervosa.',
                'how_to_use' => 'Chá: 2 colheres de sopa para 200ml de água. Infusão por 10 minutos. Tomar 2-3 vezes ao dia.',
                'image_path' => '/images/herbs/erva-cidreira.jpg',
                'benefits' => ['ansiedade', 'sono', 'digestao', 'relaxamento', 'calmante'],
                'emotions' => ['ansiedade', 'estresse', 'insonia', 'agitacao'],
            ],
            [
                'name' => 'Valeriana',
                'slug' => 'valeriana',
                'scientific_name' => 'Valeriana officinalis',
                'description' => 'Raiz potente para insônia e ansiedade. Promove sono profundo e reparador.',
                'how_to_use' => 'Chá: 1 colher de chá de raiz para 200ml de água. Infusão por 15 minutos. Tomar 1 hora antes de dormir.',
                'image_path' => '/images/herbs/valeriana.jpg',
                'benefits' => ['sono', 'ansiedade', 'relaxamento', 'calmante'],
                'emotions' => ['insonia', 'ansiedade', 'estresse', 'agitacao'],
            ],
            [
                'name' => 'Maracujá (Passiflora)',
                'slug' => 'maracuja',
                'scientific_name' => 'Passiflora incarnata',
                'description' => 'Folhas calmantes da planta do maracujá. Reduz ansiedade sem causar sonolência.',
                'how_to_use' => 'Chá: 2 colheres de sopa de folhas para 200ml de água. Infusão por 10 minutos.',
                'image_path' => '/images/herbs/maracuja.jpg',
                'benefits' => ['ansiedade', 'sono', 'relaxamento', 'calmante'],
                'emotions' => ['ansiedade', 'estresse', 'insonia', 'agitacao'],
            ],
            [
                'name' => 'Hibisco',
                'slug' => 'hibisco',
                'scientific_name' => 'Hibiscus sabdariffa',
                'description' => 'Flor vermelha rica em antioxidantes. Auxilia no controle da pressão e colesterol.',
                'how_to_use' => 'Chá: 2 colheres de sopa para 500ml de água. Infusão por 10 minutos. Pode ser tomado gelado.',
                'image_path' => '/images/herbs/hibisco.jpg',
                'benefits' => ['antioxidante', 'colesterol', 'detox', 'peso', 'circulacao'],
                'emotions' => ['desanimo', 'cansaco'],
            ],
            [
                'name' => 'Canela',
                'slug' => 'canela',
                'scientific_name' => 'Cinnamomum verum',
                'description' => 'Especiaria aromática que regula açúcar no sangue e aquece o corpo.',
                'how_to_use' => 'Chá: 1 pau de canela para 500ml de água. Ferver por 15 minutos.',
                'image_path' => '/images/herbs/canela.jpg',
                'benefits' => ['diabetes', 'circulacao', 'digestao', 'imunidade', 'anti-inflamatorio'],
                'emotions' => ['cansaco', 'desanimo'],
            ],
            [
                'name' => 'Boldo',
                'slug' => 'boldo',
                'scientific_name' => 'Peumus boldus',
                'description' => 'Folha amarga tradicionalmente usada para problemas digestivos e hepáticos.',
                'how_to_use' => 'Chá: 1 colher de chá para 200ml de água. Infusão por 5 minutos após refeições pesadas.',
                'image_path' => '/images/herbs/boldo.jpg',
                'benefits' => ['digestao', 'detox', 'diuretico'],
                'emotions' => [],
            ],
            [
                'name' => 'Espinheira-Santa',
                'slug' => 'espinheira-santa',
                'scientific_name' => 'Maytenus ilicifolia',
                'description' => 'Planta nativa brasileira excelente para gastrite e úlceras.',
                'how_to_use' => 'Chá: 1 colher de sopa para 200ml de água. Infusão por 10 minutos. Tomar 30min antes das refeições.',
                'image_path' => '/images/herbs/espinheira-santa.jpg',
                'benefits' => ['digestao', 'cicatrizante', 'anti-inflamatorio'],
                'emotions' => [],
            ],
            [
                'name' => 'Equinácea',
                'slug' => 'equinacea',
                'scientific_name' => 'Echinacea purpurea',
                'description' => 'Flor poderosa para fortalecer o sistema imunológico e combater infecções.',
                'how_to_use' => 'Chá: 1 colher de chá de raiz para 200ml de água. Infusão por 15 minutos. Tomar 2-3 vezes ao dia.',
                'image_path' => '/images/herbs/equinacea.jpg',
                'benefits' => ['imunidade', 'antibacteriano', 'anti-inflamatorio'],
                'emotions' => ['desanimo', 'cansaco'],
            ],
            [
                'name' => 'Ginkgo Biloba',
                'slug' => 'ginkgo-biloba',
                'scientific_name' => 'Ginkgo biloba',
                'description' => 'Árvore milenar que melhora circulação cerebral e memória.',
                'how_to_use' => 'Chá: 1 colher de chá de folhas para 200ml de água. Infusão por 10 minutos.',
                'image_path' => '/images/herbs/ginkgo-biloba.jpg',
                'benefits' => ['memoria', 'foco', 'circulacao', 'antioxidante'],
                'emotions' => ['confusao-mental', 'desanimo'],
            ],
            [
                'name' => 'Cúrcuma (Açafrão)',
                'slug' => 'curcuma',
                'scientific_name' => 'Curcuma longa',
                'description' => 'Raiz dourada com potente ação anti-inflamatória e antioxidante.',
                'how_to_use' => 'Chá: 1 colher de chá de pó para 200ml de água + pimenta-do-reino. Ferver por 10 minutos.',
                'image_path' => '/images/herbs/curcuma.jpg',
                'benefits' => ['anti-inflamatorio', 'antioxidante', 'digestao', 'dor', 'imunidade'],
                'emotions' => [],
            ],
            [
                'name' => 'Erva-Doce',
                'slug' => 'erva-doce',
                'scientific_name' => 'Pimpinella anisum',
                'description' => 'Semente aromática que alivia gases e cólicas. Ideal para toda a família.',
                'how_to_use' => 'Chá: 1 colher de chá de sementes para 200ml de água. Infusão por 10 minutos.',
                'image_path' => '/images/herbs/erva-doce.jpg',
                'benefits' => ['digestao', 'antiespamodico', 'expectorante', 'calmante'],
                'emotions' => ['agitacao'],
            ],
            [
                'name' => 'Cavalinha',
                'slug' => 'cavalinha',
                'scientific_name' => 'Equisetum arvense',
                'description' => 'Planta rica em silício, excelente para ossos, cabelos e unhas.',
                'how_to_use' => 'Chá: 2 colheres de sopa para 500ml de água. Ferver por 15 minutos.',
                'image_path' => '/images/herbs/cavalinha.jpg',
                'benefits' => ['diuretico', 'cabelo', 'pele', 'detox'],
                'emotions' => [],
            ],
            [
                'name' => 'Sálvia',
                'slug' => 'salvia',
                'scientific_name' => 'Salvia officinalis',
                'description' => 'Erva sagrada que auxilia na menopausa e fortalece a memória.',
                'how_to_use' => 'Chá: 1 colher de chá para 200ml de água. Infusão por 10 minutos. Evitar uso prolongado.',
                'image_path' => '/images/herbs/salvia.jpg',
                'benefits' => ['menopausa', 'memoria', 'hormonal', 'digestao', 'antibacteriano'],
                'emotions' => ['confusao-mental', 'agitacao'],
            ],
            [
                'name' => 'Melissa',
                'slug' => 'melissa',
                'scientific_name' => 'Melissa officinalis',
                'description' => 'Erva cítrica calmante, perfeita para ansiedade e tensão.',
                'how_to_use' => 'Chá: 2 colheres de sopa para 200ml de água. Infusão por 10 minutos.',
                'image_path' => '/images/herbs/melissa.jpg',
                'benefits' => ['ansiedade', 'sono', 'digestao', 'relaxamento', 'calmante'],
                'emotions' => ['ansiedade', 'estresse', 'insonia'],
            ],
            [
                'name' => 'Dente-de-Leão',
                'slug' => 'dente-de-leao',
                'scientific_name' => 'Taraxacum officinale',
                'description' => 'Planta desintoxicante que auxilia fígado e rins.',
                'how_to_use' => 'Chá: 1 colher de sopa de raiz para 200ml de água. Ferver por 15 minutos.',
                'image_path' => '/images/herbs/dente-de-leao.jpg',
                'benefits' => ['detox', 'digestao', 'diuretico', 'pele'],
                'emotions' => [],
            ],
            [
                'name' => 'Chá Verde',
                'slug' => 'cha-verde',
                'scientific_name' => 'Camellia sinensis',
                'description' => 'Folhas ricas em antioxidantes que aceleram o metabolismo.',
                'how_to_use' => 'Chá: 1 colher de chá para 200ml de água a 80°C. Infusão por 3 minutos.',
                'image_path' => '/images/herbs/cha-verde.jpg',
                'benefits' => ['antioxidante', 'peso', 'energia', 'foco', 'colesterol'],
                'emotions' => ['cansaco', 'desanimo', 'confusao-mental'],
            ],
            [
                'name' => 'Romã',
                'slug' => 'roma',
                'scientific_name' => 'Punica granatum',
                'description' => 'Fruto rico em antioxidantes com ação rejuvenescedora.',
                'how_to_use' => 'Chá: 1 colher de sopa de casca para 200ml de água. Ferver por 10 minutos.',
                'image_path' => '/images/herbs/roma.jpg',
                'benefits' => ['antioxidante', 'anti-inflamatorio', 'circulacao', 'pele'],
                'emotions' => [],
            ],
            [
                'name' => 'Chapéu-de-Couro',
                'slug' => 'chapeu-de-couro',
                'scientific_name' => 'Echinodorus macrophyllus',
                'description' => 'Planta brasileira depurativa e anti-inflamatória.',
                'how_to_use' => 'Chá: 1 colher de sopa para 200ml de água. Infusão por 10 minutos.',
                'image_path' => '/images/herbs/chapeu-de-couro.jpg',
                'benefits' => ['detox', 'anti-inflamatorio', 'diuretico', 'pele'],
                'emotions' => [],
            ],
            [
                'name' => 'Ginseng',
                'slug' => 'ginseng',
                'scientific_name' => 'Panax ginseng',
                'description' => 'Raiz adaptógena que aumenta energia e resistência ao estresse.',
                'how_to_use' => 'Chá: 1 colher de chá de raiz para 200ml de água. Infusão por 15 minutos. Tomar pela manhã.',
                'image_path' => '/images/herbs/ginseng.jpg',
                'benefits' => ['energia', 'adaptogeno', 'memoria', 'imunidade', 'aphrodisiaco'],
                'emotions' => ['cansaco', 'estresse', 'desanimo'],
            ],
            [
                'name' => 'Ashwagandha',
                'slug' => 'ashwagandha',
                'scientific_name' => 'Withania somnifera',
                'description' => 'Erva ayurvédica adaptógena que reduz cortisol e melhora sono.',
                'how_to_use' => 'Chá: 1 colher de chá de raiz em pó para 200ml de leite morno. Tomar à noite.',
                'image_path' => '/images/herbs/ashwagandha.jpg',
                'benefits' => ['adaptogeno', 'estresse', 'sono', 'energia', 'hormonal'],
                'emotions' => ['estresse', 'ansiedade', 'insonia', 'cansaco'],
            ],
        ];

        foreach ($herbs as $herbData) {
            $herb = Herb::updateOrCreate(
                ['slug' => $herbData['slug']],
                [
                    'name' => $herbData['name'],
                    'slug' => $herbData['slug'],
                    'scientific_name' => $herbData['scientific_name'],
                    'description' => $herbData['description'],
                    'how_to_use' => $herbData['how_to_use'],
                    'image_path' => $herbData['image_path'],
                ]
            );

            // Relacionar benefícios
            if (!empty($herbData['benefits'])) {
                $benefitIds = Benefit::whereIn('slug', $herbData['benefits'])->pluck('id');
                $herb->benefits()->sync($benefitIds);
            }

            // Relacionar emoções
            if (!empty($herbData['emotions'])) {
                $emotionIds = Emotion::whereIn('slug', $herbData['emotions'])->pluck('id');
                $herb->emotions()->sync($emotionIds);
            }
        }

        $this->command->info('✅ 25 ervas criadas com relacionamentos!');
    }
}
