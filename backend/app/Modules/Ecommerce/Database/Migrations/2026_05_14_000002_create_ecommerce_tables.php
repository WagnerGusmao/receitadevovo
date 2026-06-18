<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('products', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name');
            $blueprint->string('slug')->unique();
            $blueprint->text('description');
            $blueprint->decimal('price', 10, 2);
            $blueprint->integer('stock')->default(0);
            $blueprint->string('featured_image')->nullable();
            $blueprint->json('images')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('kits', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name');
            $blueprint->string('slug')->unique();
            $blueprint->text('description');
            $blueprint->decimal('price', 10, 2);
            $blueprint->string('featured_image')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('kit_product', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('kit_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('product_id')->constrained()->onDelete('cascade');
            $blueprint->integer('quantity')->default(1);
        });

        Schema::create('herb_product', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('herb_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('product_id')->constrained()->onDelete('cascade');
        });

        Schema::create('orders', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('user_id')->constrained()->onDelete('cascade');
            $blueprint->string('order_number')->unique();
            $blueprint->decimal('total', 10, 2);
            $blueprint->string('status')->default('pending'); // pending, paid, shipped, cancelled
            $blueprint->string('payment_method')->nullable();
            $blueprint->string('shipping_address')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('order_items', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('order_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('product_id')->constrained()->onDelete('cascade');
            $blueprint->integer('quantity');
            $blueprint->decimal('price', 10, 2);
            $blueprint->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('order_items');
        Schema::dropIfExists('orders');
        Schema::dropIfExists('herb_product');
        Schema::dropIfExists('kit_product');
        Schema::dropIfExists('kits');
        Schema::dropIfExists('products');
    }
};
