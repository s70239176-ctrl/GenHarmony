"use client";

import { defineChain } from "viem";
import { createConfig, http, useConnectorClient } from "wagmi";
import { injected } from "wagmi/connectors";
import { useCallback, useMemo } from "react";
import type { Track, Proposal, MintedElement } from "./types";

// --- Chain -----------------------------------------------------------------
// GenLayer's public Studio network. Swap rpcUrl / id for your target network.
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
  transports: {
    [genLayerStudio.id]: http(),
  },
});

// --- Contract --------------------------------------------------------------
// Replace once HarmonyForge is deployed to your target network.
export const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000000" as const;

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

/**
 * GenVM contracts speak their own JSON-RPC dialect (gen_call / transaction
 * submission) rather than plain eth_call ABI encoding. This hook isolates
 * that translation so every component below can call typed, friendly
 * methods. Point this at `genlayer-js` directly if you want the official
 * client instead of the raw `client.request` escape hatch used here.
 */
export function useHarmonyForge() {
  const { data: client } = useConnectorClient({ config: wagmiConfig });

  const read = useCallback(
    async <T,>(method: ReadMethod, args: unknown[] = []): Promise<T> => {
      if (!client) throw new Error("Connect a wallet first");
      const result = await client.request({
        // @ts-expect-error -- custom GenVM RPC method, not in viem's base EIP-1193 types
        method: "gen_call",
        params: [{ to: CONTRACT_ADDRESS, function: method, args }],
      });
      return result as T;
    },
    [client],
  );

  const write = useCallback(
    async (method: WriteMethod, args: unknown[] = [], valueWei = 0n): Promise<string> => {
      if (!client) throw new Error("Connect a wallet first");
      const txHash = await client.request({
        // @ts-expect-error -- custom GenVM RPC method
        method: "gen_send_transaction",
        params: [{ to: CONTRACT_ADDRESS, function: method, args, value: valueWei.toString() }],
      });
      return txHash as string;
    },
    [client],
  );

  return useMemo(
    () => ({
      submitSeed: (title: string, seedPrompt: string, genre: string) =>
        write("submit_seed", [title, seedPrompt, genre]),
      proposeEvolution: (trackId: string, contributionText: string, contributionType: string) =>
        write("propose_evolution", [trackId, contributionText, contributionType]),
      forkTrack: (parentTrackId: string, newTitle: string) => write("fork_track", [parentTrackId, newTitle]),
      evaluateProposal: (proposalId: string) => write("evaluate_proposal", [proposalId]),
      fundTreasury: (valueWei: bigint) => write("fund_treasury", [], valueWei),
      claimRewards: () => write("claim_rewards", []),
      mintElement: (trackId: string, kind: string, valueWei: bigint) =>
        write("mint_element", [trackId, kind], valueWei),

      getTrack: (trackId: string) => read<string>("get_track", [trackId]).then((s) => JSON.parse(s) as Track),
      getProposal: (proposalId: string) =>
        read<string>("get_proposal", [proposalId]).then((s) => JSON.parse(s) as Proposal),
      listActiveTracks: () => read<string[]>("list_active_tracks", []),
      getPendingRewards: (address: string) => read<string>("get_pending_rewards", [address]),
      getTreasuryBalance: () => read<string>("get_treasury_balance", []),
      getContributionCount: (address: string) => read<string>("get_contribution_count", [address]),
      getMyMintedElements: () => read<string[]>("get_my_minted_elements", []),
      getMintedElement: (elementId: string) =>
        read<string>("get_minted_element", [elementId]).then((s) => JSON.parse(s) as MintedElement),
    }),
    [read, write],
  );
}
