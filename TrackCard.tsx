"use client";

import type { Track } from "@/lib/types";

function ringColor(genre: string) {
  const hash = genre.split("").reduce((a, c) => a + c.charCodeAt(0), 0);
  return ["#FF2E97", "#00E5FF", "#FFB627"][hash % 3];
}

export function TrackCard({ track, onOpen }: { track: Track; onOpen: (id: string) => void }) {
  const accent = ringColor(track.genre || "x");

  return (
    <button
      onClick={() => onOpen(track.id)}
      className="group relative aspect-[4/5] w-full overflow-hidden rounded-md border border-line bg-panel
        p-5 text-left transition-all duration-200 hover:-translate-y-1 hover:border-line/0"
      style={{ boxShadow: "0 0 0 1px rgba(244,238,255,0.06)" }}
      onMouseEnter={(e) => (e.currentTarget.style.boxShadow = `0 0 0 1px ${accent}55, 0 10px 40px ${accent}22`)}
      onMouseLeave={(e) => (e.currentTarget.style.boxShadow = "0 0 0 1px rgba(244,238,255,0.06)")}
    >
      {/* sleeve texture */}
      <div className="absolute inset-0 bg-grain opacity-40" />

      <div className="relative flex h-full flex-col justify-between">
        <div>
          <p className="led text-[10px] uppercase tracking-[0.16em] text-muted">#{track.id} · {track.genre}</p>
          <h3 className="mt-2 font-display text-base font-semibold leading-snug text-ink">{track.title}</h3>
        </div>

        <p className="line-clamp-3 font-body text-[13px] leading-relaxed text-muted">{track.current_content}</p>

        <div className="flex items-center justify-between">
          {/* spinning vinyl label */}
          <div
            className="relative flex h-12 w-12 items-center justify-center rounded-full border border-line
              transition-transform duration-300 group-hover:animate-spin-slow"
            style={{ background: `radial-gradient(circle at 50% 50%, ${accent}33 0%, #0F0825 70%)` }}
          >
            <span className="led text-[10px] text-ink">v{track.version}</span>
            <span className="absolute h-1.5 w-1.5 rounded-full bg-void" />
          </div>
          <span className="font-mono text-[10px] uppercase tracking-[0.14em] text-muted">
            {track.creator.slice(0, 6)}…
          </span>
        </div>
      </div>
    </button>
  );
}
