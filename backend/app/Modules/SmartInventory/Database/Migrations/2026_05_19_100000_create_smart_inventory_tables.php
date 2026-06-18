<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Sessão de importação de matéria-prima (manual ou via IA/OCR)
        Schema::create('smart_input_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();

            $table->enum('status', [
                'pending',      // criada, aguardando processamento
                'processing',   // job em execução
                'needs_review', // OCR concluído, aguardando validação humana
                'confirmed',    // usuário aprovou — processando no estoque
                'completed',    // movimentações registradas com sucesso
                'failed',       // erro no OCR ou no processamento
            ])->default('pending');

            $table->enum('document_type', ['image', 'pdf', 'manual'])->default('manual');
            $table->string('document_path')->nullable();           // caminho em storage
            $table->string('document_original_name')->nullable();  // nome original do arquivo

            $table->text('raw_ocr_text')->nullable();              // texto bruto retornado pelo Gemini
            $table->json('parsed_json')->nullable();               // JSON estruturado extraído

            $table->foreignId('supplier_id')->nullable()->constrained()->nullOnDelete();
            $table->string('supplier_name_raw')->nullable();       // nome do fornecedor como extraído
            $table->date('purchase_date')->nullable();
            $table->string('document_number')->nullable();         // número NF / cupom fiscal
            $table->decimal('total_value', 12, 2)->nullable();

            $table->text('error_message')->nullable();
            $table->text('notes')->nullable();
            $table->timestamp('confirmed_at')->nullable();

            $table->timestamps();
            $table->softDeletes();

            $table->index(['user_id', 'status']);
            $table->index('created_at');
        });

        // Itens extraídos / informados em cada sessão
        Schema::create('smart_input_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('session_id')
                  ->constrained('smart_input_sessions')
                  ->cascadeOnDelete();

            // Dados como vieram do documento / usuário
            $table->string('description_raw');
            $table->decimal('quantity', 12, 4);
            $table->string('unit_raw');                             // unidade como extraída
            $table->string('unit_normalized')->nullable();          // unidade normalizada (g,kg,ml,L,un,oz)
            $table->decimal('unit_price', 10, 4)->nullable();
            $table->decimal('total_price', 12, 2)->nullable();

            // Matching com matéria-prima cadastrada
            $table->foreignId('raw_material_id')->nullable()->constrained()->nullOnDelete();
            $table->float('match_confidence')->nullable();          // 0.0 – 1.0
            $table->json('match_suggestions')->nullable();          // top 3 sugestões [{id,name,unit,confidence}]

            // Dados do lote
            $table->string('batch_number')->nullable();
            $table->date('expires_at')->nullable();
            $table->date('manufactured_at')->nullable();

            // Estado de revisão
            $table->boolean('is_confirmed')->default(false);        // usuário aprovou este item
            $table->boolean('is_skipped')->default(false);          // usuário descartou este item
            $table->boolean('is_new_material')->default(false);     // criar nova matéria-prima
            $table->string('new_material_category')->nullable();    // categoria se for nova MP

            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['session_id', 'is_confirmed']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('smart_input_items');
        Schema::dropIfExists('smart_input_sessions');
    }
};
