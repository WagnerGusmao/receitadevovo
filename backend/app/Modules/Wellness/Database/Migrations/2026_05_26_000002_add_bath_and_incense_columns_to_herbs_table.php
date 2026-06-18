<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('herbs', function (Blueprint $blueprint) {
            $blueprint->text('bath_instructions')->nullable()->after('how_to_use');
            $blueprint->text('incense_usage')->nullable()->after('bath_instructions');
        });
    }

    public function down(): void
    {
        Schema::table('herbs', function (Blueprint $blueprint) {
            $blueprint->dropColumn(['bath_instructions', 'incense_usage']);
        });
    }
};
