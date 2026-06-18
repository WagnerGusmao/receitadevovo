"use client";

import { useState } from "react";
import { useCartStore } from "../store/cartStore";
import Link from "next/link";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger, SheetFooter } from "@/components/ui/sheet";
import { Button } from "@/components/ui/button";
import { ShoppingCart, Trash2, Plus, Minus } from "lucide-react";
import { Separator } from "@/components/ui/separator";

export function CartDrawer() {
  const { items, removeItem, updateQuantity, getTotal } = useCartStore();
  const [isOpen, setIsOpen] = useState(false);
  const total = getTotal();
  const itemCount = items.reduce((acc, i) => acc + i.quantity, 0);

  return (
    <Sheet open={isOpen} onOpenChange={setIsOpen}>
      <SheetTrigger asChild>
        <button className="relative p-2 rounded-lg hover:bg-sage/10 transition-colors">
          <ShoppingCart className="w-6 h-6 text-terra" />
          {itemCount > 0 && (
            <span className="absolute -top-1 -right-1 bg-sage text-bege-light text-[10px] font-bold w-5 h-5 rounded-full flex items-center justify-center">
              {itemCount}
            </span>
          )}
        </button>
      </SheetTrigger>
      <SheetContent className="w-full sm:max-w-md flex flex-col">
        <SheetHeader className="pb-6 border-b">
          <SheetTitle className="font-outfit text-2xl flex items-center gap-2">
            Seu Ritual <span className="text-primary opacity-30 italic">(Carrinho)</span>
          </SheetTitle>
        </SheetHeader>

        <div className="flex-1 overflow-y-auto py-6 space-y-6">
          {items.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-center space-y-4 opacity-50">
              <ShoppingCart className="w-16 h-16" />
              <p className="font-inter">Seu carrinho está vazio.</p>
            </div>
          ) : (
            items.map((item) => (
              <div key={`${item.type}-${item.id}`} className="flex gap-4 animate-in fade-in slide-in-from-right-4">
                <div className="w-20 h-20 bg-cream rounded-xl flex items-center justify-center text-3xl">
                  {item.type === 'kit' ? "🎁" : "🌿"}
                </div>
                <div className="flex-1 space-y-2">
                  <div className="flex justify-between items-start">
                    <div>
                      <h4 className="font-outfit font-bold text-foreground text-sm leading-tight">{item.name}</h4>
                      {item.is_on_demand && (
                        <span className="text-[10px] text-amber-700 font-bold bg-amber-50 border border-amber-200/50 px-1.5 py-0.5 rounded mt-1 inline-block">
                          Sob Encomenda
                        </span>
                      )}
                    </div>
                    <button onClick={() => removeItem(item.id, item.type)} className="text-muted-foreground hover:text-destructive">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                  <div className="flex justify-between items-center">
                    <div className="flex items-center border border-beige/50 rounded-lg h-8">
                      <button 
                        className="px-2 hover:bg-beige/20 h-full"
                        onClick={() => updateQuantity(item.id, item.quantity - 1, item.type)}
                      >
                        <Minus className="w-3 h-3" />
                      </button>
                      <span className="px-3 text-xs font-bold">{item.quantity}</span>
                      <button 
                        className="px-2 hover:bg-beige/20 h-full"
                        onClick={() => updateQuantity(item.id, item.quantity + 1, item.type)}
                      >
                        <Plus className="w-3 h-3" />
                      </button>
                    </div>
                    <span className="font-outfit font-bold text-primary">
                      R$ {(item.price * item.quantity).toFixed(2)}
                    </span>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        {items.length > 0 && (
          <SheetFooter className="border-t pt-6 space-y-4 flex-col">
            <div className="flex justify-between items-center w-full">
              <span className="font-inter text-muted-foreground">Subtotal</span>
              <span className="font-outfit text-2xl font-bold text-primary">R$ {total.toFixed(2)}</span>
            </div>
            <Separator className="bg-beige/30" />
            <Link href="/checkout" className="w-full" onClick={() => setIsOpen(false)}>
              <Button className="w-full h-14 text-lg font-outfit bg-primary hover:bg-olive transition-all shadow-lg">
                Finalizar Ritual de Compra
              </Button>
            </Link>
            <p className="text-[10px] text-center text-muted-foreground uppercase tracking-widest">
              Pagamento Seguro & Entrega Artesanal
            </p>
          </SheetFooter>
        )}
      </SheetContent>
    </Sheet>
  );
}
