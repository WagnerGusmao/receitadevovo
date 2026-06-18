<?php

namespace App\Modules\Auth\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Auth\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    /**
     * Display a listing of the users.
     */
    public function index(Request $request)
    {
        $query = User::query();

        // Search filter (name, email, whatsapp, cpf)
        if ($request->filled('search')) {
            $search = $request->input('search');
            $digits = preg_replace('/\D/', '', $search);
            $query->where(function ($q) use ($search, $digits) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");

                if ($digits) {
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($digits);
                    $q->orWhere('whatsapp', '=', $digits)
                      ->orWhere('whatsapp', '=', $encrypted)
                      ->orWhere('cpf', '=', $digits)
                      ->orWhere('cpf', '=', $encrypted);
                }
            });
        }

        // Role filter (admin/client)
        if ($request->filled('role')) {
            $role = $request->input('role');
            if ($role === 'admin') {
                $query->where('is_admin', true);
            } elseif ($role === 'client') {
                $query->where('is_admin', false);
            }
        }

        // Active status filter
        if ($request->filled('status')) {
            $status = $request->input('status');
            if ($status === 'active') {
                $query->where('is_active', true);
            } elseif ($status === 'inactive') {
                $query->where('is_active', false);
            }
        }

        $users = $query->orderBy('name', 'asc')->paginate(15);

        return $this->success($users);
    }

    /**
     * Display the specified user.
     */
    public function show($id)
    {
        $user = User::withCount(['addresses', 'orders'])->findOrFail($id);
        return $this->success($user);
    }

    /**
     * Update the specified user in storage.
     */
    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        // Clean formatting from numeric values before validating
        if ($request->has('whatsapp')) {
            $request->merge([
                'whatsapp' => preg_replace('/\D/', '', $request->input('whatsapp'))
            ]);
        }
        if ($request->has('phone') && $request->input('phone')) {
            $request->merge([
                'phone' => preg_replace('/\D/', '', $request->input('phone'))
            ]);
        }
        if ($request->has('cpf') && $request->input('cpf')) {
            $request->merge([
                'cpf' => preg_replace('/\D/', '', $request->input('cpf'))
            ]);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique('users')->ignore($user->id),
            ],
            'whatsapp' => [
                'required',
                'string',
                'regex:/^\d{10,11}$/',
                function ($attribute, $value, $fail) use ($user) {
                    $cleaned = preg_replace('/\D/', '', $value);
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($cleaned);
                    $exists = \Illuminate\Support\Facades\DB::table('users')
                        ->where('id', '!=', $user->id)
                        ->where(function ($q) use ($cleaned, $encrypted) {
                            $q->where('whatsapp', $cleaned)
                              ->orWhere('whatsapp', $encrypted);
                        })
                        ->exists();
                    if ($exists) {
                        $fail('Este WhatsApp já está cadastrado.');
                    }
                }
            ],
            'phone' => 'nullable|string|max:20',
            'cpf' => [
                'nullable',
                'string',
                'max:14',
                function ($attribute, $value, $fail) use ($user) {
                    $cleaned = preg_replace('/\D/', '', $value);
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($cleaned);
                    $exists = \Illuminate\Support\Facades\DB::table('users')
                        ->where('id', '!=', $user->id)
                        ->where(function ($q) use ($cleaned, $encrypted) {
                            $q->where('cpf', $cleaned)
                              ->orWhere('cpf', $encrypted);
                        })
                        ->exists();
                    if ($exists) {
                        $fail('Este CPF já está cadastrado.');
                    }
                }
            ],
            'is_admin' => 'required|boolean',
            'is_active' => 'required|boolean',
            'avatar_path' => 'nullable|string|max:255',
        ]);

        // Prevent self-deactivation or self-revoking admin privileges
        if ($user->id === $request->user()->id) {
            if (!$validated['is_active']) {
                return $this->error('Você não pode desativar sua própria conta.', 400);
            }
            if (!$validated['is_admin']) {
                return $this->error('Você não pode revogar seus próprios privilégios de administrador.', 400);
            }
        }

        // Clean formatting from numeric values before saving
        $validated['whatsapp'] = preg_replace('/\D/', '', $validated['whatsapp']);
        if ($validated['phone']) {
            $validated['phone'] = preg_replace('/\D/', '', $validated['phone']);
        }
        if ($validated['cpf']) {
            $validated['cpf'] = preg_replace('/\D/', '', $validated['cpf']);
        }

        $user->update($validated);

        return $this->success($user, 'Usuário atualizado com sucesso');
    }

    /**
     * Reset user password.
     */
    public function resetPassword(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $request->validate([
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user->update([
            'password' => Hash::make($request->password),
        ]);

        return $this->success([], 'Senha redefinida com sucesso');
    }

    /**
     * Remove the specified user from storage.
     */
    public function destroy(Request $request, $id)
    {
        $user = User::findOrFail($id);

        // Prevent self-deletion
        if ($user->id === $request->user()->id) {
            return $this->error('Você não pode excluir sua própria conta.', 400);
        }

        // Prevent deletion of users with orders (data integrity)
        if ($user->orders()->exists()) {
            return $this->error('Este usuário possui pedidos realizados e não pode ser excluído por motivos de integridade de dados fiscais. Considere desativar a conta.', 422);
        }

        // Delete associated addresses first to prevent foreign key issues
        $user->addresses()->delete();
        
        $user->delete();

        return $this->success([], 'Usuário excluído com sucesso');
    }

    /**
     * Busca rápida de cliente para uso no balcão.
     * Aceita qualquer parte do nome, telefone/whatsapp ou CPF.
     */
    public function searchForCounter(Request $request)
    {
        $q = trim($request->input('q', ''));

        if (strlen($q) < 2) {
            return $this->success([]);
        }

        // Remove formatação para busca numérica
        $digits = preg_replace('/\D/', '', $q);

        $users = User::where('is_admin', false)
            ->where(function ($query) use ($q, $digits) {
                $query->where('name', 'like', "%{$q}%")
                      ->orWhere('email', 'like', "%{$q}%");

                if ($digits) {
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($digits);
                    $query->orWhere('whatsapp', '=', $digits)
                          ->orWhere('whatsapp', '=', $encrypted)
                          ->orWhere('cpf', '=', $digits)
                          ->orWhere('cpf', '=', $encrypted);
                }
            })
            ->select('id', 'name', 'email', 'whatsapp', 'cpf', 'is_active')
            ->withCount('orders')
            ->orderBy('name')
            ->limit(8)
            ->get()
            ->map(function ($user) {
                return [
                    'id'           => $user->id,
                    'name'         => $user->name,
                    'email'        => $user->email,
                    'whatsapp'     => $user->formatted_whatsapp,
                    'cpf'          => $user->formatted_cpf,
                    'is_active'    => $user->is_active,
                    'orders_count' => $user->orders_count,
                    'loyalty_points' => $user->loyalty_points_balance,
                ];
            });

        return $this->success($users);
    }

    /**
     * Cadastro rápido de cliente no balcão (dados mínimos).
     * Não requer senha — conta criada sem acesso digital por padrão.
     */
    public function quickRegister(Request $request)
    {
        // Normaliza dígitos antes de validar
        if ($request->has('whatsapp')) {
            $request->merge(['whatsapp' => preg_replace('/\D/', '', $request->input('whatsapp'))]);
        }
        if ($request->has('cpf') && $request->input('cpf')) {
            $request->merge(['cpf' => preg_replace('/\D/', '', $request->input('cpf'))]);
        }

        $request->validate([
            'name'      => 'required|string|max:255',
            'whatsapp'  => [
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
                        $fail('Já existe um cliente cadastrado com este telefone.');
                    }
                }
            ],
            'cpf'  => [
                'nullable',
                'string',
                'max:14',
                function ($attribute, $value, $fail) {
                    $cleaned = preg_replace('/\D/', '', $value);
                    $encrypted = \App\Infrastructure\Casts\SafeEncrypted::encryptDeterministic($cleaned);
                    $exists = \Illuminate\Support\Facades\DB::table('users')
                        ->where('cpf', $cleaned)
                        ->orWhere('cpf', $encrypted)
                        ->exists();
                    if ($exists) {
                        $fail('Já existe um cliente cadastrado com este CPF.');
                    }
                }
            ],
            'email'     => 'nullable|email|max:255|unique:users,email',
        ], [
            'email.unique'    => 'Já existe um cliente cadastrado com este e-mail.',
        ]);

        $user = User::create([
            'name'      => $request->name,
            'whatsapp'  => $request->whatsapp,
            'cpf'       => $request->cpf ?: null,
            'email'     => $request->email ?: (preg_replace('/\D/', '', $request->whatsapp) . '@balcao.receitadevovo.local'),
            'password'  => Hash::make(\Illuminate\Support\Str::random(32)), // senha aleatória — sem acesso digital
            'is_admin'  => false,
            'is_active' => true,
        ]);

        return $this->success([
            'id'           => $user->id,
            'name'         => $user->name,
            'email'        => $user->email,
            'whatsapp'     => $user->formatted_whatsapp,
            'cpf'          => $user->formatted_cpf,
            'is_active'    => $user->is_active,
            'orders_count' => 0,
            'loyalty_points' => 0,
        ], 'Cliente cadastrado com sucesso!', 201);
    }
}
