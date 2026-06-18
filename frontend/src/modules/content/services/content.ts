import { apiFetch } from "@/services/api";

export const contentService = {
  async getPosts() {
    return apiFetch('/content/posts');
  },

  async getPost(slug: string) {
    return apiFetch(`/content/posts/${slug}`);
  }
};
