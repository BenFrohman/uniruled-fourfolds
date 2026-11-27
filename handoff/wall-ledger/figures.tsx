import { useMemo, useEffect, useRef, useState, type PointerEvent, type ReactNode } from "react";
import {
  axes,
  clear,
  fitIso,
  gold,
  mapX,
  mapY,
  muted,
  paper,
  projectIso,
  rose,
  semicirclePoints,
  steel,
  strokeSeries,
  type Ctx,
} from "@/plots/draw";

function Frame({
  title,
  note,
  draw,
  tall,
  controls,
  onPick,
}: {
  title: string;
  note: string;
  draw: (ctx: Ctx, w: number, h: number) => void;
  tall?: boolean;
  controls: ReactNode;
  onPick?: (u: number, v: number, w: number, h: number) => void;
}) {
  const ref = useRef<HTMLCanvasElement>(null);
  useEffect(() => {
    const canvas = ref.current;
    if (!canvas) return;
    const paint = () => {
      const node = ref.current;
      if (!node) return;
      const w = node.clientWidth || 640;
      const h = node.clientHeight || 280;
      const dpr = Math.min(2, window.devicePixelRatio || 1);
      node.width = Math.floor(w * dpr);
      node.height = Math.floor(h * dpr);
      const ctx = node.getContext("2d");
      if (!ctx) return;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      draw(ctx, w, h);
    };
    paint();
    const observer = new ResizeObserver(paint);
    observer.observe(canvas);
    return () => observer.disconnect();
  }, [draw]);

  const pick = (event: PointerEvent<HTMLCanvasElement>) => {
    if (!onPick) return;
    const rect = event.currentTarget.getBoundingClientRect();
    onPick(
      (event.clientX - rect.left) / rect.width,
      (event.clientY - rect.top) / rect.height,
      rect.width,
      rect.height,
    );
  };

  return (
    <figure className="overflow-hidden rounded-2xl border border-border bg-surface">
      <figcaption className="px-4 pt-4">
        <h2 className="text-lg text-fg">{title}</h2>
        <p className="mt-1 text-sm leading-relaxed text-muted">{note}</p>
      </figcaption>
      <div className="px-4">{controls}</div>
      <div className={tall ? "h-80" : "h-64"}>
        <canvas
          ref={ref}
          className={onPick ? "h-full w-full touch-none" : "h-full w-full"}
          role="img"
          aria-label={title}
          onPointerDown={pick}
          onPointerMove={(event) => {
            if (event.buttons === 1) pick(event);
          }}
        />
      </div>
    </figure>
  );
}

function Knob({
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
  onChange: (n: number) => void;
}) {
  return (
    <label className="mb-3 block text-sm text-fg">
      <span className="flex justify-between">
        {label}
        <span className="font-mono">{step < 1 ? value.toFixed(2) : value}</span>
      </span>
      <input
        className="mt-1 h-11 w-full accent-line"
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(event) => onChange(Number(event.target.value))}
      />
    </label>
  );
}

function invertX(u: number, w: number, a: number, b: number) {
  const pad = 36;
  const t = (u * w - pad) / Math.max(1, w - pad * 2);
  return a + Math.min(1, Math.max(0, t)) * (b - a);
}

function invertY(v: number, h: number, a: number, b: number) {
  const pad = 36;
  const t = (h - pad - v * h) / Math.max(1, h - pad * 2);
  return a + Math.min(1, Math.max(0, t)) * (b - a);
}

function duffing(ctx: Ctx, w: number, h: number, force: number) {
  clear(ctx, w, h);
  const seeds = [
    [0.2, 0],
    [-0.4, 0.3],
    [0.6, -0.2],
  ];
  const colors = [rose, steel, gold];
  const dt = 0.02;
  seeds.forEach((seed, k) => {
    let x = seed[0];
    let y = seed[1];
    let t = 0;
    const trail: Array<[number, number]> = [];
    for (let i = 0; i < 2800; i++) {
      const dx = y;
      const dy = x - x * x * x - 0.25 * y + force * Math.cos(t);
      x += dx * dt;
      y += dy * dt;
      t += dt;
      if (i > 200 && i % 2 === 0) {
        const z = 8 + 6 * Math.sin(t * 0.5);
        const [sx, sy] = projectIso(x * 8, y * 8, z, w, h);
        trail.push([sx, sy]);
      }
    }
    strokeSeries(ctx, trail, colors[k], 1.2);
  });
  ctx.fillStyle = muted;
  ctx.font = "12px ui-monospace, monospace";
  ctx.fillText(`force ${force.toFixed(2)}`, 16, 22);
}

function velocity(ctx: Ctx, w: number, h: number, focus: number, bend: number) {
  const x0 = -2;
  const x1 = 2;
  const y0 = 0;
  const y1 = 3;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const pad = 36;
  for (let i = -4; i <= 4; i++) {
    for (let j = 1; j <= 6; j++) {
      const b = i * 0.45;
      const a = j * 0.4;
      const tx = -b;
      const ty = focus - a;
      const len = Math.hypot(tx, ty) || 1;
      const bx = mapX(b, x0, x1, pad, w);
      const by = mapY(a, y0, y1, pad, h);
      ctx.strokeStyle = gold;
      ctx.globalAlpha = 0.7;
      ctx.beginPath();
      ctx.moveTo(bx, by);
      ctx.lineTo(bx + (tx / len) * 16, by - (ty / len) * 16);
      ctx.stroke();
      ctx.globalAlpha = 1;
    }
  }
  const curve: Array<[number, number]> = [];
  for (let i = 0; i <= 80; i++) {
    const b = -2 + (4 * i) / 80;
    curve.push([mapX(b, x0, x1, pad, w), mapY(focus + bend * b * b, y0, y1, pad, h)]);
  }
  strokeSeries(ctx, curve, steel, 2.5);
  ctx.fillStyle = paper;
  ctx.beginPath();
  ctx.arc(mapX(0, x0, x1, pad, w), mapY(focus, y0, y1, pad, h), 6, 0, Math.PI * 2);
  ctx.fill();
}

function funnel(ctx: Ctx, w: number, h: number, turns: number) {
  clear(ctx, w, h);
  const colors = [gold, steel, rose, paper, "#8d9a7b", "#d7c4a3"];
  for (let k = 0; k < 6; k++) {
    const pts: Array<[number, number]> = [];
    for (let i = 0; i <= 180; i++) {
      const t = i / 180;
      const ang = t * turns + k * 0.7;
      const r = 0.15 + 1.6 * (1 - t);
      const beta = r * Math.cos(ang);
      const depth = r * Math.sin(ang);
      const alpha = 0.2 + 3.2 * t;
      pts.push(fitIso(beta / 2, depth / 2, alpha / 3.4, w, h) as [number, number]);
    }
    strokeSeries(ctx, pts, colors[k], 1.6);
  }
}

function orbits(ctx: Ctx, w: number, h: number, mix: number) {
  const x0 = -2.6;
  const x1 = 2.6;
  const y0 = 0;
  const y1 = 3.2;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const pad = 36;
  const high: Array<[number, number]> = [];
  const mid: Array<[number, number]> = [];
  const low: Array<[number, number]> = [];
  for (let i = 0; i <= 100; i++) {
    const u = i / 100;
    const b = -2.4 + 4.6 * u;
    high.push([mapX(b, x0, x1, pad, w), mapY(0.42 + (0.3 + mix) * (b - 0.15) ** 2, y0, y1, pad, h)]);
    const bm = -1.8 + 3.3 * u;
    mid.push([mapX(bm, x0, x1, pad, w), mapY(2.5 - (0.8 + mix) * u, y0, y1, pad, h)]);
    const bl = -1.6 + 2.6 * u;
    const loop = 1.55 + (0.15 + mix) * Math.sin(u * Math.PI * 2) * Math.sin(u * Math.PI);
    low.push([mapX(bl, x0, x1, pad, w), mapY(loop, y0, y1, pad, h)]);
  }
  strokeSeries(ctx, high, steel, 2);
  strokeSeries(ctx, mid, rose, 2);
  strokeSeries(ctx, low, gold, 2);
}

function waterfall(ctx: Ctx, w: number, h: number, shift: number) {
  clear(ctx, w, h);
  const steps = 24;
  for (let s = 0; s < steps; s++) {
    const tau = s / (steps - 1);
    const c1 = -1.2 + 0.5 * tau + shift;
    const c2 = 0.2 - 0.6 * tau + shift * 0.4;
    const pts: Array<[number, number]> = [];
    for (let i = 0; i <= 70; i++) {
      const beta = -3 + (4 * i) / 70;
      const density =
        Math.exp(-((beta - c1) ** 2) / 0.05) * (1 - 0.4 * tau) +
        Math.exp(-((beta - c2) ** 2) / 0.08) * (0.5 + 0.5 * tau);
      pts.push(fitIso((beta + 1) / 2, tau * 2 - 1, Math.min(1.4, density), w, h) as [number, number]);
    }
    const tone = `rgb(${Math.round(80 + 140 * tau)}, ${Math.round(90 + 40 * (1 - tau))}, ${Math.round(180 - 80 * tau)})`;
    strokeSeries(ctx, pts, tone, 1.4);
  }
}

function nested(ctx: Ctx, w: number, h: number, scale: number) {
  const x0 = -2.5;
  const x1 = 2.2;
  const y0 = -1;
  const y1 = 1.8;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const nests = [
    { center: -0.15, radius: 0.7 },
    { center: -0.35, radius: 1.05 },
    { center: -0.55, radius: 1.4 },
    { center: -0.75, radius: 1.75 },
  ];
  const colors = [gold, steel, rose, paper];
  nests.forEach((n, i) => {
    strokeSeries(
      ctx,
      semicirclePoints(n.center * scale, n.radius * scale, x0, x1, y0, y1, w, h),
      colors[i],
      2,
    );
  });
}

function hodge(ctx: Ctx, w: number, h: number, pSel: number, qSel: number) {
  clear(ctx, w, h);
  const weights = [
    [0.45, 0.28, 0.18, 0.12, 0.08],
    [0.28, 0.55, 0.22, 0.12, 0],
    [0.18, 0.22, 1, 0, 0],
    [0.12, 0.12, 0, 0, 0],
    [0.08, 0, 0, 0, 0],
  ];
  const size = Math.min(w, h) * 0.14;
  const ox = w * 0.22;
  const oy = h * 0.16;
  for (let q = 0; q < 5; q++) {
    for (let p = 0; p < 5; p++) {
      const weight = weights[q][p];
      ctx.fillStyle = weight === 0 ? "#1a2030" : `rgba(198, 161, 91, ${0.15 + 0.85 * weight})`;
      ctx.fillRect(ox + p * size, oy + q * size, size - 4, size - 4);
      if (p === pSel && q === qSel) {
        ctx.strokeStyle = steel;
        ctx.lineWidth = 2;
        ctx.strokeRect(ox + p * size, oy + q * size, size - 4, size - 4);
      }
    }
  }
  ctx.fillStyle = muted;
  ctx.font = "12px ui-monospace, monospace";
  ctx.fillText(`cell (${pSel}, ${qSel}) weight ${weights[qSel][pSel]}`, 16, h - 16);
}

function hyperbolas(ctx: Ctx, w: number, h: number, stretch: number) {
  const x0 = -4;
  const x1 = 4;
  const y0 = 0.6;
  const y1 = 3.4;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const pad = 36;
  const curves = [
    { center: -0.4, floor: 1.15, stretch: 0.22, color: gold },
    { center: 0.2, floor: 1.05, stretch: 0.16, color: rose },
    { center: 0.8, floor: 1.25, stretch: 0.2, color: steel },
  ];
  curves.forEach((curve) => {
    const pts: Array<[number, number]> = [];
    for (let i = 0; i <= 100; i++) {
      const b = -4 + (8 * i) / 100;
      const a = Math.sqrt(curve.floor ** 2 + curve.stretch * stretch * (b - curve.center) ** 2);
      pts.push([mapX(b, x0, x1, pad, w), mapY(a, y0, y1, pad, h)]);
    }
    strokeSeries(ctx, pts, curve.color, 2);
  });
}

function volume(ctx: Ctx, w: number, h: number, lead: number) {
  const x0 = -4.2;
  const x1 = 2.2;
  const y0 = 0;
  const y1 = 4.2;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const scales = [1, 1.5, 2, 2.5];
  const colors = [steel, gold, rose, paper];
  const right = 1.05;
  scales.forEach((scale, i) => {
    const radius = 1.45 * scale * lead;
    strokeSeries(ctx, semicirclePoints(right - radius, radius, x0, x1, y0, y1, w, h), colors[i], 2);
  });
}

function dense(ctx: Ctx, w: number, h: number, count: number) {
  const x0 = -2.2;
  const x1 = 2.2;
  const y0 = 0;
  const y1 = 2.1;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const last = Math.max(1, count - 1);
  for (let i = 0; i < count; i++) {
    const t = i / last;
    const radius = 0.35 + 1.35 * t;
    const center = -1.7 + 0.55 * t;
    const color = `rgb(${Math.round(90 + 140 * t)}, ${Math.round(70 + 80 * (1 - t))}, ${Math.round(160 - 70 * t)})`;
    strokeSeries(ctx, semicirclePoints(center, radius, x0, x1, y0, y1, w, h, 40), color, 1.2);
  }
}

function track(ctx: Ctx, w: number, h: number, beta: number, alpha: number, radius: number) {
  const x0 = -2.6;
  const x1 = 1.6;
  const y0 = 0;
  const y1 = 2.6;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  strokeSeries(ctx, semicirclePoints(-0.5, radius, x0, x1, y0, y1, w, h), steel, 2.5);
  const pad = 36;
  const inside = (beta + 0.5) ** 2 + alpha ** 2 <= radius ** 2;
  ctx.fillStyle = inside ? gold : paper;
  ctx.beginPath();
  ctx.arc(mapX(beta, x0, x1, pad, w), mapY(alpha, y0, y1, pad, h), 6, 0, Math.PI * 2);
  ctx.fill();
}

function chambers(ctx: Ctx, w: number, h: number, beta: number, alpha: number, scale: number) {
  const x0 = -3;
  const x1 = 3;
  const y0 = 0;
  const y1 = 2.6;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const walls = [
    { c: 0, r: 0.85 * scale, color: steel },
    { c: 0.15, r: 1.35 * scale, color: rose },
    { c: 0, r: 2.15 * scale, color: gold },
  ];
  walls.forEach((wall) => {
    ctx.setLineDash([5, 4]);
    strokeSeries(ctx, semicirclePoints(wall.c, wall.r, x0, x1, y0, y1, w, h), wall.color, 1.6);
    ctx.setLineDash([]);
  });
  const pad = 36;
  ctx.fillStyle = paper;
  ctx.beginPath();
  ctx.arc(mapX(beta, x0, x1, pad, w), mapY(alpha, y0, y1, pad, h), 6, 0, Math.PI * 2);
  ctx.fill();
}

function bogomolov(ctx: Ctx, w: number, h: number, half: number) {
  const x0 = -3;
  const x1 = 3;
  const y0 = -4.5;
  const y1 = 4.8;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "c1 / r", "ch2 / r");
  const pad = 36;
  const yOf = (x: number) => half * x * x;
  ctx.beginPath();
  ctx.moveTo(mapX(x0, x0, x1, pad, w), mapY(yOf(x0), y0, y1, pad, h));
  for (let i = 0; i <= 80; i++) {
    const x = x0 + ((x1 - x0) * i) / 80;
    ctx.lineTo(mapX(x, x0, x1, pad, w), mapY(yOf(x), y0, y1, pad, h));
  }
  ctx.lineTo(mapX(x1, x0, x1, pad, w), mapY(y0, y0, y1, pad, h));
  ctx.lineTo(mapX(x0, x0, x1, pad, w), mapY(y0, y0, y1, pad, h));
  ctx.closePath();
  ctx.fillStyle = "rgba(126, 162, 212, 0.28)";
  ctx.fill();
  const curve: Array<[number, number]> = [];
  for (let i = 0; i <= 80; i++) {
    const x = x0 + ((x1 - x0) * i) / 80;
    curve.push([mapX(x, x0, x1, pad, w), mapY(yOf(x), y0, y1, pad, h)]);
  }
  strokeSeries(ctx, curve, gold, 2);
}

function stream(ctx: Ctx, w: number, h: number, radius: number) {
  const x0 = -2;
  const x1 = 2;
  const y0 = 0;
  const y1 = 2.6;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const pad = 36;
  for (let i = 0; i < 12; i++) {
    for (let j = 0; j < 8; j++) {
      const b = -1.8 + i * 0.32;
      const a = 0.15 + j * 0.28;
      const inside = b * b + a * a < radius * radius;
      const vx = inside ? -a : 0;
      const vy = inside ? b : 1;
      const len = Math.hypot(vx, vy) || 1;
      const bx = mapX(b, x0, x1, pad, w);
      const by = mapY(a, y0, y1, pad, h);
      ctx.strokeStyle = inside ? rose : steel;
      ctx.beginPath();
      ctx.moveTo(bx, by);
      ctx.lineTo(bx + (vx / len) * 12, by - (vy / len) * 12);
      ctx.stroke();
    }
  }
  ctx.setLineDash([6, 4]);
  strokeSeries(ctx, semicirclePoints(0, radius, x0, x1, y0, y1, w, h), rose, 2);
  ctx.setLineDash([]);
}

function surface(ctx: Ctx, w: number, h: number, tilt: number) {
  clear(ctx, w, h);
  const center = -0.5;
  const radius = 1.15;
  for (let s = 0; s < 8; s++) {
    const ch3 = -2 + (4 * s) / 7;
    const pts: Array<[number, number]> = [];
    for (let i = 0; i <= 36; i++) {
      const beta = center - radius + (2 * radius * i) / 36;
      const base = Math.sqrt(Math.max(0, radius ** 2 - (beta - center) ** 2));
      const alpha = Math.max(0, base * (1 + tilt * ch3 * (beta - center)));
      pts.push(fitIso(beta / 2, ch3 / 2.2, alpha / 1.6, w, h) as [number, number]);
    }
    const t = s / 7;
    strokeSeries(
      ctx,
      pts,
      `rgb(${Math.round(80 + 150 * t)}, ${Math.round(120 + 60 * (1 - t))}, ${Math.round(190 - 90 * t)})`,
      2,
    );
  }
}

function deformed(ctx: Ctx, w: number, h: number, pole: number) {
  const x0 = -3.2;
  const x1 = 4.2;
  const y0 = 0;
  const y1 = 4.4;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const pad = 36;
  const left: Array<[number, number]> = semicirclePoints(-1.6, 1.45, x0, x1, y0, y1, w, h);
  for (let i = 0; i <= 30; i++) {
    const b = 0.2 + ((pole - 0.35) * i) / 30;
    const a = 0.15 + 4 / Math.max(0.08, pole - b);
    left.push([mapX(b, x0, x1, pad, w), mapY(Math.min(4.2, a), y0, y1, pad, h)]);
  }
  const right: Array<[number, number]> = semicirclePoints(-1.35, 0.7, x0, x1, y0, y1, w, h);
  const pole2 = pole + 1;
  for (let i = 0; i <= 24; i++) {
    const b = pole2 - 0.8 + (0.75 * i) / 24;
    const a = 0.2 + 3.2 / Math.max(0.08, pole2 - b);
    right.push([mapX(b, x0, x1, pad, w), mapY(Math.min(4.2, a), y0, y1, pad, h)]);
  }
  strokeSeries(ctx, left, steel, 2);
  strokeSeries(ctx, right, gold, 2);
}

function loci(ctx: Ctx, w: number, h: number, scale: number) {
  const x0 = -3.2;
  const x1 = 1.2;
  const y0 = -0.4;
  const y1 = 2.3;
  clear(ctx, w, h);
  axes(ctx, w, h, x0, x1, y0, y1, "beta", "alpha");
  const walls = [
    { c: -1.2, r: 1.15, color: steel },
    { c: -0.7, r: 1.55, color: gold },
    { c: -0.2, r: 0.55, color: rose },
    { c: -1.6, r: 2.05, color: paper },
  ];
  walls.forEach((wall) => {
    strokeSeries(ctx, semicirclePoints(wall.c, wall.r * scale, x0, x1, y0, y1, w, h), wall.color, 2);
  });
}

export function DuffingFigure() {
  const [force, setForce] = useState(0.38);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => duffing(ctx, w, h, force), [force]);
  return (
    <Frame
      title="Damped Duffing oscillator"
      tall
      note="Three seeds of x-double-prime = x − x³ − 0.25 x-prime + force times cos(t). Drag the force. Not a stability condition."
      draw={draw}
      controls={<Knob label="Force" value={force} min={0.05} max={0.8} step={0.01} onChange={setForce} />}
    />
  );
}

export function VelocityFigure() {
  const [focus, setFocus] = useState(1);
  const [bend, setBend] = useState(0.3);
  const draw = useMemo(
    () => (ctx: Ctx, w: number, h: number) => velocity(ctx, w, h, focus, bend),
    [focus, bend],
  );
  return (
    <Frame
      title="Arrow field toward a focus"
      note="Arrows point at (0, focus). The curve is focus plus bend times beta squared. Drag the canvas to move the focus."
      draw={draw}
      controls={
        <>
          <Knob label="Focus height" value={focus} min={0.4} max={2.4} step={0.05} onChange={setFocus} />
          <Knob label="Bend" value={bend} min={0.05} max={0.8} step={0.01} onChange={setBend} />
        </>
      }
      onPick={(_u, v, _w, h) => setFocus(invertY(v, h, 0, 3))}
    />
  );
}

export function FunnelFigure() {
  const [turns, setTurns] = useState(16);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => funnel(ctx, w, h, turns), [turns]);
  return (
    <Frame
      title="Shrinking helices"
      tall
      note="Six helices. The slider sets how many turns the radius takes while the height rises."
      draw={draw}
      controls={<Knob label="Turns" value={turns} min={4} max={28} step={1} onChange={setTurns} />}
    />
  );
}

export function OrbitFigure() {
  const [mix, setMix] = useState(0.2);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => orbits(ctx, w, h, mix), [mix]);
  return (
    <Frame
      title="Three drawn loci"
      note="A parabola, a segment, and a sine wiggle. The mix changes all three. Not a limit as tau goes to infinity."
      draw={draw}
      controls={<Knob label="Mix" value={mix} min={0} max={1} step={0.01} onChange={setMix} />}
    />
  );
}

export function WaterfallFigure() {
  const [shift, setShift] = useState(0);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => waterfall(ctx, w, h, shift), [shift]);
  return (
    <Frame
      title="Two moving Gaussians"
      tall
      note="Peaks at −1.2 + 0.5 tau and 0.2 − 0.6 tau, then shifted by the slider. Not a Harder–Narasimhan density."
      draw={draw}
      controls={<Knob label="Peak shift" value={shift} min={-1.2} max={1.2} step={0.02} onChange={setShift} />}
    />
  );
}

export function NestedFigure() {
  const [scale, setScale] = useState(1);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => nested(ctx, w, h, scale), [scale]);
  return (
    <Frame
      title="Four nested semicircles"
      note="Centers and radii scale together. The submitted run of this panel drew only the axes."
      draw={draw}
      controls={<Knob label="Scale" value={scale} min={0.4} max={1.6} step={0.02} onChange={setScale} />}
    />
  );
}

export function HodgeFigure() {
  const [cell, setCell] = useState({ p: 2, q: 2 });
  const draw = useMemo(
    () => (ctx: Ctx, w: number, h: number) => hodge(ctx, w, h, cell.p, cell.q),
    [cell],
  );
  return (
    <Frame
      title="Painted 5 by 5 grid"
      note="Tap a cell. The number is a paint weight, not a Hodge number. The Hodge conjecture stays open."
      draw={draw}
      controls={
        <p className="mb-2 font-mono text-sm text-muted">
          selected ({cell.p}, {cell.q})
        </p>
      }
      onPick={(u, v, w, h) => {
        const size = Math.min(w, h) * 0.14;
        const p = Math.floor((u * w - w * 0.22) / size);
        const q = Math.floor((v * h - h * 0.16) / size);
        if (p >= 0 && p < 5 && q >= 0 && q < 5) setCell({ p, q });
      }}
    />
  );
}

export function HyperbolaFigure() {
  const [stretch, setStretch] = useState(1);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => hyperbolas(ctx, w, h, stretch), [stretch]);
  return (
    <Frame
      title="Three hyperbolic branches"
      note="alpha is the square root of floor squared plus stretch times (beta − center) squared."
      draw={draw}
      controls={<Knob label="Stretch" value={stretch} min={0.2} max={3} step={0.05} onChange={setStretch} />}
    />
  );
}

export function VolumeFigure() {
  const [lead, setLead] = useState(1);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => volume(ctx, w, h, lead), [lead]);
  return (
    <Frame
      title="Semicircles with a fixed right foot"
      note="Scales 1, 1.5, 2, and 2.5, then multiplied by the slider. The right endpoint stays put."
      draw={draw}
      controls={<Knob label="Lead scale" value={lead} min={0.5} max={1.4} step={0.02} onChange={setLead} />}
    />
  );
}

export function DenseFigure() {
  const [count, setCount] = useState(22);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => dense(ctx, w, h, count), [count]);
  return (
    <Frame
      title="Fan of semicircles"
      note="The slider sets how many arcs are drawn. A fan, not a count of topological fractures."
      draw={draw}
      controls={<Knob label="Arc count" value={count} min={4} max={30} step={1} onChange={setCount} />}
    />
  );
}

export function TrackFigure() {
  const [beta, setBeta] = useState(0.4);
  const [alpha, setAlpha] = useState(1.2);
  const [radius, setRadius] = useState(1.5);
  const inside = (beta + 0.5) ** 2 + alpha ** 2 <= radius ** 2;
  const draw = useMemo(
    () => (ctx: Ctx, w: number, h: number) => track(ctx, w, h, beta, alpha, radius),
    [beta, alpha, radius],
  );
  return (
    <Frame
      title="Point against one semicircle"
      note="Drag the point. Inside when (beta + 0.5) squared plus alpha squared is at most radius squared. Not a Harder–Narasimhan filtration."
      draw={draw}
      controls={
        <>
          <p className="mb-2 font-mono text-sm text-muted">inside {String(inside)}</p>
          <Knob label="Beta" value={beta} min={-2.4} max={1.4} step={0.05} onChange={setBeta} />
          <Knob label="Alpha" value={alpha} min={0} max={2.4} step={0.05} onChange={setAlpha} />
          <Knob label="Radius" value={radius} min={0.4} max={2.2} step={0.05} onChange={setRadius} />
        </>
      }
      onPick={(u, v, w, h) => {
        setBeta(invertX(u, w, -2.6, 1.6));
        setAlpha(invertY(v, h, 0, 2.6));
      }}
    />
  );
}

export function ChamberFigure() {
  const [beta, setBeta] = useState(0);
  const [alpha, setAlpha] = useState(1.2);
  const [scale, setScale] = useState(1);
  const walls = [
    { c: 0, r: 0.85 * scale },
    { c: 0.15, r: 1.35 * scale },
    { c: 0, r: 2.15 * scale },
  ];
  const count = walls.filter((wall) => (beta - wall.c) ** 2 + alpha ** 2 <= wall.r ** 2).length;
  const draw = useMemo(
    () => (ctx: Ctx, w: number, h: number) => chambers(ctx, w, h, beta, alpha, scale),
    [beta, alpha, scale],
  );
  return (
    <Frame
      title="Point against three circles"
      note="Drag the point. The count is how many drawn disks contain it. It does not name an ideal sheaf."
      draw={draw}
      controls={
        <>
          <p className="mb-2 font-mono text-sm text-muted">circles containing the point {count}</p>
          <Knob label="Beta" value={beta} min={-2.6} max={2.6} step={0.05} onChange={setBeta} />
          <Knob label="Alpha" value={alpha} min={0} max={2.4} step={0.05} onChange={setAlpha} />
          <Knob label="Radius scale" value={scale} min={0.5} max={1.4} step={0.02} onChange={setScale} />
        </>
      }
      onPick={(u, v, w, h) => {
        setBeta(invertX(u, w, -3, 3));
        setAlpha(invertY(v, h, 0, 2.6));
      }}
    />
  );
}

export function BogomolovFigure() {
  const [half, setHalf] = useState(0.5);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => bogomolov(ctx, w, h, half), [half]);
  return (
    <Frame
      title="Discriminant side of the parabola"
      note="The curve is ch2/r = coefficient times (c1/r) squared. For positive rank the nonnegative side of Delta is under the curve."
      draw={draw}
      controls={<Knob label="Coefficient" value={half} min={0.1} max={1.2} step={0.02} onChange={setHalf} />}
    />
  );
}

export function StreamFigure() {
  const [radius, setRadius] = useState(1);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => stream(ctx, w, h, radius), [radius]);
  return (
    <Frame
      title="Sampled arrow field"
      note="Inside the semicircle the arrows rotate. Outside they point up. The slider sets that radius."
      draw={draw}
      controls={<Knob label="Wall radius" value={radius} min={0.4} max={1.8} step={0.05} onChange={setRadius} />}
    />
  );
}

export function SurfaceFigure() {
  const [tilt, setTilt] = useState(0.2);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => surface(ctx, w, h, tilt), [tilt]);
  return (
    <Frame
      title="ch3 multiplier on a semicircle"
      tall
      note="Height is the semicircle times (1 + tilt times ch3 times (beta − center)). Center −0.5, radius 1.15."
      draw={draw}
      controls={<Knob label="Tilt" value={tilt} min={0} max={0.6} step={0.01} onChange={setTilt} />}
    />
  );
}

export function DeformedFigure() {
  const [pole, setPole] = useState(2);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => deformed(ctx, w, h, pole), [pole]);
  return (
    <Frame
      title="Semicircle plus a pole"
      note="Each curve is a semicircle joined to 1 over (pole − beta). The second pole sits one unit to the right."
      draw={draw}
      controls={<Knob label="Pole" value={pole} min={1.2} max={3.2} step={0.05} onChange={setPole} />}
    />
  );
}

export function LociFigure() {
  const [scale, setScale] = useState(1);
  const draw = useMemo(() => (ctx: Ctx, w: number, h: number) => loci(ctx, w, h, scale), [scale]);
  return (
    <Frame
      title="Four semicircles in the plane"
      note="The center formula does not fix the radius. The slider scales the four chosen radii."
      draw={draw}
      controls={<Knob label="Radius scale" value={scale} min={0.4} max={1.6} step={0.02} onChange={setScale} />}
    />
  );
}
