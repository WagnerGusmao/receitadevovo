"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Upload, X, ImageIcon, Plus } from "lucide-react";
import { toast } from "sonner";
import { Label } from "@/components/ui/label";

interface MultiImageUploadProps {
  onUpload: (urls: string[]) => void;
  value: string[];
}

export function MultiImageUpload({ onUpload, value = [] }: MultiImageUploadProps) {
  const [loading, setLoading] = useState(false);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    setLoading(true);
    const newUrls = [...value];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      if (file.size > 5 * 1024 * 1024) {
        toast.error(`A imagem ${file.name} deve ter no máximo 5MB`);
        continue;
      }

      const formData = new FormData();
      formData.append("image", file);

      try {
        const token = localStorage.getItem('auth_token');
        const apiBaseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api';
        const response = await fetch(`${apiBaseUrl}/upload`, {
          method: "POST",
          headers: {
            'Authorization': `Bearer ${token}`
          },
          body: formData,
        });

        const data = await response.json();
        if (response.ok) {
          newUrls.push(data.data.url);
        } else {
          toast.error(data.message || `Erro ao enviar ${file.name}`);
        }
      } catch (error) {
        toast.error(`Erro na conexão ao enviar ${file.name}`);
      }
    }

    onUpload(newUrls);
    setLoading(false);
  };

  const removeImage = (index: number) => {
    const newUrls = value.filter((_, i) => i !== index);
    onUpload(newUrls);
  };

  return (
    <div className="space-y-4 w-full">
      <Label className="block text-xs font-medium text-zinc-500 uppercase tracking-wider">Galeria de Imagens</Label>
      
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {value.map((url, index) => (
          <div key={index} className="relative aspect-square rounded-lg overflow-hidden border group">
            <img src={url} alt={`Gallery ${index}`} className="w-full h-full object-cover transition-transform group-hover:scale-105" />
            <button 
              type="button"
              onClick={() => removeImage(index)}
              className="absolute top-1 right-1 p-1 bg-destructive text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <X className="w-3 h-3" />
            </button>
          </div>
        ))}
        
        <button
          type="button"
          disabled={loading}
          onClick={() => document.getElementById('multi-image-upload')?.click()}
          className="aspect-square rounded-lg bg-zinc-50 border border-dashed border-zinc-200 flex flex-col items-center justify-center text-zinc-400 hover:bg-zinc-100 hover:border-primary/20 transition-all"
        >
          {loading ? (
            <div className="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin" />
          ) : (
            <>
              <Plus className="w-6 h-6 mb-1" />
              <span className="text-[10px]">Adicionar</span>
            </>
          )}
        </button>
      </div>
      
      <input 
        type="file" 
        className="hidden" 
        id="multi-image-upload" 
        accept="image/*"
        multiple
        onChange={handleFileChange}
      />
    </div>
  );
}
