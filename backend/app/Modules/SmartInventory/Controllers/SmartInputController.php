<?php

namespace App\Modules\SmartInventory\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\SmartInventory\DTOs\SmartInputItemData;
use App\Modules\SmartInventory\DTOs\SmartInputSessionData;
use App\Modules\SmartInventory\Models\SmartInputItem;
use App\Modules\SmartInventory\Models\SmartInputSession;
use App\Modules\SmartInventory\Services\SmartInputService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class SmartInputController extends Controller
{
    public function __construct(private readonly SmartInputService $service) {}

    /* ────────────────────────────────────────────────────
     | LIST — histórico de sessões do usuário autenticado
     ─────────────────────────────────────────────────── */

    public function index(Request $request)
    {
        $sessions = SmartInputSession::where('user_id', $request->user()->id)
            ->withCount(['items', 'items as confirmed_items_count' => fn($q) => $q->where('is_confirmed', true)])
            ->latest()
            ->paginate(20);

        return $this->success($sessions);
    }

    /* ────────────────────────────────────────────────────
     | SHOW — sessão completa com itens e sugestões
     ─────────────────────────────────────────────────── */

    public function show(int $id)
    {
        $session = SmartInputSession::with(['items.rawMaterial', 'supplier', 'user'])
            ->findOrFail($id);

        return $this->success($session);
    }

    /* ────────────────────────────────────────────────────
     | UPLOAD — faz upload e cria sessão para IA/OCR
     ─────────────────────────────────────────────────── */

    public function upload(Request $request)
    {
        $request->validate([
            'document' => 'required|file|mimes:jpeg,jpg,png,webp,pdf|max:10240',
        ]);

        $session = $this->service->createUploadSession(
            file:   $request->file('document'),
            userId: $request->user()->id,
        );

        return $this->success($session, 'Documento enviado. Processamento iniciado.', 201);
    }

    /* ────────────────────────────────────────────────────
     | MANUAL — cria sessão de entrada manual
     ─────────────────────────────────────────────────── */

    public function manual(Request $request)
    {
        $request->validate([
            'supplier_id'     => 'nullable|exists:suppliers,id',
            'supplier_name_raw' => 'nullable|string|max:255',
            'purchase_date'   => 'nullable|date',
            'document_number' => 'nullable|string|max:100',
            'total_value'     => 'nullable|numeric|min:0',
            'notes'           => 'nullable|string',
            'items'           => 'required|array|min:1',
            'items.*.description_raw' => 'required|string|max:255',
            'items.*.quantity'        => 'required|numeric|min:0.001',
            'items.*.unit_raw'        => 'required|string|max:20',
            'items.*.unit_price'      => 'nullable|numeric|min:0',
            'items.*.total_price'     => 'nullable|numeric|min:0',
            'items.*.raw_material_id' => 'nullable|exists:raw_materials,id',
            'items.*.batch_number'    => 'nullable|string|max:100',
            'items.*.expires_at'      => 'nullable|date',
            'items.*.manufactured_at' => 'nullable|date',
            'items.*.notes'           => 'nullable|string',
        ]);

        $sessionData = SmartInputSessionData::fromArray($request->all());

        $itemsData = array_map(
            fn(array $item) => new SmartInputItemData(
                descriptionRaw: $item['description_raw'],
                quantity:       (float) $item['quantity'],
                unitRaw:        $item['unit_raw'],
                unitPrice:      isset($item['unit_price']) ? (float) $item['unit_price'] : null,
                totalPrice:     isset($item['total_price']) ? (float) $item['total_price'] : null,
                rawMaterialId:  $item['raw_material_id'] ?? null,
                batchNumber:    $item['batch_number'] ?? null,
                expiresAt:      $item['expires_at'] ?? null,
                manufacturedAt: $item['manufactured_at'] ?? null,
                notes:          $item['notes'] ?? null,
            ),
            $request->input('items')
        );

        $session = $this->service->createManualSession($sessionData, $itemsData, $request->user()->id);

        return $this->success($session, 'Sessão manual criada com sucesso.', 201);
    }

    /* ────────────────────────────────────────────────────
     | UPDATE ITEM — revisão humana de um item
     ─────────────────────────────────────────────────── */

    public function updateItem(Request $request, int $sessionId, int $itemId)
    {
        $session = SmartInputSession::findOrFail($sessionId);

        if ($session->status === 'completed') {
            return $this->error('Sessão já finalizada. Não é possível alterar itens.', 422);
        }

        $request->validate([
            'raw_material_id'      => 'nullable|exists:raw_materials,id',
            'description_raw'      => 'nullable|string|max:255',
            'quantity'             => 'nullable|numeric|min:0.001',
            'unit_normalized'      => 'nullable|string|in:g,kg,ml,L,un,oz,cx',
            'unit_price'           => 'nullable|numeric|min:0',
            'total_price'          => 'nullable|numeric|min:0',
            'batch_number'         => 'nullable|string|max:100',
            'expires_at'           => 'nullable|date',
            'manufactured_at'      => 'nullable|date',
            'is_confirmed'         => 'nullable|boolean',
            'is_skipped'           => 'nullable|boolean',
            'is_new_material'      => 'nullable|boolean',
            'new_material_category' => 'nullable|string|max:100',
            'notes'                => 'nullable|string',
        ]);

        $item = SmartInputItem::where('session_id', $sessionId)->findOrFail($itemId);
        $item = $this->service->updateItem($item, $request->all());

        return $this->success($item, 'Item atualizado.');
    }

    /* ────────────────────────────────────────────────────
     | CONFIRM — valida e registra movimentações no estoque
     ─────────────────────────────────────────────────── */

    public function confirm(int $sessionId, Request $request)
    {
        $session = SmartInputSession::findOrFail($sessionId);

        // Verificar duplicidade de nota fiscal
        if ($session->document_number) {
            $duplicate = SmartInputSession::where('id', '!=', $sessionId)
                ->where('document_number', $session->document_number)
                ->where('status', 'completed')
                ->first();

            if ($duplicate) {
                return $this->error(
                    "A nota fiscal '{$session->document_number}' já foi registrada anteriormente (Entrada #{$duplicate->id} em " .
                    optional($duplicate->created_at)->format('d/m/Y') . "). Verifique se não é uma duplicidade.",
                    409
                );
            }
        }

        try {
            $movements = $this->service->confirmSession($session, $request->user()->id);

            return $this->success(
                [
                    'session'         => $session->fresh(['items', 'supplier']),
                    'movements_count' => count($movements),
                ],
                'Entrada registrada com sucesso no estoque.'
            );
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /* ────────────────────────────────────────────────────
     | REPROCESS — reprocessa sessão com falha
     ─────────────────────────────────────────────────── */

    public function reprocess(int $sessionId)
    {
        $session = SmartInputSession::findOrFail($sessionId);

        try {
            $session = $this->service->reprocessSession($session);
            return $this->success($session, 'Reprocessamento iniciado.');
        } catch (\DomainException $e) {
            return $this->error($e->getMessage(), 422);
        }
    }

    /* ────────────────────────────────────────────────────
     | UPDATE SESSION — atualiza fornecedor/data/número da NF
     ─────────────────────────────────────────────────── */

    public function updateSession(Request $request, int $sessionId)
    {
        $session = SmartInputSession::findOrFail($sessionId);

        if ($session->status === 'completed') {
            return $this->error('Sessão já finalizada.', 422);
        }

        $request->validate([
            'supplier_id'     => 'nullable|exists:suppliers,id',
            'purchase_date'   => 'nullable|date',
            'document_number' => 'nullable|string|max:100',
            'notes'           => 'nullable|string',
        ]);

        $session->update($request->only(['supplier_id', 'purchase_date', 'document_number', 'notes']));

        return $this->success($session->fresh(['supplier']), 'Sessão atualizada.');
    }

    /* ────────────────────────────────────────────────────
     | CANCEL — descarta uma sessão
     ─────────────────────────────────────────────────── */

    public function cancel(int $sessionId)
    {
        $session = SmartInputSession::findOrFail($sessionId);

        if ($session->status === 'completed') {
            return $this->error('Sessão concluída não pode ser excluída — faz parte do histórico de auditoria.', 422);
        }

        // Remove o arquivo do storage se existir
        if ($session->document_path && Storage::exists($session->document_path)) {
            Storage::delete($session->document_path);
        }

        $session->delete();

        return $this->success([], 'Sessão excluída com sucesso.');
    }

    /* ────────────────────────────────────────────────────
     | DASHBOARD — resumo das sessões recentes
     ─────────────────────────────────────────────────── */

    public function dashboard()
    {
        $recent = SmartInputSession::with('supplier')
            ->withCount('items')
            ->latest()
            ->limit(10)
            ->get();

        $stats = [
            'total'       => SmartInputSession::count(),
            'completed'   => SmartInputSession::where('status', 'completed')->count(),
            'failed'      => SmartInputSession::where('status', 'failed')->count(),
            'pending'     => SmartInputSession::whereIn('status', ['pending', 'processing', 'needs_review'])->count(),
        ];

        return $this->success(['stats' => $stats, 'recent' => $recent]);
    }
}
