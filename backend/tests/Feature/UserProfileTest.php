<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use App\Modules\Ecommerce\Models\Address;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class UserProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_fetch_own_profile()
    {
        $user = User::create([
            'name' => 'User Client',
            'email' => 'client@example.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '5511999999999',
            'phone' => '11999999999',
            'cpf' => '12345678901',
        ]);

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/auth/me');

        $response->assertStatus(200);
        $response->assertJsonPath('data.email', 'client@example.com');
    }

    public function test_user_can_update_own_profile()
    {
        $user = User::create([
            'name' => 'User Client',
            'email' => 'client@example.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '5511999999999',
        ]);

        $response = $this->actingAs($user, 'sanctum')->putJson('/api/auth/profile', [
            'name' => 'Updated Name',
            'email' => 'client@example.com',
            'whatsapp' => '(11) 98888-8888', // with mask
            'avatar_path' => 'uploads/avatar1.webp',
        ]);

        $response->assertStatus(200);
        $user->refresh();

        $this->assertEquals('Updated Name', $user->name);
        $this->assertEquals('11988888888', $user->whatsapp); // cleaned
        $this->assertEquals('uploads/avatar1.webp', $user->avatar_path);
    }

    public function test_user_cannot_update_profile_email_to_existing_another_user_email()
    {
        $user1 = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
        ]);

        $user2 = User::create([
            'name' => 'User Two',
            'email' => 'user2@example.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999998',
        ]);

        $response = $this->actingAs($user1, 'sanctum')->putJson('/api/auth/profile', [
            'name' => 'User One Updated',
            'email' => 'user2@example.com', // Conflict with user2
            'whatsapp' => '11999999999',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['email']);
    }

    public function test_user_can_update_profile_password()
    {
        $user = User::create([
            'name' => 'User Client',
            'email' => 'client@example.com',
            'password' => bcrypt('old_password'),
            'whatsapp' => '11999999999',
        ]);

        $response = $this->actingAs($user, 'sanctum')->putJson('/api/auth/profile', [
            'name' => 'User Client',
            'email' => 'client@example.com',
            'whatsapp' => '11999999999',
            'password' => 'new_secure_password',
            'password_confirmation' => 'new_secure_password',
        ]);

        $response->assertStatus(200);
        $user->refresh();

        $this->assertTrue(Hash::check('new_secure_password', $user->password));
    }

    public function test_address_cleans_mask_before_validation()
    {
        $user = User::create([
            'name' => 'User Client',
            'email' => 'client@example.com',
            'password' => bcrypt('password123'),
            'whatsapp' => '11999999999',
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/ecommerce/addresses', [
            'label' => 'Casa',
            'recipient_name' => 'Wagner Gusmão',
            'cpf' => '123.456.789-01', // with mask (length 14)
            'phone' => '(11) 98888-8888', // with mask
            'zipcode' => '01311-200', // with mask
            'street' => 'Av Paulista',
            'number' => '1000',
            'neighborhood' => 'Bela Vista',
            'city' => 'São Paulo',
            'state' => 'SP',
        ]);

        $response->assertStatus(201);
        
        $this->assertDatabaseHas('addresses', [
            'user_id' => $user->id,
            'cpf' => '12345678901',
            'phone' => '11988888888',
            'zipcode' => '01311200',
        ]);
    }
}
