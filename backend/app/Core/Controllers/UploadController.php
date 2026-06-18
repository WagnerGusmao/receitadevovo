<?php

namespace App\Core\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class UploadController extends Controller
{
    /**
     * Upload an image to the local storage (can be swapped for Cloudinary/S3).
     */
    public function upload(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
        ]);

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            
            try {
                $path = $this->optimizeAndSaveImage($file, 'uploads');
            } catch (\Exception $e) {
                // Se falhar o processamento, salva no formato original como fallback de segurança
                $path = $file->store('uploads', 'public');
            }
            
            $url = asset('storage/' . $path);

            return $this->success([
                'path' => $path,
                'url' => $url
            ], 'Imagem enviada com sucesso');
        }

        return $this->error('Falha ao enviar imagem', 400);
    }

    /**
     * Otimiza a imagem redimensionando-a para o limite máximo e convertendo para WebP.
     */
    private function optimizeAndSaveImage($file, string $folder, int $maxWidth = 800, int $maxHeight = 800): string
    {
        $mime = $file->getMimeType();

        // 1. Criar recurso de imagem correspondente ao tipo mime
        switch ($mime) {
            case 'image/jpeg':
            case 'image/jpg':
                $srcImage = imagecreatefromjpeg($file->getRealPath());
                break;
            case 'image/png':
                $srcImage = imagecreatefrompng($file->getRealPath());
                break;
            case 'image/gif':
                $srcImage = imagecreatefromgif($file->getRealPath());
                break;
            case 'image/webp':
                $srcImage = imagecreatefromwebp($file->getRealPath());
                break;
            default:
                return $file->store($folder, 'public');
        }

        if (!$srcImage) {
            return $file->store($folder, 'public');
        }

        // 2. Obter dimensões originais
        list($width, $height) = getimagesize($file->getRealPath());

        // 3. Calcular novas dimensões mantendo proporção
        $newWidth = $width;
        $newHeight = $height;

        if ($width > $maxWidth || $height > $maxHeight) {
            $ratio = $width / $height;
            if ($width > $height) {
                $newWidth = $maxWidth;
                $newHeight = (int) round($maxWidth / $ratio);
            } else {
                $newHeight = $maxHeight;
                $newWidth = (int) round($maxHeight * $ratio);
            }
        }

        // 4. Criar tela de destino
        $dstImage = imagecreatetruecolor($newWidth, $newHeight);

        // Preservar transparência para PNG, WebP e GIF
        if (in_array($mime, ['image/png', 'image/webp', 'image/gif'])) {
            imagealphablending($dstImage, false);
            imagesavealpha($dstImage, true);
            $transparent = imagecolorallocatealpha($dstImage, 255, 255, 255, 127);
            imagefilledrectangle($dstImage, 0, 0, $newWidth, $newHeight, $transparent);
        }

        // 5. Redimensionar cópia
        imagecopyresampled($dstImage, $srcImage, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height);

        // 6. Gerar nome de arquivo WebP único e caminho temporário
        $filename = uniqid() . '.webp';
        $tempPath = tempnam(sys_get_temp_dir(), 'img_') . '.webp';
        
        // Salvar em arquivo temporário com 80% de qualidade
        imagewebp($dstImage, $tempPath, 80);

        // Liberar memória GD
        imagedestroy($srcImage);
        imagedestroy($dstImage);

        // 7. Enviar arquivo temporário otimizado para o storage do Laravel
        $path = Storage::disk('public')->putFileAs($folder, new \Illuminate\Http\File($tempPath), $filename);
        
        // Remover arquivo temporário local do servidor
        @unlink($tempPath);

        return $path;
    }
}
