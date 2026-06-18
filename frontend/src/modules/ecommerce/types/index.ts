export interface Product {
  id: number;
  name: string;
  slug: string;
  description: string;
  price: number;
  old_price?: number;
  stock: number;
  featured_image?: string;
  images?: string[];
  category?: string;
}

export interface Kit {
  id: number;
  name: string;
  slug: string;
  description: string;
  price: number;
  products?: Product[];
}

export interface Address {
  id: number;
  user_id: number;
  label: string;
  recipient_name: string;
  cpf: string;
  phone: string;
  cep: string;
  street: string;
  number: string;
  complement?: string;
  neighborhood: string;
  city: string;
  state: string;
  reference?: string;
  is_default: boolean;
}

export interface Order {
  id: number;
  order_number: string;
  total: number;
  status: 'pending' | 'paid' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  payment_method?: string;
  shipping_address?: string;
  created_at: string;
}
