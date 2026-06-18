import type { Metadata } from "next";
import { Inter, Outfit } from "next/font/google";
import "./globals.css";
import { Navbar } from "@/shared/components/Navbar";
import { Toaster } from "@/components/ui/sonner";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "Receita de Vovó | Wellness & Autocuidado Natural",
    template: "%s | Receita de Vovó"
  },
  description: "Descubra o poder da ancestralidade com nossos rituais de autocuidado, produtos artesanais 100% naturais e sabedoria das ervas.",
  keywords: ["autocuidado", "natural", "ervas medicinais", "artesanal", "wellness", "bem-estar", "receita de vovó"],
  authors: [{ name: "Receita de Vovó" }],
  creator: "Receita de Vovó",
  themeColor: "#5D6D3F", // Primary green color
  icons: {
    icon: "/logos/logo-icon.png",
    shortcut: "/logos/logo-icon.png",
    apple: "/logos/logo-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="pt-BR"
      className={`${inter.variable} ${outfit.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col font-inter">
        {children}
        <Toaster />
      </body>
    </html>
  );
}
