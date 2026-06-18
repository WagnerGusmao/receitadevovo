<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('order_items', function (Blueprint $table) {
            // Remove foreign key and drop product_id column
            $table->dropForeign(['product_id']);
            $table->dropColumn('product_id');
            
            // Add polymorphic columns
            $table->nullableMorphs('itemable');
        });
    }

    public function down(): void
    {
        Schema::table('order_items', function (Blueprint $table) {
            $table->dropMorphs('itemable');
            $table->foreignId('product_id')->nullable()->constrained()->onDelete('cascade');
        });
    }
};
