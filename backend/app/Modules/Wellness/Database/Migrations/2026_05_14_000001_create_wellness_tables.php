<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('benefits', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name')->unique();
            $blueprint->string('slug')->unique();
            $blueprint->text('description')->nullable();
            $blueprint->string('icon')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('emotions', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name')->unique();
            $blueprint->string('slug')->unique();
            $blueprint->text('description')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('herbs', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name')->unique();
            $blueprint->string('slug')->unique();
            $blueprint->string('scientific_name')->nullable();
            $blueprint->text('description');
            $blueprint->text('how_to_use')->nullable();
            $blueprint->string('image_path')->nullable();
            $blueprint->timestamps();
        });

        Schema::create('benefit_herb', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('benefit_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('herb_id')->constrained()->onDelete('cascade');
        });

        Schema::create('emotion_herb', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->foreignId('emotion_id')->constrained()->onDelete('cascade');
            $blueprint->foreignId('herb_id')->constrained()->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('emotion_herb');
        Schema::dropIfExists('benefit_herb');
        Schema::dropIfExists('herbs');
        Schema::dropIfExists('emotions');
        Schema::dropIfExists('benefits');
    }
};
