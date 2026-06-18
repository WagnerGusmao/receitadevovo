<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Inspeções de qualidade (polimórficas: Batch ou ProductionOrder)
        Schema::create('quality_checks', function (Blueprint $table) {
            $table->id();

            // Polimórfico: App\Modules\Inventory\Models\Batch ou ProductionOrder
            $table->morphs('checkable');

            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();

            $table->enum('check_type', ['receipt', 'production'])
                  ->comment('receipt = inspeção de lote recebido; production = inspeção de produção');

            $table->enum('status', ['pending', 'approved', 'rejected', 'quarantine'])
                  ->default('pending');

            $table->timestamp('checked_at')->nullable();    // quando a inspeção foi concluída
            $table->text('notes')->nullable();              // observações gerais
            $table->text('rejection_reason')->nullable();   // motivo de rejeição

            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'check_type']);
            $table->index('created_at');
        });

        // Critérios individuais avaliados em cada inspeção
        Schema::create('quality_check_criteria', function (Blueprint $table) {
            $table->id();
            $table->foreignId('quality_check_id')->constrained()->cascadeOnDelete();

            $table->string('criterion');                    // appearance, smell, taste, texture, weight, packaging, expiry
            $table->string('criterion_label');              // label legível
            $table->enum('result', ['pass', 'fail', 'conditional'])->nullable();
            $table->string('measured_value')->nullable();   // ex: "47g" ou "aprovado"
            $table->text('notes')->nullable();

            $table->timestamps();

            $table->index(['quality_check_id', 'criterion']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('quality_check_criteria');
        Schema::dropIfExists('quality_checks');
    }
};
