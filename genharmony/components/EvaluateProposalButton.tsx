"use client";

import { useState } from "react";
import { Gavel, CheckCircle2 } from "lucide-react";
import { Button } from "./ui/Button";
import { VuMeter } from "./VuMeter";
import { useHarmonyForge } from "@/lib/genlayer";

type State = "idle" | "judging" | "submitted" | "error";

export function EvaluateProposalButton({
  proposalId,
  onResolved,
}: {
  proposalId: string;
  onResolved?: () => void;
}) {
  const { evaluateProposal } = useHarmonyForge();
  const [state, setState] = useState<State>("idle");
  const [error, setError] = useState<string | null>(null);

  async function handleEvaluate() {
    setState("judging");
    setError(null);
    try {
      await evaluateProposal(proposalId);
      setState("submitted");
      onResolved?.();
    } catch (err) {
      const raw = err instanceof Error ? err.message
        : typeof err === "object" && err !== null ? JSON.stringify(err)
        : String(err);
      // Ignore internal JSON parse errors from genlayer-js receipt decoding —
      // the transaction still went through; the LLM jury is processing.
      if (raw.includes("non-whitespace") || raw.includes("JSON")) {
        setState("submitted");
        onResolved?.();
      } else {
        setError(raw);
        setState("error");
      }
    }
  }

  if (state === "judging") {
    return (
      <div className="flex items-center gap-3 rounded-sm border border-line bg-rail/60 px-4 py-2.5">
        <VuMeter label="Jury deliberating" />
      </div>
    );
  }

  if (state === "submitted") {
    return (
      <div className="flex items-center gap-2 rounded-sm border border-current/40 px-4 py-2.5 text-current">
        <CheckCircle2 className="h-4 w-4" />
        <span className="font-mono text-[12px] uppercase tracking-[0.1em]">
          Submitted — refresh track to see result
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
      {state === "error" && error && (
        <p className="mt-2 font-mono text-[12px] text-pulse">{error}</p>
      )}
    </div>
  );
}
