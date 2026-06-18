<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('addresses', function (Blueprint $table) {
            if (!Schema::hasColumn('addresses', 'recipient_name')) {
                $table->string('recipient_name')->after('is_default');
            }
            if (!Schema::hasColumn('addresses', 'cpf')) {
                $table->string('cpf', 14)->after('recipient_name');
            }
            if (!Schema::hasColumn('addresses', 'phone')) {
                $table->string('phone', 20)->after('cpf');
            }
            if (!Schema::hasColumn('addresses', 'zipcode')) {
                $table->string('zipcode', 9)->after('phone');
            }
        });
    }

    public function down(): void
    {
        Schema::table('addresses', function (Blueprint $table) {
            if (Schema::hasColumn('addresses', 'zipcode')) {
                $table->dropColumn('zipcode');
            }
            if (Schema::hasColumn('addresses', 'phone')) {
                $table->dropColumn('phone');
            }
            if (Schema::hasColumn('addresses', 'cpf')) {
                $table->dropColumn('cpf');
            }
            if (Schema::hasColumn('addresses', 'recipient_name')) {
                $table->dropColumn('recipient_name');
            }
        });
    }
};
