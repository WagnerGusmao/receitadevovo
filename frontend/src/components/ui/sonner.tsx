"use client"

import { Toaster as Sonner } from "sonner"

type ToasterProps = React.ComponentProps<typeof Sonner>

const Toaster = ({ ...props }: ToasterProps) => {
  return (
    <Sonner
      theme="light"
      className="toaster group"
      position="top-right"
      toastOptions={{
        classNames: {
          toast:
            "group toast group-[.toaster]:bg-bege-light group-[.toaster]:text-terra group-[.toaster]:border-bege group-[.toaster]:shadow-lg group-[.toaster]:rounded-lg group-[.toaster]:p-4",
          description: "group-[.toast]:text-marrom-suave",
          actionButton:
            "group-[.toast]:bg-sage group-[.toast]:text-bege-light group-[.toast]:hover:bg-sage/90",
          cancelButton:
            "group-[.toast]:bg-bege group-[.toast]:text-terra group-[.toast]:hover:bg-bege/80",
          success: "group-[.toast]:border-l-4 group-[.toast]:border-l-success group-[.toast]:bg-success/5",
          error: "group-[.toast]:border-l-4 group-[.toast]:border-l-error group-[.toast]:bg-error/5",
          warning: "group-[.toast]:border-l-4 group-[.toast]:border-l-dourado group-[.toast]:bg-dourado/5",
          info: "group-[.toast]:border-l-4 group-[.toast]:border-l-sage group-[.toast]:bg-sage/5",
        },
      }}
      {...props}
    />
  )
}

export { Toaster }
