import Image from 'next/image';
import { cn } from '@/lib/utils';

interface LogoProps {
  variant?: 'icon' | 'badge' | 'vertical' | 'horizontal' | 'stamp';
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl';
  className?: string;
  priority?: boolean;
}

const LOGO_VARIANTS = {
  icon: '/logos/logo-icon.png',
  badge: '/logos/logo-badge.png',
  vertical: '/logos/logo-vertical.png',
  horizontal: '/logos/logo-horizontal.png',
  stamp: '/logos/logo-stamp-3d.png',
} as const;

const SIZE_CLASSES = {
  icon: {
    xs: 'w-6 h-6',
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-14 h-14',
    xl: 'w-18 h-18',
    '2xl': 'w-24 h-24',
  },
  horizontal: {
    xs: 'h-6',
    sm: 'h-8',
    md: 'h-12',
    lg: 'h-16',
    xl: 'h-20',
    '2xl': 'h-24',
  },
  vertical: {
    xs: 'h-8',
    sm: 'h-12',
    md: 'h-18',
    lg: 'h-24',
    xl: 'h-30',
    '2xl': 'h-36',
  },
  badge: {
    xs: 'w-12 h-12',
    sm: 'w-16 h-16',
    md: 'w-20 h-20',
    lg: 'w-26 h-26',
    xl: 'w-32 h-32',
    '2xl': 'w-40 h-40',
  },
  stamp: {
    xs: 'w-12 h-12',
    sm: 'w-16 h-16',
    md: 'w-20 h-20',
    lg: 'w-26 h-26',
    xl: 'w-32 h-32',
    '2xl': 'w-40 h-40',
  },
} as const;

export function Logo({
  variant = 'horizontal',
  size = 'md',
  className,
  priority = false,
}: LogoProps) {
  const sizeClass = SIZE_CLASSES[variant][size];
  const isSquare = variant === 'icon' || variant === 'badge' || variant === 'stamp';

  return (
    <Image
      src={LOGO_VARIANTS[variant]}
      alt="Receita de Vovó"
      width={isSquare ? 400 : 800}
      height={400}
      className={cn(
        sizeClass, 
        'w-auto object-contain',
        'select-none',
        className
      )}
      priority={priority}
      unoptimized
    />
  );
}
