import { apiFetch } from "@/services/api";

export const ecommerceService = {
  async getProducts() {
    return apiFetch('/ecommerce/products');
  },

  async getProduct(slug: string) {
    return apiFetch(`/ecommerce/products/${slug}`);
  },

  async createOrder(data: { 
    items: { product_id: number; quantity: number }[];
    shipping_address: string;
    payment_method: string;
  }) {
    return apiFetch('/ecommerce/orders', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async getOrders() {
    return apiFetch('/ecommerce/orders');
  }
};
