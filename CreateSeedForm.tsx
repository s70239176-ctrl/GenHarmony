"use client";

import { useState } from "react";
import { Disc3 } from "lucide-react";
import { Button } from "./ui/Button";
import { Input, Textarea } from "./ui/Field";
import { useHarmonyForge } from "@/lib/genlayer";

export function CreateSeedForm({ onCreated }: { onCreated?: (trackId: string) => void }) {
  const { submitSeed } = useHarmonyForge();
  const [title, setTitle] = useState("");
  const [genre, setGenre] = useState("");
  const [seedPrompt, setSeedPrompt] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const txHash = await submitSeed(title, seedPrompt, genre);
      onCreated?.(txHash);
      setTitle("");
      setGenre("");
      setSeedPrompt("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not press this seed to the deck.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="rounded-md border border-line bg-panel/70 p-6 shadow-[inset_0_1px_0_rgba(255,255,255,0.03)]"
    >
      <div className="mb-5 flex items-center gap-2.5">
        <Disc3 className="h-4 w-4 animate-spin-slow text-pulse" />
        <h3 className="font-display text-sm font-semibold uppercase tracking-[0.1em] text-ink">
          Press a new seed
        </h3>
      </div>

      <div className="space-y-4">
        <Input label="Title" value={title} onChange={(e) => setTitle(e.target.value)} required placeholder="Midnight Static" />
        <Input label="Genre" value={genre} onChange={(e) => setGenre(e.target.value)} required placeholder="Synthwave" />
        <Textarea
          label="Seed prompt"
          rows={4}
          value={seedPrompt}
          onChange={(e) => setSeedPrompt(e.target.value)}
          required
          placeholder="A slow-motion drive through a neon city at 3am, in love with no one in particular..."
        />
      </div>

      {error && <p className="mt-3 font-mono text-[12px] text-pulse">{error}</p>}

      <Button type="submit" loading={submitting} className="mt-5 w-full">
        Submit seed
      </Button>
    </form>
  );
}
