"use client";

const bars = [0, 0.12, 0.24, 0.08, 0.3, 0.15, 0.05];

export function VuMeter({ label }: { label?: string }) {
  return (
    <span className="inline-flex items-center gap-2">
      <span className="flex h-3.5 items-end gap-[2px]" aria-hidden="true">
        {bars.map((delay, i) => (
          <span
            key={i}
            className="w-[2.5px] origin-bottom rounded-[1px] bg-gradient-to-t from-pulse to-current animate-vu"
            style={{ height: "100%", animationDelay: `${delay}s` }}
          />
        ))}
      </span>
      {label && <span className="font-mono text-[11px] uppercase tracking-[0.16em] text-muted">{label}</span>}
    </span>
  );
}

