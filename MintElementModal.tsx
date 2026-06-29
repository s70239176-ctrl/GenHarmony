"use client";

import { useState } from "react";
import { parseEther } from "viem";
import { Stamp } from "lucide-react";
import { Modal } from "./ui/Modal";
import { Button } from "./ui/Button";
import { Input } from "./ui/Field";
import { useHarmonyForge } from "@/lib/genlayer";

const KINDS = ["full_version", "stem:lead", "stem:bass", "prompt"];

export function MintElementModal({
  trackId,
  open,
  onClose,
}: {
  trackId: string;
  open: boolean;
  onClose: () => void;
}) {
  const { mintElement } = useHarmonyForge();
  const [kind, setKind] = useState(KINDS[0]);
  const [amount, setAmount] = useState("0.05");
  const [minting, setMinting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [mintedId, setMintedId] = useState<string | null>(null);

  async function handleMint() {
    setError(null);
    setMinting(true);
    try {
      const elementId = await mintElement(trackId, kind, parseEther(amount || "0"));
      setMintedId(elementId);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Mint failed — the press jammed.");
    } finally {
      setMinting(false);
    }
  }

  return (
    <Modal open={open} onClose={onClose} eyebrow={`Track #${trackId}`} title="Mint an element">
      {mintedId ? (
        <div className="space-y-3 text-center">
          <p className="font-display text-base text-current">Pressed.</p>
          <p className="led text-sm text-muted">Element #{mintedId}</p>
          <Button variant="secondary" onClick={onClose} className="w-full">
            Done
          </Button>
        </div>
      ) : (
        <div className="space-y-4">
          <div>
            <p className="mb-1.5 font-mono text-[11px] uppercase tracking-[0.18em] text-muted">Element</p>
            <div className="flex flex-wrap gap-2">
              {KINDS.map((k) => (
                <button
                  key={k}
                  onClick={() => setKind(k)}
                  className={`rounded-full border px-3 py-1 font-mono text-[11px] uppercase tracking-[0.1em] transition-colors ${
                    kind === k ? "border-vinyl text-vinyl shadow-glow-vinyl" : "border-line text-muted hover:text-ink"
                  }`}
                >
                  {k}
                </button>
              ))}
            </div>
          </div>

          <Input
            label="GEN to treasury"
            type="number"
            min="0"
            step="0.01"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />

          {error && <p className="font-mono text-[12px] text-pulse">{error}</p>}

          <Button variant="vinyl" loading={minting} onClick={handleMint} className="w-full gap-2">
            <Stamp className="h-3.5 w-3.5" />
            Mint element
          </Button>
        </div>
      )}
    </Modal>
  );
}
