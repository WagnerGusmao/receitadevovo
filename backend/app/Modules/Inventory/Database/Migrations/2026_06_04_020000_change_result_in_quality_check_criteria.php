<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('quality_check_criteria', function (Blueprint $table) {
            $table->string('result')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('quality_check_criteria', function (Blueprint $table) {
            $table->enum('result', ['pass', 'fail', 'conditional'])->nullable()->change();
        });
    }
};
