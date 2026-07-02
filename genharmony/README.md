# GenHarmony

A decentralized AI music evolution studio, built on top of the HarmonyForge Intelligent Contract on GenLayer. Seed a track, propose an evolution, let the on-chain LLM jury decide whether it joins the canon.

## Stack

- **Next.js 15** (App Router) + **TypeScript**
- **wagmi** + **viem** for wallet connection and chain interaction
- **Tailwind CSS** with a custom synthwave/vinyl theme (no default Tailwind palette)
- **lucide-react** for icons
- **@tanstack/react-query** (peer dependency of wagmi)

## Getting started

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000). You'll need a browser wallet (e.g. MetaMask) connected to whatever network your HarmonyForge contract is deployed on.

Before running against a real deployment, set:

- `CONTRACT_ADDRESS` in `lib/genlayer.ts` → your deployed HarmonyForge address
- `genLayerStudio` chain config in `lib/genlayer.ts` → your target network's `id` and `rpcUrls`

## Project structure

```
app/
  layout.tsx        Root layout — loads the three theme fonts, sets the dark shell
  page.tsx           Route entry — renders <App />
  globals.css        Base styles, grain overlay, LED-readout utility class

components/
  App.tsx                    Top-level composition: providers + view routing
  Navigation.tsx              Channel-strip rail nav + top bar with wallet connect
  WalletConnect.tsx           Connect / connected state, truncated address + balance
  TrackGrid.tsx                Browse view: featured panel + vinyl-sleeve card grid
  TrackCard.tsx                Individual track card (rotating vinyl label on hover)
  TrackDetail.tsx              Full track view, evolution history, propose + evaluate
  CreateSeedForm.tsx           submit_seed
  ProposeEvolutionForm.tsx     propose_evolution
  EvaluateProposalButton.tsx   evaluate_proposal, with the VU-meter loading state
  MintElementModal.tsx         mint_element
  RewardsPanel.tsx             pending rewards, contribution count, claim_rewards
  VuMeter.tsx                  the signature "jury deliberating" animation
  ui/
    Button.tsx, Field.tsx, Modal.tsx   custom primitives (no stock shadcn defaults)

lib/
  genlayer.ts        Chain config, wagmi config, useHarmonyForge() contract hook
  types.ts            Track / Proposal / MintedElement TS types
```

## Design notes

- **Palette**: `void #0A0118` background, `panel #160B2E` surfaces, `pulse #FF2E97` / `current #00E5FF` neon accents, `vinyl #FFB627` for treasury/rewards.
- **Type**: `Unbounded` for display, `Sora` for body, `JetBrains Mono` for LED-style numeric readouts (scores, wei amounts, addresses) — see the `.led` utility class in `globals.css`.
- **Layout**: a fixed left channel-strip rail instead of a top navbar, and an asymmetric "Now Evolving" panel instead of a centered hero.
- **Signature motion**: the VU-meter bar array in `EvaluateProposalButton` is the one deliberate animation moment — tied to the actual async LLM-jury call, not decorative.
- `prefers-reduced-motion` is respected globally (see `globals.css`).

## GenLayer integration

GenVM Intelligent Contracts speak their own JSON-RPC dialect (`gen_call` for reads, transaction submission for writes) rather than a plain Solidity ABI. `lib/genlayer.ts` isolates that translation behind a single hook, `useHarmonyForge()`, so every component calls friendly, typed methods (`submitSeed`, `evaluateProposal`, `claimRewards`, …) without knowing the wire format.

If GenLayer's official `genlayer-js` client is available for your target network, swap the internals of `read` / `write` in `lib/genlayer.ts` for it — no other file needs to change.

## Contract methods this UI exercises

`submit_seed`, `propose_evolution`, `fork_track`, `evaluate_proposal`, `fund_treasury`, `claim_rewards`, `mint_element`, `get_track`, `get_proposal`, `list_active_tracks`, `get_pending_rewards`, `get_treasury_balance`, `get_contribution_count`, `get_my_minted_elements`, `get_minted_element`.

