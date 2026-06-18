import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface LoyaltyLevel {
  id: number;
  name: string;
  min_points: number;
  discount_percentage: number;
  badge_icon: string;
  description?: string;
}

interface User {
  id: number;
  name: string;
  email: string;
  is_admin: boolean;
  whatsapp?: string;
  phone?: string;
  cpf?: string;
  avatar_path?: string;
  loyalty_points_balance?: number;
  loyalty_lifetime_points?: number;
  loyalty_level?: LoyaltyLevel;
}

interface AuthStore {
  user: User | null;
  token: string | null;
  setAuth: (user: User, token: string) => void;
  logout: () => void;
  isAuthenticated: boolean;
}

export const useAuthStore = create<AuthStore>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      setAuth: (user, token) => {
        localStorage.setItem('auth_token', token);
        set({ user, token, isAuthenticated: true });
      },
      logout: () => {
        localStorage.removeItem('auth_token');
        set({ user: null, token: null, isAuthenticated: false });
      },
    }),
    {
      name: 'vovo-auth-storage',
    }
  )
);
