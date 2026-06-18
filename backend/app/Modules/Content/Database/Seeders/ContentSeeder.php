<?php

namespace App\Modules\Content\Database\Seeders;

use App\Modules\Auth\Models\User;
use App\Modules\Content\Models\Post;
use App\Modules\Content\Models\PostCategory;
use Illuminate\Database\Seeder;

class ContentSeeder extends Seeder
{
    public function run(): void
    {
        $user = User::first();
        if (!$user) return;

        $catAncestral = PostCategory::create(['name' => 'Sabedoria Ancestral', 'description' => 'Conhecimentos passados por gerações.']);
        $catSelfCare = PostCategory::create(['name' => 'Autocuidado', 'description' => 'Rituais para o dia a dia.']);

        Post::create([
            'user_id' => $user->id,
            'category_id' => $catAncestral->id,
            'title' => 'O Poder Secreto da Lavanda',
            'content' => 'A lavanda não é apenas uma flor bonita; ela carrega séculos de história...',
            'status' => 'published',
            'published_at' => now(),
        ]);

        Post::create([
            'user_id' => $user->id,
            'category_id' => $catSelfCare->id,
            'title' => 'Como Criar seu Próprio Ritual de Banho',
            'content' => 'Um banho pode ser muito mais que higiene; pode ser uma renovação energética...',
            'status' => 'published',
            'published_at' => now(),
        ]);
    }
}
