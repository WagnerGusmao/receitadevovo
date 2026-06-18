"use client"

import * as React from "react"
import { Label as LabelPrimitive } from "radix-ui"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const labelVariants = cva(
  "text-sm font-medium leading-none select-none transition-colors peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "text-terra",
        muted: "text-marrom-suave",
        error: "text-error",
        success: "text-success",
      },
      size: {
        sm: "text-xs",
        default: "text-sm",
        lg: "text-base",
      },
      required: {
        true: "after:content-['*'] after:ml-0.5 after:text-error",
        false: "",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
      required: false,
    },
  }
)

export interface LabelProps
  extends React.ComponentProps<typeof LabelPrimitive.Root>,
    VariantProps<typeof labelVariants> {}

function Label({
  className,
  variant,
  size,
  required,
  ...props
}: LabelProps) {
  return (
    <LabelPrimitive.Root
      data-slot="label"
      className={cn(labelVariants({ variant, size, required }), className)}
      {...props}
    />
  )
}

export { Label }
