# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Draw the submitted formulas and save PNG files.

A green run of this file is not a stability wall, a Harder-Narasimhan
filtration, a spherical twist, or a Hodge diamond. Each figure is the
expression written in its function, including the expressions whose
squared radius is not the slope equation.
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUT = Path(__file__).resolve().parent / "out"


def save(fig, name):
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / name
    fig.savefig(path, dpi=120, bbox_inches="tight")
    plt.close(fig)
    print(path.name)


def fake_center_radius(e_r, e_c, e_s, f_r, f_c, f_s):
    num = f_r * e_s - e_r * f_s
    den = f_r * e_c - e_r * f_c
    center = num / den
    radius = np.sqrt(abs(center**2 + 2 * (f_s / f_r - e_s / e_r)))
    return center, radius


def semicircle(center, radius, n=300):
    beta = np.linspace(center - radius, center + radius, n)
    alpha = np.sqrt(np.maximum(0, radius**2 - (beta - center) ** 2))
    return beta, alpha


def fig_ch3_surface():
    center, radius = fake_center_radius(2, 0, -1, 1, -1, 0)
    beta = np.linspace(center - radius + 0.01, center + radius - 0.01, 80)
    ch3 = np.linspace(-2.0, 2.0, 80)
    b, c3 = np.meshgrid(beta, ch3)
    alpha_base = np.sqrt(np.maximum(0, radius**2 - (b - center) ** 2))
    height = np.maximum(0, alpha_base * (1 + 0.2 * c3 * (b - center)))
    fig = plt.figure(figsize=(10, 6))
    ax = fig.add_subplot(111, projection="3d")
    ax.plot_surface(b, c3, height, cmap="viridis", edgecolor="none", alpha=0.85)
    ax.set_title(r"formula: $\alpha_{base}(1+0.2\,\mathrm{ch}_3(\beta-c))$, stand-in radius")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel(r"grid $\mathrm{ch}_3$")
    ax.set_zlabel("height")
    save(fig, "ch3_surface.png")


def fig_ch3_slice():
    center, radius = fake_center_radius(2, 0, -1, 1, -1, 0)
    c = 1.5
    beta = np.linspace(center - radius + 0.01, center + radius - 0.01, 300)
    alpha_base = np.sqrt(np.maximum(0, radius**2 - (beta - center) ** 2))
    alpha_sliced = alpha_base * (1 + 0.2 * c * (beta - center))
    fig, ax = plt.subplots(figsize=(9, 5))
    ax.plot(beta, alpha_base, "k--", label="stand-in semicircle")
    ax.plot(beta, alpha_sliced, color="crimson", label=r"times $1+0.2\cdot 1.5\cdot(\beta-c)$")
    ax.set_title("formula: slice of the ch3 height at 1.5")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel("height")
    ax.legend()
    ax.grid(True, linestyle=":")
    save(fig, "ch3_slice.png")


def fig_point_on_standin_disk():
    center, radius = fake_center_radius(2, 0, -1, 1, -1, 0)
    beta, alpha = semicircle(center, radius, 200)
    fig, ax = plt.subplots(figsize=(9, 5))
    ax.plot(beta, alpha, color="crimson", label=r"stand-in radius $\sqrt{5/4}$")
    ax.scatter([-0.6], [0.8], color="black", s=40, label="point (-0.6, 0.8)")
    ax.set_title("formula: point inside the stand-in disk, not a phase wall")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel("height")
    ax.set_xlim(-2.5, 0.5)
    ax.set_ylim(0, 2.0)
    ax.legend()
    ax.grid(True, linestyle=":")
    save(fig, "standin_point.png")


def fig_mukai_standin_walls():
    v = (3, 2, -1)
    subs = [(1, 0, 1, "w1"), (2, 1, -2, "w2"), (1, -1, 0, "w3")]
    fig, ax = plt.subplots(figsize=(10, 6))
    for r, c1, s, label in subs:
        num = r * v[2] - v[0] * s
        den = r * v[1] - v[0] * c1
        if den == 0:
            continue
        center = num / den
        inner = c1 * v[1] - r * v[2] - v[0] * s
        radius = np.sqrt(abs(center**2 + 2 * (inner / (v[0] * r + 1e-5))))
        beta, alpha = semicircle(center, radius)
        ax.plot(beta, alpha, label=f"{label}: radius uses 1e-5")
    ax.set_title(r"formula: stand-in radii for $v=(3,2,-1)$, not K3 walls")
    ax.set_xlim(-4, 4)
    ax.set_ylim(0, 4)
    ax.legend()
    ax.grid(True, linestyle=":")
    save(fig, "mukai_standin.png")


def fig_submitted_array():
    grid = np.zeros((5, 5))
    grid[0, 0] = 1
    grid[1, 1] = 1
    grid[2, 2] = 23
    grid[3, 3] = 1
    grid[4, 4] = 1
    fig, ax = plt.subplots(figsize=(6, 5))
    ax.imshow(grid, cmap="Blues")
    for i in range(5):
        for j in range(5):
            ax.text(j, i, f"{int(grid[i, j])}", ha="center", va="center")
    ax.set_title("submitted array with 23 in the center; cubic fourfold h^{2,2} is 21")
    ax.set_xticks(range(5), [f"q={k}" for k in range(5)])
    ax.set_yticks(range(5), [f"p={k}" for k in range(5)])
    save(fig, "submitted_array.png")


def fig_pairing_sign_curves():
    center = -0.5
    pairings = [2.0, 1.0, 0.2, 0.0, -0.5, -1.5]
    beta = np.linspace(-4, 3, 500)
    fig, ax = plt.subplots(figsize=(10, 6))
    for p in pairings:
        if p > 0:
            radius = np.sqrt(p + 0.5)
            b, a = semicircle(center, radius)
            ax.plot(b, a, label=f"sqrt({p}+1/2)")
        elif p == 0:
            ax.axvline(center, color="black", linestyle="--", label="vertical line at -1/2")
        else:
            ax.plot(beta, np.sqrt(np.abs(p) + (beta - center) ** 2), linestyle=":", label=f"sqrt(|{p}|+(beta+1/2)^2)")
    ax.set_title("formula: pairing-sign curves; these pairings are not all integral")
    ax.set_xlim(-3.5, 2.5)
    ax.set_ylim(0, 3.5)
    ax.legend(fontsize=8)
    ax.grid(True, linestyle=":")
    save(fig, "pairing_sign_curves.png")


def fig_volume_scales():
    scales = [1.0, 1.4, 1.8, 2.2, 2.5]
    fig, ax = plt.subplots(figsize=(10, 6))
    for vscale in scales:
        num = 1 * (-1) - 2 * 0
        den = (1 * 0 - 2 * (-1)) * vscale
        center = num / den
        radius = np.sqrt(abs(center**2 + 2 * vscale * (0 / 1 - (-1) / 2)))
        beta = np.linspace(center - radius + 0.01, center + radius - 0.01, 300)
        alpha = np.sqrt(np.maximum(0, radius**2 - (beta - center) ** 2))
        ax.plot(beta, alpha, label=f"V={vscale}")
    ax.set_title("formula: stand-in disk scaled by V; slope radius stays -3/4")
    ax.set_xlim(-4, 1)
    ax.set_ylim(0, 3.5)
    ax.legend()
    ax.grid(True, linestyle=":")
    save(fig, "volume_scales.png")


def _density(seed, n, beta_axis, alpha_axis, tilt_mu0, tilt_omega, degree):
    rng = np.random.default_rng(seed)
    r_arr = rng.integers(1, 4, n)
    c1_arr = rng.integers(-3, 1, n)
    ch2_arr = rng.integers(-2, 2, n)
    e_ch2 = -1 * degree
    density = np.zeros((len(alpha_axis), len(beta_axis)))
    for i in range(n):
        num = r_arr[i] * e_ch2 - 2 * ch2_arr[i] * degree
        den = (r_arr[i] * 0 - 2 * c1_arr[i]) * tilt_omega
        if den == 0:
            continue
        center = (num / den) + tilt_mu0
        radius_sq = (num / den) ** 2 + 2 * tilt_omega * (ch2_arr[i] / r_arr[i] - e_ch2 / 2)
        if radius_sq <= 0:
            continue
        radius = np.sqrt(radius_sq)
        for b_idx, b in enumerate(beta_axis):
            if center - radius <= b <= center + radius:
                target = np.sqrt(radius**2 - (b - center) ** 2)
                a_idx = int(np.abs(alpha_axis - target).argmin())
                lo = max(0, a_idx - 1)
                hi = min(len(alpha_axis), a_idx + 2)
                density[lo:hi, b_idx] += 1.0
    return density


def fig_density():
    beta = np.linspace(-3.0, 1.0, 120)
    alpha = np.linspace(0.05, 3.0, 120)
    density = _density(42, 150, beta, alpha, 0.0, 1.0, 1)
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.imshow(density, extent=[-3.0, 1.0, 0.05, 3.0], origin="lower", cmap="inferno", aspect="auto")
    ax.set_title("formula: 150 random triples, seed 42, stand-in radius")
    save(fig, "random_density.png")


def fig_tilt_density():
    beta = np.linspace(-4.0, 2.0, 120)
    alpha = np.linspace(0.05, 4.0, 120)
    density = _density(101, 200, beta, alpha, -1.2, 1.5, 1)
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.imshow(density, extent=[-4.0, 2.0, 0.05, 4.0], origin="lower", cmap="magma", aspect="auto")
    ax.set_title(r"formula: center shifted by $-1.2$ after dividing by $1.5$")
    save(fig, "tilt_density.png")


def fig_waterfall():
    beta = np.linspace(-2.5, 0.5, 100)
    taus = np.linspace(0, 1, 30)
    fig = plt.figure(figsize=(10, 6))
    ax = fig.add_subplot(111, projection="3d")
    for tau in taus:
        c1 = -1.2 + 0.5 * tau
        c2 = 0.2 - 0.6 * tau
        height = np.exp(-((beta - c1) ** 2) / 0.05) * (1 - 0.4 * tau) + np.exp(-((beta - c2) ** 2) / 0.08) * (
            0.5 + 0.5 * tau
        )
        ax.plot(beta, np.full_like(beta, tau), height, color=plt.cm.coolwarm(tau), linewidth=1.2)
    ax.set_title(r"formula: two Gaussians in $\tau$; not a family of varieties")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel(r"$\tau$")
    save(fig, "waterfall.png")


def fig_stream():
    b, a = np.meshgrid(np.linspace(-2.5, 0.5, 25), np.linspace(0.1, 3.0, 25))
    v_b = -(b + 1.0) * np.exp(-a / 2.0)
    v_a = (a * (b + 0.5)) / (b**2 + a**2 + 0.1)
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.streamplot(b, a, v_b, v_a, color=np.sqrt(v_b**2 + v_a**2), cmap="turbo", density=1.2)
    ax.scatter([-1.0, -0.5], [1.2, 0.5], color="black", s=40, label="marked points, not equilibria")
    ax.set_title(r"formula: $V_\beta=-(\beta+1)e^{-\alpha/2}$")
    ax.legend()
    save(fig, "stream.png")


def fig_dashboard():
    configs = [(-1.8, 0.8, "shift -1.8, radius 0.8"), (-0.5, 1.2, "shift -0.5, radius 1.2"),
               (0.0, 1.5, "shift 0, radius 1.5"), (1.1, 2.0, "shift 1.1, radius 2")]
    b = np.linspace(-3.0, 3.0, 150)
    a = np.linspace(0.05, 3.0, 150)
    bb, aa = np.meshgrid(b, a)
    fig, axes = plt.subplots(2, 2, figsize=(12, 8))
    for ax, (c, r, title) in zip(axes.ravel(), configs):
        z = np.exp(-(((bb - c) ** 2 + aa**2 - r**2) ** 2) / 0.5)
        ax.imshow(z, extent=[-3, 3, 0.05, 3], origin="lower", cmap="plasma", aspect="auto")
        ax.set_title(title)
    fig.suptitle("formula: Gaussian ridge on a circle; not four varieties")
    save(fig, "dashboard.png")


def fig_twist_standin():
    def pairing(u, w):
        return u[1] * w[1] - u[0] * w[2] - w[0] * u[2]

    def twist(v, s):
        f = pairing(v, s)
        return (v[0] - f * s[0], v[1] - f * s[1], v[2] - f * s[2])

    s = (1, 0, 1)
    pairs = [((2, 0, -1), (1, -1, 0), "original"),
             (twist((2, 0, -1), s), twist((1, -1, 0), s), "one minus-shift"),
             (twist(twist((2, 0, -1), s), s), twist(twist((1, -1, 0), s), s), "two minus-shifts")]
    fig, ax = plt.subplots(figsize=(10, 6))
    for v, w, label in pairs:
        den = w[0] * v[1] - v[0] * w[1]
        if den == 0:
            continue
        num = w[0] * v[2] - v[0] * w[2]
        center = num / den
        inner = pairing(w, v)
        radius_sq = center**2 + 2 * (inner / (v[0] * w[0] + 1e-5))
        if radius_sq <= 0:
            continue
        beta, alpha = semicircle(center, np.sqrt(radius_sq))
        ax.plot(beta, alpha, label=label)
    ax.scatter([-0.5, 0.5], [0.866, 0.866], color="black", s=30, label="(±1/2, 0.866), not computed")
    ax.set_title("formula: stand-in arcs after v - <v,S> S")
    ax.set_xlim(-3, 3)
    ax.set_ylim(0, 3.2)
    ax.legend(fontsize=8)
    ax.grid(True, linestyle=":")
    save(fig, "twist_standin.png")


def fig_one_orbit():
    b, a = -0.4, 1.5
    bs, as_ = [b], [a]
    for i in range(12):
        if i % 2 == 0:
            denom = b**2 + a**2 + 0.2
            b, a = (b + 0.3) / denom - 0.4, abs(a / denom) + 0.1
        else:
            b, a = b - 0.6, a * 0.9
        bs.append(b)
        as_.append(a)
    fig, ax = plt.subplots(figsize=(9, 5))
    ax.plot(bs, as_, linestyle=":")
    ax.scatter(bs, as_, s=30)
    ax.set_title("formula: (b+0.3)/(b^2+a^2+0.2)-0.4 alternating with b-0.6")
    ax.grid(True, linestyle="--")
    save(fig, "one_orbit.png")


def fig_five_orbits():
    starts = [(-1.5, 2.0), (-0.8, 0.5), (0.5, 1.8), (-2.2, 1.0), (1.2, 0.2)]
    fig, ax = plt.subplots(figsize=(10, 6))
    for b0, a0 in starts:
        b, a = b0, a0
        bs, as_ = [b], [a]
        for s in range(25):
            if s % 2 == 0:
                denom = b**2 + a**2 + 0.25
                b, a = (b + 0.2) / denom - 0.45, abs(a / denom) + 0.15
            else:
                b, a = b + 0.3, a * 0.85
            bs.append(b)
            as_.append(a)
        ax.plot(bs, as_, alpha=0.7)
        ax.scatter(bs[-1], as_[-1], marker="x")
    ax.set_title("formula: five paths of (b+0.2)/(b^2+a^2+1/4)-0.45")
    ax.set_xlim(-3, 2.5)
    ax.set_ylim(0, 2.8)
    ax.grid(True, linestyle=":")
    save(fig, "five_orbits.png")


def fig_hyper_orbits():
    def step(b, a, t):
        denom = b**2 + a**2 + 0.3
        return (b + 0.1 * t) / denom - 0.4, abs(a / denom) + 0.2, (t * b + 0.5) / (a + 0.5)

    seeds = [(-0.5, 1.5, 0.2), (-0.2, 1.2, -0.4), (0.1, 1.8, 0.6), (-0.8, 0.9, 0.0)]
    fig = plt.figure(figsize=(10, 6))
    ax = fig.add_subplot(111, projection="3d")
    for b, a, t in seeds:
        bs, as_, ts = [b], [a], [t]
        for s in range(40):
            if s % 3 == 0:
                b, a, t = step(b, a, t)
            elif s % 3 == 1:
                b, a, t = b + 0.25, a * 0.88, t - 0.1
            else:
                b, a, t = b - 0.1, a + 0.15, t * 0.9
            bs.append(b)
            as_.append(a)
            ts.append(t)
        ax.plot(bs, ts, as_, linewidth=1.2)
    ax.set_title(r"formula: $(b+0.1\tau)/(b^2+a^2+0.3)-0.4$; not an $A_n$ orbit")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel(r"$\tau$")
    ax.set_zlabel(r"$\alpha$")
    save(fig, "hyper_orbits.png")


def fig_tau_slice():
    rng = np.random.default_rng(42)
    n = 4000
    b = rng.uniform(-2.5, 1.5, n)
    a = rng.uniform(0.05, 2.5, n)
    t = np.sin(3 * b) * np.cos(2 * a) + rng.normal(0, 0.05, n)
    mask = np.abs(t - 0.25) < 0.08
    fig, ax = plt.subplots(figsize=(10, 6))
    sc = ax.scatter(b[mask], a[mask], c=t[mask], cmap="plasma", s=20)
    fig.colorbar(sc, ax=ax, label=r"$\tau$")
    ax.set_title(r"formula: $\sin(3\beta)\cos(2\alpha)$ plus noise, sliced at $0.25\pm 0.08$")
    ax.set_xlabel(r"$\beta$")
    ax.set_ylabel(r"$\alpha$")
    ax.set_xlim(-2.5, 1.5)
    ax.set_ylim(0.05, 2.5)
    ax.grid(True, linestyle=":")
    save(fig, "tau_slice.png")


def main():
    fig_ch3_surface()
    fig_ch3_slice()
    fig_point_on_standin_disk()
    fig_mukai_standin_walls()
    fig_submitted_array()
    fig_pairing_sign_curves()
    fig_volume_scales()
    fig_density()
    fig_tilt_density()
    fig_waterfall()
    fig_stream()
    fig_dashboard()
    fig_twist_standin()
    fig_one_orbit()
    fig_five_orbits()
    fig_hyper_orbits()
    fig_tau_slice()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
