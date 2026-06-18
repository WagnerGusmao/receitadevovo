<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UserEditTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_update_user_with_formatted_phone_and_cpf()
    {
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => bcrypt('password'),
            'whatsapp' => '5511999999999',
            'is_admin' => true,
        ]);
        Sanctum::actingAs($admin);

        $targetUser = User::create([
            'name' => 'Target User',
            'email' => 'target@example.com',
            'password' => bcrypt('password'),
            'whatsapp' => '11888888888',
        ]);

        $payload = [
            'name' => 'Target User Updated',
            'email' => 'target@example.com',
            'whatsapp' => '(11) 97777-7777', // formatted
            'phone' => '(11) 5555-5555',     // formatted
            'cpf' => '123.456.789-00',        // formatted
            'is_admin' => false,
            'is_active' => true,
        ];

        $response = $this->putJson("/api/auth/admin/users/{$targetUser->id}", $payload);

        $response->assertStatus(200);

        // Assert database stores the cleaned values
        $this->assertDatabaseHas('users', [
            'id' => $targetUser->id,
            'whatsapp' => '11977777777',
            'phone' => '1155555555',
            'cpf' => '12345678900',
        ]);
    }

    public function test_can_register_user_with_formatted_whatsapp()
    {
        $payload = [
            'name' => 'Registering User',
            'email' => 'register@example.com',
            'whatsapp' => '(11) 96666-6666',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ];

        $response = $this->postJson('/api/auth/register', $payload);

        $response->assertStatus(201);

        $this->assertDatabaseHas('users', [
            'email' => 'register@example.com',
            'whatsapp' => '11966666666',
        ]);
    }
}
