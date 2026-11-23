export const MODES = [
  {
    id: "sheet",
    label: "ch3 sheet",
    gainLabel: "Tilt",
    gain: 0.62,
    cut: 0.55,
    probe: false,
    blurb: "One wall, lifted along a third Chern coordinate. The glass plane cuts a single contour out of the sheet.",
  },
  {
    id: "nested",
    label: "Nested walls",
    gainLabel: "Scale",
    gain: 0.48,
    cut: 0.42,
    probe: false,
    blurb: "The same semicircle at seven radii, set back through depth so the nest is a corridor, not a stack of ink.",
  },
  {
    id: "fan",
    label: "Dense fan",
    gainLabel: "Count",
    gain: 0.58,
    cut: 0.5,
    probe: false,
    blurb: "A family of arcs separated in depth. Crossings that looked like a scribble on a page are just arcs passing in front of each other.",
  },
  {
    id: "loci",
    label: "Four loci",
    gainLabel: "Spread",
    gain: 0.4,
    cut: 0.5,
    probe: false,
    blurb: "Four stand-in arcs of one parent charge against four sub-triples. Spread pushes them apart along depth.",
  },
  {
    id: "volume",
    label: "Volume scales",
    gainLabel: "Range",
    gain: 0.66,
    cut: 0.36,
    probe: false,
    blurb: "One wall rewritten at increasing volume scales and stood in a row through the volume.",
  },
  {
    id: "branches",
    label: "Branches",
    gainLabel: "Stretch",
    gain: 0.46,
    cut: 0.5,
    probe: false,
    blurb: "A negative square opens a hyperbola. Stretch opens the arms. Three copies sit at different depths.",
  },
  {
    id: "track",
    label: "One wall",
    gainLabel: "Radius",
    gain: 0.5,
    cut: 0.5,
    probe: true,
    blurb: "The arc is extruded through depth. Drag the charge on the glass plane: under the arc, or outside it.",
  },
  {
    id: "chamber",
    label: "Three walls",
    gainLabel: "Scale",
    gain: 0.52,
    cut: 0.48,
    probe: true,
    blurb: "Three extruded arcs. The charge on the cut reports how many of them contain it.",
  },
  {
    id: "parabola",
    label: "Bogomolov",
    gainLabel: "Coefficient",
    gain: 0.36,
    cut: 0.5,
    probe: true,
    blurb: "The boundary is a parabolic cylinder. The side under the sheet is the Δ ≥ 0 side of the inequality.",
  },
  {
    id: "stream",
    label: "Gieseker flow",
    gainLabel: "Speed",
    gain: 0.5,
    cut: 0.5,
    probe: false,
    blurb: "A vector field in the slab, drifting toward one principal wall. Arrows, not a Harder–Narasimhan filtration.",
  },
  {
    id: "focus",
    label: "Focal field",
    gainLabel: "Stiffness",
    gain: 0.55,
    cut: 0.5,
    probe: true,
    blurb: "Drag the node. The field in the slab contracts toward that point.",
  },
  {
    id: "orbits",
    label: "Orbits",
    gainLabel: "Mix",
    gain: 0.74,
    cut: 0.5,
    probe: false,
    blurb: "Three trajectories. As the mix rises they settle onto a parabolic locus instead of winding forever.",
  },
  {
    id: "poles",
    label: "Deformed poles",
    gainLabel: "Gap",
    gain: 0.42,
    cut: 0.5,
    probe: false,
    blurb: "Two walls. The gap is their separation along the slope axis, copied back through depth.",
  },
  {
    id: "ridges",
    label: "Ridges",
    gainLabel: "Shift",
    gain: 0.34,
    cut: 0.52,
    probe: false,
    blurb: "Gaussian ridges. Depth is the variety parameter, so the peaks walk as you move through the solid.",
  },
  {
    id: "funnel",
    label: "Funnel",
    gainLabel: "Turns",
    gain: 0.42,
    cut: 0.28,
    probe: false,
    blurb: "Helices tightening onto a core. Orbit around them — the depth is the radius collapsing, not a second plot.",
  },
  {
    id: "attractor",
    label: "Duffing",
    gainLabel: "Drive",
    gain: 0.48,
    cut: 0.5,
    probe: false,
    blurb: "A forced Duffing oscillator. The third axis is cos(ωt), the honest suspension of a non-autonomous equation.",
  },
  {
    id: "diamond",
    label: "Hodge diamond",
    gainLabel: "Lift",
    gain: 0.72,
    cut: 0.5,
    probe: false,
    blurb: "Textbook Hodge numbers of a smooth cubic fourfold. The tall cell is h(2,2) = 21. Tap a cell. This does not produce a cycle.",
  },
  {
    id: "pairing",
    label: "Pairing",
    gainLabel: "Ghosts",
    gain: 0.55,
    cut: 0.5,
    probe: false,
    blurb: "Square is c² − 2rs. Positive squares are drawn as semicircles, negative squares as hyperbolas, then stepped back into the volume.",
  },
] as const;

export type ModeId = (typeof MODES)[number]["id"];

export type Gesture = "orbit" | "probe";

export type ChamberState = {
  mode: ModeId;
  cut: number;
  gain: number;
  probeB: number;
  probeA: number;
  r: number;
  c: number;
  s: number;
  viewNonce: number;
  gesture: Gesture;
  picked: string;
};

export type Vec3 = { x: number; y: number; z: number };

export type Curve =
  | { kind: "arc"; center: number; radius: number; z: number; color: number; opacity: number }
  | { kind: "hyper"; a: number; b: number; center: number; z: number; color: number; opacity: number }
  | { kind: "helix"; phase: number; turns: number; color: number; opacity: number }
  | { kind: "orbit"; lane: number; mix: number; color: number; opacity: number };

export type SurfaceKind = "wall" | "ridge" | "parabola" | "none";
export type FlowKind = "stream" | "focus" | "none";

export type Model = {
  note: string;
  curves: Curve[];
  surface: SurfaceKind;
  tilt: number;
  center: number;
  radius: number;
  coeff: number;
  shift: number;
  flow: FlowKind;
  speed: number;
  attractor: boolean;
  drive: number;
  diamond: boolean;
  lift: number;
  probe: boolean;
  probeInside: boolean;
};

export const SAMPLES = 81;
export const GOLD = 0xc6a15b;
export const STEEL = 0x7ea2d4;
export const ROSE = 0xc4787a;
export const PAPER = 0xe7e1d4;
export const GRID = 0x2a3140;

const PALETTE = [GOLD, STEEL, PAPER, ROSE];

type Vec = { r: number; c: number; s: number };

export function square(v: Vec) {
  return v.c * v.c - 2 * v.r * v.s;
}

export function cutZ(cut: number) {
  return -1.8 + clamp01(cut) * 3.6;
}

export function wallHeight(beta: number, center: number, radius: number) {
  const under = radius * radius - (beta - center) * (beta - center);
  return under > 0 ? Math.sqrt(under) : 0;
}

export function sheetHeight(beta: number, ch3: number, tilt: number, center: number, radius: number) {
  const base = wallHeight(beta, center, radius);
  if (base <= 0) return 0;
  const amp = 1 + 0.22 * ch3 * tilt * (beta - center);
  return Math.max(0, base * amp);
}

export function ridgeHeight(beta: number, tau: number, shift: number) {
  const t = clamp01(tau + shift * 0.35);
  const p1 = -1.2 + 0.55 * t;
  const p2 = 0.25 - 0.7 * t;
  const a = Math.exp(-((beta - p1) ** 2) / 0.09) * (1.05 - 0.4 * t);
  const b = Math.exp(-((beta - p2) ** 2) / 0.14) * (0.4 + 0.7 * t);
  return (a + b) * 1.35;
}

export function parabolaHeight(x: number, coeff: number) {
  return coeff * x * x;
}

export function standIn(parent: Vec, sub: Vec) {
  const den = sub.r * parent.c - parent.r * sub.c;
  if (den === 0 || sub.r === 0 || parent.r === 0) return null;
  const center = (sub.r * parent.s - parent.r * sub.s) / den;
  const radius = Math.sqrt(Math.abs(center * center + 2 * (sub.s / sub.r - parent.s / parent.r)));
  if (!Number.isFinite(radius) || radius < 0.05) return null;
  return { center, radius };
}

export function sampleAt(curve: Curve, index: number, time: number): Vec3 {
  const u = index / (SAMPLES - 1);
  if (curve.kind === "arc") {
    const t = Math.PI * u;
    return {
      x: curve.center + curve.radius * Math.cos(t),
      y: curve.radius * Math.sin(t),
      z: curve.z,
    };
  }
  if (curve.kind === "hyper") {
    const s = -1.5 + 3 * u;
    return {
      x: curve.center + curve.b * Math.sinh(s),
      y: curve.a * Math.cosh(s),
      z: curve.z,
    };
  }
  if (curve.kind === "helix") {
    const rad = 1.6 * (1 - u) + 0.05;
    const ang = u * Math.PI * 2 * (1.15 + curve.turns * 4.2) + curve.phase + time * 0.55;
    return { x: rad * Math.cos(ang), y: 0.1 + u * 2.75, z: rad * Math.sin(ang) };
  }
  const x = -2.3 + u * 4.7;
  const yLim = 0.22 + 0.2 * (x + 0.35) ** 2;
  const yFree = 1.45 + 0.5 * Math.sin(u * 9 + curve.lane * 2.1 + time * 0.7);
  const settle = u * curve.mix;
  return {
    x,
    y: yFree * (1 - settle) + yLim * settle,
    z: (curve.lane - 1) * 0.9,
  };
}

export function flowVelocity(
  x: number,
  y: number,
  z: number,
  flow: FlowKind,
  speed: number,
  probeB: number,
  probeA: number,
) {
  if (flow === "focus") {
    const stiff = 0.35 + speed * 1.4;
    return {
      vx: (probeB - x) * stiff,
      vy: (probeA - y) * stiff,
      vz: (cutZ(0.5) - z) * 0.25 * stiff,
    };
  }
  const center = -0.45;
  const radius = 1.15;
  const wall = wallHeight(x, center, radius);
  return {
    vx: -(x - center) * 0.28 * (0.4 + speed),
    vy: (wall - y) * 0.55 * (0.35 + speed),
    vz: Math.sin(x * 1.4 + z) * 0.12,
  };
}

export function duffingDeriv(x: number, v: number, t: number, drive: number): [number, number] {
  const dx = v;
  const dv = x - x * x * x - 0.18 * v + drive * Math.cos(1.15 * t);
  return [dx, dv];
}

const KNOWN: Record<string, number> = {
  "0,0": 1,
  "1,1": 1,
  "2,2": 21,
  "3,1": 1,
  "1,3": 1,
  "3,3": 1,
  "4,4": 1,
};

export function hodgeNumber(p: number, q: number) {
  return KNOWN[`${p},${q}`] ?? 0;
}

export const HODGE = Array.from({ length: 25 }, (_, i) => {
  const p = i % 5;
  const q = Math.floor(i / 5);
  return { p, q, n: hodgeNumber(p, q) };
});

export function hodgePose(p: number, q: number, n: number, lift: number) {
  const h = (n === 0 ? 0.04 : n === 1 ? 0.62 : 3.15) * (0.45 + lift);
  return { x: (p - q) * 0.78, y: h / 2, z: (p + q - 4) * 0.52, h };
}

export function hodgeColor(p: number, q: number, n: number) {
  if (n === 21) return STEEL;
  if ((p === 3 && q === 1) || (p === 1 && q === 3)) return ROSE;
  if (n === 1) return GOLD;
  return GRID;
}

export function modelOf(state: ChamberState): Model {
  const base: Model = {
    note: "",
    curves: [],
    surface: "none",
    tilt: 1,
    center: -0.35,
    radius: 1.25,
    coeff: 0.5,
    shift: 0,
    flow: "none",
    speed: state.gain,
    attractor: false,
    drive: 0.2,
    diamond: false,
    lift: state.gain,
    probe: false,
    probeInside: false,
  };
  const mode = state.mode;
  if (mode === "sheet") {
    base.surface = "wall";
    base.tilt = 0.35 + state.gain * 2.4;
    base.note = `tilt ${base.tilt.toFixed(2)} · cut ${cutZ(state.cut).toFixed(2)}`;
    return base;
  }
  if (mode === "ridges") {
    base.surface = "ridge";
    base.shift = state.gain;
    base.note = `peak shift ${base.shift.toFixed(2)} · depth runs τ`;
    return base;
  }
  if (mode === "parabola") {
    base.surface = "parabola";
    base.coeff = 0.18 + state.gain * 0.95;
    base.probe = true;
    const y = parabolaHeight(state.probeB, base.coeff);
    base.probeInside = state.probeA <= y;
    base.note = base.probeInside
      ? `under the sheet · Δ ≥ 0 side · coeff ${base.coeff.toFixed(2)}`
      : `above the sheet · coeff ${base.coeff.toFixed(2)}`;
    return base;
  }
  if (mode === "diamond") {
    base.diamond = true;
    base.note = `${state.picked} · smooth cubic fourfold`;
    return base;
  }
  if (mode === "attractor") {
    base.attractor = true;
    base.drive = 0.12 + state.gain * 0.72;
    base.note = `drive ${base.drive.toFixed(2)} · x″ + 0.18 x′ − x + x³ = γ cos(ωt)`;
    return base;
  }
  if (mode === "stream") {
    base.flow = "stream";
    base.curves = extruded({ center: -0.45, radius: 1.15 }, 5, GOLD, state.cut);
    base.note = `speed ${(0.35 + state.gain).toFixed(2)} · drifting toward one wall`;
    return base;
  }
  if (mode === "focus") {
    base.flow = "focus";
    base.probe = true;
    base.probeInside = true;
    base.note = `node (${state.probeB.toFixed(2)}, ${state.probeA.toFixed(2)}) · stiffness ${(0.35 + state.gain * 1.4).toFixed(2)}`;
    return base;
  }
  if (mode === "funnel") {
    const turns = 0.25 + state.gain * 1.35;
    base.curves = [0, 1, 2, 3, 4].map((lane) => ({
      kind: "helix" as const,
      phase: lane * 1.25,
      turns,
      color: PALETTE[lane % PALETTE.length],
      opacity: 0.9,
    }));
    base.note = `turns ${turns.toFixed(2)} · radius collapses along the core`;
    return base;
  }
  if (mode === "orbits") {
    const mix = clamp01(state.gain);
    base.curves = [0, 1, 2].map((lane) => ({
      kind: "orbit" as const,
      lane,
      mix,
      color: PALETTE[lane],
      opacity: 0.92,
    }));
    base.note = `mix ${(mix * 100).toFixed(0)}% toward the parabolic locus`;
    return base;
  }
  if (mode === "branches") {
    const a = 0.38 + state.gain * 0.85;
    const b = 0.42 + state.gain * 0.7;
    base.curves = [0, 1, 2].map((i) => ({
      kind: "hyper" as const,
      a,
      b,
      center: -0.2 + (i - 1) * 0.15,
      z: zOf(i, 3),
      color: PALETTE[i],
      opacity: fade(zOf(i, 3), state.cut),
    }));
    base.note = `hyperbola · arms ${a.toFixed(2)} by ${b.toFixed(2)}`;
    return base;
  }
  if (mode === "nested") {
    const scale = 0.55 + state.gain * 1.15;
    const n = 7;
    base.curves = Array.from({ length: n }, (_, i) => {
      const z = zOf(i, n);
      return {
        kind: "arc" as const,
        center: -0.35,
        radius: scale * (0.42 + i * 0.3),
        z,
        color: PALETTE[i % PALETTE.length],
        opacity: fade(z, state.cut),
      };
    });
    base.note = `scale ${scale.toFixed(2)} · seven radii`;
    return base;
  }
  if (mode === "fan") {
    const n = 6 + Math.round(state.gain * 16);
    base.curves = Array.from({ length: n }, (_, i) => {
      const t = n === 1 ? 0 : i / (n - 1);
      const z = zOf(i, n);
      return {
        kind: "arc" as const,
        center: -1.7 + t * 2.5,
        radius: 0.55 + (i % 5) * 0.22,
        z,
        color: PALETTE[i % PALETTE.length],
        opacity: fade(z, state.cut),
      };
    });
    base.note = `${n} arcs · separated in depth`;
    return base;
  }
  if (mode === "loci" || mode === "pairing" || mode === "volume" || mode === "poles" || mode === "track" || mode === "chamber") {
    return chargeModel(state, base);
  }
  return base;
}

function chargeModel(state: ChamberState, base: Model): Model {
  const parent = { r: state.r, c: state.c, s: state.s };
  const subs: Vec[] = [
    { r: 1, c: -1, s: 0 },
    { r: 1, c: 0, s: 1 },
    { r: 2, c: 1, s: -2 },
    { r: 1, c: -2, s: 1 },
  ];
  if (state.mode === "volume") {
    const wall = standIn({ r: 2, c: 0, s: -1 }, subs[0]);
    const n = 6;
    if (wall) {
      base.curves = Array.from({ length: n }, (_, i) => {
        const z = zOf(i, n);
        const scale = 1 + (i / (n - 1)) * (0.25 + state.gain * 2.1);
        return {
          kind: "arc" as const,
          center: wall.center,
          radius: wall.radius * scale,
          z,
          color: PALETTE[i % PALETTE.length],
          opacity: fade(z, state.cut),
        };
      });
    }
    base.note = wall ? `scales ×1 to ×${(1 + 0.25 + state.gain * 2.1).toFixed(2)}` : "this pair has no wall";
    return base;
  }
  if (state.mode === "poles") {
    const gap = 0.45 + state.gain * 1.8;
    const walls = [
      { center: -gap / 2, radius: 0.95 },
      { center: gap / 2, radius: 0.8 },
    ];
    base.curves = walls.flatMap((wall, k) => extruded(wall, 4, PALETTE[k], state.cut));
    base.note = `gap ${gap.toFixed(2)} between the poles`;
    return base;
  }
  if (state.mode === "track") {
    const radius = 0.75 + state.gain * 1.45;
    const center = -0.3;
    base.curves = extruded({ center, radius }, 8, GOLD, state.cut);
    base.probe = true;
    const h = wallHeight(state.probeB, center, radius);
    base.probeInside = Math.abs(state.probeB - center) <= radius && state.probeA <= h;
    base.note = base.probeInside ? `under the arc · height ${h.toFixed(2)}` : `outside the arc · height ${h.toFixed(2)}`;
    return base;
  }
  if (state.mode === "chamber") {
    const scale = 0.75 + state.gain * 0.7;
    const walls = [
      { center: -1.15, radius: 0.95 * scale },
      { center: -0.15, radius: 1.2 * scale },
      { center: 0.85, radius: 0.8 * scale },
    ];
    base.curves = walls.flatMap((wall, k) => extruded(wall, 4, PALETTE[k], state.cut));
    base.probe = true;
    const hits = walls.filter((wall) => {
      const h = wallHeight(state.probeB, wall.center, wall.radius);
      return Math.abs(state.probeB - wall.center) <= wall.radius && state.probeA <= h;
    }).length;
    base.probeInside = hits > 0;
    base.note = `${hits} of 3 walls contain the charge`;
    return base;
  }
  if (state.mode === "loci") {
    const spread = 0.35 + state.gain * 1.4;
    const fixed = { r: 2, c: 0, s: -1 };
    subs.forEach((sub, i) => {
      const wall = standIn(fixed, sub);
      if (!wall) return;
      const z = -1.2 + i * spread * 0.55;
      base.curves.push({
        kind: "arc",
        center: wall.center,
        radius: wall.radius,
        z,
        color: PALETTE[i],
        opacity: fade(z, state.cut),
      });
    });
    base.note = `${base.curves.length} stand-in arcs · parent (2, 0, −1)`;
    return base;
  }
  const sq = square(parent);
  subs.forEach((sub, i) => {
    const wall = standIn(parent, sub);
    if (!wall) return;
    const z = zOf(i, subs.length);
    if (sq < 0) {
      base.curves.push({
        kind: "hyper",
        a: 0.34 + Math.min(1.2, Math.abs(sq) * 0.18),
        b: 0.4 + state.gain * 0.55,
        center: wall.center,
        z,
        color: PALETTE[i],
        opacity: fade(z, state.cut),
      });
    } else {
      base.curves.push({
        kind: "arc",
        center: wall.center,
        radius: wall.radius * (1 + (i === 0 ? 0 : state.gain * 0.08)),
        z,
        color: PALETTE[i],
        opacity: fade(z, state.cut),
      });
      if (state.gain > 0.2) {
        const zg = z + 0.55 + state.gain;
        base.curves.push({
          kind: "arc",
          center: wall.center,
          radius: wall.radius * (1.15 + state.gain * 0.35),
          z: zg,
          color: PALETTE[i],
          opacity: fade(zg, state.cut) * 0.55,
        });
      }
    }
  });
  base.note = `v = (${parent.r}, ${parent.c}, ${parent.s}) · square ${sq} · ${sq < 0 ? "hyperbola" : "semicircle"}`;
  return base;
}

function extruded(wall: { center: number; radius: number }, slices: number, color: number, cut: number): Curve[] {
  return Array.from({ length: slices }, (_, i) => {
    const z = zOf(i, slices);
    return {
      kind: "arc" as const,
      center: wall.center,
      radius: wall.radius,
      z,
      color,
      opacity: fade(z, cut),
    };
  });
}

function zOf(i: number, n: number) {
  if (n <= 1) return 0;
  return -1.8 + (3.6 * i) / (n - 1);
}

function fade(z: number, cut: number) {
  const d = Math.abs(z - cutZ(cut));
  return Math.max(0.16, 1 - d / 2.15);
}

function clamp01(n: number) {
  return Math.min(1, Math.max(0, n));
}
