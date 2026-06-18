"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { contentService } from "@/modules/content/services/content";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { ArrowLeft, Calendar, User, Share2 } from "lucide-react";

export default function PostDetailPage() {
  const params = useParams();
  const router = useRouter();
  const [post, setPost] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadPost() {
      try {
        const data = await contentService.getPost(params.slug as string);
        setPost(data.data);
      } catch (error) {
        console.error("Error loading post", error);
        router.push("/blog");
      } finally {
        setLoading(false);
      }
    }
    loadPost();
  }, [params.slug, router]);

  if (loading) {
    return (
      <div className="container mx-auto max-w-3xl py-20 px-6 space-y-8">
        <Skeleton className="h-10 w-1/4" />
        <Skeleton className="h-20 w-full" />
        <Skeleton className="h-[400px] w-full" />
        <div className="space-y-4">
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </div>
      </div>
    );
  }

  if (!post) return null;

  return (
    <article className="min-h-screen bg-background pb-20">
      {/* Article Header */}
      <div className="bg-cream/50 border-b border-beige/30 py-16 px-6">
        <div className="container mx-auto max-w-3xl space-y-6">
          <Button 
            variant="ghost" 
            className="group text-muted-foreground hover:text-primary p-0 h-auto"
            onClick={() => router.back()}
          >
            <ArrowLeft className="w-4 h-4 mr-2 group-hover:-translate-x-1 transition-transform" />
            Voltar
          </Button>

          <div className="space-y-4">
            <span className="text-xs font-bold uppercase tracking-widest text-primary">
              {post.category.name}
            </span>
            <h1 className="text-4xl md:text-5xl font-bold font-outfit text-foreground leading-tight">
              {post.title}
            </h1>
            
            <div className="flex flex-wrap items-center gap-6 pt-4 text-sm text-muted-foreground border-t border-beige/30">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-full bg-olive/20 flex items-center justify-center text-primary font-bold">
                  {post.user.name.charAt(0)}
                </div>
                <span className="font-medium text-foreground">{post.user.name}</span>
              </div>
              <div className="flex items-center gap-2">
                <Calendar className="w-4 h-4" />
                <span>{new Date(post.published_at).toLocaleDateString('pt-BR')}</span>
              </div>
              <Button variant="ghost" size="icon" className="ml-auto">
                <Share2 className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto max-w-3xl py-12 px-6">
        <div className="prose prose-olive max-w-none font-inter text-lg leading-relaxed text-foreground/80">
          {post.content.split('\n').map((paragraph: string, i: number) => (
            <p key={i} className="mb-6">{paragraph}</p>
          ))}
        </div>
        
        {/* Author Bio Teaser */}
        <div className="mt-20 p-8 rounded-2xl bg-white border border-beige/50 flex gap-6 items-center">
          <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center text-3xl shrink-0">
            👵
          </div>
          <div className="space-y-2">
            <h3 className="font-outfit font-bold text-xl">Escrito por {post.user.name}</h3>
            <p className="text-sm text-muted-foreground">
              Especialista em ervas e tradições naturais, dedicada a resgatar o cuidado manual e a sabedoria das gerações passadas.
            </p>
          </div>
        </div>
      </div>
    </article>
  );
}
