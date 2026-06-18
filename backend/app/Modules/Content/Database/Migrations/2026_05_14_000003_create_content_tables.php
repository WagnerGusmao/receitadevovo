<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('post_categories', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name')->unique();
            $blueprint->string('slug')->unique();
            $blueprint->text('description')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('posts', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('user_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('category_id')->constrained('post_categories')->onDelete('cascade');
            $blueprint->string('title');
            $blueprint->string('slug')->unique();
            $blueprint->text('excerpt')->nullable();
            $blueprint->longText('content');
            $blueprint->string('featured_image')->nullable();
            $blueprint->enum('status', ['draft', 'published'])->default('draft');
            $blueprint->json('seo_metadata')->nullable(); // meta_title, meta_description, keywords
            $blueprint->timestamp('published_at')->nullable();
            $blueprint->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('posts');
        Schema::dropIfExists('post_categories');
    }
};
