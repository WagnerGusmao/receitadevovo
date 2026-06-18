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
            $table->string('whatsapp', 255)->change();
            $table->string('phone', 255)->nullable()->change();
            $table->string('cpf', 255)->nullable()->change();
        });

        Schema::table('addresses', function (Blueprint $table) {
            $table->string('recipient_name', 255)->change();
            $table->string('cpf', 255)->nullable()->change();
            $table->string('phone', 255)->nullable()->change();
            $table->string('street', 255)->change();
            $table->string('number', 255)->change();
            $table->string('complement', 255)->nullable()->change();
            $table->string('neighborhood', 255)->change();
            $table->string('reference', 255)->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('whatsapp', 20)->change();
            $table->string('phone', 20)->nullable()->change();
            $table->string('cpf', 14)->nullable()->change();
        });

        Schema::table('addresses', function (Blueprint $table) {
            $table->string('recipient_name', 255)->change();
            $table->string('cpf', 14)->nullable()->change();
            $table->string('phone', 20)->nullable()->change();
            $table->string('street', 255)->change();
            $table->string('number', 255)->change();
            $table->string('complement', 255)->nullable()->change();
            $table->string('neighborhood', 255)->change();
            $table->string('reference', 255)->nullable()->change();
        });
    }
};
