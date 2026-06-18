import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface CartItem {
  id: number | string;
  name: string;
  price: number;
  quantity: number;
  image?: string;
  type?: 'product' | 'kit' | 'variant';
  is_on_demand?: boolean;
  lead_time_days?: number;
  slug?: string;
}

interface CartStore {
  items: CartItem[];
  addItem: (item: CartItem) => void;
  removeItem: (id: number | string, type?: string) => void;
  updateQuantity: (id: number | string, quantity: number, type?: string) => void;
  clearCart: () => void;
  getTotal: () => number;
}

export const useCartStore = create<CartStore>()(
  persist(
    (set, get) => ({
      items: [],
      addItem: (item) => {
        const currentItems = get().items;
        const type = item.type || 'product';
        
        const existingItem = currentItems.find(
          (i) => i.id === item.id && (i.type || 'product') === type
        );
        
        if (existingItem) {
          set({
            items: currentItems.map((i) =>
              i.id === item.id && (i.type || 'product') === type 
                ? { ...i, quantity: i.quantity + item.quantity } 
                : i
            ),
          });
        } else {
          set({ items: [...currentItems, { ...item, type }] });
        }
      },
      removeItem: (id, type = 'product') => set({ 
        items: get().items.filter((i) => !(i.id === id && (i.type || 'product') === type)) 
      }),
      updateQuantity: (id, quantity, type = 'product') => {
        if (quantity <= 0) {
          get().removeItem(id, type);
          return;
        }
        set({
          items: get().items.map((i) => 
            (i.id === id && (i.type || 'product') === type) ? { ...i, quantity } : i
          ),
        });
      },
      clearCart: () => set({ items: [] }),
      getTotal: () => {
        return get().items.reduce((acc, i) => acc + (i.price * i.quantity), 0);
      }
    }),
    { name: 'vovo-cart-storage' }
  )
);
