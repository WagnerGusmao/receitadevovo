<?php

namespace Tests\Feature;

use App\Modules\Auth\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ImageUploadTest extends TestCase
{
    use RefreshDatabase;

    public function test_image_upload_compresses_and_converts_to_webp()
    {
        Storage::fake('public');

        // Create user and authenticate
        $user = User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => bcrypt('password'),
            'whatsapp' => '5511999999999',
        ]);
        Sanctum::actingAs($user);

        // 1. Create a large temporary JPEG image using GD
        $width = 1200;
        $height = 1000;
        $image = imagecreatetruecolor($width, $height);
        $bg = imagecolorallocate($image, 255, 0, 0); // Red background
        imagefill($image, 0, 0, $bg);

        $tempFile = tempnam(sys_get_temp_dir(), 'test_upload_') . '.jpg';
        imagejpeg($image, $tempFile);
        imagedestroy($image);

        // Wrap in UploadedFile
        $file = new UploadedFile(
            $tempFile,
            'test_image.jpg',
            'image/jpeg',
            null,
            true
        );

        // 2. Perform the upload request
        $response = $this->postJson('/api/upload', [
            'image' => $file,
        ]);

        @unlink($tempFile);

        // 3. Assertions
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'status',
            'data' => [
                'path',
                'url',
            ],
            'message',
        ]);

        $path = $response->json('data.path');
        
        // Assert it was saved as webp
        $this->assertStringEndsWith('.webp', $path);

        // Assert file exists in the public storage disk
        Storage::disk('public')->assertExists($path);

        // 4. Validate image dimensions of the processed file
        $fullPath = Storage::disk('public')->path($path);
        list($savedWidth, $savedHeight) = getimagesize($fullPath);

        // The image should be scaled down. 1200x1000 scaled to max 800:
        // Max dimension is width (1200). Ratio is 1200/1000 = 1.2.
        // New width should be 800. New height should be round(800 / 1.2) = 667.
        $this->assertEquals(800, $savedWidth);
        $this->assertEquals(667, $savedHeight);
    }
}
