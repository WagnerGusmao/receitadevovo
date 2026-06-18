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
        Schema::table('posts', function (Blueprint $table) {
            $table->foreignId('linked_product_id')->nullable()->constrained('products')->nullOnDelete();
            $table->boolean('show_on_home')->default(false);
            $table->integer('home_order')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign(['linked_product_id']);
            $table->dropColumn(['linked_product_id', 'show_on_home', 'home_order']);
        });
    }
};
