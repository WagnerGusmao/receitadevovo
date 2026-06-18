import { toast as sonnerToast } from "sonner"
import { CheckCircle2, XCircle, AlertCircle, Info } from "lucide-react"

export const toast = {
  success: (message: string, description?: string) => {
    return sonnerToast.success(message, {
      description,
      icon: CheckCircle2({ className: "w-5 h-5 text-success" }),
    })
  },

  error: (message: string, description?: string) => {
    return sonnerToast.error(message, {
      description,
      icon: XCircle({ className: "w-5 h-5 text-error" }),
    })
  },

  warning: (message: string, description?: string) => {
    return sonnerToast.warning(message, {
      description,
      icon: AlertCircle({ className: "w-5 h-5 text-dourado" }),
    })
  },

  info: (message: string, description?: string) => {
    return sonnerToast.info(message, {
      description,
      icon: Info({ className: "w-5 h-5 text-sage" }),
    })
  },

  promise: <T,>(
    promise: Promise<T>,
    messages: {
      loading: string
      success: string | ((data: T) => string)
      error: string | ((error: any) => string)
    }
  ) => {
    return sonnerToast.promise(promise, messages)
  },

  custom: (message: string, options?: any) => {
    return sonnerToast(message, options)
  },

  dismiss: (toastId?: string | number) => {
    return sonnerToast.dismiss(toastId)
  },
}
