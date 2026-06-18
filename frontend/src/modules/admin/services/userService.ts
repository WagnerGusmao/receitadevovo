import { apiFetch } from "@/services/api";

export interface UserFilterParams {
  search?: string;
  role?: 'all' | 'admin' | 'client';
  status?: 'all' | 'active' | 'inactive';
  page?: number;
}

export const userService = {
  async getUsers(params: UserFilterParams = {}) {
    const searchParams = new URLSearchParams();
    if (params.search) searchParams.append('search', params.search);
    if (params.role && params.role !== 'all') searchParams.append('role', params.role);
    if (params.status && params.status !== 'all') searchParams.append('status', params.status);
    if (params.page) searchParams.append('page', params.page.toString());

    const queryString = searchParams.toString();
    const endpoint = `/auth/admin/users${queryString ? `?${queryString}` : ''}`;
    return apiFetch(endpoint);
  },

  async getUser(id: number) {
    return apiFetch(`/auth/admin/users/${id}`);
  },

  async updateUser(id: number, data: {
    name: string;
    email: string;
    whatsapp: string;
    phone?: string;
    cpf?: string;
    is_admin: boolean;
    is_active: boolean;
  }) {
    return apiFetch(`/auth/admin/users/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async resetPassword(id: number, data: any) {
    return apiFetch(`/auth/admin/users/${id}/reset-password`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async deleteUser(id: number) {
    return apiFetch(`/auth/admin/users/${id}`, {
      method: 'DELETE',
    });
  }
};
