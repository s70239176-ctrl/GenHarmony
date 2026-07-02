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

