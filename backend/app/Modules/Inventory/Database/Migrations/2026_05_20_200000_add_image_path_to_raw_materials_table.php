<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('raw_materials', function (Blueprint $table) {
            if (!Schema::hasColumn('raw_materials', 'image_path')) {
                $table->string('image_path')->nullable()->after('supplier_id');
            }
        });
    }

    public function down(): void
    {
        Schema::table('raw_materials', function (Blueprint $table) {
            if (Schema::hasColumn('raw_materials', 'image_path')) {
                $table->dropColumn('image_path');
            }
        });
    }
};
