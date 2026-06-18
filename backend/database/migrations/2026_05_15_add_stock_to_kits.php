<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('kits', function (Blueprint $table) {
            if (!Schema::hasColumn('kits', 'stock')) {
                $table->integer('stock')->default(0)->after('original_price');
            }
        });
    }

    public function down(): void
    {
        Schema::table('kits', function (Blueprint $table) {
            if (Schema::hasColumn('kits', 'stock')) {
                $table->dropColumn('stock');
            }
        });
    }
};
