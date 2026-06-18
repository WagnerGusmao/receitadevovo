<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Ordens de Compra
        Schema::create('purchase_orders', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique();                       // OC-2026-0001
            $table->foreignId('supplier_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();

            $table->enum('status', ['draft', 'sent', 'partial', 'received', 'cancelled'])
                  ->default('draft');

            $table->decimal('total_planned', 12, 2)->default(0);   // custo estimado
            $table->decimal('total_actual', 12, 2)->nullable();    // custo real ao receber

            $table->date('expected_at')->nullable();               // prazo de entrega esperado
            $table->timestamp('sent_at')->nullable();
            $table->timestamp('received_at')->nullable();

            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'created_at']);
            $table->index('supplier_id');
        });

        // Itens da Ordem de Compra
        Schema::create('purchase_order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('purchase_order_id')->constrained()->cascadeOnDelete();
            $table->foreignId('raw_material_id')->constrained()->restrictOnDelete();

            $table->decimal('quantity_ordered', 12, 4);            // quantidade solicitada
            $table->decimal('quantity_received', 12, 4)->nullable(); // recebido (pode ser parcial)
            $table->decimal('unit_price', 10, 4);                  // preço estimado
            $table->decimal('actual_unit_price', 10, 4)->nullable(); // preço real pago

            $table->decimal('total_planned', 12, 4);               // qty × unit_price
            $table->decimal('total_actual', 12, 4)->nullable();    // qty_received × actual_price

            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['purchase_order_id', 'raw_material_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('purchase_order_items');
        Schema::dropIfExists('purchase_orders');
    }
};
