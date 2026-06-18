<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->enum('source', ['online', 'counter'])->default('online')->after('status');
            $table->string('customer_name')->nullable()->after('user_id');
            $table->string('customer_phone', 50)->nullable()->after('customer_name');
            $table->decimal('discount_amount', 10, 2)->nullable()->after('total');
            $table->text('notes')->nullable()->after('shipping_address');
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['source', 'customer_name', 'customer_phone', 'discount_amount', 'notes']);
        });
    }
};
