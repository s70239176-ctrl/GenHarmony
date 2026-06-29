"use client";

import { type InputHTMLAttributes, type TextareaHTMLAttributes, forwardRef } from "react";

function FieldShell({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1.5 block font-mono text-[11px] uppercase tracking-[0.18em] text-muted">{label}</span>
      {children}
    </label>
  );
}

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(({ label, className = "", ...rest }, ref) => (
  <FieldShell label={label}>
    <input
      ref={ref}
      className={`w-full rounded-sm border border-line bg-rail/60 px-3.5 py-2.5 font-body text-sm text-ink
        placeholder:text-muted/60 transition-colors focus:border-current/60 focus:outline-none
        focus:shadow-glow-current ${className}`}
      {...rest}
    />
  </FieldShell>
));
Input.displayName = "Input";

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label: string;
}

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ label, className = "", ...rest }, ref) => (
    <FieldShell label={label}>
      <textarea
        ref={ref}
        className={`w-full resize-none rounded-sm border border-line bg-rail/60 px-3.5 py-2.5 font-body text-sm
          text-ink placeholder:text-muted/60 transition-colors focus:border-current/60 focus:outline-none
          focus:shadow-glow-current ${className}`}
        {...rest}
      />
    </FieldShell>
  ),
);
Textarea.displayName = "Textarea";
