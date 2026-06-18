<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

class PasswordResetTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Mail::fake();
    }

    public function test_forgot_password_requires_existing_email()
    {
        $response = $this->postJson('/api/auth/forgot-password', [
            'email' => 'nonexistent@example.com',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['email']);
    }

    public function test_forgot_password_generates_code_and_sends_email()
    {
        $user = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => bcrypt('old_password'),
            'whatsapp' => '5511999999999',
        ]);

        $response = $this->postJson('/api/auth/forgot-password', [
            'email' => 'user1@example.com',
        ]);

        $response->assertStatus(200);

        // Assert code was saved in DB
        $this->assertDatabaseHas('password_reset_tokens', [
            'email' => 'user1@example.com',
        ]);

        // Assert email was sent
        Mail::assertSent(function (\Illuminate\Mail\Mailable $mail) {
            return $mail->hasTo('user1@example.com');
        });
    }

    public function test_reset_password_validates_code_and_updates_password()
    {
        $user = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => bcrypt('old_password'),
            'whatsapp' => '5511999999999',
        ]);

        $code = '123456';
        DB::table('password_reset_tokens')->insert([
            'email' => 'user1@example.com',
            'token' => Hash::make($code),
            'created_at' => now(),
        ]);

        $response = $this->postJson('/api/auth/reset-password', [
            'email' => 'user1@example.com',
            'code' => $code,
            'password' => 'new_secure_password',
            'password_confirmation' => 'new_secure_password',
        ]);

        $response->assertStatus(200);

        // Assert password was updated
        $user->refresh();
        $this->assertTrue(Hash::check('new_secure_password', $user->password));

        // Assert token was deleted
        $this->assertDatabaseMissing('password_reset_tokens', [
            'email' => 'user1@example.com',
        ]);
    }

    public function test_reset_password_fails_if_code_incorrect()
    {
        $user = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => bcrypt('old_password'),
            'whatsapp' => '5511999999999',
        ]);

        DB::table('password_reset_tokens')->insert([
            'email' => 'user1@example.com',
            'token' => Hash::make('123456'),
            'created_at' => now(),
        ]);

        $response = $this->postJson('/api/auth/reset-password', [
            'email' => 'user1@example.com',
            'code' => '654321', // wrong code
            'password' => 'new_secure_password',
            'password_confirmation' => 'new_secure_password',
        ]);

        $response->assertStatus(422);
    }

    public function test_reset_password_fails_if_code_expired()
    {
        $user = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => bcrypt('old_password'),
            'whatsapp' => '5511999999999',
        ]);

        DB::table('password_reset_tokens')->insert([
            'email' => 'user1@example.com',
            'token' => Hash::make('123456'),
            'created_at' => now()->subMinutes(16), // expired
        ]);

        $response = $this->postJson('/api/auth/reset-password', [
            'email' => 'user1@example.com',
            'code' => '123456',
            'password' => 'new_secure_password',
            'password_confirmation' => 'new_secure_password',
        ]);

        $response->assertStatus(422);
    }
}
