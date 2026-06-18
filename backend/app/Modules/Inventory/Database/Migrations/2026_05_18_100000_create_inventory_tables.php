<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Fornecedores
        Schema::create('suppliers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('cnpj', 18)->nullable()->unique();
            $table->string('contact_name')->nullable();
            $table->string('email')->nullable();
            $table->string('phone', 20)->nullable();
            $table->string('website')->nullable();
            $table->text('notes')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();
        });

        // 2. Matérias-Primas
        Schema::create('raw_materials', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('description')->nullable();
            $table->string('unit'); // g, ml, kg, L, un
            $table->string('category')->nullable(); // ex: óleo essencial, base, conservante
            $table->decimal('stock_quantity', 12, 3)->default(0);
            $table->decimal('min_stock_quantity', 12, 3)->default(0);
            $table->decimal('average_cost', 10, 4)->default(0); // Custo médio ponderado
            $table->integer('shelf_life_days')->nullable(); // validade em dias
            $table->foreignId('supplier_id')->nullable()->constrained()->nullOnDelete();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index(['is_active', 'stock_quantity']);
            $table->index('supplier_id');
        });

        // 3. Lotes de Matéria-Prima
        Schema::create('batches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('raw_material_id')->constrained()->cascadeOnDelete();
            $table->foreignId('supplier_id')->nullable()->constrained()->nullOnDelete();
            $table->string('batch_number'); // Número do lote do fornecedor
            $table->string('internal_code')->unique(); // Código interno gerado
            $table->decimal('quantity_received', 12, 3);
            $table->decimal('quantity_remaining', 12, 3);
            $table->decimal('unit_cost', 10, 4); // Custo unitário deste lote
            $table->decimal('total_cost', 12, 2)->storedAs('quantity_received * unit_cost');
            $table->date('manufactured_at')->nullable();
            $table->date('expires_at')->nullable();
            $table->enum('status', ['active', 'depleted', 'expired', 'quarantine'])->default('active');
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['raw_material_id', 'status']);
            $table->index('expires_at');
        });

        // 4. Movimentações de Matéria-Prima
        Schema::create('raw_material_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('raw_material_id')->constrained()->cascadeOnDelete();
            $table->foreignId('batch_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->enum('type', ['purchase', 'adjustment_in', 'adjustment_out', 'consumed', 'waste', 'return']);
            $table->decimal('quantity', 12, 3);
            $table->decimal('unit_cost', 10, 4)->nullable();
            $table->decimal('total_cost', 12, 2)->nullable();
            $table->decimal('stock_after', 12, 3); // saldo após a movimentação
            $table->decimal('average_cost_after', 10, 4); // custo médio após
            $table->string('reference_type')->nullable(); // ex: ProductionOrder
            $table->unsignedBigInteger('reference_id')->nullable(); // FK polimórfica
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['raw_material_id', 'type']);
            $table->index(['reference_type', 'reference_id']);
        });

        // 5. Adicionar unit_cost aos produtos finais (sem destruir colunas)
        Schema::table('products', function (Blueprint $table) {
            if (!Schema::hasColumn('products', 'unit_cost')) {
                $table->decimal('unit_cost', 10, 4)->nullable()->after('price')
                    ->comment('Custo de produção por unidade');
            }
        });

        Schema::table('kits', function (Blueprint $table) {
            if (!Schema::hasColumn('kits', 'unit_cost')) {
                $table->decimal('unit_cost', 10, 4)->nullable()->after('price')
                    ->comment('Custo de montagem por unidade');
            }
        });
    }

    public function down(): void
    {
        Schema::table('kits', function (Blueprint $table) {
            if (Schema::hasColumn('kits', 'unit_cost')) {
                $table->dropColumn('unit_cost');
            }
        });

        Schema::table('products', function (Blueprint $table) {
            if (Schema::hasColumn('products', 'unit_cost')) {
                $table->dropColumn('unit_cost');
            }
        });

        Schema::dropIfExists('raw_material_movements');
        Schema::dropIfExists('batches');
        Schema::dropIfExists('raw_materials');
        Schema::dropIfExists('suppliers');
    }
};
