import { apiFetch } from "@/services/api";

export const aiService = {
  async sendMessage(message: string) {
    return apiFetch('/ai/chat', {
      method: 'POST',
      body: JSON.stringify({ message }),
    });
  }
};
