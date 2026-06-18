<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->boolean('is_on_demand')->default(false)->after('is_active');
            $table->integer('lead_time_days')->default(0)->after('is_on_demand');
        });

        Schema::table('kits', function (Blueprint $table) {
            $table->boolean('is_on_demand')->default(false)->after('is_active');
            $table->integer('lead_time_days')->default(0)->after('is_on_demand');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['is_on_demand', 'lead_time_days']);
        });

        Schema::table('kits', function (Blueprint $table) {
            $table->dropColumn(['is_on_demand', 'lead_time_days']);
        });
    }
};
