import { ReactNode } from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';

interface HeroProps {
  title: string;
  subtitle?: string;
  description?: string;
  primaryAction?: {
    label: string;
    href?: string;
    onClick?: () => void;
  };
  secondaryAction?: {
    label: string;
    href?: string;
    onClick?: () => void;
  };
  image?: string;
  variant?: 'default' | 'centered' | 'split';
  size?: 'default' | 'large';
  children?: ReactNode;
  className?: string;
}

export function Hero({
  title,
  subtitle,
  description,
  primaryAction,
  secondaryAction,
  image,
  variant = 'default',
  size = 'default',
  children,
  className,
}: HeroProps) {
  const isLarge = size === 'large';
  const isCentered = variant === 'centered';
  const isSplit = variant === 'split';

  return (
    <section
      className={cn(
        'relative w-full overflow-hidden bg-gradient-to-b from-bege-light via-creme to-background',
        isLarge ? 'min-h-[600px] md:min-h-[700px]' : 'min-h-[400px] md:min-h-[500px]',
        className
      )}
    >
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 right-0 w-96 h-96 bg-sage/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 left-0 w-96 h-96 bg-dourado/5 rounded-full blur-3xl" />
      </div>

      <div
        className={cn(
          'container mx-auto px-4 md:px-6 relative z-10',
          isLarge ? 'py-20 md:py-32' : 'py-16 md:py-24',
          isSplit ? 'grid md:grid-cols-2 gap-12 items-center' : ''
        )}
      >
        <div
          className={cn(
            'flex flex-col',
            isCentered ? 'items-center text-center max-w-3xl mx-auto' : 'max-w-2xl',
            isSplit ? 'order-1' : ''
          )}
        >
          {subtitle && (
            <div className="inline-flex items-center gap-2 mb-4">
              <div className="w-8 h-px bg-gradient-to-r from-sage to-dourado" />
              <span className="text-sm font-medium text-sage uppercase tracking-wider">
                {subtitle}
              </span>
            </div>
          )}

          <h1
            className={cn(
              'font-heading font-semibold text-terra leading-tight tracking-tight',
              isLarge
                ? 'text-4xl md:text-5xl lg:text-6xl'
                : 'text-3xl md:text-4xl lg:text-5xl',
              'mb-6'
            )}
          >
            {title}
          </h1>

          {description && (
            <p
              className={cn(
                'text-marrom-suave leading-relaxed',
                isLarge ? 'text-lg md:text-xl' : 'text-base md:text-lg',
                'mb-8'
              )}
            >
              {description}
            </p>
          )}

          {(primaryAction || secondaryAction) && (
            <div
              className={cn(
                'flex flex-wrap gap-4',
                isCentered ? 'justify-center' : ''
              )}
            >
              {primaryAction && (
                <Button
                  variant="sage"
                  size={isLarge ? 'lg' : 'default'}
                  asChild={!!primaryAction.href}
                  onClick={primaryAction.onClick}
                >
                  {primaryAction.href ? (
                    <a href={primaryAction.href}>{primaryAction.label}</a>
                  ) : (
                    primaryAction.label
                  )}
                </Button>
              )}

              {secondaryAction && (
                <Button
                  variant="outline"
                  size={isLarge ? 'lg' : 'default'}
                  asChild={!!secondaryAction.href}
                  onClick={secondaryAction.onClick}
                >
                  {secondaryAction.href ? (
                    <a href={secondaryAction.href}>{secondaryAction.label}</a>
                  ) : (
                    secondaryAction.label
                  )}
                </Button>
              )}
            </div>
          )}

          {children}
        </div>

        {isSplit && image && (
          <div className="order-2 relative">
            <div className="relative aspect-square rounded-2xl overflow-hidden shadow-2xl">
              <img
                src={image}
                alt={title}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-tr from-sage/20 to-transparent" />
            </div>
            <div className="absolute -bottom-6 -right-6 w-32 h-32 bg-dourado/10 rounded-full blur-2xl -z-10" />
          </div>
        )}
      </div>
    </section>
  );
}
