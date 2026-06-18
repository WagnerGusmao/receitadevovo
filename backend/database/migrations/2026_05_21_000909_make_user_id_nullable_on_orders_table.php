<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Torna user_id nullable para suportar pedidos balcão com clientes avulsos
     * (sem cadastro no sistema).
     */
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            // Remove a foreign key constraint antes de alterar a coluna
            $table->unsignedBigInteger('user_id')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->unsignedBigInteger('user_id')->nullable(false)->change();
        });
    }
};
