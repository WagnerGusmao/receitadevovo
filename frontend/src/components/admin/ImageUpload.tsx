"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Upload, X, ImageIcon } from "lucide-react";
import { toast } from "sonner";

interface ImageUploadProps {
  onUpload: (url: string) => void;
  value?: string;
}

export function ImageUpload({ onUpload, value }: ImageUploadProps) {
  const [loading, setLoading] = useState(false);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (file.size > 5 * 1024 * 1024) {
      toast.error("A imagem deve ter no máximo 5MB");
      return;
    }

    setLoading(true);
    const formData = new FormData();
    formData.append("image", file);

    try {
      // We use standard fetch for multipart/form-data because apiFetch might stringify body
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
        onUpload(data.data.url);
        toast.success("Imagem enviada!");
      } else {
        toast.error(data.message || "Erro ao enviar imagem");
      }
    } catch (error) {
      toast.error("Erro na conexão com o servidor");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-4 w-full">
      <div className="flex items-center gap-4">
        {value ? (
          <div className="relative w-24 h-24 rounded-lg overflow-hidden border">
            <img src={value} alt="Preview" className="w-full h-full object-cover" />
            <button 
              onClick={() => onUpload("")}
              className="absolute top-1 right-1 p-1 bg-destructive text-white rounded-full hover:scale-110 transition-transform"
            >
              <X className="w-3 h-3" />
            </button>
          </div>
        ) : (
          <div className="w-24 h-24 rounded-lg bg-zinc-50 border border-dashed border-zinc-200 flex flex-col items-center justify-center text-zinc-400">
            <ImageIcon className="w-8 h-8 mb-1" />
            <span className="text-[10px]">Sem imagem</span>
          </div>
        )}
        
        <div className="flex-1">
          <Label className="block mb-2 text-xs font-medium text-zinc-500 uppercase tracking-wider">Foto do Produto</Label>
          <div className="relative">
            <input 
              type="file" 
              className="hidden" 
              id="image-upload" 
              accept="image/*"
              onChange={handleFileChange}
            />
            <Button 
              type="button" 
              variant="outline" 
              className="w-full gap-2 border-primary/20 text-primary hover:bg-primary/5"
              disabled={loading}
              onClick={() => document.getElementById('image-upload')?.click()}
            >
              <Upload className="w-4 h-4" />
              {loading ? "Enviando..." : "Escolher Imagem"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}

import { Label } from "@/components/ui/label";
