#!/usr/bin/env bash
set -e
PROJECT="genharmony"
echo "→ Creating $PROJECT..."
mkdir -p $PROJECT/app $PROJECT/components/ui $PROJECT/lib
cd $PROJECT

cat > package.json << 'HEREDOC_0184661b7dc0'
{
  "name": "genharmony",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "^15.0.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "wagmi": "^2.12.0",
    "viem": "^2.21.0",
    "@tanstack/react-query": "^5.59.0",
    "lucide-react": "^0.452.0",
    "genlayer-js": "latest"
  },
  "devDependencies": {
    "typescript": "^5.6.0",
    "@types/node": "^22.7.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.0",
    "autoprefixer": "^10.4.0"
  }
}

HEREDOC_0184661b7dc0

cat > tsconfig.json << 'HEREDOC_5aa4a6bf5fd9'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}

HEREDOC_5aa4a6bf5fd9

cat > postcss.config.js << 'HEREDOC_7597964e363b'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

HEREDOC_7597964e363b

cat > tailwind.config.ts << 'HEREDOC_cf0f854f9191'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./lib/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        void: "#0A0118",
        panel: "#160B2E",
        rail: "#0F0825",
        ink: "#F4EEFF",
        muted: "#8D82AD",
        pulse: "#FF2E97",
        current: "#00E5FF",
        vinyl: "#FFB627",
        line: "rgba(244,238,255,0.08)",
      },
      fontFamily: {
        display: ["var(--font-display)", "sans-serif"],
        body: ["var(--font-body)", "sans-serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
      boxShadow: {
        "glow-pulse": "0 0 0.5px #FF2E97, 0 0 18px rgba(255,46,151,0.45), 0 0 48px rgba(255,46,151,0.15)",
        "glow-current": "0 0 0.5px #00E5FF, 0 0 18px rgba(0,229,255,0.4), 0 0 48px rgba(0,229,255,0.12)",
        "glow-vinyl": "0 0 0.5px #FFB627, 0 0 16px rgba(255,182,39,0.35)",
        "rail-edge": "1px 0 0 rgba(255,46,151,0.25), 4px 0 24px rgba(255,46,151,0.08)",
      },
      keyframes: {
        vuBounce: {
          "0%, 100%": { transform: "scaleY(0.25)" },
          "50%": { transform: "scaleY(1)" },
        },
        spinSlow: {
          "0%": { transform: "rotate(0deg)" },
          "100%": { transform: "rotate(360deg)" },
        },
        scanline: {
          "0%": { backgroundPosition: "0 0" },
          "100%": { backgroundPosition: "0 64px" },
        },
        flicker: {
          "0%, 96%, 100%": { opacity: "1" },
          "97%": { opacity: "0.86" },
          "98%": { opacity: "1" },
          "99%": { opacity: "0.9" },
        },
        riseIn: {
          "0%": { opacity: "0", transform: "translateY(10px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
      },
      animation: {
        vu: "vuBounce 0.9s ease-in-out infinite",
        "spin-slow": "spinSlow 6s linear infinite",
        scanline: "scanline 1.2s linear infinite",
        flicker: "flicker 6s linear infinite",
        "rise-in": "riseIn 0.5s cubic-bezier(0.16,1,0.3,1) both",
      },
      backgroundImage: {
        grain:
          "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.05'/%3E%3C/svg%3E\")",
      },
    },
  },
  plugins: [],
};

export default config;

HEREDOC_cf0f854f9191

cat > README.md << 'HEREDOC_8cba4741b564'
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

HEREDOC_8cba4741b564

cat > app/globals.css << 'HEREDOC_9c8f78c83581'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  color-scheme: dark;
}

* {
  border-color: theme("colors.line");
}

html,
body {
  background: #0a0118;
  color: #f4eeff;
}

body {
  font-family: var(--font-body), sans-serif;
  background-image:
    radial-gradient(ellipse 80% 50% at 20% -10%, rgba(255, 46, 151, 0.12), transparent),
    radial-gradient(ellipse 60% 50% at 100% 0%, rgba(0, 229, 255, 0.08), transparent);
  background-attachment: fixed;
}

/* Subtle film-grain overlay across the whole app, fixed so it never tiles visibly on scroll */
.grain-overlay {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 60;
  background-image: theme("backgroundImage.grain");
  mix-blend-mode: overlay;
}

::-webkit-scrollbar {
  width: 10px;
}
::-webkit-scrollbar-track {
  background: #0a0118;
}
::-webkit-scrollbar-thumb {
  background: linear-gradient(#ff2e97, #00e5ff);
  border-radius: 6px;
}

:focus-visible {
  outline: 2px solid #00e5ff;
  outline-offset: 2px;
  border-radius: 2px;
}

/* LED tape-counter look for numeric/data readouts (scores, wei, addresses) */
.led {
  font-family: var(--font-mono), monospace;
  letter-spacing: 0.04em;
  font-variant-numeric: tabular-nums;
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.001ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.001ms !important;
  }
}

HEREDOC_9c8f78c83581

cat > app/layout.tsx << 'HEREDOC_e8cdbb7a2807'
import type { Metadata } from "next";
import { Unbounded, Sora, JetBrains_Mono } from "next/font/google";
import "./globals.css";

const display = Unbounded({
  subsets: ["latin"],
  weight: ["500", "700", "800"],
  variable: "--font-display",
});

const body = Sora({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-body",
});

const mono = JetBrains_Mono({
  subsets: ["latin"],
  weight: ["400", "500"],
  variable: "--font-mono",
});

export const metadata: Metadata = {
  title: "GenHarmony — collaborative music, evolved on-chain",
  description:
    "Seed a track, propose an evolution, let the AI jury decide. A decentralized music studio built on GenLayer.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${display.variable} ${body.variable} ${mono.variable}`}>
      <body className="min-h-screen bg-void text-ink antialiased">
        <div className="grain-overlay" />
        {children}
      </body>
    </html>
  );
}

HEREDOC_e8cdbb7a2807

cat > app/page.tsx << 'HEREDOC_0f52210f8f72'
"use client";

import dynamic from "next/dynamic";

const App = dynamic(() => import("@/components/App"), { ssr: false });

export default function Page() {
  return <App />;
}

HEREDOC_0f52210f8f72

cat > lib/types.ts << 'HEREDOC_a6d56eb57799'
export interface Track {
  id: string;
  title: string;
  genre: string;
  creator: string;
  status: "active" | "archived";
  current_content: string;
  version: number;
  parent_track_id?: string | null;
}

export interface ProposalScores {
  approve: boolean;
  quality: number;
  originality: number;
  emotional: number;
  canon_fit: number;
  evolved_content: string;
  rationale: string;
}

export interface Proposal {
  id: string;
  track_id: string;
  proposer: string;
  contribution_text: string;
  contribution_type: string;
  status: "pending" | "approved" | "rejected";
  scores: ProposalScores | null;
  evolved_content: string | null;
  rationale: string | null;
}

export interface MintedElement {
  id: string;
  track_id: string;
  kind: string;
  owner: string;
  version_at_mint: number;
}

HEREDOC_a6d56eb57799

cat > lib/genlayer.ts << 'HEREDOC_14002b8a72bb'
"use client";

import { defineChain } from "viem";
import { createConfig, http, useAccount } from "wagmi";
import { injected } from "wagmi/connectors";
import { useCallback, useMemo } from "react";
import { createClient, createAccount } from "genlayer-js";
import { studionet } from "genlayer-js/chains";
import { TransactionStatus } from "genlayer-js/types";
import type { Track, Proposal, MintedElement } from "./types";

// ---------------------------------------------------------------------------
// wagmi — wallet connection UI only
// ---------------------------------------------------------------------------
export const genLayerStudio = defineChain({
  id: 61_999,
  name: "GenLayer Studio",
  nativeCurrency: { name: "GEN", symbol: "GEN", decimals: 18 },
  rpcUrls: { default: { http: ["https://studio.genlayer.com/api"] } },
  testnet: true,
});

export const wagmiConfig = createConfig({
  chains: [genLayerStudio],
  connectors: [injected()],
  transports: { [genLayerStudio.id]: http() },
});

export const CONTRACT_ADDRESS =
  "0x3F51358206490CcB8eDD2D40Fd8bb42bCd39F363" as const;

// ---------------------------------------------------------------------------
// genlayer-js clients
// ---------------------------------------------------------------------------
function makeReadClient() {
  return createClient({ chain: studionet });
}

function makeWriteClient() {
  const pk = process.env.NEXT_PUBLIC_GENLAYER_PRIVATE_KEY as `0x${string}` | undefined;
  if (!pk) throw new Error("Set NEXT_PUBLIC_GENLAYER_PRIVATE_KEY in .env.local");
  const account = createAccount(pk);
  return { client: createClient({ chain: studionet, account }), account };
}

// ---------------------------------------------------------------------------
// Safe value coercion — readContract may return string OR already-parsed value
// ---------------------------------------------------------------------------
function coerce<T>(v: unknown): T {
  if (typeof v === "string") {
    try { return JSON.parse(v) as T; } catch { return v as unknown as T; }
  }
  return v as unknown as T;
}

// ---------------------------------------------------------------------------
// useHarmonyForge
// ---------------------------------------------------------------------------
export function useHarmonyForge() {
  const { address } = useAccount();

  const read = useCallback(
    async <T,>(functionName: string, args: unknown[] = []): Promise<T> => {
      const client = makeReadClient();
      const result = await client.readContract({
        address: CONTRACT_ADDRESS,
        functionName,
        args,
      });
      return coerce<T>(result);
    },
    [],
  );

  // Returns { txHash, result } where result is the contract method's return value
  const write = useCallback(
    async (
      functionName: string,
      args: unknown[] = [],
      value = BigInt(0),
    ): Promise<{ txHash: string; result: unknown }> => {
      const { client, account } = makeWriteClient();

      const txHash = await client.writeContract({
        account,
        address: CONTRACT_ADDRESS,
        functionName,
        args,
        value,
      });

      const receipt = await client.waitForTransactionReceipt({
        hash: txHash,
        status: TransactionStatus.ACCEPTED,
      });

      // genlayer-js puts the contract's return value in receipt.result
      const result = (receipt as unknown as Record<string, unknown>).result ?? txHash;
      return { txHash: txHash as string, result };
    },
    [address],
  );

  return useMemo(
    () => ({
      // writes — return the contract's own return value (track/proposal id) when available
      submitSeed: (title: string, seedPrompt: string, genre: string) =>
        write("submit_seed", [title, seedPrompt, genre])
          .then(({ result }) => coerce<string>(result)),

      proposeEvolution: (trackId: string, text: string, type: string) =>
        write("propose_evolution", [trackId, text, type])
          .then(({ result }) => coerce<string>(result)),

      forkTrack: (parentTrackId: string, newTitle: string) =>
        write("fork_track", [parentTrackId, newTitle])
          .then(({ result }) => coerce<string>(result)),

      evaluateProposal: (proposalId: string) =>
        write("evaluate_proposal", [proposalId])
          .then(({ txHash }) => txHash),

      fundTreasury: (valueWei: bigint) =>
        write("fund_treasury", [], valueWei).then(({ txHash }) => txHash),

      claimRewards: () =>
        write("claim_rewards", []).then(({ txHash }) => txHash),

      mintElement: (trackId: string, kind: string, valueWei: bigint) =>
        write("mint_element", [trackId, kind], valueWei)
          .then(({ result }) => coerce<string>(result)),

      // reads
      getTrack: (trackId: string) =>
        read<Track>("get_track", [trackId]),
      getProposal: (proposalId: string) =>
        read<Proposal>("get_proposal", [proposalId]),
      listActiveTracks: () =>
        read<string[]>("list_active_tracks", []),
      getPendingRewards: (addr: string) =>
        read<unknown>("get_pending_rewards", [addr]).then((v) => String(v)),
      getTreasuryBalance: () =>
        read<unknown>("get_treasury_balance", []).then((v) => String(v)),
      getContributionCount: (addr: string) =>
        read<unknown>("get_contribution_count", [addr]).then((v) => String(v)),
      getMyMintedElements: () =>
        read<string[]>("get_my_minted_elements", []),
      getMintedElement: (elementId: string) =>
        read<MintedElement>("get_minted_element", [elementId]),
    }),
    [read, write],
  );
}

HEREDOC_14002b8a72bb

cat > components/App.tsx << 'HEREDOC_28129c0b86bb'
"use client";

import { useState } from "react";
import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { wagmiConfig } from "@/lib/genlayer";
import { Navigation, type View } from "./Navigation";
import { TrackGrid } from "./TrackGrid";
import { TrackDetail } from "./TrackDetail";
import { RewardsPanel } from "./RewardsPanel";

const queryClient = new QueryClient();

function Shell() {
  const [view, setView] = useState<View>("deck");
  const [openTrackId, setOpenTrackId] = useState<string | null>(null);

  return (
    <div className="min-h-screen">
      <Navigation
        view={view}
        onChange={(v) => {
          setView(v);
          setOpenTrackId(null);
        }}
      />

      <main className="ml-[4.5rem] px-6 pb-16 pt-24 lg:px-10">
        <div className="mx-auto max-w-6xl">
          {view === "deck" &&
            (openTrackId ? (
              <TrackDetail trackId={openTrackId} onBack={() => setOpenTrackId(null)} />
            ) : (
              <TrackGrid onOpen={setOpenTrackId} />
            ))}
          {view === "rewards" && <RewardsPanel />}
        </div>
      </main>
    </div>
  );
}

export default function App() {
  return (
    <WagmiProvider config={wagmiConfig}>
      <QueryClientProvider client={queryClient}>
        <Shell />
      </QueryClientProvider>
    </WagmiProvider>
  );
}

HEREDOC_28129c0b86bb

cat > components/Navigation.tsx << 'HEREDOC_d6da8f5b1abb'
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

HEREDOC_d6da8f5b1abb

cat > components/WalletConnect.tsx << 'HEREDOC_55659950d32c'
"use client";

import { useAccount, useConnect, useDisconnect, useBalance } from "wagmi";
import { Power, Wallet, Loader2 } from "lucide-react";
import { Button } from "./ui/Button";

function truncate(address: string) {
  return `${address.slice(0, 6)}…${address.slice(-4)}`;
}

export function WalletConnect() {
  const { address, isConnected, isReconnecting } = useAccount();
  const { connectors, connect, isPending } = useConnect();
  const { disconnect } = useDisconnect();
  const { data: balance } = useBalance({ address });

  // Wallet was previously connected and wagmi is restoring the session.
  // Show a neutral loading state instead of the connect button so the
  // user never sees a misleading "not connected" flash.
  if (isReconnecting) {
    return (
      <div className="flex items-center gap-2 rounded-sm border border-line bg-rail/60 px-3 py-2">
        <Loader2 className="h-3.5 w-3.5 animate-spin text-muted" />
        <span className="font-mono text-[11px] text-muted">Reconnecting…</span>
      </div>
    );
  }

  if (isConnected && address) {
    return (
      <div className="flex items-center gap-3 rounded-sm border border-line bg-rail/60 px-3 py-2">
        <span className="h-1.5 w-1.5 rounded-full bg-current shadow-glow-current animate-flicker" />
        <div className="leading-tight">
          <p className="led text-[12px] text-ink">{truncate(address)}</p>
          {balance && (
            <p className="led text-[10px] text-muted">
              {Number(balance.formatted).toFixed(3)} {balance.symbol}
            </p>
          )}
        </div>
        <button
          onClick={() => disconnect()}
          aria-label="Disconnect wallet"
          className="ml-1 rounded-sm border border-line p-1.5 text-muted transition-colors hover:border-pulse/50 hover:text-pulse"
        >
          <Power className="h-3.5 w-3.5" />
        </button>
      </div>
    );
  }

  return (
    <Button
      variant="primary"
      loading={isPending}
      onClick={() => connect({ connector: connectors[0] })}
      className="gap-2"
    >
      <Wallet className="h-3.5 w-3.5" />
      Connect wallet
    </Button>
  );
}

HEREDOC_55659950d32c

cat > components/VuMeter.tsx << 'HEREDOC_1afad4cc41d3'
"use client";

const bars = [0, 0.12, 0.24, 0.08, 0.3, 0.15, 0.05];

export function VuMeter({ label }: { label?: string }) {
  return (
    <span className="inline-flex items-center gap-2">
      <span className="flex h-3.5 items-end gap-[2px]" aria-hidden="true">
        {bars.map((delay, i) => (
          <span
            key={i}
            className="w-[2.5px] origin-bottom rounded-[1px] bg-gradient-to-t from-pulse to-current animate-vu"
            style={{ height: "100%", animationDelay: `${delay}s` }}
          />
        ))}
      </span>
      {label && <span className="font-mono text-[11px] uppercase tracking-[0.16em] text-muted">{label}</span>}
    </span>
  );
}

HEREDOC_1afad4cc41d3

cat > components/CreateSeedForm.tsx << 'HEREDOC_8241087b1354'
"use client";

import { useState } from "react";
import { useAccount } from "wagmi";
import { Disc3 } from "lucide-react";
import { Button } from "./ui/Button";
import { Input, Textarea } from "./ui/Field";
import { useHarmonyForge } from "@/lib/genlayer";

export function CreateSeedForm({ onCreated }: { onCreated?: (trackId: string) => void }) {
  const { submitSeed } = useHarmonyForge();
  // isReconnecting: wagmi is restoring a prior session — address not ready yet
  const { isConnected, isReconnecting } = useAccount();

  const [title, setTitle] = useState("");
  const [genre, setGenre] = useState("");
  const [seedPrompt, setSeedPrompt] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const notReady = !isConnected || isReconnecting;

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
      if (err instanceof Error) {
        setError(err.message);
      } else {
        try {
          setError(JSON.stringify(err));
        } catch {
          setError(String(err));
        }
      }
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
        <Input
          label="Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required
          placeholder="Midnight Static"
        />
        <Input
          label="Genre"
          value={genre}
          onChange={(e) => setGenre(e.target.value)}
          required
          placeholder="Synthwave"
        />
        <Textarea
          label="Seed prompt"
          rows={4}
          value={seedPrompt}
          onChange={(e) => setSeedPrompt(e.target.value)}
          required
          placeholder="A slow-motion drive through a neon city at 3am, in love with no one in particular..."
        />
      </div>

      {notReady && !submitting && (
        <p className="mt-3 font-mono text-[12px] text-muted">
          {isReconnecting ? "Reconnecting wallet…" : "Connect a wallet above to submit."}
        </p>
      )}
      {error && <p className="mt-3 font-mono text-[12px] text-pulse">{error}</p>}

      <Button
        type="submit"
        loading={submitting}
        disabled={notReady}
        className="mt-5 w-full"
      >
        {isReconnecting ? "Reconnecting…" : "Submit seed"}
      </Button>
    </form>
  );
}

HEREDOC_8241087b1354

cat > components/TrackCard.tsx << 'HEREDOC_d183110e999d'
"use client";

import type { Track } from "@/lib/types";

function ringColor(genre: string) {
  const hash = genre.split("").reduce((a, c) => a + c.charCodeAt(0), 0);
  return ["#FF2E97", "#00E5FF", "#FFB627"][hash % 3];
}

export function TrackCard({ track, onOpen }: { track: Track; onOpen: (id: string) => void }) {
  const accent = ringColor(track.genre || "x");

  return (
    <button
      onClick={() => onOpen(track.id)}
      className="group relative aspect-[4/5] w-full overflow-hidden rounded-md border border-line bg-panel
        p-5 text-left transition-all duration-200 hover:-translate-y-1 hover:border-line/0"
      style={{ boxShadow: "0 0 0 1px rgba(244,238,255,0.06)" }}
      onMouseEnter={(e) => (e.currentTarget.style.boxShadow = `0 0 0 1px ${accent}55, 0 10px 40px ${accent}22`)}
      onMouseLeave={(e) => (e.currentTarget.style.boxShadow = "0 0 0 1px rgba(244,238,255,0.06)")}
    >
      {/* sleeve texture */}
      <div className="absolute inset-0 bg-grain opacity-40" />

      <div className="relative flex h-full flex-col justify-between">
        <div>
          <p className="led text-[10px] uppercase tracking-[0.16em] text-muted">#{track.id} · {track.genre}</p>
          <h3 className="mt-2 font-display text-base font-semibold leading-snug text-ink">{track.title}</h3>
        </div>

        <p className="line-clamp-3 font-body text-[13px] leading-relaxed text-muted">{track.current_content}</p>

        <div className="flex items-center justify-between">
          {/* spinning vinyl label */}
          <div
            className="relative flex h-12 w-12 items-center justify-center rounded-full border border-line
              transition-transform duration-300 group-hover:animate-spin-slow"
            style={{ background: `radial-gradient(circle at 50% 50%, ${accent}33 0%, #0F0825 70%)` }}
          >
            <span className="led text-[10px] text-ink">v{track.version}</span>
            <span className="absolute h-1.5 w-1.5 rounded-full bg-void" />
          </div>
          <span className="font-mono text-[10px] uppercase tracking-[0.14em] text-muted">
            {track.creator.slice(0, 6)}…
          </span>
        </div>
      </div>
    </button>
  );
}

HEREDOC_d183110e999d

cat > components/TrackGrid.tsx << 'HEREDOC_1abb5956e333'
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

HEREDOC_1abb5956e333

cat > components/TrackDetail.tsx << 'HEREDOC_ff27dbb3b866'
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

HEREDOC_ff27dbb3b866

cat > components/ProposeEvolutionForm.tsx << 'HEREDOC_96556a8d8eee'
"use client";

import { useState } from "react";
import { GitBranch } from "lucide-react";
import { Button } from "./ui/Button";
import { Textarea } from "./ui/Field";
import { useHarmonyForge } from "@/lib/genlayer";

const TYPES = ["harmony", "remix", "lyric", "melody", "structure"] as const;

export function ProposeEvolutionForm({
  trackId,
  onProposed,
}: {
  trackId: string;
  // Now receives the real on-chain proposal ID + type
  onProposed?: (proposalId: string, type: string) => void;
}) {
  const { proposeEvolution } = useHarmonyForge();
  const [type, setType] = useState<(typeof TYPES)[number]>("harmony");
  const [text, setText] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      // proposeEvolution now returns the real on-chain proposal ID
      const proposalId = await proposeEvolution(trackId, text, type);
      setText("");
      onProposed?.(String(proposalId), type);
    } catch (err) {
      const msg = err instanceof Error ? err.message
        : typeof err === "object" ? JSON.stringify(err)
        : String(err);
      setError(msg);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="rounded-md border border-line bg-panel/70 p-5">
      <div className="mb-4 flex items-center gap-2.5">
        <GitBranch className="h-4 w-4 text-current" />
        <h4 className="font-display text-sm font-semibold uppercase tracking-[0.1em] text-ink">
          Propose an evolution
        </h4>
      </div>

      <div className="mb-4 flex flex-wrap gap-2">
        {TYPES.map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setType(t)}
            className={`rounded-full border px-3 py-1 font-mono text-[11px] uppercase tracking-[0.1em] transition-colors ${
              type === t ? "border-current text-current shadow-glow-current" : "border-line text-muted hover:text-ink"
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      <Textarea
        label="Contribution"
        rows={3}
        value={text}
        onChange={(e) => setText(e.target.value)}
        required
        placeholder="Add a half-time breakdown with a saxophone hook over the second chorus..."
      />

      {error && <p className="mt-3 font-mono text-[12px] text-pulse">{error}</p>}

      <Button type="submit" variant="secondary" loading={submitting} className="mt-4 w-full">
        Submit proposal
      </Button>
    </form>
  );
}

HEREDOC_96556a8d8eee

cat > components/EvaluateProposalButton.tsx << 'HEREDOC_66ec1a814119'
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
      setError(err instanceof Error ? err.message : (typeof err === "object" ? JSON.stringify(err) : String(err)));
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

HEREDOC_66ec1a814119

cat > components/MintElementModal.tsx << 'HEREDOC_b59ec872ae0b'
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
      setError(err instanceof Error ? err.message : (typeof err === "object" ? JSON.stringify(err) : String(err)));
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

HEREDOC_b59ec872ae0b

cat > components/RewardsPanel.tsx << 'HEREDOC_079b88b8ea95'
"use client";

import { useEffect, useState } from "react";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { Coins, Gem, Sparkle } from "lucide-react";
import { useHarmonyForge } from "@/lib/genlayer";
import { Button } from "./ui/Button";

function StatCard({
  icon: Icon,
  label,
  value,
  accent,
}: {
  icon: typeof Coins;
  label: string;
  value: string;
  accent: string;
}) {
  return (
    <div className="rounded-md border border-line bg-panel p-6">
      <Icon className="h-4 w-4" style={{ color: accent }} />
      <p className="mt-4 led text-2xl text-ink">{value}</p>
      <p className="mt-1 font-mono text-[11px] uppercase tracking-[0.16em] text-muted">{label}</p>
    </div>
  );
}

export function RewardsPanel() {
  const { address, isConnected } = useAccount();
  const { getPendingRewards, getTreasuryBalance, getContributionCount, claimRewards } = useHarmonyForge();

  const [pending, setPending] = useState<bigint>(0n);
  const [treasury, setTreasury] = useState<bigint>(0n);
  const [contributions, setContributions] = useState<bigint>(0n);
  const [claiming, setClaiming] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function refresh() {
    if (!address) return;
    const [p, t, c] = await Promise.all([
      getPendingRewards(address),
      getTreasuryBalance(),
      getContributionCount(address),
    ]);
    setPending(BigInt(p));
    setTreasury(BigInt(t));
    setContributions(BigInt(c));
  }

  useEffect(() => {
    refresh();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [address]);

  async function handleClaim() {
    setError(null);
    setClaiming(true);
    try {
      await claimRewards();
      await refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : (typeof err === "object" ? JSON.stringify(err) : String(err)));
    } finally {
      setClaiming(false);
    }
  }

  if (!isConnected) {
    return <p className="font-body text-sm text-muted">Connect a wallet to see what you&apos;ve earned.</p>;
  }

  return (
    <div className="space-y-8">
      <div>
        <p className="font-mono text-[11px] uppercase tracking-[0.18em] text-vinyl">Royalty desk</p>
        <h2 className="mt-1 font-display text-2xl font-bold text-ink">Your rewards</h2>
      </div>

      <div className="grid gap-5 sm:grid-cols-3">
        <StatCard icon={Coins} label="Pending GEN" value={Number(formatEther(pending)).toFixed(4)} accent="#FFB627" />
        <StatCard icon={Gem} label="Approved evolutions" value={contributions.toString()} accent="#00E5FF" />
        <StatCard
          icon={Sparkle}
          label="Treasury balance"
          value={Number(formatEther(treasury)).toFixed(2)}
          accent="#FF2E97"
        />
      </div>

      <div className="rounded-md border border-line bg-panel/70 p-6">
        <p className="font-body text-sm text-muted">
          Every approved evolution earns a share of the treasury, scaled by how the jury scored it. Claim
          whenever you like — nothing expires.
        </p>
        {error && <p className="mt-3 font-mono text-[12px] text-pulse">{error}</p>}
        <Button
          variant="vinyl"
          loading={claiming}
          disabled={pending === 0n}
          onClick={handleClaim}
          className="mt-5 gap-2"
        >
          <Coins className="h-3.5 w-3.5" />
          Claim {Number(formatEther(pending)).toFixed(4)} GEN
        </Button>
      </div>
    </div>
  );
}

HEREDOC_079b88b8ea95

cat > components/ui/Button.tsx << 'HEREDOC_6c3d7dd4ed62'
"use client";

import { type ButtonHTMLAttributes, forwardRef } from "react";
import { Loader2 } from "lucide-react";

type Variant = "primary" | "secondary" | "ghost" | "vinyl";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
}

const variants: Record<Variant, string> = {
  primary:
    "bg-pulse text-void shadow-glow-pulse hover:brightness-110 active:scale-[0.98] border border-pulse/60",
  secondary:
    "bg-transparent text-current border border-current/50 shadow-glow-current hover:bg-current/10 active:scale-[0.98]",
  ghost: "bg-transparent text-ink/80 border border-line hover:border-ink/30 hover:text-ink",
  vinyl: "bg-vinyl text-void shadow-glow-vinyl hover:brightness-110 active:scale-[0.98] border border-vinyl/60",
};

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = "primary", loading, className = "", children, disabled, ...rest }, ref) => {
    return (
      <button
        ref={ref}
        disabled={disabled || loading}
        className={`relative inline-flex items-center justify-center gap-2 rounded-sm px-5 py-2.5
          font-display text-[13px] font-medium uppercase tracking-[0.08em]
          transition-all duration-150 disabled:cursor-not-allowed disabled:opacity-40
          ${variants[variant]} ${className}`}
        {...rest}
      >
        {loading && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
        {children}
      </button>
    );
  },
);
Button.displayName = "Button";

HEREDOC_6c3d7dd4ed62

cat > components/ui/Field.tsx << 'HEREDOC_a9a47c6e5549'
"use client";

import { type InputHTMLAttributes, type TextareaHTMLAttributes, forwardRef } from "react";

function FieldShell({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1.5 block font-mono text-[11px] uppercase tracking-[0.18em] text-muted">{label}</span>
      {children}
    </label>
  );
}

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(({ label, className = "", ...rest }, ref) => (
  <FieldShell label={label}>
    <input
      ref={ref}
      className={`w-full rounded-sm border border-line bg-rail/60 px-3.5 py-2.5 font-body text-sm text-ink
        placeholder:text-muted/60 transition-colors focus:border-current/60 focus:outline-none
        focus:shadow-glow-current ${className}`}
      {...rest}
    />
  </FieldShell>
));
Input.displayName = "Input";

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label: string;
}

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ label, className = "", ...rest }, ref) => (
    <FieldShell label={label}>
      <textarea
        ref={ref}
        className={`w-full resize-none rounded-sm border border-line bg-rail/60 px-3.5 py-2.5 font-body text-sm
          text-ink placeholder:text-muted/60 transition-colors focus:border-current/60 focus:outline-none
          focus:shadow-glow-current ${className}`}
        {...rest}
      />
    </FieldShell>
  ),
);
Textarea.displayName = "Textarea";

HEREDOC_a9a47c6e5549

cat > components/ui/Modal.tsx << 'HEREDOC_1e2e449aa8ee'
"use client";

import { useEffect } from "react";
import { X } from "lucide-react";

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  eyebrow?: string;
  children: React.ReactNode;
}

export function Modal({ open, onClose, title, eyebrow, children }: ModalProps) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center sm:items-center" role="dialog" aria-modal="true">
      <button
        aria-label="Close"
        onClick={onClose}
        className="absolute inset-0 bg-void/80 backdrop-blur-sm"
      />
      <div className="relative w-full max-w-md animate-rise-in rounded-t-lg border border-line bg-panel
        p-6 shadow-glow-pulse sm:rounded-lg">
        <div className="mb-5 flex items-start justify-between">
          <div>
            {eyebrow && (
              <p className="mb-1 font-mono text-[11px] uppercase tracking-[0.18em] text-pulse">{eyebrow}</p>
            )}
            <h2 className="font-display text-lg font-semibold text-ink">{title}</h2>
          </div>
          <button
            onClick={onClose}
            className="rounded-sm border border-line p-1.5 text-muted transition-colors hover:border-ink/30 hover:text-ink"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
        {children}
      </div>
    </div>
  );
}

HEREDOC_1e2e449aa8ee
echo "→ Installing dependencies..."
npm install
echo "✓ Done! Run:  cd genharmony && npm run dev"
