<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('whatsapp', 20)->after('email');
            $table->string('phone', 20)->nullable()->after('whatsapp');
            $table->string('cpf', 14)->nullable()->after('phone');
            
            $table->index('whatsapp');
            $table->index('cpf');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['whatsapp']);
            $table->dropIndex(['cpf']);
            $table->dropColumn(['whatsapp', 'phone', 'cpf']);
        });
    }
};
