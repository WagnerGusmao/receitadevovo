<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('comodato_partners', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('contact_name')->nullable();
            $table->string('phone')->nullable();
            $table->text('address')->nullable();
            $table->decimal('commission_percentage', 5, 2)->default(0.00);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        Schema::create('comodato_stocks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('partner_id')->constrained('comodato_partners')->onDelete('cascade');
            $table->string('itemable_type'); // App\Modules\Ecommerce\Models\Product, Kit, etc.
            $table->unsignedBigInteger('itemable_id');
            $table->integer('quantity')->default(0);
            $table->timestamps();

            $table->unique(['partner_id', 'itemable_type', 'itemable_id'], 'comodato_stocks_unique');
        });

        Schema::create('comodato_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('partner_id')->constrained('comodato_partners')->onDelete('cascade');
            $table->string('itemable_type');
            $table->unsignedBigInteger('itemable_id');
            $table->string('type'); // dispatch, sale, return, loss
            $table->integer('quantity');
            $table->unsignedBigInteger('order_id')->nullable(); // vinculada à tabela orders se for venda
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('comodato_audits', function (Blueprint $table) {
            $table->id();
            $table->foreignId('partner_id')->constrained('comodato_partners')->onDelete('cascade');
            $table->timestamp('audited_at')->useCurrent();
            $table->string('status')->default('completed'); // completed, discrepancy_found
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('comodato_audit_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('comodato_audit_id')->constrained('comodato_audits')->onDelete('cascade');
            $table->string('itemable_type');
            $table->unsignedBigInteger('itemable_id');
            $table->integer('expected_quantity');
            $table->integer('actual_quantity');
            $table->integer('difference');
            $table->string('action_taken')->nullable(); // loss_registered, sale_registered, adjusted
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('comodato_audit_items');
        Schema::dropIfExists('comodato_audits');
        Schema::dropIfExists('comodato_movements');
        Schema::dropIfExists('comodato_stocks');
        Schema::dropIfExists('comodato_partners');
    }
};
