import * as React from "react"

import { cn } from "@/lib/utils"

export interface TextareaProps extends React.ComponentProps<"textarea"> {
  error?: boolean
}

const Textarea = React.forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ className, error, ...props }, ref) => {
    return (
      <textarea
        className={cn(
          "flex min-h-[100px] w-full rounded-lg border bg-background px-4 py-3 text-base text-terra",
          "placeholder:text-marrom-suave/50",
          "transition-all duration-200",
          "focus:outline-none focus:ring-2 focus:ring-offset-0",
          "hover:border-sage/50",
          "disabled:cursor-not-allowed disabled:opacity-50 disabled:bg-bege-light",
          "resize-y",
          error
            ? "border-error focus:border-error focus:ring-error/20"
            : "border-bege focus:border-sage focus:ring-sage/20",
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Textarea.displayName = "Textarea"

export { Textarea }
