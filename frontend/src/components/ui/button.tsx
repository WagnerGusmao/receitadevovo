import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { Slot } from "radix-ui"
import { Loader2 } from "lucide-react"

import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "group/button inline-flex shrink-0 items-center justify-center rounded-lg border border-transparent bg-clip-padding text-sm font-medium whitespace-nowrap transition-all duration-200 outline-none select-none focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 active:not-aria-[haspopup]:translate-y-px disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-3 aria-invalid:ring-destructive/20 dark:aria-invalid:border-destructive/50 dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90 shadow-sm hover:shadow",
        sage: "bg-sage text-bege-light hover:bg-folha shadow-sm hover:shadow",
        dourado: "bg-dourado text-terra hover:bg-warning shadow-sm hover:shadow",
        terra: "bg-terra text-bege-light hover:bg-marrom-dark shadow-sm hover:shadow",
        outline:
          "border-sage bg-transparent text-sage hover:bg-sage/10 dark:border-sage/80",
        outlineDourado:
          "border-dourado bg-transparent text-dourado hover:bg-dourado/10",
        secondary:
          "bg-folha/10 text-sage hover:bg-folha/20",
        ghost:
          "hover:bg-muted hover:text-foreground",
        ghostSage:
          "text-sage hover:bg-sage/10",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90 shadow-sm",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        xs: "h-7 gap-1 rounded-md px-2.5 text-xs [&_svg:not([class*='size-'])]:size-3",
        sm: "h-8 gap-1.5 rounded-lg px-3 text-sm [&_svg:not([class*='size-'])]:size-3.5",
        default: "h-10 gap-2 rounded-lg px-4",
        lg: "h-11 gap-2 rounded-lg px-6 text-base",
        xl: "h-12 gap-2.5 rounded-lg px-8 text-lg",
        icon: "size-10 rounded-lg",
        "icon-sm": "size-8 rounded-lg",
        "icon-lg": "size-12 rounded-lg",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
  loading?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, loading = false, children, ...props }, ref) => {
    if (asChild) {
      return (
        <Slot.Root
          data-slot="button"
          data-variant={variant}
          data-size={size}
          className={cn(buttonVariants({ variant, size, className }))}
          ref={ref}
          {...props}
        >
          {children}
        </Slot.Root>
      )
    }

    return (
      <button
        data-slot="button"
        data-variant={variant}
        data-size={size}
        disabled={loading || props.disabled}
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      >
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {children}
      </button>
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
