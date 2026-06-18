<?php

namespace App\Modules\SmartInventory\DTOs;

readonly class SmartInputItemData
{
    public function __construct(
        public string  $descriptionRaw,
        public float   $quantity,
        public string  $unitRaw,
        public ?string $unitNormalized = null,
        public ?float  $unitPrice = null,
        public ?float  $totalPrice = null,
        public ?int    $rawMaterialId = null,
        public ?float  $matchConfidence = null,
        public ?array  $matchSuggestions = null,
        public ?string $batchNumber = null,
        public ?string $expiresAt = null,
        public ?string $manufacturedAt = null,
        public bool    $isNewMaterial = false,
        public ?string $newMaterialCategory = null,
        public ?string $notes = null,
    ) {}

    public static function fromExtracted(array $item): self
    {
        return new self(
            descriptionRaw: $item['description'] ?? '',
            quantity:       (float) ($item['quantity'] ?? 0),
            unitRaw:        $item['unit'] ?? 'un',
            unitPrice:      isset($item['unit_price']) ? (float) $item['unit_price'] : null,
            totalPrice:     isset($item['total_price']) ? (float) $item['total_price'] : null,
        );
    }
}
