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

