import { apiFetch } from "@/services/api";
import { Address } from "../types";

export const addressService = {
  async getAddresses() {
    return apiFetch('/ecommerce/addresses');
  },

  async createAddress(data: Omit<Address, 'id' | 'user_id'>) {
    return apiFetch('/ecommerce/addresses', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async updateAddress(id: number, data: Partial<Address>) {
    return apiFetch(`/ecommerce/addresses/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async deleteAddress(id: number) {
    return apiFetch(`/ecommerce/addresses/${id}`, {
      method: 'DELETE',
    });
  },

  async setDefault(id: number) {
    return apiFetch(`/ecommerce/addresses/${id}/default`, {
      method: 'PATCH',
    });
  }
};
