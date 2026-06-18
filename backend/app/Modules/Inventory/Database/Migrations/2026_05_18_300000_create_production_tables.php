<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Ordens de Produção
        Schema::create('production_orders', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique();                       // OP-2026-0001
            $table->foreignId('recipe_id')->constrained()->restrictOnDelete();
            $table->foreignId('product_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();

            $table->enum('status', ['draft', 'in_progress', 'completed', 'cancelled'])
                  ->default('draft');

            // Quantidades planejadas x reais
            $table->integer('planned_batches')->default(1);
            $table->decimal('planned_yield', 12, 3);        // rendimento esperado (ex: 95 un)
            $table->decimal('planned_cost', 12, 2);         // custo estimado

            $table->integer('actual_batches')->nullable();
            $table->decimal('actual_yield', 12, 3)->nullable();     // produção real
            $table->decimal('actual_cost', 12, 2)->nullable();      // custo real

            // Perdas
            $table->decimal('waste_quantity', 12, 3)->nullable();
            $table->text('waste_notes')->nullable();

            // Controle de tempo
            $table->timestamp('started_at')->nullable();
            $table->timestamp('completed_at')->nullable();

            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'created_at']);
            $table->index('product_id');
        });

        // Itens consumidos por ordem de produção (rastreabilidade)
        Schema::create('production_order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('production_order_id')->constrained()->cascadeOnDelete();
            $table->foreignId('raw_material_id')->constrained()->restrictOnDelete();
            $table->foreignId('batch_id')->nullable()->constrained()->nullOnDelete();

            $table->decimal('planned_quantity', 12, 4);     // quantidade planejada
            $table->decimal('actual_quantity', 12, 4)->nullable(); // quantidade real consumida
            $table->decimal('unit_cost', 10, 4);            // custo médio no momento
            $table->decimal('total_cost', 12, 4);           // total real

            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index('raw_material_id');
            $table->index(['production_order_id', 'raw_material_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('production_order_items');
        Schema::dropIfExists('production_orders');
    }
};
