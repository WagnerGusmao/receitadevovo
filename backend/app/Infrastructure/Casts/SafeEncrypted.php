<?php

namespace App\Infrastructure\Casts;

use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Contracts\Encryption\DecryptException;

class SafeEncrypted implements CastsAttributes
{
    /**
     * Encrypt a value deterministically.
     */
    public static function encryptDeterministic(mixed $value): ?string
    {
        if (is_null($value)) {
            return null;
        }

        $key = config('app.key');
        if (str_starts_with($key, 'base64:')) {
            $key = base64_decode(substr($key, 7));
        }

        $iv = substr(hash('sha256', $key, true), 0, 16);
        $encrypted = openssl_encrypt((string)$value, 'AES-256-CBC', $key, 0, $iv);

        return 'det:' . $encrypted;
    }

    /**
     * Decrypt a deterministically encrypted value.
     */
    public static function decryptDeterministic(mixed $value): ?string
    {
        if (is_null($value)) {
            return null;
        }

        if (!is_string($value) || !str_starts_with($value, 'det:')) {
            return null;
        }

        $key = config('app.key');
        if (str_starts_with($key, 'base64:')) {
            $key = base64_decode(substr($key, 7));
        }

        $iv = substr(hash('sha256', $key, true), 0, 16);
        $ciphertext = substr($value, 4);

        $decrypted = openssl_decrypt($ciphertext, 'AES-256-CBC', $key, 0, $iv);

        return $decrypted !== false ? $decrypted : null;
    }

    /**
     * Cast the given value.
     */
    public function get(Model $model, string $key, mixed $value, array $attributes): mixed
    {
        if (is_null($value)) {
            return null;
        }

        if (is_string($value) && str_starts_with($value, 'det:')) {
            $decrypted = self::decryptDeterministic($value);
            return $decrypted ?? $value;
        }

        try {
            return Crypt::decryptString($value);
        } catch (DecryptException $e) {
            // Decryption failed: it is likely unencrypted plain text
            return $value;
        }
    }

    /**
     * Prepare the given value for storage.
     */
    public function set(Model $model, string $key, mixed $value, array $attributes): mixed
    {
        if (is_null($value)) {
            return null;
        }

        // Check if it is already deterministically encrypted
        if (is_string($value) && str_starts_with($value, 'det:')) {
            return $value;
        }

        // Check if it is already a valid Laravel encrypted payload
        if (is_string($value)) {
            $decoded = json_decode(base64_decode($value), true);
            if (is_array($decoded) && isset($decoded['iv'], $decoded['value'], $decoded['mac'])) {
                return $value;
            }
        }

        return self::encryptDeterministic($value);
    }
}
