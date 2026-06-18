"use client"

import * as React from "react"
import * as CheckboxPrimitive from "@radix-ui/react-checkbox"
import { Check } from "lucide-react"

import { cn } from "@/lib/utils"

const Checkbox = React.forwardRef<
  React.ElementRef<typeof CheckboxPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root>
>(({ className, ...props }, ref) => (
  <CheckboxPrimitive.Root
    ref={ref}
    className={cn(
      "peer h-5 w-5 shrink-0 rounded border-2 border-bege bg-background",
      "ring-offset-background transition-all duration-200",
      "hover:border-sage/60",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sage/20 focus-visible:ring-offset-2",
      "disabled:cursor-not-allowed disabled:opacity-50 disabled:bg-bege-light",
      "data-[state=checked]:bg-sage data-[state=checked]:border-sage data-[state=checked]:text-bege-light",
      "data-[state=indeterminate]:bg-sage data-[state=indeterminate]:border-sage data-[state=indeterminate]:text-bege-light",
      className
    )}
    {...props}
  >
    <CheckboxPrimitive.Indicator
      className={cn("flex items-center justify-center text-current")}
    >
      <Check className="h-4 w-4 font-bold" />
    </CheckboxPrimitive.Indicator>
  </CheckboxPrimitive.Root>
))
Checkbox.displayName = CheckboxPrimitive.Root.displayName

export { Checkbox }
