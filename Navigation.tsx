"use client";

import { Disc3, Sparkles, Coins, Radio } from "lucide-react";
import { WalletConnect } from "./WalletConnect";

export type View = "deck" | "rewards";

const channels: { id: View; label: string; icon: typeof Disc3 }[] = [
  { id: "deck", label: "Deck", icon: Disc3 },
  { id: "rewards", label: "Rewards", icon: Coins },
];

export function Navigation({ view, onChange }: { view: View; onChange: (v: View) => void }) {
  return (
    <>
      {/* Top bar */}
      <header className="fixed inset-x-0 top-0 z-40 flex h-16 items-center justify-between border-b border-line
        bg-void/80 px-6 pl-[5.5rem] backdrop-blur-md">
        <div className="flex items-center gap-2">
          <Radio className="h-4 w-4 text-pulse" />
          <span className="font-display text-sm font-bold uppercase tracking-[0.14em] text-ink">
            GenHarmony
          </span>
          <span className="ml-2 hidden font-mono text-[10px] uppercase tracking-[0.18em] text-muted sm:inline">
            / collective sessions, evolved on-chain
          </span>
        </div>
        <WalletConnect />
      </header>

      {/* Channel-strip rail */}
      <nav className="fixed inset-y-0 left-0 z-50 flex w-[4.5rem] flex-col items-center gap-1 border-r
        border-line bg-rail py-4 shadow-rail-edge">
        <Sparkles className="mb-4 h-5 w-5 text-pulse" />
        {channels.map((c) => {
          const active = view === c.id;
          const Icon = c.icon;
          return (
            <button
              key={c.id}
              onClick={() => onChange(c.id)}
              className="group relative flex w-full flex-col items-center gap-1.5 py-3 transition-colors"
            >
              <span
                className={`absolute left-0 top-1/2 h-6 w-[2.5px] -translate-y-1/2 rounded-full transition-all
                  ${active ? "bg-pulse shadow-glow-pulse" : "bg-transparent"}`}
              />
              <Icon
                className={`h-[18px] w-[18px] transition-colors ${
                  active ? "text-pulse" : "text-muted group-hover:text-ink"
                }`}
              />
              <span
                className={`font-mono text-[9px] uppercase tracking-[0.1em] transition-colors ${
                  active ? "text-pulse" : "text-muted group-hover:text-ink"
                }`}
              >
                {c.label}
              </span>
            </button>
          );
        })}
      </nav>
    </>
  );
}
