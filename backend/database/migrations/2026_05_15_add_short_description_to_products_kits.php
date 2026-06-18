<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (!Schema::hasColumn('products', 'short_description')) {
                $table->string('short_description')->nullable()->after('description');
            }
        });

        Schema::table('kits', function (Blueprint $table) {
            if (!Schema::hasColumn('kits', 'short_description')) {
                $table->string('short_description')->nullable()->after('description');
            }
            if (!Schema::hasColumn('kits', 'original_price')) {
                $table->decimal('original_price', 10, 2)->nullable()->after('price');
            }
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (Schema::hasColumn('products', 'short_description')) {
                $table->dropColumn('short_description');
            }
        });

        Schema::table('kits', function (Blueprint $table) {
            if (Schema::hasColumn('kits', 'short_description')) {
                $table->dropColumn('short_description');
            }
            if (Schema::hasColumn('kits', 'original_price')) {
                $table->dropColumn('original_price');
            }
        });
    }
};
