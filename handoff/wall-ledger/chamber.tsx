import { useEffect, useRef } from "react";
import {
  GOLD,
  GRID,
  HODGE,
  PAPER,
  ROSE,
  SAMPLES,
  STEEL,
  cutZ,
  duffingDeriv,
  flowVelocity,
  hodgeColor,
  hodgePose,
  modelOf,
  parabolaHeight,
  ridgeHeight,
  sampleAt,
  sheetHeight,
  type ChamberState,
  type Curve,
} from "@/chamber/model";

const POOL = 32;
const FLOW_N = 160;
const TRAIL = 640;

export function Chamber({
  stateRef,
  onPick,
  onProbe,
}: {
  stateRef: React.RefObject<ChamberState>;
  onPick: (label: string) => void;
  onProbe: (beta: number, alpha: number) => void;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const pickRef = useRef(onPick);
  const probeRef = useRef(onProbe);
  pickRef.current = onPick;
  probeRef.current = onProbe;

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    let dispose = () => {};
    let cancel = false;
    import("three").then((THREE) => {
      if (cancel || !canvasRef.current) return;
      dispose = start(THREE, canvasRef.current, stateRef, pickRef, probeRef);
    });
    return () => {
      cancel = true;
      dispose();
    };
  }, [stateRef]);

  return <canvas ref={canvasRef} className="stage-canvas" aria-label="Stability volume" />;
}

function start(
  THREE: typeof import("three"),
  canvas: HTMLCanvasElement,
  stateRef: React.RefObject<ChamberState>,
  pickRef: React.RefObject<(label: string) => void>,
  probeRef: React.RefObject<(beta: number, alpha: number) => void>,
) {
  const renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: false, powerPreference: "high-performance" });
  renderer.setClearColor(0x0c0e14, 1);
  renderer.setPixelRatio(Math.min(2, window.devicePixelRatio || 1));

  const scene = new THREE.Scene();
  scene.fog = new THREE.FogExp2(0x0c0e14, 0.055);
  const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 80);

  scene.add(new THREE.AmbientLight(0xe7e1d4, 0.45));
  scene.add(new THREE.HemisphereLight(0xe7e1d4, 0x10141c, 0.4));
  const key = new THREE.DirectionalLight(0xe7e1d4, 1.25);
  key.position.set(5, 8, 4);
  scene.add(key);
  const fill = new THREE.DirectionalLight(0x7ea2d4, 0.4);
  fill.position.set(-6, 3, -3);
  scene.add(fill);

  scene.add(buildGrid(THREE));
  scene.add(axis(THREE, new THREE.Vector3(3.3, 0, 0), GOLD));
  scene.add(axis(THREE, new THREE.Vector3(0, 3.05, 0), STEEL));
  scene.add(axis(THREE, new THREE.Vector3(0, 0, 2.15), ROSE));

  const slice = new THREE.Mesh(
    new THREE.PlaneGeometry(7.2, 3.25),
    new THREE.MeshBasicMaterial({
      color: STEEL,
      transparent: true,
      opacity: 0.07,
      side: THREE.DoubleSide,
      depthWrite: false,
    }),
  );
  slice.position.set(-0.2, 1.58, 0);
  const frame = new THREE.LineLoop(
    new THREE.BufferGeometry().setFromPoints([
      new THREE.Vector3(-3.6, -1.62, 0),
      new THREE.Vector3(3.6, -1.62, 0),
      new THREE.Vector3(3.6, 1.62, 0),
      new THREE.Vector3(-3.6, 1.62, 0),
    ]),
    new THREE.LineBasicMaterial({ color: STEEL, transparent: true, opacity: 0.55 }),
  );
  slice.add(frame);
  scene.add(slice);

  const ribbons = Array.from({ length: POOL }, () => makeRibbon(THREE));
  ribbons.forEach((item) => {
    scene.add(item.ribbon);
    scene.add(item.line);
  });

  const sheetGeo = gridGeometry(THREE, 72, 42);
  const sheet = new THREE.Mesh(
    sheetGeo,
    new THREE.MeshStandardMaterial({
      vertexColors: true,
      roughness: 0.48,
      metalness: 0.04,
      side: THREE.DoubleSide,
    }),
  );
  const wire = new THREE.Mesh(
    sheetGeo,
    new THREE.MeshBasicMaterial({ color: PAPER, wireframe: true, transparent: true, opacity: 0.1 }),
  );
  scene.add(sheet);
  scene.add(wire);

  const flowGeo = new THREE.BufferGeometry();
  const flowPos = new Float32Array(FLOW_N * 2 * 3);
  flowGeo.setAttribute("position", new THREE.BufferAttribute(flowPos, 3));
  const flowLines = new THREE.LineSegments(
    flowGeo,
    new THREE.LineBasicMaterial({ color: STEEL, transparent: true, opacity: 0.75 }),
  );
  scene.add(flowLines);
  const flowPts = Array.from({ length: FLOW_N }, () => ({
    x: -2.4 + Math.random() * 4.6,
    y: 0.15 + Math.random() * 2.4,
    z: -1.6 + Math.random() * 3.2,
  }));

  const ridersGeo = new THREE.BufferGeometry();
  const riderPos = new Float32Array(POOL * 6 * 3);
  ridersGeo.setAttribute("position", new THREE.BufferAttribute(riderPos, 3));
  const riders = new THREE.Points(
    ridersGeo,
    new THREE.PointsMaterial({ color: PAPER, size: 0.045, transparent: true, opacity: 0.85, depthWrite: false, sizeAttenuation: true }),
  );
  scene.add(riders);

  const trails = [GOLD, STEEL, ROSE].map((color, i) => makeTrail(THREE, color, i));
  trails.forEach((trail) => {
    scene.add(trail.line);
    scene.add(trail.head);
  });

  const diamond = buildDiamond(THREE);
  scene.add(diamond.mesh);

  const probeMat = new THREE.MeshStandardMaterial({ color: GOLD, emissive: GOLD, emissiveIntensity: 0.6, roughness: 0.28 });
  const probe = new THREE.Mesh(new THREE.SphereGeometry(0.08, 28, 28), probeMat);
  scene.add(probe);
  const dropGeo = new THREE.BufferGeometry();
  dropGeo.setAttribute("position", new THREE.BufferAttribute(new Float32Array(6), 3));
  const drop = new THREE.Line(dropGeo, new THREE.LineBasicMaterial({ color: GOLD, transparent: true, opacity: 0.8 }));
  scene.add(drop);

  let yaw = 0.95;
  let pitch = 0.4;
  let radius = 9.4;
  const target = new THREE.Vector3(-0.15, 1.08, 0.05);
  let dragging = false;
  let moved = 0;
  let lastX = 0;
  let lastY = 0;
  let pointerX = 0;
  let pointerY = 0;
  let idleUntil = 0;
  let seenNonce = -1;
  const reducedMedia = window.matchMedia("(prefers-reduced-motion: reduce)");
  let reduced = reducedMedia.matches;
  const onReduce = () => {
    reduced = reducedMedia.matches;
  };
  reducedMedia.addEventListener("change", onReduce);

  const placeCamera = () => {
    camera.position.set(
      target.x + radius * Math.cos(pitch) * Math.sin(yaw),
      target.y + radius * Math.sin(pitch),
      target.z + radius * Math.cos(pitch) * Math.cos(yaw),
    );
    camera.lookAt(target);
  };

  const resize = () => {
    const w = canvas.clientWidth || 1;
    const h = canvas.clientHeight || 1;
    renderer.setPixelRatio(Math.min(2, window.devicePixelRatio || 1));
    renderer.setSize(w, h, false);
    camera.aspect = w / Math.max(1, h);
    camera.updateProjectionMatrix();
  };
  resize();
  const observer = new ResizeObserver(resize);
  observer.observe(canvas);

  const onDown = (event: PointerEvent) => {
    dragging = true;
    moved = 0;
    lastX = event.clientX;
    lastY = event.clientY;
    pointerX = event.clientX;
    pointerY = event.clientY;
    canvas.setPointerCapture(event.pointerId);
  };
  const onMove = (event: PointerEvent) => {
    if (!dragging) return;
    const dx = event.clientX - lastX;
    const dy = event.clientY - lastY;
    moved += Math.abs(dx) + Math.abs(dy);
    lastX = event.clientX;
    lastY = event.clientY;
    pointerX = event.clientX;
    pointerY = event.clientY;
    const state = stateRef.current;
    if (!state) return;
    if (state.gesture === "probe" && state.mode !== "diamond") {
      state.probeB = clamp(state.probeB + dx * 0.008, -2.4, 2.3);
      state.probeA = clamp(state.probeA - dy * 0.008, 0.05, 2.85);
      probeRef.current?.(state.probeB, state.probeA);
      return;
    }
    yaw -= dx * 0.0055;
    pitch = clamp(pitch - dy * 0.0045, -0.15, 1.15);
    idleUntil = performance.now() + 2800;
  };
  const onUp = (event: PointerEvent) => {
    dragging = false;
    pointerX = event.clientX;
    pointerY = event.clientY;
    const state = stateRef.current;
    if (state?.mode === "diamond" && moved < 6) pickCell(THREE, camera, canvas, event, diamond, pickRef);
    idleUntil = performance.now() + 1600;
  };
  const onWheel = (event: WheelEvent) => {
    event.preventDefault();
    radius = clamp(radius * (event.deltaY > 0 ? 1.07 : 0.93), 4.2, 16);
  };
  canvas.addEventListener("pointerdown", onDown);
  canvas.addEventListener("pointermove", onMove);
  canvas.addEventListener("pointerup", onUp);
  canvas.addEventListener("pointercancel", onUp);
  canvas.addEventListener("wheel", onWheel, { passive: false });

  let raf = 0;
  let last = performance.now();
  const tick = (now: number) => {
    raf = requestAnimationFrame(tick);
    const dt = Math.min(0.033, (now - last) / 1000);
    last = now;
    const state = stateRef.current;
    if (!state) return;
    if (state.viewNonce !== seenNonce) {
      yaw = 0.95;
      pitch = 0.4;
      radius = 9.4;
      seenNonce = state.viewNonce;
    }
    if (!reduced && !dragging && now > idleUntil) yaw += dt * 0.18;
    placeCamera();
    const model = modelOf(state);
    const time = reduced ? 0 : now / 1000;
    slice.position.z = cutZ(state.cut);
    paintCurves(ribbons, model.curves, time);
    paintRiders(riders, riderPos, model.curves, time);
    paintSheet(THREE, sheet, wire, model, time);
    paintFlow(flowLines, flowPos, flowPts, model, state, dt, reduced);
    paintTrails(trails, model, dt, reduced, time);
    paintDiamond(THREE, diamond, model, state.picked);
    paintProbe(probe, probeMat, drop, model, state);
    renderer.render(scene, camera);
  };
  raf = requestAnimationFrame(tick);

  return () => {
    cancelAnimationFrame(raf);
    observer.disconnect();
    reducedMedia.removeEventListener("change", onReduce);
    canvas.removeEventListener("pointerdown", onDown);
    canvas.removeEventListener("pointermove", onMove);
    canvas.removeEventListener("pointerup", onUp);
    canvas.removeEventListener("pointercancel", onUp);
    canvas.removeEventListener("wheel", onWheel);
    renderer.dispose();
    scene.traverse((obj) => {
      const mesh = obj as import("three").Mesh;
      if (mesh.geometry) mesh.geometry.dispose();
      const mat = mesh.material as import("three").Material | import("three").Material[] | undefined;
      if (Array.isArray(mat)) mat.forEach((item) => item.dispose());
      else mat?.dispose();
    });
  };
}

function paintCurves(
  ribbons: ReturnType<typeof makeRibbon>[],
  curves: Curve[],
  time: number,
) {
  for (let i = 0; i < ribbons.length; i++) {
    const item = ribbons[i];
    const curve = curves[i];
    const show = Boolean(curve);
    item.ribbon.visible = show;
    item.line.visible = show;
    if (!curve) continue;
    const pos = item.ribbon.geometry.attributes.position as import("three").BufferAttribute;
    const linePos = item.line.geometry.attributes.position as import("three").BufferAttribute;
    for (let s = 0; s < SAMPLES; s++) {
      const p = sampleAt(curve, s, time);
      const prev = sampleAt(curve, Math.max(0, s - 1), time);
      const next = sampleAt(curve, Math.min(SAMPLES - 1, s + 1), time);
      let nx = -(next.y - prev.y);
      let ny = next.x - prev.x;
      const len = Math.hypot(nx, ny) || 1;
      const w = 0.03;
      nx = (nx / len) * w;
      ny = (ny / len) * w;
      pos.setXYZ(s * 2, p.x + nx, p.y + ny, p.z);
      pos.setXYZ(s * 2 + 1, p.x - nx, p.y - ny, p.z);
      linePos.setXYZ(s, p.x, p.y, p.z);
    }
    pos.needsUpdate = true;
    linePos.needsUpdate = true;
    item.ribbonMat.color.setHex(curve.color);
    item.ribbonMat.opacity = curve.opacity;
    item.lineMat.color.setHex(curve.color);
    item.lineMat.opacity = Math.min(1, curve.opacity + 0.15);
  }
}

function paintRiders(
  points: import("three").Points,
  buffer: Float32Array,
  curves: Curve[],
  time: number,
) {
  const attr = points.geometry.attributes.position as import("three").BufferAttribute;
  let n = 0;
  const alive = curves.filter((curve) => curve.kind === "arc" || curve.kind === "hyper" || curve.kind === "helix");
  for (let i = 0; i < alive.length && n < POOL * 6; i++) {
    for (let k = 0; k < 6 && n < POOL * 6; k++) {
      const p = sampleAt(alive[i], Math.floor(((time * 0.12 + k / 6 + i * 0.17) % 1) * (SAMPLES - 1)), time);
      buffer[n * 3] = p.x;
      buffer[n * 3 + 1] = p.y;
      buffer[n * 3 + 2] = p.z;
      n += 1;
    }
  }
  attr.needsUpdate = true;
  points.geometry.setDrawRange(0, n);
  points.visible = n > 0;
}

function paintSheet(
  THREE: typeof import("three"),
  sheet: import("three").Mesh,
  wire: import("three").Mesh,
  model: ReturnType<typeof modelOf>,
  time: number,
) {
  const show = model.surface !== "none";
  sheet.visible = show;
  wire.visible = show;
  if (!show) return;
  const pos = sheet.geometry.attributes.position as import("three").BufferAttribute;
  const col = sheet.geometry.attributes.color as import("three").BufferAttribute;
  const nx = 72;
  const nz = 42;
  const gold = new THREE.Color(GOLD);
  const steel = new THREE.Color(STEEL);
  const ink = new THREE.Color(0x10141c);
  const tone = new THREE.Color();
  for (let j = 0; j <= nz; j++) {
    for (let i = 0; i <= nx; i++) {
      const idx = j * (nx + 1) + i;
      let x = 0;
      let y = 0;
      let z = 0;
      if (model.surface === "parabola") {
        x = -2.3 + (4.6 * i) / nx;
        z = -1.8 + (3.6 * j) / nz;
        y = parabolaHeight(x, model.coeff);
      } else if (model.surface === "ridge") {
        x = -2.6 + (5.2 * i) / nx;
        const tau = j / nz;
        z = -1.8 + 3.6 * tau;
        y = ridgeHeight(x, tau, model.shift + Math.sin(time * 0.6) * 0.04);
      } else {
        x = -3 + (6 * i) / nx;
        const ch3 = -2 + (4 * j) / nz;
        z = ch3;
        y = sheetHeight(x, ch3, model.tilt, model.center, model.radius);
      }
      pos.setXYZ(idx, x, y, z);
      const t = Math.max(0, Math.min(1, y / 2.4));
      tone.copy(ink).lerp(steel, 0.35 + t * 0.3).lerp(gold, t);
      col.setXYZ(idx, tone.r, tone.g, tone.b);
    }
  }
  pos.needsUpdate = true;
  col.needsUpdate = true;
  sheet.geometry.computeVertexNormals();
}

function paintFlow(
  lines: import("three").LineSegments,
  buffer: Float32Array,
  pts: { x: number; y: number; z: number }[],
  model: ReturnType<typeof modelOf>,
  state: ChamberState,
  dt: number,
  reduced: boolean,
) {
  lines.visible = model.flow !== "none";
  if (model.flow === "none") return;
  const attr = lines.geometry.attributes.position as import("three").BufferAttribute;
  const step = reduced ? 0 : Math.min(0.05, dt);
  for (let i = 0; i < pts.length; i++) {
    const p = pts[i];
    const v = flowVelocity(p.x, p.y, p.z, model.flow, model.speed, state.probeB, state.probeA);
    const len = 0.18 + model.speed * 0.12;
    buffer[i * 6] = p.x;
    buffer[i * 6 + 1] = p.y;
    buffer[i * 6 + 2] = p.z;
    buffer[i * 6 + 3] = p.x + v.vx * len;
    buffer[i * 6 + 4] = p.y + v.vy * len;
    buffer[i * 6 + 5] = p.z + v.vz * len;
    p.x += v.vx * step;
    p.y += v.vy * step;
    p.z += v.vz * step;
    if (p.x < -2.7 || p.x > 2.5) p.x = -2.4 + Math.random() * 4.6;
    if (p.y < 0.08 || p.y > 2.85) p.y = 0.15 + Math.random() * 2.3;
    if (p.z < -1.9 || p.z > 1.9) p.z = -1.6 + Math.random() * 3.2;
  }
  attr.needsUpdate = true;
  const mat = lines.material as import("three").LineBasicMaterial;
  mat.color.setHex(model.flow === "focus" ? ROSE : STEEL);
}

function paintTrails(
  trails: ReturnType<typeof makeTrail>[],
  model: ReturnType<typeof modelOf>,
  dt: number,
  reduced: boolean,
  time: number,
) {
  for (const trail of trails) {
    trail.line.visible = model.attractor;
    trail.head.visible = model.attractor;
    if (!model.attractor) continue;
    if (!trail.warm || Math.abs(trail.lastDrive - model.drive) > 0.05) {
      trail.x = trail.seedX;
      trail.v = trail.seedV;
      trail.t = trail.seedT;
      const h = 0.018;
      for (let s = 0; s < TRAIL; s++) {
        const [dx1, dv1] = duffingDeriv(trail.x, trail.v, trail.t, model.drive);
        const [dx2, dv2] = duffingDeriv(trail.x + dx1 * h, trail.v + dv1 * h, trail.t + h, model.drive);
        trail.x += ((dx1 + dx2) * 0.5) * h;
        trail.v += ((dv1 + dv2) * 0.5) * h;
        trail.t += h;
        trail.hist[s * 3] = trail.x * 1.15;
        trail.hist[s * 3 + 1] = trail.v * 1.05 + 1.25;
        trail.hist[s * 3 + 2] = 1.35 * Math.cos(trail.t);
      }
      trail.headIndex = TRAIL - 1;
      trail.warm = true;
      trail.lastDrive = model.drive;
    }
    const steps = reduced ? 0 : 7;
    const h = Math.min(0.02, dt / Math.max(1, steps));
    for (let s = 0; s < steps; s++) {
      const [dx1, dv1] = duffingDeriv(trail.x, trail.v, trail.t, model.drive);
      const [dx2, dv2] = duffingDeriv(trail.x + dx1 * h, trail.v + dv1 * h, trail.t + h, model.drive);
      trail.x += ((dx1 + dx2) * 0.5) * h;
      trail.v += ((dv1 + dv2) * 0.5) * h;
      trail.t += h;
      if (!Number.isFinite(trail.x) || Math.abs(trail.x) > 3.2 || Math.abs(trail.v) > 3.2) {
        trail.x = trail.seedX;
        trail.v = trail.seedV;
        trail.t = time + trail.seedT;
      }
      trail.headIndex = (trail.headIndex + 1) % TRAIL;
      const o = trail.headIndex * 3;
      trail.hist[o] = trail.x * 1.15;
      trail.hist[o + 1] = trail.v * 1.05 + 1.25;
      trail.hist[o + 2] = 1.35 * Math.cos(trail.t);
    }
    const pos = trail.line.geometry.attributes.position as import("three").BufferAttribute;
    const col = trail.line.geometry.attributes.color as import("three").BufferAttribute;
    for (let i = 0; i < TRAIL; i++) {
      const src = ((trail.headIndex + 1 + i) % TRAIL) * 3;
      pos.setXYZ(i, trail.hist[src], trail.hist[src + 1], trail.hist[src + 2]);
      const fade = i / (TRAIL - 1);
      col.setXYZ(i, trail.rgb[0] * fade, trail.rgb[1] * fade, trail.rgb[2] * fade);
    }
    pos.needsUpdate = true;
    col.needsUpdate = true;
    const tip = trail.headIndex * 3;
    trail.head.position.set(trail.hist[tip], trail.hist[tip + 1], trail.hist[tip + 2]);
  }
}

function paintDiamond(
  THREE: typeof import("three"),
  diamond: ReturnType<typeof buildDiamond>,
  model: ReturnType<typeof modelOf>,
  picked: string,
) {
  diamond.mesh.visible = model.diamond;
  if (!model.diamond) return;
  const dummy = diamond.dummy;
  HODGE.forEach((cell, i) => {
    const pose = hodgePose(cell.p, cell.q, cell.n, model.lift);
    const label = `h(${cell.p},${cell.q}) = ${cell.n}`;
    dummy.position.set(pose.x, pose.y, pose.z);
    dummy.scale.set(0.34, Math.max(0.04, pose.h), 0.34);
    dummy.rotation.set(0, 0, 0);
    dummy.updateMatrix();
    diamond.mesh.setMatrixAt(i, dummy.matrix);
    const color = new THREE.Color(label === picked ? PAPER : hodgeColor(cell.p, cell.q, cell.n));
    diamond.mesh.setColorAt(i, color);
  });
  diamond.mesh.instanceMatrix.needsUpdate = true;
  if (diamond.mesh.instanceColor) diamond.mesh.instanceColor.needsUpdate = true;
}

function paintProbe(
  probe: import("three").Mesh,
  mat: import("three").MeshStandardMaterial,
  drop: import("three").Line,
  model: ReturnType<typeof modelOf>,
  state: ChamberState,
) {
  probe.visible = model.probe;
  drop.visible = model.probe;
  if (!model.probe) return;
  const z = cutZ(state.cut);
  probe.position.set(state.probeB, state.probeA, z);
  const hex = model.probeInside ? GOLD : ROSE;
  mat.color.setHex(hex);
  mat.emissive.setHex(hex);
  const pos = drop.geometry.attributes.position as import("three").BufferAttribute;
  pos.setXYZ(0, state.probeB, 0, z);
  pos.setXYZ(1, state.probeB, state.probeA, z);
  pos.needsUpdate = true;
  (drop.material as import("three").LineBasicMaterial).color.setHex(hex);
}

function pickCell(
  THREE: typeof import("three"),
  camera: import("three").PerspectiveCamera,
  canvas: HTMLCanvasElement,
  event: PointerEvent,
  diamond: ReturnType<typeof buildDiamond>,
  pickRef: React.RefObject<(label: string) => void>,
) {
  const rect = canvas.getBoundingClientRect();
  const ndc = new THREE.Vector2(
    ((event.clientX - rect.left) / rect.width) * 2 - 1,
    -((event.clientY - rect.top) / rect.height) * 2 + 1,
  );
  const ray = new THREE.Raycaster();
  ray.setFromCamera(ndc, camera);
  const hits = ray.intersectObject(diamond.mesh);
  const id = hits[0]?.instanceId;
  if (id == null || !HODGE[id]) return;
  const cell = HODGE[id];
  pickRef.current?.(`h(${cell.p},${cell.q}) = ${cell.n}`);
}

function makeRibbon(THREE: typeof import("three")) {
  const positions = new Float32Array(SAMPLES * 2 * 3);
  const indices: number[] = [];
  for (let i = 0; i < SAMPLES - 1; i++) {
    const a = i * 2;
    indices.push(a, a + 1, a + 2, a + 1, a + 3, a + 2);
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute("position", new THREE.BufferAttribute(positions, 3));
  geo.setIndex(indices);
  const ribbonMat = new THREE.MeshBasicMaterial({
    color: GOLD,
    transparent: true,
    opacity: 0.85,
    side: THREE.DoubleSide,
    depthWrite: false,
  });
  const ribbon = new THREE.Mesh(geo, ribbonMat);
  const lineGeo = new THREE.BufferGeometry();
  lineGeo.setAttribute("position", new THREE.BufferAttribute(new Float32Array(SAMPLES * 3), 3));
  const lineMat = new THREE.LineBasicMaterial({ color: PAPER, transparent: true, opacity: 0.9 });
  const line = new THREE.Line(lineGeo, lineMat);
  ribbon.visible = false;
  line.visible = false;
  return { ribbon, line, ribbonMat, lineMat };
}

function gridGeometry(THREE: typeof import("three"), nx: number, nz: number) {
  const count = (nx + 1) * (nz + 1);
  const positions = new Float32Array(count * 3);
  const colors = new Float32Array(count * 3);
  const indices: number[] = [];
  for (let j = 0; j < nz; j++) {
    for (let i = 0; i < nx; i++) {
      const a = j * (nx + 1) + i;
      const b = a + 1;
      const c = a + (nx + 1);
      const d = c + 1;
      indices.push(a, c, b, b, c, d);
    }
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute("position", new THREE.BufferAttribute(positions, 3));
  geo.setAttribute("color", new THREE.BufferAttribute(colors, 3));
  geo.setIndex(indices);
  geo.computeVertexNormals();
  return geo;
}

function buildGrid(THREE: typeof import("three")) {
  const pts: import("three").Vector3[] = [];
  for (let i = 0; i <= 14; i++) {
    const x = -3.5 + i * 0.5;
    pts.push(new THREE.Vector3(x, 0, -2.2), new THREE.Vector3(x, 0, 2.2));
  }
  for (let i = 0; i <= 10; i++) {
    const z = -2.2 + i * 0.44;
    pts.push(new THREE.Vector3(-3.5, 0, z), new THREE.Vector3(3.5, 0, z));
  }
  return new THREE.LineSegments(
    new THREE.BufferGeometry().setFromPoints(pts),
    new THREE.LineBasicMaterial({ color: GRID }),
  );
}

function axis(THREE: typeof import("three"), dir: import("three").Vector3, color: number) {
  return new THREE.Line(
    new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(), dir]),
    new THREE.LineBasicMaterial({ color }),
  );
}

function makeTrail(THREE: typeof import("three"), color: number, index: number) {
  const seeds = [
    { x: 0.22, v: 0, t: 0 },
    { x: -0.38, v: 0.16, t: 1.7 },
    { x: 0.52, v: -0.22, t: 3.2 },
  ];
  const seed = seeds[index];
  const hist = new Float32Array(TRAIL * 3);
  for (let i = 0; i < TRAIL; i++) {
    hist[i * 3 + 1] = 1.25;
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute("position", new THREE.BufferAttribute(new Float32Array(TRAIL * 3), 3));
  geo.setAttribute("color", new THREE.BufferAttribute(new Float32Array(TRAIL * 3), 3));
  const line = new THREE.Line(geo, new THREE.LineBasicMaterial({ vertexColors: true }));
  const tone = new THREE.Color(color);
  const head = new THREE.Mesh(
    new THREE.SphereGeometry(0.055, 16, 16),
    new THREE.MeshStandardMaterial({ color, emissive: color, emissiveIntensity: 0.7, roughness: 0.3 }),
  );
  return {
    line,
    head,
    hist,
    headIndex: 0,
    x: seed.x,
    v: seed.v,
    t: seed.t,
    seedX: seed.x,
    seedV: seed.v,
    seedT: seed.t,
    rgb: [tone.r, tone.g, tone.b] as [number, number, number],
    warm: false,
    lastDrive: -1,
  };
}

function buildDiamond(THREE: typeof import("three")) {
  const geo = new THREE.BoxGeometry(1, 1, 1);
  const mat = new THREE.MeshStandardMaterial({ roughness: 0.42, metalness: 0.08 });
  const mesh = new THREE.InstancedMesh(geo, mat, HODGE.length);
  mesh.instanceMatrix.setUsage(THREE.DynamicDrawUsage);
  const dummy = new THREE.Object3D();
  HODGE.forEach((cell, i) => {
    const pose = hodgePose(cell.p, cell.q, cell.n, 0.7);
    dummy.position.set(pose.x, pose.y, pose.z);
    dummy.scale.set(0.34, pose.h, 0.34);
    dummy.updateMatrix();
    mesh.setMatrixAt(i, dummy.matrix);
    mesh.setColorAt(i, new THREE.Color(hodgeColor(cell.p, cell.q, cell.n)));
  });
  mesh.visible = false;
  return { mesh, dummy };
}

function clamp(n: number, a: number, b: number) {
  return Math.min(b, Math.max(a, n));
}
