export const ink = "#10141c";
export const grid = "#2a3140";
export const paper = "#e7e1d4";
export const muted = "#9c9488";
export const gold = "#c6a15b";
export const steel = "#7ea2d4";
export const rose = "#c4787a";

export type Ctx = CanvasRenderingContext2D;

export function clear(ctx: Ctx, w: number, h: number) {
  ctx.fillStyle = ink;
  ctx.fillRect(0, 0, w, h);
}

export function mapX(v: number, a: number, b: number, pad: number, w: number) {
  return pad + ((v - a) / (b - a)) * (w - pad * 2);
}

export function mapY(v: number, a: number, b: number, pad: number, h: number) {
  return h - pad - ((v - a) / (b - a)) * (h - pad * 2);
}

export function axes(
  ctx: Ctx,
  w: number,
  h: number,
  x0: number,
  x1: number,
  y0: number,
  y1: number,
  xlabel: string,
  ylabel: string,
) {
  const pad = 36;
  ctx.strokeStyle = grid;
  ctx.lineWidth = 1;
  for (let i = 0; i <= 4; i++) {
    const x = mapX(x0 + ((x1 - x0) * i) / 4, x0, x1, pad, w);
    const y = mapY(y0 + ((y1 - y0) * i) / 4, y0, y1, pad, h);
    ctx.beginPath();
    ctx.moveTo(x, pad);
    ctx.lineTo(x, h - pad);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(pad, y);
    ctx.lineTo(w - pad, y);
    ctx.stroke();
  }
  ctx.fillStyle = muted;
  ctx.font = "12px ui-monospace, monospace";
  ctx.fillText(xlabel, w / 2 - 40, h - 8);
  ctx.save();
  ctx.translate(14, h / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText(ylabel, -30, 0);
  ctx.restore();
  return pad;
}

export function strokeSeries(
  ctx: Ctx,
  pts: Array<[number, number]>,
  color: string,
  width = 2,
) {
  if (pts.length < 2) return;
  ctx.beginPath();
  ctx.moveTo(pts[0][0], pts[0][1]);
  for (let i = 1; i < pts.length; i++) ctx.lineTo(pts[i][0], pts[i][1]);
  ctx.strokeStyle = color;
  ctx.lineWidth = width;
  ctx.stroke();
}

export function semicirclePoints(
  center: number,
  radius: number,
  x0: number,
  x1: number,
  y0: number,
  y1: number,
  w: number,
  h: number,
  n = 80,
): Array<[number, number]> {
  const pad = 36;
  const pts: Array<[number, number]> = [];
  for (let i = 0; i <= n; i++) {
    const beta = center - radius + (2 * radius * i) / n;
    const alpha = Math.sqrt(Math.max(0, radius * radius - (beta - center) ** 2));
    pts.push([
      mapX(beta, x0, x1, pad, w),
      mapY(alpha, y0, y1, pad, h),
    ]);
  }
  return pts;
}

export function projectIso(x: number, y: number, z: number, w: number, h: number) {
  const sx = w * 0.5 + (x - y) * w * 0.22;
  const sy = h * 0.62 - z * h * 0.22 + (x + y) * h * 0.08;
  return [sx, sy] as const;
}

export function fitIso(nx: number, ny: number, nz: number, w: number, h: number) {
  const sx = w * 0.52 + (nx - ny) * w * 0.26;
  const sy = h * 0.58 - nz * h * 0.28 + (nx + ny) * h * 0.08;
  return [sx, sy] as const;
}
