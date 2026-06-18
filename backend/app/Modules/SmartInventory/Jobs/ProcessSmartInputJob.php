<?php

namespace App\Modules\SmartInventory\Jobs;

use App\Modules\SmartInventory\Models\SmartInputSession;
use App\Modules\SmartInventory\Services\SmartInputService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ProcessSmartInputJob implements ShouldQueue
{
    use Queueable, InteractsWithQueue, SerializesModels;

    public int $tries   = 2;
    public int $timeout = 90;

    public function __construct(
        public readonly int    $sessionId,
        public readonly string $mimeType,
    ) {}

    public function handle(SmartInputService $service): void
    {
        $session = SmartInputSession::find($this->sessionId);

        if (!$session) {
            Log::warning("ProcessSmartInputJob: session {$this->sessionId} not found.");
            return;
        }

        if (!in_array($session->status, ['pending', 'failed'])) {
            Log::info("ProcessSmartInputJob: session {$this->sessionId} already in status {$session->status}, skipping.");
            return;
        }

        $service->processSession($session, $this->mimeType);
    }

    public function failed(\Throwable $exception): void
    {
        Log::error("ProcessSmartInputJob: job failed for session {$this->sessionId}", [
            'error' => $exception->getMessage(),
        ]);

        SmartInputSession::where('id', $this->sessionId)->update([
            'status'        => 'failed',
            'error_message' => 'Falha no processamento: ' . $exception->getMessage(),
        ]);
    }
}
