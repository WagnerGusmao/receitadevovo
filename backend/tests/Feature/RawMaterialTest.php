<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Inventory\Models\RawMaterial;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class RawMaterialTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_create_raw_material_with_image_path()
    {
        $user = User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => bcrypt('password'),
            'whatsapp' => '5511999999999',
        ]);
        Sanctum::actingAs($user);

        $payload = [
            'name' => 'Pote de Vidro 30g',
            'unit' => 'un',
            'category' => 'Embalagens',
            'min_stock_quantity' => 10,
            'shelf_life_days' => 365,
            'image_path' => 'uploads/test_glass_pot.webp',
        ];

        $response = $this->postJson('/api/inventory/raw-materials', $payload);

        $response->assertStatus(201);
        $response->assertJsonPath('data.image_path', 'uploads/test_glass_pot.webp');

        $this->assertDatabaseHas('raw_materials', [
            'name' => 'Pote de Vidro 30g',
            'image_path' => 'uploads/test_glass_pot.webp',
        ]);
    }

    public function test_can_update_raw_material_image_path()
    {
        $user = User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => bcrypt('password'),
            'whatsapp' => '5511999999999',
        ]);
        Sanctum::actingAs($user);

        $material = RawMaterial::create([
            'name' => 'Pote de Vidro 30g',
            'unit' => 'un',
            'category' => 'Embalagens',
            'image_path' => 'uploads/old_image.webp',
        ]);

        $payload = [
            'name' => 'Pote de Vidro 30g - Atualizado',
            'image_path' => 'uploads/new_image.webp',
        ];

        $response = $this->putJson("/api/inventory/raw-materials/{$material->id}", $payload);

        $response->assertStatus(200);
        $response->assertJsonPath('data.image_path', 'uploads/new_image.webp');

        $this->assertDatabaseHas('raw_materials', [
            'id' => $material->id,
            'name' => 'Pote de Vidro 30g - Atualizado',
            'image_path' => 'uploads/new_image.webp',
        ]);
    }
}
