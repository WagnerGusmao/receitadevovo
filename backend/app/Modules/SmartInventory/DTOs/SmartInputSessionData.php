<?php

namespace App\Modules\SmartInventory\DTOs;

readonly class SmartInputSessionData
{
    public function __construct(
        public string  $documentType,
        public ?string $documentPath = null,
        public ?string $documentOriginalName = null,
        public ?int    $supplierId = null,
        public ?string $supplierNameRaw = null,
        public ?string $purchaseDate = null,
        public ?string $documentNumber = null,
        public ?float  $totalValue = null,
        public ?string $notes = null,
    ) {}

    public static function fromArray(array $data): self
    {
        return new self(
            documentType:         $data['document_type'] ?? 'manual',
            documentPath:         $data['document_path'] ?? null,
            documentOriginalName: $data['document_original_name'] ?? null,
            supplierId:           $data['supplier_id'] ?? null,
            supplierNameRaw:      $data['supplier_name_raw'] ?? null,
            purchaseDate:         $data['purchase_date'] ?? null,
            documentNumber:       $data['document_number'] ?? null,
            totalValue:           isset($data['total_value']) ? (float) $data['total_value'] : null,
            notes:                $data['notes'] ?? null,
        );
    }
}
