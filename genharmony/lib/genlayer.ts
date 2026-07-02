"use client";

import { defineChain } from "viem";
import { createConfig, http, useAccount } from "wagmi";
import { injected } from "wagmi/connectors";
import { useCallback, useMemo } from "react";
import type { Track, Proposal, MintedElement } from "./types";

// ---------------------------------------------------------------------------
// Chain & wagmi config
// ---------------------------------------------------------------------------
export const genLayerStudio = defineChain({
  id: 61_999,
  name: "GenLayer Studio",
  nativeCurrency: { name: "GEN", symbol: "GEN", decimals: 18 },
  rpcUrls: {
    default: { http: ["https://studio.genlayer.com/api"] },
  },
  testnet: true,
});

export const wagmiConfig = createConfig({
  chains: [genLayerStudio],
  connectors: [injected()],
  transports: { [genLayerStudio.id]: http() },
});

export const CONTRACT_ADDRESS =
  "0x0000000000000000000000000000000000000000" as const;

const RPC_URL = "https://studio.genlayer.com/api";

// ---------------------------------------------------------------------------
// JSON-RPC fetch helper
// ---------------------------------------------------------------------------
let _id = 1;
async function rpcPost<T>(method: string, params: unknown): Promise<T> {
  const res = await fetch(RPC_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ jsonrpc: "2.0", id: _id++, method, params }),
  });
  if (!res.ok) throw new Error(`HTTP ${res.status} from GenLayer RPC`);
  const json = (await res.json()) as {
    result?: T;
    error?: { message?: string; code?: number };
  };
  if (json.error)
    throw new Error(json.error.message ?? `GenLayer RPC error ${json.error.code}`);
  return json.result as T;
}

// ---------------------------------------------------------------------------
// Resolve the connected address at call time.
// Avoids stale closure issues during wagmi's reconnecting phase:
// useAccount().address may be undefined briefly on page load even when a
// wallet is already connected — querying eth_accounts directly always works.
// ---------------------------------------------------------------------------
async function resolveAddress(staleAddress: string | undefined): Promise<string> {
  if (staleAddress) return staleAddress;

  // Wagmi is still reconnecting — ask the injected provider directly
  const eth = (typeof window !== "undefined" ? (window as { ethereum?: { request: (a: { method: string }) => Promise<string[]> } }).ethereum : undefined);
  if (eth) {
    const accounts = await eth.request({ method: "eth_accounts" });
    if (accounts?.[0]) return accounts[0];
  }
  throw new Error("No wallet connected — please connect first.");
}

// ---------------------------------------------------------------------------
// Method name types
// ---------------------------------------------------------------------------
type WriteMethod =
  | "submit_seed"
  | "propose_evolution"
  | "fork_track"
  | "evaluate_proposal"
  | "fund_treasury"
  | "claim_rewards"
  | "mint_element";

type ReadMethod =
  | "get_track"
  | "get_proposal"
  | "list_active_tracks"
  | "get_pending_rewards"
  | "get_treasury_balance"
  | "get_contribution_count"
  | "get_my_minted_elements"
  | "get_minted_element";

// ---------------------------------------------------------------------------
// Hook
// ---------------------------------------------------------------------------
export function useHarmonyForge() {
  // address may be undefined during wagmi's reconnecting phase — resolveAddress
  // handles that by falling back to eth_accounts at call time.
  const { address } = useAccount();

  const read = useCallback(
    <T,>(method: ReadMethod, args: unknown[] = []): Promise<T> =>
      rpcPost<T>("gen_call", [{ to: CONTRACT_ADDRESS, function: method, args }]),
    [],
  );

  const write = useCallback(
    async (method: WriteMethod, args: unknown[] = [], valueWei = 0n): Promise<string> => {
      const from = await resolveAddress(address);
      return rpcPost<string>("gen_send_transaction", [
        { from, to: CONTRACT_ADDRESS, function: method, args, value: valueWei.toString() },
      ]);
    },
    [address],
  );

  return useMemo(
    () => ({
      submitSeed: (title: string, seedPrompt: string, genre: string) =>
        write("submit_seed", [title, seedPrompt, genre]),
      proposeEvolution: (trackId: string, text: string, type: string) =>
        write("propose_evolution", [trackId, text, type]),
      forkTrack: (parentTrackId: string, newTitle: string) =>
        write("fork_track", [parentTrackId, newTitle]),
      evaluateProposal: (proposalId: string) =>
        write("evaluate_proposal", [proposalId]),
      fundTreasury: (valueWei: bigint) => write("fund_treasury", [], valueWei),
      claimRewards: () => write("claim_rewards", []),
      mintElement: (trackId: string, kind: string, valueWei: bigint) =>
        write("mint_element", [trackId, kind], valueWei),

      getTrack: (trackId: string) =>
        read<string>("get_track", [trackId]).then((s) => JSON.parse(s) as Track),
      getProposal: (proposalId: string) =>
        read<string>("get_proposal", [proposalId]).then((s) => JSON.parse(s) as Proposal),
      listActiveTracks: () => read<string[]>("list_active_tracks", []),
      getPendingRewards: (addr: string) => read<string>("get_pending_rewards", [addr]),
      getTreasuryBalance: () => read<string>("get_treasury_balance", []),
      getContributionCount: (addr: string) => read<string>("get_contribution_count", [addr]),
      getMyMintedElements: () => read<string[]>("get_my_minted_elements", []),
      getMintedElement: (elementId: string) =>
        read<string>("get_minted_element", [elementId]).then((s) => JSON.parse(s) as MintedElement),
    }),
    [read, write],
  );
}

