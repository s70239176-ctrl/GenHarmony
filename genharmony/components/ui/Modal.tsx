"use client";

import { useEffect } from "react";
import { X } from "lucide-react";

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  eyebrow?: string;
  children: React.ReactNode;
}

export function Modal({ open, onClose, title, eyebrow, children }: ModalProps) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center sm:items-center" role="dialog" aria-modal="true">
      <button
        aria-label="Close"
        onClick={onClose}
        className="absolute inset-0 bg-void/80 backdrop-blur-sm"
      />
      <div className="relative w-full max-w-md animate-rise-in rounded-t-lg border border-line bg-panel
        p-6 shadow-glow-pulse sm:rounded-lg">
        <div className="mb-5 flex items-start justify-between">
          <div>
            {eyebrow && (
              <p className="mb-1 font-mono text-[11px] uppercase tracking-[0.18em] text-pulse">{eyebrow}</p>
            )}
            <h2 className="font-display text-lg font-semibold text-ink">{title}</h2>
          </div>
          <button
            onClick={onClose}
            className="rounded-sm border border-line p-1.5 text-muted transition-colors hover:border-ink/30 hover:text-ink"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
        {children}
      </div>
    </div>
  );
}

