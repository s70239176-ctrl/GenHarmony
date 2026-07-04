"use client";

import { useEffect, useState } from "react";
import { ArrowLeft, Stamp, ListMusic } from "lucide-react";
import { useHarmonyForge } from "@/lib/genlayer";
import type { Track } from "@/lib/types";
import { Button } from "./ui/Button";
import { ProposeEvolutionForm } from "./ProposeEvolutionForm";
import { EvaluateProposalButton } from "./EvaluateProposalButton";
import { MintElementModal } from "./MintElementModal";

interface SessionProposal {
  id: string;   // real on-chain proposal ID
  type: string;
}

export function TrackDetail({ trackId, onBack }: { trackId: string; onBack: () => void }) {
  const { getTrack } = useHarmonyForge();
  const [track, setTrack] = useState<Track | null>(null);
  const [mintOpen, setMintOpen] = useState(false);
  // Real proposal IDs returned by propose_evolution on-chain
  const [sessionProposals, setSessionProposals] = useState<SessionProposal[]>([]);

  async function refresh() {
    setTrack(await getTrack(trackId));
  }

  useEffect(() => {
    refresh();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trackId]);

  // Called by ProposeEvolutionForm with the real proposal ID from the contract
  function onProposed(proposalId: string, type: string) {
    setSessionProposals((p) => [...p, { id: proposalId, type }]);
  }

  if (!track) {
    return <p className="font-body text-sm text-muted">Cueing up track #{trackId}…</p>;
  }

  return (
    <div className="space-y-8">
      <button
        onClick={onBack}
        className="flex items-center gap-2 font-mono text-[12px] uppercase tracking-[0.12em] text-muted transition-colors hover:text-ink"
      >
        <ArrowLeft className="h-3.5 w-3.5" />
        Back to the deck
      </button>

      <div className="grid gap-8 lg:grid-cols-[1.2fr_1fr]">
        {/* Main panel */}
        <div className="relative overflow-hidden rounded-md border border-line bg-panel p-8">
          <div className="absolute inset-0 bg-grain opacity-30" />
          <div className="relative">
            <p className="led text-[11px] uppercase tracking-[0.16em] text-pulse">
              {track.genre} · v{track.version} · #{track.id}
            </p>
            <h1 className="mt-2 font-display text-3xl font-bold leading-tight text-ink">{track.title}</h1>
            <p className="mt-2 font-mono text-[11px] text-muted">by {track.creator}</p>
            <p className="mt-6 whitespace-pre-wrap font-body text-[15px] leading-relaxed text-ink/90">
              {track.current_content}
            </p>
            <Button variant="vinyl" onClick={() => setMintOpen(true)} className="mt-8 gap-2">
              <Stamp className="h-3.5 w-3.5" />
              Mint this version
            </Button>
          </div>
        </div>

        {/* Propose + evaluate */}
        <div className="space-y-6">
          <ProposeEvolutionForm trackId={track.id} onProposed={onProposed} />

          <div className="rounded-md border border-line bg-panel/70 p-5">
            <div className="mb-4 flex items-center gap-2.5">
              <ListMusic className="h-4 w-4 text-vinyl" />
              <h4 className="font-display text-sm font-semibold uppercase tracking-[0.1em] text-ink">
                This session&apos;s proposals
              </h4>
            </div>
            {sessionProposals.length === 0 ? (
              <p className="font-body text-sm text-muted">
                Nothing queued yet. Propose an evolution above — its on-chain ID will appear here.
              </p>
            ) : (
              <ul className="space-y-3">
                {sessionProposals.map((p) => (
                  <li
                    key={p.id}
                    className="flex items-center justify-between rounded-sm border border-line/60 px-3 py-2.5"
                  >
                    <div>
                      <span className="font-mono text-[12px] uppercase tracking-[0.08em] text-muted">{p.type}</span>
                      <span className="ml-2 led text-[10px] text-muted/60">#{p.id}</span>
                    </div>
                    <EvaluateProposalButton proposalId={p.id} onResolved={refresh} />
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      </div>

      {/* Evolution history */}
      <div>
        <h3 className="mb-4 font-display text-sm font-semibold uppercase tracking-[0.1em] text-muted">
          Evolution history
        </h3>
        <ol className="relative space-y-0 border-l border-line pl-6">
          {Array.from({ length: track.version + 1 }, (_, i) => track.version - i).map((v) => (
            <li key={v} className="relative py-3">
              <span
                className={`absolute -left-[27px] top-4 h-3 w-3 rounded-full border-2 ${
                  v === track.version ? "border-pulse bg-pulse shadow-glow-pulse" : "border-line bg-rail"
                }`}
              />
              <p className="led text-[12px] text-ink">version {v}</p>
              <p className="font-mono text-[11px] text-muted">
                {v === track.version ? "current canon" : "superseded by a later evolution"}
              </p>
            </li>
          ))}
        </ol>
      </div>

      <MintElementModal trackId={track.id} open={mintOpen} onClose={() => setMintOpen(false)} />
    </div>
  );
}

