import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { Slot } from "radix-ui"

import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center rounded-lg px-2.5 py-0.5 text-xs font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  {
    variants: {
      variant: {
        default:
          "bg-sage text-bege-light shadow-sm hover:bg-folha",
        sage:
          "bg-sage/10 text-sage ring-1 ring-sage/20 hover:bg-sage/20",
        dourado:
          "bg-dourado/10 text-dourado ring-1 ring-dourado/30 hover:bg-dourado/20",
        terra:
          "bg-terra/10 text-terra ring-1 ring-terra/20 hover:bg-terra/20",
        terracota:
          "bg-terracota/10 text-terracota ring-1 ring-terracota/20 hover:bg-terracota/20",
        secondary:
          "bg-folha/10 text-sage ring-1 ring-folha/20 hover:bg-folha/20",
        success:
          "bg-success/10 text-success ring-1 ring-success/20 hover:bg-success/20",
        warning:
          "bg-warning/10 text-warning ring-1 ring-warning/30 hover:bg-warning/20",
        error:
          "bg-error/10 text-error ring-1 ring-error/20 hover:bg-error/20",
        info:
          "bg-info/10 text-info ring-1 ring-info/20 hover:bg-info/20",
        outline:
          "text-foreground border border-border bg-transparent hover:bg-muted",
        ghost:
          "hover:bg-muted text-muted-foreground",
      },
      size: {
        sm: "px-2 py-0.5 text-[10px]",
        default: "px-2.5 py-0.5 text-xs",
        lg: "px-3 py-1 text-sm",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface BadgeProps
  extends React.HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {
  asChild?: boolean
}

const Badge = React.forwardRef<HTMLSpanElement, BadgeProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot.Root : "span"

    return (
      <Comp
        data-slot="badge"
        data-variant={variant}
        className={cn(badgeVariants({ variant, size }), className)}
        ref={ref}
        {...props}
      />
    )
  }
)
Badge.displayName = "Badge"

export { Badge, badgeVariants }
