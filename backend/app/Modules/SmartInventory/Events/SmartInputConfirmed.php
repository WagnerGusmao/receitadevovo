<?php

namespace App\Modules\SmartInventory\Events;

use App\Modules\SmartInventory\Models\SmartInputSession;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SmartInputConfirmed
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public readonly SmartInputSession $session,
        public readonly array             $movements,
    ) {}
}
