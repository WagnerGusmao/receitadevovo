import { apiFetch } from "@/services/api";

export const wellnessService = {
  async getHerbs(params: { benefit?: string; emotion?: string; search?: string; page?: number; per_page?: number } = {}) {
    const query = new URLSearchParams(params as any).toString();
    return apiFetch(`/wellness/herbs?${query}`);
  },

  async getBenefits() {
    return apiFetch('/wellness/benefits');
  },

  async getEmotions() {
    return apiFetch('/wellness/emotions');
  }
};
