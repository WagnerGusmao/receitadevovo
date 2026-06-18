<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Modules\Auth\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AnonymizeUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user:anonymize {id : The ID of the user to anonymize}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Anonymize personal data of a user for LGPD compliance (Right to be Forgotten)';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $userId = $this->argument('id');
        $user = User::find($userId);

        if (!$user) {
            $this->error("User with ID {$userId} not found.");
            return Command::FAILURE;
        }

        $this->info("Starting anonymization for user: {$user->name} (ID: {$userId})");

        if (!$this->confirm('Are you sure you want to anonymize this user? This action is irreversible.')) {
            $this->info('Anonymization cancelled.');
            return Command::SUCCESS;
        }

        DB::beginTransaction();

        try {
            // 1. Delete user addresses (contains name, CEP, street, number, complement, neighborhood, cpf, phone)
            $user->addresses()->delete();
            $this->line('- User addresses deleted.');

            // 2. Anonymize past orders
            $orders = $user->orders;
            foreach ($orders as $order) {
                // Parse shipping address if it's JSON to preserve city and state for statistics
                $city = '';
                $state = '';
                if ($order->shipping_address) {
                    $addressData = json_decode($order->shipping_address, true);
                    if (json_last_error() === JSON_ERROR_NONE && is_array($addressData)) {
                        $city = $addressData['city'] ?? '';
                        $state = $addressData['state'] ?? '';
                    } else {
                        $city = 'Cidade';
                        $state = 'UF';
                    }
                }
                
                // Keep minimal regional location data for financial/shipping reports, clear everything else
                $anonymizedAddress = json_encode([
                    'street' => 'Rua Anonimizada',
                    'number' => 'S/N',
                    'complement' => '',
                    'neighborhood' => 'Bairro Anonimizado',
                    'city' => $city,
                    'state' => $state,
                    'cep' => '00000-000',
                    'recipient_name' => 'Usuário Anonimizado'
                ]);

                $order->update([
                    'customer_name' => 'Usuário Anonimizado',
                    'customer_phone' => null,
                    'shipping_address' => $anonymizedAddress,
                    'notes' => null,
                ]);
            }
            $this->line("- Anonymized {$orders->count()} orders (financial records kept).");

            // 3. Delete Loyalty points and transactions
            $user->loyaltyTransactions()->delete();
            $user->loyaltyRedemptions()->delete();
            $this->line('- Loyalty points transactions and redemptions deleted.');

            // 4. Anonymize user credentials & personal fields
            $user->update([
                'name' => 'Usuário Anonimizado',
                'email' => 'anonymous_user_' . $user->id . '@receitadevovo.com.br',
                'password' => Hash::make(Str::random(40)),
                'whatsapp' => null,
                'phone' => null,
                'cpf' => null,
                'google_id' => null,
                'avatar_path' => null,
                'is_active' => false,
                'remember_token' => null,
            ]);
            $this->line('- User personal data anonymized and account deactivated.');

            DB::commit();

            $this->info("User ID {$userId} has been successfully anonymized.");
            return Command::SUCCESS;

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error("An error occurred: " . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
