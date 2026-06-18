import * as React from "react"

import { cn } from "@/lib/utils"

export interface InputProps extends React.ComponentProps<"input"> {
  error?: boolean
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, error, ...props }, ref) => {
    return (
      <input
        type={type}
        data-slot="input"
        className={cn(
          "h-10 w-full min-w-0 rounded-lg border bg-background px-3 py-2 text-sm transition-all outline-none text-terra",
          "placeholder:text-marrom-suave/50",
          "focus-visible:ring-2 focus-visible:ring-offset-0",
          "disabled:pointer-events-none disabled:cursor-not-allowed disabled:bg-bege-light disabled:opacity-50",
          "file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground",
          error
            ? "border-error focus-visible:border-error focus-visible:ring-error/20"
            : "border-bege focus-visible:border-sage focus-visible:ring-sage/20 hover:border-sage/50",
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Input.displayName = "Input"

export { Input }
