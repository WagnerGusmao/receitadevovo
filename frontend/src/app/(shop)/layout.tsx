import { Navbar } from "@/shared/components/Navbar";
import { Footer } from "@/shared/components/Footer";
import { PageTransition } from "@/shared/components/PageTransition";
import { VovoChat } from "@/modules/ai/components/VovoChat";

export default function ShopLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-1">
        <PageTransition>{children}</PageTransition>
      </main>
      <Footer />
      <VovoChat />
    </div>
  );
}
