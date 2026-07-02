"use client";

import { useEffect, useState } from "react";
import { useAccount } from "wagmi";
import { RefreshCw } from "lucide-react";
import { useHarmonyForge } from "@/lib/genlayer";
import type { Track } from "@/lib/types";
import { TrackCard } from "./TrackCard";
import { CreateSeedForm } from "./CreateSeedForm";
import { Button } from "./ui/Button";

export function TrackGrid({ onOpen }: { onOpen: (id: string) => void }) {
  const { isConnected } = useAccount();
  const { listActiveTracks, getTrack } = useHarmonyForge();
  const [tracks, setTracks] = useState<Track[]>([]);
  const [loading, setLoading] = useState(false);

  async function refresh() {
    if (!isConnected) return;
    setLoading(true);
    try {
      const ids = await listActiveTracks();
      const hydrated = await Promise.all(ids.map((id) => getTrack(id)));
      setTracks(hydrated.reverse());
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    refresh();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isConnected]);

  const [featured, ...rest] = tracks;

  if (!isConnected) {
    return (
      <div className="flex h-[60vh] flex-col items-center justify-center gap-3 text-center">
        <p className="font-display text-lg text-ink">The deck is dark.</p>
        <p className="max-w-sm font-body text-sm text-muted">
          Connect a wallet to spin up the studio and see what the collective is evolving right now.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-10">
      <div className="grid gap-8 lg:grid-cols-[1.3fr_1fr]">
        {/* Now Evolving featured panel */}
        <div className="relative overflow-hidden rounded-md border border-line bg-panel p-8">
          <div className="absolute inset-0 bg-grain opacity-30" />
          <p className="relative font-mono text-[11px] uppercase tracking-[0.18em] text-pulse">Now evolving</p>
          {featured ? (
            <button onClick={() => onOpen(featured.id)} className="relative mt-3 block text-left">
              <h2 className="font-display text-3xl font-bold leading-tight text-ink">{featured.title}</h2>
              <p className="mt-1 led text-xs uppercase tracking-[0.12em] text-muted">
                {featured.genre} · v{featured.version} · #{featured.id}
              </p>
              <p className="mt-4 max-w-md font-body text-sm leading-relaxed text-muted">
                {featured.current_content}
              </p>
            </button>
          ) : (
            <p className="relative mt-3 font-body text-sm text-muted">
              {loading ? "Cueing up the catalog…" : "No tracks yet — be the first to press a seed."}
            </p>
          )}
        </div>

        <CreateSeedForm onCreated={() => refresh()} />
      </div>

      <div>
        <div className="mb-4 flex items-center justify-between">
          <h3 className="font-display text-sm font-semibold uppercase tracking-[0.1em] text-muted">
            The crate
          </h3>
          <Button variant="ghost" onClick={refresh} loading={loading} className="!px-3 !py-1.5">
            <RefreshCw className="h-3.5 w-3.5" />
          </Button>
        </div>

        {rest.length === 0 && !loading ? (
          <p className="font-body text-sm text-muted">Nothing else spinning yet.</p>
        ) : (
          <div className="grid grid-cols-2 gap-5 sm:grid-cols-3 lg:grid-cols-4">
            {rest.map((t) => (
              <TrackCard key={t.id} track={t} onOpen={onOpen} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

