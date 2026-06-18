"use client";

import { useState, useRef, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { MessageCircle, X, Send, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { aiService } from "../services/ai";
import { Card } from "@/components/ui/card";

export function VovoChat() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<{ role: 'user' | 'vovo', text: string }[]>([
    { role: 'vovo', text: 'Olá, meu querido(a). Como você está se sentindo hoje? Quer um conselho das ervas?' }
  ]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() || isLoading) return;

    const userMessage = input;
    setMessages(prev => [...prev, { role: 'user', text: userMessage }]);
    setInput("");
    setIsLoading(true);

    try {
      const response = await aiService.sendMessage(userMessage);
      setMessages(prev => [...prev, { role: 'vovo', text: response.data.text }]);
    } catch (error) {
      setMessages(prev => [...prev, { role: 'vovo', text: 'Desculpe, a vovó se perdeu um pouco nas palavras. Tente novamente mais tarde.' }]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      {/* Floating Button */}
      <motion.button
        whileHover={{ scale: 1.1 }}
        whileTap={{ scale: 0.9 }}
        onClick={() => setIsOpen(!isOpen)}
        className="fixed bottom-8 right-8 z-50 w-16 h-16 bg-primary text-white rounded-full shadow-2xl flex items-center justify-center border-4 border-white"
      >
        {isOpen ? <X /> : <MessageCircle />}
      </motion.button>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 100, scale: 0.5 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 100, scale: 0.5 }}
            className="fixed bottom-28 right-8 z-50 w-full max-w-[350px] md:max-w-[400px]"
          >
            <Card className="overflow-hidden border-beige/50 shadow-2xl flex flex-col h-[500px] bg-white">
              {/* Header */}
              <div className="bg-primary p-4 text-white flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-2xl">
                  👵
                </div>
                <div>
                  <h3 className="font-outfit font-bold leading-none">Conselho da Vovó</h3>
                  <span className="text-[10px] uppercase tracking-widest opacity-70">IA Contextual</span>
                </div>
              </div>

              {/* Messages Area */}
              <div 
                ref={scrollRef}
                className="flex-1 overflow-y-auto p-4 space-y-4 bg-zinc-50/50"
              >
                {messages.map((m, i) => (
                  <motion.div
                    initial={{ opacity: 0, x: m.role === 'user' ? 20 : -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    key={i}
                    className={`flex ${m.role === 'user' ? 'justify-end' : 'justify-start'}`}
                  >
                    <div className={`max-w-[80%] p-3 rounded-2xl text-sm font-inter shadow-sm ${
                      m.role === 'user' 
                        ? 'bg-primary text-white rounded-tr-none' 
                        : 'bg-white text-zinc-800 rounded-tl-none border border-beige/30'
                    }`}>
                      {m.text}
                    </div>
                  </motion.div>
                ))}
                {isLoading && (
                  <div className="flex justify-start">
                    <div className="bg-white p-3 rounded-2xl border border-beige/30 flex gap-1">
                      <span className="w-1 h-1 bg-zinc-300 rounded-full animate-bounce" />
                      <span className="w-1 h-1 bg-zinc-300 rounded-full animate-bounce delay-75" />
                      <span className="w-1 h-1 bg-zinc-300 rounded-full animate-bounce delay-150" />
                    </div>
                  </div>
                )}
              </div>

              {/* Input Area */}
              <div className="p-4 bg-white border-t border-beige/30">
                <form 
                  onSubmit={(e) => { e.preventDefault(); handleSend(); }}
                  className="flex gap-2"
                >
                  <Input 
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    placeholder="Diga à vovó como você se sente..."
                    className="bg-zinc-50 border-beige/30 focus:ring-primary h-12"
                  />
                  <Button 
                    type="submit" 
                    size="icon" 
                    className="h-12 w-12 bg-primary shrink-0 shadow-md"
                    disabled={isLoading}
                  >
                    <Send className="w-4 h-4" />
                  </Button>
                </form>
                <p className="mt-2 text-[10px] text-center text-zinc-400 leading-normal font-sans">
                  ⚠️ <em>As orientações da Vovó são conselhos naturais complementares e não substituem o aconselhamento médico profissional.</em>
                </p>
                <div className="mt-2 flex items-center justify-center gap-1 opacity-30 text-[9px] uppercase tracking-tighter">
                  <Sparkles className="w-2 h-2" />
                  Sabedoria Artificial & Natural
                </div>
              </div>
            </Card>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
