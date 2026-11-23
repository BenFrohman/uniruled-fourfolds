import { createFileRoute } from "@tanstack/react-router";
import { useRef, useState } from "react";
import { MODES, modelOf, type ChamberState, type ModeId } from "@/chamber/model";
import { Chamber } from "@/components/chamber";

export const Route = createFileRoute("/")({ component: Home });

function Home() {
  const initial = MODES[0];
  const [mode, setMode] = useState<ModeId>(initial.id);
  const [cut, setCut] = useState<number>(initial.cut);
  const [gain, setGain] = useState<number>(initial.gain);
  const [probeB, setProbeB] = useState(-0.25);
  const [probeA, setProbeA] = useState(0.72);
  const [r, setR] = useState(2);
  const [c, setC] = useState(1);
  const [s, setS] = useState(-1);
  const [gesture, setGesture] = useState<ChamberState["gesture"]>("orbit");
  const [viewNonce, setViewNonce] = useState(0);
  const [picked, setPicked] = useState("h(2,2) = 21");
  const stateRef = useRef<ChamberState>(null!);
  const current = MODES.find((item) => item.id === mode) ?? MODES[0];
  const snapshot: ChamberState = {
    mode,
    cut,
    gain,
    probeB,
    probeA,
    r,
    c,
    s,
    viewNonce,
    gesture: current.probe ? gesture : "orbit",
    picked,
  };
  stateRef.current = snapshot;
  const note = modelOf(snapshot).note;

  function choose(id: ModeId) {
    const next = MODES.find((item) => item.id === id);
    if (!next) return;
    setMode(next.id);
    setCut(next.cut);
    setGain(next.gain);
    setGesture("orbit");
  }

  return (
    <main className="flex h-dvh flex-col overflow-hidden bg-bg text-fg">
      <section className="relative min-h-0 flex-1">
        <div className="absolute inset-0">
          <Chamber
            stateRef={stateRef}
            onPick={setPicked}
            onProbe={(beta, alpha) => {
              setProbeB(beta);
              setProbeA(alpha);
            }}
          />
        </div>
        <div className="pointer-events-none absolute inset-x-0 top-0 flex items-start justify-between gap-4 p-4 sm:p-6">
          <div className="min-w-0 flex-1">
            <p className="font-mono text-xs tracking-widest text-line">VOLUME</p>
            <h1 className="mt-1 text-3xl text-fg sm:text-4xl">Wall ledger</h1>
            <p className="mt-2 text-sm leading-relaxed text-muted">{current.blurb}</p>
            <p className="mt-3 font-mono text-sm text-line sm:text-base">{note}</p>
          </div>
          <button
            type="button"
            className="pointer-events-auto shrink-0 rounded-full border border-border bg-surface px-3 py-2 text-sm text-fg"
            onClick={() => setViewNonce((value) => value + 1)}
          >
            Reset view
          </button>
        </div>
        <p className="pointer-events-none absolute bottom-3 left-4 hidden font-mono text-xs text-muted sm:block">
          β gold · α steel · depth rose · drag orbits · wheel dollies
        </p>
      </section>

      <footer className="shrink-0 border-t border-border bg-surface">
        <div className="flex gap-1 overflow-x-auto px-2">
          {MODES.map((item) => (
            <button
              key={item.id}
              type="button"
              aria-pressed={item.id === mode}
              className={
                item.id === mode
                  ? "shrink-0 border-b-2 border-line px-3 py-3 text-sm text-fg"
                  : "shrink-0 border-b-2 border-transparent px-3 py-3 text-sm text-muted"
              }
              onClick={() => choose(item.id)}
            >
              {item.label}
            </button>
          ))}
        </div>
        <div className="grid gap-x-6 px-4 pb-4 sm:grid-cols-2">
          <Slider label="Cut" value={cut} min={0} max={1} step={0.01} onChange={setCut} />
          <Slider label={current.gainLabel} value={gain} min={0} max={1} step={0.01} onChange={setGain} />
          {current.probe ? (
            <>
              <Slider label="Charge β" value={probeB} min={-2.4} max={2.3} step={0.01} onChange={setProbeB} />
              <Slider label="Charge α" value={probeA} min={0.05} max={2.85} step={0.01} onChange={setProbeA} />
              <div className="flex gap-2 sm:col-span-2">
                <button
                  type="button"
                  className={gesture === "orbit" ? "rounded-full border border-line px-3 py-2 text-sm text-fg" : "rounded-full border border-border px-3 py-2 text-sm text-muted"}
                  onClick={() => setGesture("orbit")}
                >
                  Orbit
                </button>
                <button
                  type="button"
                  className={gesture === "probe" ? "rounded-full border border-line px-3 py-2 text-sm text-fg" : "rounded-full border border-border px-3 py-2 text-sm text-muted"}
                  onClick={() => setGesture("probe")}
                >
                  Drag the charge
                </button>
              </div>
            </>
          ) : null}
          {mode === "pairing" ? (
            <>
              <Slider label="Rank r" value={r} min={1} max={4} step={1} onChange={setR} />
              <Slider label="Chern c" value={c} min={-3} max={3} step={1} onChange={setC} />
              <Slider label="Character s" value={s} min={-3} max={3} step={1} onChange={setS} />
              <div className="flex gap-2 sm:col-span-2">
                <button type="button" className="rounded-full border border-border px-3 py-2 text-sm" onClick={() => { setR(2); setC(1); setS(-1); }}>
                  (2, 1, −1)
                </button>
                <button type="button" className="rounded-full border border-border px-3 py-2 text-sm" onClick={() => { setR(1); setC(2); setS(3); }}>
                  (1, 2, 3)
                </button>
              </div>
            </>
          ) : null}
        </div>
      </footer>
    </main>
  );
}

function Slider({
  label,
  value,
  min,
  max,
  step,
  onChange,
}: {
  label: string;
  value: number;
  min: number;
  max: number;
  step: number;
  onChange: (value: number) => void;
}) {
  const shown = Number.isInteger(step) ? String(value) : value.toFixed(2);
  return (
    <label className="block py-2 text-sm text-fg">
      <span className="flex justify-between">
        {label}
        <span className="font-mono text-muted">{shown}</span>
      </span>
      <input
        className="mt-2 h-11 w-full accent-line"
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        suppressHydrationWarning
        onChange={(event) => onChange(Number(event.target.value))}
      />
    </label>
  );
}
