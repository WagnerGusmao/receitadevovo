<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Receitas / Fórmulas de Produção
        Schema::create('recipes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->nullable()->constrained()->nullOnDelete();
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('description')->nullable();
            $table->text('instructions')->nullable();    // modo de preparo
            $table->decimal('yield_quantity', 10, 3);   // rendimento esperado (ex: 100 unidades, 500 g)
            $table->string('yield_unit');               // unidade do rendimento (un, g, ml...)
            $table->decimal('waste_percent', 5, 2)->default(0); // % de perda esperada
            $table->integer('prep_time_minutes')->nullable();   // tempo de preparo estimado
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index(['product_id', 'is_active']);
        });

        // Ingredientes de cada receita (matérias-primas + quantidades)
        Schema::create('recipe_ingredients', function (Blueprint $table) {
            $table->id();
            $table->foreignId('recipe_id')->constrained()->cascadeOnDelete();
            $table->foreignId('raw_material_id')->constrained()->cascadeOnDelete();
            $table->decimal('quantity', 12, 4);         // quantidade necessária por lote
            $table->decimal('waste_percent', 5, 2)->default(0); // perda individual do ingrediente
            $table->string('notes')->nullable();
            $table->timestamps();

            $table->unique(['recipe_id', 'raw_material_id']);
            $table->index('raw_material_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('recipe_ingredients');
        Schema::dropIfExists('recipes');
    }
};
