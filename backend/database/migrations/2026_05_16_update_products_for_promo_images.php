<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            // Adicionar preço original se não existir
            if (!Schema::hasColumn('products', 'old_price')) {
                $table->decimal('old_price', 10, 2)->nullable()->after('price');
            }
            
            // Adicionar campo de desconto percentual (opcional)
            if (!Schema::hasColumn('products', 'discount_percent')) {
                $table->decimal('discount_percent', 5, 2)->nullable()->after('old_price');
            }
            
            // Adicionar data de início da promoção
            if (!Schema::hasColumn('products', 'promo_start')) {
                $table->timestamp('promo_start')->nullable()->after('discount_percent');
            }
            
            // Adicionar data de fim da promoção
            if (!Schema::hasColumn('products', 'promo_end')) {
                $table->timestamp('promo_end')->nullable()->after('promo_start');
            }
            
            // Garantir que images é JSON
            if (Schema::hasColumn('products', 'images')) {
                $table->json('images')->nullable()->change();
            } else {
                $table->json('images')->nullable()->after('featured_image');
            }
        });

        Schema::table('kits', function (Blueprint $table) {
            // Adicionar preço original se não existir
            if (!Schema::hasColumn('kits', 'old_price')) {
                $table->decimal('old_price', 10, 2)->nullable()->after('price');
            }
            
            // Adicionar campo de desconto percentual (opcional)
            if (!Schema::hasColumn('kits', 'discount_percent')) {
                $table->decimal('discount_percent', 5, 2)->nullable()->after('old_price');
            }
            
            // Adicionar data de início da promoção
            if (!Schema::hasColumn('kits', 'promo_start')) {
                $table->timestamp('promo_start')->nullable()->after('discount_percent');
            }
            
            // Adicionar data de fim da promoção
            if (!Schema::hasColumn('kits', 'promo_end')) {
                $table->timestamp('promo_end')->nullable()->after('promo_start');
            }
            
            // Garantir que images é JSON
            if (Schema::hasColumn('kits', 'images')) {
                $table->json('images')->nullable()->change();
            } else {
                $table->json('images')->nullable()->after('featured_image');
            }
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (Schema::hasColumn('products', 'promo_end')) {
                $table->dropColumn('promo_end');
            }
            if (Schema::hasColumn('products', 'promo_start')) {
                $table->dropColumn('promo_start');
            }
            if (Schema::hasColumn('products', 'discount_percent')) {
                $table->dropColumn('discount_percent');
            }
            if (Schema::hasColumn('products', 'old_price')) {
                $table->dropColumn('old_price');
            }
        });

        Schema::table('kits', function (Blueprint $table) {
            if (Schema::hasColumn('kits', 'promo_end')) {
                $table->dropColumn('promo_end');
            }
            if (Schema::hasColumn('kits', 'promo_start')) {
                $table->dropColumn('promo_start');
            }
            if (Schema::hasColumn('kits', 'discount_percent')) {
                $table->dropColumn('discount_percent');
            }
            if (Schema::hasColumn('kits', 'old_price')) {
                $table->dropColumn('old_price');
            }
        });
    }
};
