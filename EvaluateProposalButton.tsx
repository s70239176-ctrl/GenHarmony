"use client";

import { useState } from "react";
import { Gavel, CheckCircle2, XCircle } from "lucide-react";
import { Button } from "./ui/Button";
import { VuMeter } from "./VuMeter";
import { useHarmonyForge } from "@/lib/genlayer";

interface Verdict {
  status: "approved" | "rejected";
  composite_score: number;
}

export function EvaluateProposalButton({
  proposalId,
  onResolved,
}: {
  proposalId: string;
  onResolved?: () => void;
}) {
  const { evaluateProposal } = useHarmonyForge();
  const [judging, setJudging] = useState(false);
  const [verdict, setVerdict] = useState<Verdict | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleEvaluate() {
    setJudging(true);
    setError(null);
    try {
      const raw = await evaluateProposal(proposalId);
      setVerdict(JSON.parse(raw) as Verdict);
      onResolved?.();
    } catch (err) {
      setError(err instanceof Error ? err.message : "The jury couldn't be reached.");
    } finally {
      setJudging(false);
    }
  }

  if (judging) {
    return (
      <div className="flex items-center gap-3 rounded-sm border border-line bg-rail/60 px-4 py-2.5">
        <VuMeter label="Jury deliberating" />
      </div>
    );
  }

  if (verdict) {
    const approved = verdict.status === "approved";
    return (
      <div
        className={`flex items-center gap-2 rounded-sm border px-4 py-2.5 ${
          approved ? "border-current/40 text-current" : "border-pulse/40 text-pulse"
        }`}
      >
        {approved ? <CheckCircle2 className="h-4 w-4" /> : <XCircle className="h-4 w-4" />}
        <span className="font-mono text-[12px] uppercase tracking-[0.1em]">
          {approved ? "Merged into canon" : "Not merged"} · score {verdict.composite_score}
        </span>
      </div>
    );
  }

  return (
    <div>
      <Button variant="secondary" onClick={handleEvaluate} className="gap-2">
        <Gavel className="h-3.5 w-3.5" />
        Convene the jury
      </Button>
      {error && <p className="mt-2 font-mono text-[12px] text-pulse">{error}</p>}
    </div>
  );
}
