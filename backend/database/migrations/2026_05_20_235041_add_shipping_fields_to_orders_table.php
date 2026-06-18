<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->string('tracking_code')->nullable()->after('notes');
            $table->timestamp('shipped_at')->nullable()->after('tracking_code');
            $table->decimal('weight_kg', 5, 2)->nullable()->after('shipped_at');
            $table->string('box_dimensions')->nullable()->after('weight_kg'); // ex: "30x20x15"
            $table->decimal('freight_value', 8, 2)->nullable()->after('box_dimensions');
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['tracking_code', 'shipped_at', 'weight_kg', 'box_dimensions', 'freight_value']);
        });
    }
};
