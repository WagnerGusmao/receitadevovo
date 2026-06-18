<?php

namespace App\Modules\Ecommerce\Database\Seeders;

use App\Modules\Ecommerce\Models\Kit;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Wellness\Models\Herb;
use Illuminate\Database\Seeder;

class EcommerceSeeder extends Seeder
{
    public function run(): void
    {
        $lavender = Herb::where('slug', 'lavanda')->first();
        $rosemary = Herb::where('slug', 'alecrim')->first();
        $camomile = Herb::where('slug', 'camomila')->first();

        // Products
        $soapLavender = Product::create([
            'name' => 'Sabonete Artesanal de Lavanda',
            'description' => 'Feito à mão com óleo essencial de lavanda pura. Ideal para o banho noturno.',
            'price' => 28.90,
            'stock' => 50,
        ]);
        if ($lavender) $soapLavender->herbs()->attach($lavender);

        $oilRosemary = Product::create([
            'name' => 'Óleo Essencial de Alecrim',
            'description' => 'Puro e concentrado, ideal para foco e energia.',
            'price' => 45.00,
            'stock' => 30,
        ]);
        if ($rosemary) $oilRosemary->herbs()->attach($rosemary);

        $teaMix = Product::create([
            'name' => 'Infusão "Calma Profunda"',
            'description' => 'Mix especial de camomila e melissa para noites tranquilas.',
            'price' => 35.00,
            'stock' => 100,
        ]);
        if ($camomile) $teaMix->herbs()->attach($camomile);

        // Kits
        $kitRelax = Kit::create([
            'name' => 'Kit Ritual Relaxante',
            'description' => 'Tudo o que você precisa para uma noite de sono reparadora.',
            'price' => 85.00,
        ]);
        $kitRelax->products()->attach([$soapLavender->id, $teaMix->id]);
    }
}
