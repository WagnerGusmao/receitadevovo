"use client";

import Image from "next/image";
import Link from "next/link";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { 
  Sparkles, 
  Leaf, 
  Heart, 
  BookOpen, 
  Wind,
  Flower2,
  Sparkle,
  ArrowRight,
  Eye,
  Compass,
  GraduationCap,
  ShieldCheck,
  FlameKindling
} from "lucide-react";

// Variantes de animação para os elementos da página
const fadeInUp = {
  hidden: { opacity: 0, y: 30 },
  visible: { 
    opacity: 1, 
    y: 0,
    transition: { duration: 0.8, ease: "easeOut" as const }
  }
};

const fadeIn = {
  hidden: { opacity: 0 },
  visible: { 
    opacity: 1,
    transition: { duration: 1, ease: "easeOut" as const }
  }
};

const staggerContainer = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.15
    }
  }
};

export default function NossaHistoriaPage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-bege-light via-creme/30 to-bege-light text-terra selection:bg-sage/20">
      
      {/* 1. Hero Section */}
      <section className="relative overflow-hidden pt-20 pb-16 md:pt-32 md:pb-24 border-b border-bege/40">
        <div className="absolute inset-0 opacity-30 pointer-events-none">
          <div className="absolute top-10 left-10 w-72 h-72 rounded-full bg-sage/10 blur-3xl" />
          <div className="absolute bottom-10 right-10 w-96 h-96 rounded-full bg-dourado/10 blur-3xl" />
        </div>
        
        <div className="container mx-auto px-6 relative z-10 text-center max-w-4xl">
          <motion.div
            initial="hidden"
            animate="visible"
            variants={fadeInUp}
            className="space-y-6"
          >
            <Badge variant="sage" size="lg" className="px-4 py-1.5 text-xs font-semibold uppercase tracking-wider">
              Legado & Alma
            </Badge>
            <h1 className="text-4xl md:text-6xl font-heading font-semibold text-terra mb-6 leading-tight">
              Nossa História
            </h1>
            <h2 className="text-2xl md:text-3xl font-heading font-normal text-sage max-w-3xl mx-auto leading-relaxed">
              O Despertar da Ancestralidade
            </h2>
            <p className="text-lg md:text-xl text-marrom-suave max-w-2xl mx-auto italic font-sans font-light leading-relaxed">
              &ldquo;A Receita de Vovó Ervas Medicinais não nasceu apenas de um plano de negócios, mas de um reencontro silencioso e sagrado.&rdquo;
            </p>
            <div className="w-16 h-1 bg-sage/40 mx-auto mt-8 rounded-full" />
          </motion.div>
        </div>
      </section>

      {/* 2. O Reencontro e os Cadernos (Dona Maria Áurea) */}
      <section className="py-20 md:py-28 container mx-auto px-6">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center max-w-6xl mx-auto">
          
          {/* Lado do Texto */}
          <motion.div 
            className="lg:col-span-7 space-y-6"
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-100px" }}
            variants={fadeInUp}
          >
            <div className="flex items-center gap-3 text-sage">
              <BookOpen className="w-6 h-6" />
              <span className="font-heading font-semibold tracking-wide uppercase text-sm">O Tesouro Revelado</span>
            </div>
            
            <h3 className="text-3xl md:text-4xl font-heading font-semibold text-terra leading-snug">
              O Despertar nos antigos cadernos
            </h3>
            
            <p className="text-lg text-marrom-suave leading-relaxed">
              Em 2020, durante o isolamento imposto pela pandemia, o tempo parecia ter parado. Foi nesse recolhimento que a fundadora, <strong>Yohana Gusmão</strong>, encontrou um tesouro que aguardava o momento certo para ser revelado: os cadernos antigos de sua avó, <strong>Maria Áurea</strong>.
            </p>
            
            <p className="text-lg text-marrom-suave leading-relaxed font-light">
              Naquelas páginas amareladas pelo tempo, residia uma sabedoria ancestral — receitas minuciosas de cremes, loções, elixires, benzimentos e rezas.
            </p>

            <div className="p-6 md:p-8 bg-creme rounded-2xl border-l-4 border-sage shadow-sm text-terra/90 italic font-sans text-lg relative overflow-hidden">
              <span className="absolute -top-4 -left-2 text-8xl text-sage/10 font-serif select-none pointer-events-none">“</span>
              Ali, Yohana sentiu o chamado. Não era apenas sobre cosméticos ou remédios; era sobre raízes que se estendiam até o coração da floresta e o centro das terras indígenas.
            </div>

            <p className="text-lg text-marrom-suave leading-relaxed">
              Era o conhecimento que flui da terra e que, embora muitas vezes explorado comercialmente por grandes indústrias, pertence, em essência, àqueles que respeitam o ciclo da vida.
            </p>
          </motion.div>

          {/* Lado da Imagem (Dona Maria Áurea) */}
          <motion.div 
            className="lg:col-span-5 flex justify-center"
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-100px" }}
            variants={fadeIn}
          >
            <div className="relative group">
              <div className="absolute -inset-3 rounded-[2.5rem] bg-gradient-to-tr from-sage/20 to-dourado/20 opacity-70 blur-lg group-hover:opacity-100 transition duration-500" />
              <div className="absolute -bottom-4 -right-4 w-24 h-24 bg-dourado/20 rounded-full blur-xl" />
              
              <div className="relative bg-creme p-4 rounded-[2rem] shadow-xl border border-bege transform hover:-rotate-1 transition duration-300">
                <div className="relative overflow-hidden rounded-[1.5rem] w-full max-w-[340px] aspect-[9/16]">
                  <Image
                    src="/images/maria-aurea.jpg"
                    alt="Dona Maria Áurea, avó de Yohana"
                    fill
                    sizes="(max-width: 768px) 100vw, 340px"
                    className="object-cover transition-transform duration-700 hover:scale-105"
                    priority
                    unoptimized
                  />
                </div>
                <div className="mt-4 text-center">
                  <p className="font-heading font-semibold text-terra">Dona Maria Áurea</p>
                  <p className="text-xs text-marrom-suave/80 font-sans">A inspiração e a sabedoria ancestral</p>
                </div>
              </div>
            </div>
          </motion.div>

        </div>
      </section>

      {/* 3. De Educadora à Guardiã (Yohana Gusmão) */}
      <section className="py-20 md:py-28 bg-gradient-to-r from-sage/10 via-creme/50 to-dourado/10 border-y border-bege/40">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center max-w-6xl mx-auto">
            
            {/* Lado da Imagem (Yohana) - Primeiro no Mobile e no Desktop no Grid */}
            <motion.div 
              className="lg:col-span-5 flex justify-center order-last lg:order-first"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, margin: "-100px" }}
              variants={fadeIn}
            >
              <div className="relative group">
                <div className="absolute -inset-3 rounded-[2.5rem] bg-gradient-to-tr from-dourado/20 to-terracota/20 opacity-70 blur-lg group-hover:opacity-100 transition duration-500" />
                <div className="absolute -top-4 -left-4 w-24 h-24 bg-sage/20 rounded-full blur-xl" />
                
                <div className="relative bg-creme p-4 rounded-[2rem] shadow-xl border border-bege transform hover:rotate-1 transition duration-300">
                  <div className="relative overflow-hidden rounded-[1.5rem] w-full max-w-[340px] aspect-[4/3] md:aspect-[3/4]">
                    <Image
                      src="/images/yohana.jpg"
                      alt="Yohana Gusmão"
                      fill
                      sizes="(max-width: 768px) 100vw, 340px"
                      className="object-cover transition-transform duration-700 hover:scale-105"
                      unoptimized
                    />
                  </div>
                  <div className="mt-4 text-center">
                    <p className="font-heading font-semibold text-terra">Yohana Gusmão</p>
                    <p className="text-xs text-marrom-suave/80 font-sans">Idealizadora e Guardiã do Saber Natural</p>
                  </div>
                </div>
              </div>
            </motion.div>

            {/* Lado do Texto */}
            <motion.div 
              className="lg:col-span-7 space-y-6"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, margin: "-100px" }}
              variants={fadeInUp}
            >
              <div className="flex items-center gap-3 text-sage">
                <Flower2 className="w-6 h-6" />
                <span className="font-heading font-semibold tracking-wide uppercase text-sm">Transição & Propósito</span>
              </div>
              
              <h3 className="text-3xl md:text-4xl font-heading font-semibold text-terra leading-snug">
                De Educadora à Guardiã do Saber Natural
              </h3>
              
              <p className="text-lg text-marrom-suave leading-relaxed">
                Após <strong>35 anos dedicados à educação</strong>, transformando crianças em cidadãos, a aposentadoria trouxe para Yohana uma nova e poderosa missão. Ao mergulhar nos estudos da fitoterapia, ela uniu a pedagogia do cuidado ao rigor da ciência das ervas.
              </p>
              
              <p className="text-lg text-marrom-suave leading-relaxed font-light">
                A busca pela cura através da natureza — por meio de banhos, chás, simpatias, emplastros e unguentos — tornou-se o alicerce de sua nova jornada.
              </p>

              <div className="p-5 bg-sage/5 border border-sage/20 rounded-xl">
                <p className="text-base text-terra font-semibold flex items-center gap-2">
                  <Leaf className="w-4 h-4 text-sage" /> O objetivo?
                </p>
                <p className="text-base text-marrom-suave mt-1.5">
                  Levar o toque de carinho, a energia das matas e o vigor da ancestralidade para o cotidiano das pessoas.
                </p>
              </div>
            </motion.div>

          </div>
        </div>
      </section>

      {/* 4. Mais que Produtos, um Legado em Potinhos (Carta Aberta) */}
      <section className="py-20 md:py-28 container mx-auto px-6">
        <div className="max-w-4xl mx-auto space-y-12">
          <motion.div 
            className="text-center space-y-4"
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={fadeInUp}
          >
            <Badge variant="terracota" className="px-3.5 py-1 uppercase text-xs tracking-wider">Filosofia do Cuidado</Badge>
            <h3 className="text-3xl md:text-4xl font-heading font-semibold text-terra">
              Mais que Produtos, um Legado em Potinhos
            </h3>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-center">
            <motion.div 
              className="space-y-6"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              variants={fadeInUp}
            >
              <p className="text-lg text-marrom-suave leading-relaxed">
                Hoje, a <strong>Receita de Vovó</strong> é a materialização dessa história. Cada frasco, como o nosso consagrado <strong>BioAlivio 21</strong>, é mais do que um produto artesanal; é um recipiente que carrega tradição, respeito ao solo e a força daqueles que vieram antes de nós.
              </p>
              
              <p className="text-lg text-marrom-suave leading-relaxed">
                Nossas formulações são preparadas com a paciência que a natureza exige e o amor que só uma "receita de vovó" possui. Proporcionamos uma experiência única de bem-estar, prazer e alívio, conectando você à sabedoria da terra.
              </p>
            </motion.div>

            {/* Carta em Pergaminho / Destaque */}
            <motion.div 
              className="relative bg-creme p-8 rounded-3xl border border-bege shadow-lg font-sans relative overflow-hidden"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              variants={fadeIn}
            >
              <div className="absolute top-0 right-0 w-24 h-24 bg-dourado/10 rounded-full blur-xl" />
              <span className="text-4xl text-sage font-serif block mb-4">“</span>
              <p className="text-lg text-terra/90 leading-relaxed italic font-serif">
                Desejo que, ao abrir um de nossos produtos, você sinta a força dos nossos ancestrais e o cuidado que atravessou gerações para chegar até você. Tudo aqui é feito à mão, com respeito à safra e amor à vida.
              </p>
              <div className="mt-6 flex items-center gap-3">
                <div className="w-10 h-0.5 bg-sage" />
                <span className="font-heading font-semibold text-sm text-terra uppercase tracking-wider">Yohana Gusmão</span>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* 5. Seção Institucional: Missão, Visão e Valores */}
      <section className="py-20 md:py-28 bg-bege/20 border-t border-bege/40">
        <div className="container mx-auto px-6 max-w-6xl space-y-20">
          
          {/* Missão e Visão (Grid 2 colunas) */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12">
            
            {/* Card Missão */}
            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              variants={fadeInUp}
              className="group/mv bg-creme/60 rounded-3xl p-8 lg:p-10 border border-bege/30 hover:border-sage/30 hover:bg-creme transition-all duration-300 shadow-sm relative overflow-hidden flex flex-col md:flex-row gap-6 items-center md:items-start text-center md:text-left"
            >
              <div className="absolute -top-10 -right-10 w-32 h-32 bg-sage/5 rounded-full blur-2xl group-hover/mv:bg-sage/10 transition-colors" />
              <div className="relative w-28 h-28 shrink-0 group-hover/mv:scale-105 transition-transform duration-300 select-none">
                <Image
                  src="/images/missao.png"
                  alt="Missão - Cuidado e Cura Natural"
                  fill
                  sizes="112px"
                  className="object-contain"
                  unoptimized
                />
              </div>
              <div className="space-y-3">
                <h4 className="text-2xl font-heading font-semibold text-terra">Missão</h4>
                <p className="text-base text-marrom-suave leading-relaxed">
                  Resgatar e compartilhar o saber ancestral das ervas medicinais, transformando o conhecimento tradicional em produtos artesanais que proporcionam alívio, bem-estar e uma conexão profunda com a cura que vem da natureza.
                </p>
              </div>
            </motion.div>

            {/* Card Visão */}
            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              variants={fadeInUp}
              className="group/mv bg-creme/60 rounded-3xl p-8 lg:p-10 border border-bege/30 hover:border-dourado/20 hover:bg-creme transition-all duration-300 shadow-sm relative overflow-hidden flex flex-col md:flex-row gap-6 items-center md:items-start text-center md:text-left"
            >
              <div className="absolute -top-10 -right-10 w-32 h-32 bg-dourado/5 rounded-full blur-2xl group-hover/mv:bg-dourado/10 transition-colors" />
              <div className="relative w-28 h-28 shrink-0 group-hover/mv:scale-105 transition-transform duration-300 select-none">
                <Image
                  src="/images/visao.png"
                  alt="Visão - Crescimento e Clareza Natural"
                  fill
                  sizes="112px"
                  className="object-contain"
                  unoptimized
                />
              </div>
              <div className="space-y-3">
                <h4 className="text-2xl font-heading font-semibold text-terra">Visão</h4>
                <p className="text-base text-marrom-suave leading-relaxed">
                  Ser referência nacional em fitoterapia artesanal, reconhecida pela autenticidade de nossas raízes indígenas e familiares, provando que o cuidado humanizado e o respeito à terra são o caminho para uma vida mais equilibrada e saudável.
                </p>
              </div>
            </motion.div>

          </div>

          {/* Valores (Grid 5 colunas) */}
          <div className="space-y-12">
            <motion.div 
              className="text-center flex flex-col items-center gap-4"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              variants={fadeInUp}
            >
              <Badge variant="dourado" className="uppercase text-xs tracking-wider px-3.5 py-1">Nossos Pilares</Badge>
              <h4 className="text-3xl font-heading font-semibold text-terra">Nossos Valores</h4>
              <div className="relative w-32 h-32 mt-2 hover:scale-105 transition-transform duration-300 select-none">
                <Image
                  src="/images/valores.png"
                  alt="Símbolo de Valores - Ancestralidade, Amor e Cuidado"
                  fill
                  sizes="128px"
                  className="object-contain"
                  unoptimized
                />
              </div>
            </motion.div>

            <motion.div 
              className="grid grid-cols-1 md:grid-cols-5 gap-6"
              variants={staggerContainer}
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
            >
              {[
                { 
                  icon: FlameKindling, 
                  title: "Ancestralidade", 
                  desc: "Honrar o legado de Dona Áurea e a sabedoria dos povos da floresta em cada formulação.",
                  color: "bg-sage/10 text-sage group-hover:bg-sage group-hover:text-bege-light"
                },
                { 
                  icon: Leaf, 
                  title: "Respeito à Natureza", 
                  desc: "Extrair o melhor das ervas com consciência, respeitando as safras e os ciclos da terra.",
                  color: "bg-folha/10 text-folha group-hover:bg-folha group-hover:text-bege-light"
                },
                { 
                  icon: Heart, 
                  title: "Afetividade", 
                  desc: "Manter o 'toque de vó' em cada detalhe, tratando cada cliente com o carinho de quem prepara um remédio para a própria família.",
                  color: "bg-terracota/10 text-terracota group-hover:bg-terracota group-hover:text-bege-light"
                },
                { 
                  icon: GraduationCap, 
                  title: "Educação e Consciência", 
                  desc: "Utilizar a experiência de uma vida no ensino para informar e conscientizar sobre o poder terapêutico das plantas.",
                  color: "bg-dourado/10 text-dourado group-hover:bg-dourado group-hover:text-bege-light"
                },
                { 
                  icon: ShieldCheck, 
                  title: "Transparência e Ética", 
                  desc: "Entregar produtos puros, feitos à mão, com ingredientes reais e processos honestos.",
                  color: "bg-info/10 text-info group-hover:bg-info group-hover:text-bege-light"
                }
              ].map((val, idx) => (
                <motion.div
                  key={idx}
                  variants={fadeInUp}
                  className="group bg-creme/40 rounded-2xl p-6 border border-bege/30 hover:bg-creme hover:shadow-md transition-all duration-300 flex flex-col gap-4 text-center hover:-translate-y-1"
                >
                  <div className={`w-12 h-12 rounded-xl mx-auto flex items-center justify-center transition-all duration-300 ${val.color}`}>
                    <val.icon className="w-6 h-6" />
                  </div>
                  <div className="space-y-2">
                    <h5 className="font-heading font-semibold text-terra text-base leading-snug">
                      {val.title}
                    </h5>
                    <p className="text-sm text-marrom-suave leading-relaxed font-light">
                      {val.desc}
                    </p>
                  </div>
                </motion.div>
              ))}
            </motion.div>
          </div>

        </div>
      </section>

      {/* 6. Manifesto & Chamada para Ação */}
      <section className="py-20 md:py-28 container mx-auto px-6 max-w-5xl">
        <motion.div
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          variants={fadeInUp}
          className="relative rounded-3xl bg-terra text-bege-light px-8 py-12 md:p-16 overflow-hidden shadow-2xl"
        >
          {/* Efeitos Decorativos Internos */}
          <div className="absolute top-0 right-0 w-80 h-80 rounded-full bg-sage/10 blur-3xl pointer-events-none" />
          <div className="absolute -bottom-20 -left-20 w-80 h-80 rounded-full bg-dourado/10 blur-3xl pointer-events-none" />
          
          <div className="relative z-10 text-center max-w-3xl mx-auto space-y-8">
            <span className="inline-block p-3 rounded-full bg-bege-light/10 text-dourado">
              <Sparkles className="w-8 h-8" />
            </span>
            
            <h3 className="text-3xl md:text-5xl font-heading font-semibold text-bege-light leading-tight">
              Mais do que cosméticos ou fragrâncias, criamos produtos que carregam história, afeto e propósito.
            </h3>
            
            <p className="text-lg md:text-xl text-bege/80 font-sans font-light leading-relaxed max-w-2xl mx-auto">
              Porque acreditamos que o verdadeiro cuidado começa quando nos permitimos desacelerar, respirar e receber o carinho que a natureza tem para oferecer.
            </p>
            
            <div className="pt-4">
              <Button 
                variant="sage" 
                size="lg" 
                asChild
                className="bg-sage hover:bg-folha text-bege-light font-medium py-6 px-8 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 gap-2 shrink-0 text-base"
              >
                <Link href="/produtos">
                  Explorar Nossos Produtos
                  <ArrowRight className="w-5 h-5" />
                </Link>
              </Button>
            </div>
          </div>
        </motion.div>
      </section>

    </div>
  );
}
