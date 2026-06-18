"use client";

import { useEffect, useState } from "react";
import { contentService } from "@/modules/content/services/content";
import Link from "next/link";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Calendar, User } from "lucide-react";

export default function BlogPage() {
  const [posts, setPosts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadPosts() {
      try {
        const data = await contentService.getPosts();
        setPosts(data.data);
      } catch (error) {
        console.error("Error loading posts", error);
      } finally {
        setLoading(false);
      }
    }
    loadPosts();
  }, []);

  return (
    <div className="min-h-screen bg-background p-8">
      <div className="container mx-auto max-w-6xl space-y-12">
        {/* Header */}
        <div className="text-center space-y-4 max-w-2xl mx-auto">
          <h2 className="text-primary font-outfit uppercase tracking-widest text-sm font-semibold">Sabedoria Ancestral</h2>
          <h1 className="text-5xl font-bold font-outfit text-foreground">Diário da Vovó</h1>
          <p className="text-lg text-muted-foreground font-inter">
            Artigos sobre autocuidado, rituais naturais e o poder das ervas para nutrir sua jornada.
          </p>
        </div>

        {/* Featured Posts Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {loading ? (
            Array.from({ length: 6 }).map((_, i) => (
              <Card key={i} className="border-beige/50 overflow-hidden">
                <Skeleton className="h-56 w-full" />
                <CardHeader>
                  <Skeleton className="h-6 w-3/4" />
                </CardHeader>
              </Card>
            ))
          ) : posts.length > 0 ? (
            posts.map((post) => (
              <Link key={post.id} href={`/blog/${post.slug}`} className="group">
                <Card className="h-full border-beige/50 hover:shadow-xl transition-all duration-500 overflow-hidden bg-white/50">
                  <div className="h-56 bg-cream/50 relative overflow-hidden">
                    <div className="absolute inset-0 bg-olive/10 group-hover:bg-olive/0 transition-colors duration-500" />
                    <span className="absolute inset-0 flex items-center justify-center text-7xl opacity-20 group-hover:scale-110 transition-transform duration-500">
                      📖
                    </span>
                    <Badge className="absolute top-4 left-4 bg-primary text-white">
                      {post.category.name}
                    </Badge>
                  </div>
                  <CardHeader>
                    <CardTitle className="font-outfit text-2xl group-hover:text-primary transition-colors">
                      {post.title}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-muted-foreground line-clamp-3 text-sm leading-relaxed">
                      {post.content}
                    </p>
                  </CardContent>
                  <CardFooter className="pt-4 border-t border-beige/30 flex justify-between text-[11px] text-muted-foreground uppercase tracking-widest font-bold">
                    <div className="flex items-center gap-1">
                      <User className="w-3 h-3" />
                      <span>{post.user.name}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Calendar className="w-3 h-3" />
                      <span>{new Date(post.published_at).toLocaleDateString('pt-BR')}</span>
                    </div>
                  </CardFooter>
                </Card>
              </Link>
            ))
          ) : (
            <div className="col-span-full py-20 text-center">
              <p className="text-muted-foreground">Em breve, novos conhecimentos serão compartilhados.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// Inline Badge since I can't be sure if it's imported correctly as a component or need to use the one from UI
function Badge({ children, className }: { children: React.ReactNode; className?: string }) {
  return (
    <span className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${className}`}>
      {children}
    </span>
  );
}
