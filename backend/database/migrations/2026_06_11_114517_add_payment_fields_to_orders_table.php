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
        Schema::table('orders', function (Blueprint $table) {
            $table->string('payment_id')->nullable()->after('payment_method');
            $table->string('payment_status')->nullable()->after('payment_id');
            $table->text('payment_link')->nullable()->after('payment_status');
            $table->text('payment_pix_qr')->nullable()->after('payment_link');
            $table->text('payment_pix_code')->nullable()->after('payment_pix_qr');
            $table->timestamp('payment_pix_expiration')->nullable()->after('payment_pix_code');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn([
                'payment_id',
                'payment_status',
                'payment_link',
                'payment_pix_qr',
                'payment_pix_code',
                'payment_pix_expiration',
            ]);
        });
    }
};
