<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('products', 'unit_cost')) {
            Schema::table('products', function (Blueprint $table) {
                $table->decimal('unit_cost', 10, 4)->nullable()->after('price');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('products', 'unit_cost')) {
            Schema::table('products', function (Blueprint $table) {
                $table->dropColumn('unit_cost');
            });
        }
    }
};
