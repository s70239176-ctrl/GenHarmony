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
