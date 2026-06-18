<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Category;
use App\Modules\Ecommerce\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CategoryTest extends TestCase
{
    use RefreshDatabase;

    private $admin;
    private $user;

    protected function setUp(): void
    {
        parent::setUp();

        // Criar admin e usuário comum
        $this->admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@test.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
            'is_admin' => true,
        ]);

        $this->user = User::create([
            'name' => 'Regular User',
            'email' => 'user@test.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11888888888',
            'is_admin' => false,
        ]);
    }

    public function test_can_list_categories_publicly()
    {
        Category::create(['name' => 'Chás', 'slug' => 'chas']);
        Category::create(['name' => 'Sabonetes', 'slug' => 'sabonetes']);

        $response = $this->getJson('/api/ecommerce/categories');

        $response->assertStatus(200)
                 ->assertJsonCount(2, 'data')
                 ->assertJsonFragment(['name' => 'Chás'])
                 ->assertJsonFragment(['name' => 'Sabonetes']);
    }

    public function test_admin_can_create_category()
    {
        $response = $this->actingAs($this->admin)
                         ->postJson('/api/ecommerce/categories', [
                             'name' => 'Óleos Essenciais',
                             'description' => 'Óleos puros'
                         ]);

        $response->assertStatus(201)
                 ->assertJsonPath('data.name', 'Óleos Essenciais')
                 ->assertJsonPath('data.slug', 'oleos-essenciais');

        $this->assertDatabaseHas('categories', [
            'name' => 'Óleos Essenciais',
            'slug' => 'oleos-essenciais'
        ]);
    }

    public function test_non_admin_cannot_create_category()
    {
        $response = $this->actingAs($this->user)
                         ->postJson('/api/ecommerce/categories', [
                             'name' => 'Óleos Essenciais'
                         ]);

        $response->assertStatus(403);
    }

    public function test_admin_can_update_category()
    {
        $category = Category::create(['name' => 'Chás', 'slug' => 'chas']);

        $response = $this->actingAs($this->admin)
                         ->putJson("/api/ecommerce/categories/{$category->id}", [
                             'name' => 'Chás Orgânicos'
                         ]);

        $response->assertStatus(200)
                 ->assertJsonPath('data.name', 'Chás Orgânicos')
                 ->assertJsonPath('data.slug', 'chas-organicos');

        $this->assertDatabaseHas('categories', [
            'id' => $category->id,
            'name' => 'Chás Orgânicos'
        ]);
    }

    public function test_admin_can_delete_category()
    {
        $category = Category::create(['name' => 'Chás', 'slug' => 'chas']);

        $response = $this->actingAs($this->admin)
                         ->deleteJson("/api/ecommerce/categories/{$category->id}");

        $response->assertStatus(200);
        $this->assertDatabaseMissing('categories', ['id' => $category->id]);
    }

    public function test_can_create_product_with_category()
    {
        $category = Category::create(['name' => 'Chás', 'slug' => 'chas']);

        $response = $this->actingAs($this->admin)
                         ->postJson('/api/ecommerce/products', [
                             'name' => 'Chá de Erva Cidreira',
                             'description' => 'Chá calmante natural',
                             'price' => 12.50,
                             'stock' => 10,
                             'slug' => 'cha-de-erva-cidreira',
                             'category_id' => $category->id
                         ]);

        $response->assertStatus(201)
                 ->assertJsonPath('data.category_id', $category->id);

        $this->assertDatabaseHas('products', [
            'name' => 'Chá de Erva Cidreira',
            'category_id' => $category->id
        ]);
    }
}
