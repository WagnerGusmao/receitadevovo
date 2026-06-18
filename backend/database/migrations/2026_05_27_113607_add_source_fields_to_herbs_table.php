<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('herbs', function (Blueprint $table) {
            $table->string('source_type')->default('popular')->after('image_path');
            $table->text('sources')->nullable()->after('source_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('herbs', function (Blueprint $table) {
            $table->dropColumn(['source_type', 'sources']);
        });
    }
};
