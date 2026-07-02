"use client";

import { type ButtonHTMLAttributes, forwardRef } from "react";
import { Loader2 } from "lucide-react";

type Variant = "primary" | "secondary" | "ghost" | "vinyl";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
}

const variants: Record<Variant, string> = {
  primary:
    "bg-pulse text-void shadow-glow-pulse hover:brightness-110 active:scale-[0.98] border border-pulse/60",
  secondary:
    "bg-transparent text-current border border-current/50 shadow-glow-current hover:bg-current/10 active:scale-[0.98]",
  ghost: "bg-transparent text-ink/80 border border-line hover:border-ink/30 hover:text-ink",
  vinyl: "bg-vinyl text-void shadow-glow-vinyl hover:brightness-110 active:scale-[0.98] border border-vinyl/60",
};

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = "primary", loading, className = "", children, disabled, ...rest }, ref) => {
    return (
      <button
        ref={ref}
        disabled={disabled || loading}
        className={`relative inline-flex items-center justify-center gap-2 rounded-sm px-5 py-2.5
          font-display text-[13px] font-medium uppercase tracking-[0.08em]
          transition-all duration-150 disabled:cursor-not-allowed disabled:opacity-40
          ${variants[variant]} ${className}`}
        {...rest}
      >
        {loading && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
        {children}
      </button>
    );
  },
);
Button.displayName = "Button";

