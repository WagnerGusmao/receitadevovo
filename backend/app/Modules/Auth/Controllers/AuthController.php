<?php

namespace App\Modules\Auth\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Auth\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use App\Mail\PasswordResetMail;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        if ($request->has('whatsapp')) {
            $request->merge([
                'whatsapp' => preg_replace('/\D/', '', $request->input('whatsapp'))
            ]);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'whatsapp' => [
                'required',
                'string',
                'regex:/^\d{10,11}$/',
                function ($attribute, $value, $fail) {
                    $cleaned = preg_replace('/\D/', '', $value);
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($cleaned);
                    $exists = \Illuminate\Support\Facades\DB::table('users')
                        ->where('whatsapp', $cleaned)
                        ->orWhere('whatsapp', $encrypted)
                        ->exists();
                    if ($exists) {
                        $fail('Este WhatsApp já está cadastrado.');
                    }
                }
            ],
            'password' => 'required|string|min:8|confirmed',
            'consent' => 'accepted',
        ], [
            'whatsapp.required' => 'O WhatsApp é obrigatório',
            'whatsapp.regex' => 'WhatsApp deve conter 10 ou 11 dígitos (apenas números)',
            'consent.accepted' => 'Você deve aceitar os termos e a Política de Privacidade para continuar.',
        ]);

        // Remove formatação do WhatsApp antes de salvar
        $whatsapp = preg_replace('/\D/', '', $request->whatsapp);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'whatsapp' => $whatsapp,
            'password' => Hash::make($request->password),
            'consent_accepted_at' => now(),
            'privacy_policy_version' => $request->input('privacy_policy_version', '1.0'),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->success([
            'user' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 'Usuário registrado com sucesso', 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return $this->error('Credenciais inválidas', 401);
        }

        $user = User::where('email', $request->email)->firstOrFail();

        if (!$user->is_active) {
            return $this->error('Esta conta foi desativada. Entre em contato com o suporte.', 403);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->success([
            'user' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 'Login realizado com sucesso');
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return $this->success([], 'Logout realizado com sucesso');
    }

    public function me(Request $request)
    {
        return $this->success($request->user());
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email|exists:users,email',
        ], [
            'email.required' => 'O e-mail é obrigatório.',
            'email.email' => 'Informe um e-mail válido.',
            'email.exists' => 'Este e-mail não está cadastrado em nosso sistema.',
        ]);

        $email = $request->email;
        $code = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        // Store hashed code in database
        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $email],
            [
                'token' => Hash::make($code),
                'created_at' => now(),
            ]
        );

        // Send email (logged locally, sent via SMTP/SES in production)
        Mail::to($email)->send(new PasswordResetMail($code));

        $responseData = [];
        if (config('app.env') === 'local') {
            $responseData['code'] = $code; // return for developer convenience in local dev
        }

        return $this->success($responseData, 'Código de recuperação enviado para o seu e-mail.');
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email|exists:users,email',
            'code' => 'required|string|size:6',
            'password' => 'required|string|min:8|confirmed',
        ], [
            'email.required' => 'O e-mail é obrigatório.',
            'email.email' => 'Informe um e-mail válido.',
            'email.exists' => 'Este e-mail não está cadastrado.',
            'code.required' => 'O código de verificação é obrigatório.',
            'code.size' => 'O código de verificação deve ter 6 dígitos.',
            'password.required' => 'A nova senha é obrigatória.',
            'password.min' => 'A nova senha deve ter pelo menos 8 caracteres.',
            'password.confirmed' => 'A confirmação de senha não confere.',
        ]);

        $reset = DB::table('password_reset_tokens')->where('email', $request->email)->first();

        if (!$reset) {
            return $this->error('Código de recuperação inválido ou expirado.', 422);
        }

        // Check expiration (15 minutes)
        if (now()->subMinutes(15)->gt($reset->created_at)) {
            DB::table('password_reset_tokens')->where('email', $request->email)->delete();
            return $this->error('Este código de verificação expirou. Solicite um novo código.', 422);
        }

        // Check code match
        if (!Hash::check($request->code, $reset->token)) {
            return $this->error('Código de verificação incorreto.', 422);
        }

        // Update user password
        $user = User::where('email', $request->email)->firstOrFail();
        $user->update([
            'password' => Hash::make($request->password)
        ]);

        // Delete token
        DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return $this->success([], 'Sua senha foi redefinida com sucesso.');
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        if ($request->has('whatsapp')) {
            $request->merge([
                'whatsapp' => preg_replace('/\D/', '', $request->input('whatsapp'))
            ]);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
            'whatsapp' => 'required|string|regex:/^\d{10,11}$/',
            'password' => 'nullable|string|min:8|confirmed',
            'avatar_path' => 'nullable|string|max:255',
        ], [
            'name.required' => 'O nome é obrigatório.',
            'email.required' => 'O e-mail é obrigatório.',
            'email.email' => 'Informe um e-mail válido.',
            'email.unique' => 'Este e-mail já está sendo utilizado por outra conta.',
            'whatsapp.required' => 'O WhatsApp é obrigatório.',
            'whatsapp.regex' => 'O WhatsApp deve conter 10 ou 11 dígitos.',
            'password.min' => 'A nova senha deve ter pelo menos 8 caracteres.',
            'password.confirmed' => 'A confirmação de senha não confere.',
        ]);

        if (empty($validated['password'])) {
            unset($validated['password']);
        } else {
            $validated['password'] = Hash::make($validated['password']);
        }

        $user->update($validated);

        return $this->success($user, 'Perfil atualizado com sucesso.');
    }

    /**
     * Redirect to Google OAuth Consent Screen.
     */
    public function googleRedirect()
    {
        try {
            $url = Socialite::driver('google')->stateless()->redirect()->getTargetUrl();
            return $this->success(['url' => $url]);
        } catch (\Exception $e) {
            return $this->error('Erro ao gerar URL de autenticação do Google: ' . $e->getMessage());
        }
    }

    /**
     * Handle Google OAuth callback.
     */
    public function googleCallback(Request $request)
    {
        $request->validate([
            'code' => 'required|string',
        ]);

        try {
            request()->merge(['code' => $request->code]);
            $googleUser = Socialite::driver('google')->stateless()->user();
        } catch (\Exception $e) {
            return $this->error('Erro ao obter usuário do Google: ' . $e->getMessage(), 422);
        }

        if (!$googleUser || !$googleUser->getEmail()) {
            return $this->error('Não foi possível obter os dados do usuário do Google.', 422);
        }

        $email = strtolower($googleUser->getEmail());
        $googleId = $googleUser->getId();
        $name = $googleUser->getName();

        // 1. Check if user already exists by google_id
        $user = User::where('google_id', $googleId)->first();

        // 2. If not, check if user exists by email
        if (!$user) {
            $user = User::where('email', $email)->first();
            if ($user) {
                // Link Google account
                $user->update(['google_id' => $googleId]);
            }
        }

        // 3. If user exists, log them in
        if ($user) {
            if (!$user->is_active) {
                return $this->error('Esta conta foi desativada. Entre em contato com o suporte.', 403);
            }

            $token = $user->createToken('auth_token')->plainTextToken;
            return $this->success([
                'status' => 'logged_in',
                'user' => $user,
                'access_token' => $token,
                'token_type' => 'Bearer',
            ], 'Login realizado com sucesso.');
        }

        // 4. If user doesn't exist, request WhatsApp
        return $this->success([
            'status' => 'needs_whatsapp',
            'email' => $email,
            'name' => $name,
            'google_id' => $googleId,
        ], 'Cadastro quase completo. Insira seu número de WhatsApp para finalizar.');
    }

    /**
     * Complete Google registration with WhatsApp.
     */
    public function googleRegister(Request $request)
    {
        if ($request->has('whatsapp')) {
            $request->merge([
                'whatsapp' => preg_replace('/\D/', '', $request->input('whatsapp'))
            ]);
        }

        $request->validate([
            'email' => 'required|email|max:255|unique:users,email',
            'name' => 'required|string|max:255',
            'google_id' => 'required|string|unique:users,google_id',
            'whatsapp' => [
                'required',
                'string',
                'regex:/^\d{10,11}$/',
                function ($attribute, $value, $fail) {
                    $cleaned = preg_replace('/\D/', '', $value);
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($cleaned);
                    $exists = \Illuminate\Support\Facades\DB::table('users')
                        ->where('whatsapp', $cleaned)
                        ->orWhere('whatsapp', $encrypted)
                        ->exists();
                    if ($exists) {
                        $fail('Este WhatsApp já está cadastrado.');
                    }
                }
            ],
            'consent' => 'accepted',
        ], [
            'whatsapp.required' => 'O WhatsApp é obrigatório',
            'whatsapp.regex' => 'WhatsApp deve conter 10 ou 11 dígitos (apenas números)',
            'consent.accepted' => 'Você deve aceitar os termos e a Política de Privacidade para continuar.',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => strtolower($request->email),
            'google_id' => $request->google_id,
            'whatsapp' => $request->whatsapp,
            'password' => Hash::make(bin2hex(random_bytes(16))),
            'consent_accepted_at' => now(),
            'privacy_policy_version' => $request->input('privacy_policy_version', '1.0'),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->success([
            'user' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 'Usuário registrado e autenticado com sucesso', 201);
    }
}
