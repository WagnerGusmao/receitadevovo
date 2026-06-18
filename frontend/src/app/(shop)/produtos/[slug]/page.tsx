import { Metadata } from "next";
import ProductDetail from "./ProductDetail";

type Props = {
  params: Promise<{ slug: string }>;
};

async function getProduct(slug: string) {
  const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api';
  const res = await fetch(`${baseUrl}/ecommerce/products/${slug}`, { next: { revalidate: 3600 } });
  if (!res.ok) return null;
  const data = await res.json();
  return data.data;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const product = await getProduct(slug);

  if (!product) {
    return {
      title: "Produto não encontrado",
    };
  }

  return {
    title: product.name,
    description: product.description.substring(0, 160),
    openGraph: {
      title: product.name,
      description: product.description.substring(0, 160),
      type: "website",
      // images: [product.image_url], // Add actual image when available
    },
  };
}

export default async function Page({ params }: Props) {
  const { slug } = await params;
  return <ProductDetail slug={slug} />;
}
