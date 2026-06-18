import { apiFetch } from "@/services/api";

export const authService = {
  async login(credentials: any) {
    const response = await apiFetch('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    });
    
    if (response.status === 'success') {
      localStorage.setItem('auth_token', response.data.access_token);
    }
    
    return response;
  },

  async register(data: any) {
    return apiFetch('/auth/register', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async logout() {
    await apiFetch('/auth/logout', { method: 'POST' });
    localStorage.removeItem('auth_token');
  },

  async me() {
    return apiFetch('/auth/me');
  },

  async forgotPassword(email: string) {
    return apiFetch('/auth/forgot-password', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  },

  async resetPassword(payload: any) {
    return apiFetch('/auth/reset-password', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
  },

  async updateProfile(data: any) {
    return apiFetch('/auth/profile', {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }
};
