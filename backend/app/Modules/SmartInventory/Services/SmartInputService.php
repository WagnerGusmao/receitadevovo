<?php

namespace App\Modules\SmartInventory\Services;

use App\Modules\Inventory\Models\RawMaterial;
use App\Modules\Inventory\Models\Supplier;
use App\Modules\Inventory\Services\InventoryService;
use App\Modules\SmartInventory\DTOs\SmartInputItemData;
use App\Modules\SmartInventory\DTOs\SmartInputSessionData;
use App\Modules\SmartInventory\Events\SmartInputConfirmed;
use App\Modules\SmartInventory\Jobs\ProcessSmartInputJob;
use App\Modules\SmartInventory\Models\SmartInputItem;
use App\Modules\SmartInventory\Models\SmartInputSession;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class SmartInputService
{
    public function __construct(
        private readonly InventoryService      $inventoryService,
        private readonly GeminiOcrService      $geminiOcrService,
        private readonly MaterialMatchingService $matchingService,
    ) {}

    /* ─────────────────────────────────────────────────────
     | 1. CRIAR SESSÃO COM UPLOAD DE DOCUMENTO
     ──────────────────────────────────────────────────── */

    public function createUploadSession(UploadedFile $file, int $userId): SmartInputSession
    {
        $extension = strtolower($file->getClientOriginalExtension());
        $path      = $file->store("smart_input/{$userId}", 'local');
        $mimeType  = GeminiOcrService::mimeFromExtension($extension);

        $session = SmartInputSession::create([
            'user_id'               => $userId,
            'status'                => 'pending',
            'document_type'         => $extension === 'pdf' ? 'pdf' : 'image',
            'document_path'         => $path,
            'document_original_name' => $file->getClientOriginalName(),
        ]);

        ProcessSmartInputJob::dispatch($session->id, $mimeType);

        return $session->fresh();
    }

    /* ─────────────────────────────────────────────────────
     | 2. CRIAR SESSÃO MANUAL (SEM IA)
     ──────────────────────────────────────────────────── */

    public function createManualSession(SmartInputSessionData $sessionData, array $items, int $userId): SmartInputSession
    {
        return DB::transaction(function () use ($sessionData, $items, $userId) {
            $session = SmartInputSession::create([
                'user_id'          => $userId,
                'status'           => 'needs_review',
                'document_type'    => 'manual',
                'supplier_id'      => $sessionData->supplierId,
                'supplier_name_raw' => $sessionData->supplierNameRaw,
                'purchase_date'    => $sessionData->purchaseDate,
                'document_number'  => $sessionData->documentNumber,
                'total_value'      => $sessionData->totalValue,
                'notes'            => $sessionData->notes,
            ]);

            foreach ($items as $itemData) {
                /** @var SmartInputItemData $itemData */
                $suggestions = $this->matchingService->findMatches($itemData->descriptionRaw);
                $topMatch    = $suggestions[0] ?? null;

                SmartInputItem::create([
                    'session_id'        => $session->id,
                    'description_raw'   => $itemData->descriptionRaw,
                    'quantity'          => $itemData->quantity,
                    'unit_raw'          => $itemData->unitRaw,
                    'unit_normalized'   => $this->matchingService->normalizeUnit($itemData->unitRaw),
                    'unit_price'        => $itemData->unitPrice,
                    'total_price'       => $itemData->totalPrice,
                    'raw_material_id'   => $itemData->rawMaterialId ?? ($topMatch['raw_material_id'] ?? null),
                    'match_confidence'  => $itemData->matchConfidence ?? ($topMatch['confidence'] ?? null),
                    'match_suggestions' => $suggestions,
                    'batch_number'      => $itemData->batchNumber,
                    'expires_at'        => $itemData->expiresAt,
                    'manufactured_at'   => $itemData->manufacturedAt,
                    'is_confirmed'      => (bool) $itemData->rawMaterialId, // pre-confirma se MP já informada
                    'notes'             => $itemData->notes,
                ]);
            }

            return $session->load('items.rawMaterial');
        });
    }

    /* ─────────────────────────────────────────────────────
     | 3. PROCESSAR SESSÃO (chamado pelo Job)
     ──────────────────────────────────────────────────── */

    public function processSession(SmartInputSession $session, string $mimeType): void
    {
        try {
            $session->update(['status' => 'processing']);

            $extracted = $this->geminiOcrService->extractFromFile($session->document_path, $mimeType);

            Log::info('SmartInputService: OCR extracted', [
                'session' => $session->id,
                'items'   => count($extracted['items'] ?? []),
            ]);

            DB::transaction(function () use ($session, $extracted) {
                // Atualizar metadados da sessão
                $session->update([
                    'raw_ocr_text'      => json_encode($extracted, JSON_UNESCAPED_UNICODE),
                    'parsed_json'       => $extracted,
                    'supplier_name_raw' => $extracted['supplier'],
                    'purchase_date'     => $extracted['purchase_date'],
                    'document_number'   => $extracted['document_number'],
                    'total_value'       => $extracted['total_value'],
                ]);

                // Tentar resolver fornecedor automaticamente
                if ($extracted['supplier']) {
                    $supplier = $this->findOrSuggestSupplier($extracted['supplier']);
                    if ($supplier) {
                        $session->update(['supplier_id' => $supplier->id]);
                    }
                }

                // Criar itens com matching
                foreach ($extracted['items'] as $item) {
                    $suggestions = $this->matchingService->findMatches($item['description']);
                    $topMatch    = $suggestions[0] ?? null;
                    $unitNorm    = $this->matchingService->normalizeUnit($item['unit']);

                    SmartInputItem::create([
                        'session_id'       => $session->id,
                        'description_raw'  => $item['description'],
                        'quantity'         => $item['quantity'],
                        'unit_raw'         => $item['unit'],
                        'unit_normalized'  => $unitNorm,
                        'unit_price'       => $item['unit_price'],
                        'total_price'      => $item['total_price'],
                        'raw_material_id'  => $topMatch ? $topMatch['raw_material_id'] : null,
                        'match_confidence' => $topMatch ? $topMatch['confidence'] : null,
                        'match_suggestions' => $suggestions,
                    ]);
                }

                $session->update(['status' => 'needs_review']);
            });
        } catch (\Throwable $e) {
            Log::error('SmartInputService: processSession failed', [
                'session' => $session->id,
                'error'   => $e->getMessage(),
            ]);

            $session->update([
                'status'        => 'failed',
                'error_message' => $e->getMessage(),
            ]);
        }
    }

    /* ─────────────────────────────────────────────────────
     | 4. ATUALIZAR ITEM (revisão humana)
     ──────────────────────────────────────────────────── */

    public function updateItem(SmartInputItem $item, array $data): SmartInputItem
    {
        $fillable = [
            'raw_material_id', 'description_raw', 'quantity', 'unit_normalized', 'unit_price',
            'total_price', 'batch_number', 'expires_at', 'manufactured_at',
            'is_confirmed', 'is_skipped', 'is_new_material', 'new_material_category', 'notes',
        ];

        $updates = array_intersect_key($data, array_flip($fillable));

        // Ao trocar a matéria-prima manualmente, zera confiança automática
        if (isset($updates['raw_material_id'])) {
            $updates['match_confidence'] = 1.0; // usuário confirmou manualmente
        }

        $item->update($updates);

        return $item->fresh(['rawMaterial']);
    }

    /* ─────────────────────────────────────────────────────
     | 5. CONFIRMAR SESSÃO — registra movimentações
     ──────────────────────────────────────────────────── */

    public function confirmSession(SmartInputSession $session, int $userId): array
    {
        if (!$session->canBeConfirmed()) {
            throw new \DomainException("Sessão não pode ser confirmada no estado '{$session->status}'.");
        }

        $pendingItems = $session->items()
            ->where('is_skipped', false)
            ->where('is_confirmed', false)
            ->count();

        if ($pendingItems > 0) {
            throw new \DomainException("Existem {$pendingItems} item(ns) pendentes. Confirme ou descarte todos antes de finalizar.");
        }

        $confirmedItems = $session->items()
            ->where('is_confirmed', true)
            ->get();

        if ($confirmedItems->isEmpty()) {
            throw new \DomainException('Nenhum item confirmado para entrada no estoque.');
        }

        $movements = [];

        DB::transaction(function () use ($session, $confirmedItems, $userId, &$movements) {
            foreach ($confirmedItems as $item) {
                $material = $this->resolveRawMaterial($item, $session->supplier_id);

                $batchNumber = $item->batch_number
                    ?? ('SI-' . $session->id . '-' . Str::upper(Str::random(4)));

                $result = $this->inventoryService->receiveBatch(
                    material:  $material,
                    batchData: [
                        'supplier_id'    => $session->supplier_id,
                        'batch_number'   => $batchNumber,
                        'quantity'       => $item->quantity,
                        'unit_cost'      => $item->unit_price ?? 0,
                        'expires_at'     => $item->expires_at?->toDateString(),
                        'manufactured_at' => $item->manufactured_at?->toDateString(),
                        'notes'          => "SmartInput #{$session->id}: {$item->description_raw}",
                    ],
                    userId: $userId,
                );

                // Aponta a movimentação para a sessão SmartInput (auditoria)
                $result['movement']->update([
                    'reference_type' => SmartInputSession::class,
                    'reference_id'   => $session->id,
                ]);

                $movements[] = $result;
            }

            $session->update([
                'status'       => 'completed',
                'confirmed_at' => now(),
            ]);

            event(new SmartInputConfirmed($session, $movements));
        });

        Log::info('SmartInputService: session confirmed', [
            'session'    => $session->id,
            'movements'  => count($movements),
        ]);

        return $movements;
    }

    /* ─────────────────────────────────────────────────────
     | 6. REPROCESSAR SESSÃO FALHA
     ──────────────────────────────────────────────────── */

    public function reprocessSession(SmartInputSession $session): SmartInputSession
    {
        if ($session->status !== 'failed') {
            throw new \DomainException("Apenas sessões com falha podem ser reprocessadas.");
        }

        // Limpa itens anteriores e reseta
        $session->items()->delete();
        $session->update([
            'status'        => 'pending',
            'error_message' => null,
            'raw_ocr_text'  => null,
            'parsed_json'   => null,
        ]);

        $mimeType = GeminiOcrService::mimeFromExtension(
            pathinfo($session->document_original_name ?? '', PATHINFO_EXTENSION)
        );

        ProcessSmartInputJob::dispatch($session->id, $mimeType);

        return $session->fresh();
    }

    /* ─────────────────────────────────────────────────────
     | Helpers privados
     ──────────────────────────────────────────────────── */

    private function resolveRawMaterial(SmartInputItem $item, ?int $supplierId): RawMaterial
    {
        if ($item->is_new_material) {
            return RawMaterial::create([
                'name'        => $item->description_raw,
                'unit'        => $item->unit_normalized ?? $item->unit_raw,
                'category'    => $item->new_material_category,
                'supplier_id' => $supplierId,
            ]);
        }

        return RawMaterial::lockForUpdate()->findOrFail($item->raw_material_id);
    }

    private function findOrSuggestSupplier(string $name): ?Supplier
    {
        $normalized = $this->matchingService->normalize($name);

        return Supplier::where('is_active', true)->get()->first(function (Supplier $s) use ($normalized) {
            similar_text(
                $this->matchingService->normalize($s->name),
                $normalized,
                $percent
            );
            return $percent >= 70;
        });
    }
}
