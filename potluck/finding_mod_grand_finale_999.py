# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""A moving Gaussian with a phase. Not a quantum Hall state.

The curvature expression is not integrated to a Chern number.
The entropy is the Shannon entropy of the normalized grid density.
numpy's seed is set and never used. No password is stored.
"""

import os

import numpy as np


def compute(grid_size=40, phases=50):
    theta = np.linspace(0, 2 * np.pi, grid_size)
    t1, t2 = np.meshgrid(theta, theta, indexing="ij")
    tau_space = np.linspace(0.0, 1.0, phases)
    sums = []
    entropies = []
    for tau in tau_space:
        center_x = np.pi * (1.0 + 0.3 * np.sin(2 * np.pi * tau))
        center_y = np.pi * (1.0 + 0.3 * np.cos(2 * np.pi * tau))
        amplitude = np.exp(-((t1 - center_x) ** 2 + (t2 - center_y) ** 2) / (1.5 - 0.5 * tau))
        phase = tau * np.sin(t1) * np.cos(t2) + (1.0 - tau) * (t1 + t2)
        psi = amplitude * np.exp(1j * phase)
        dx = np.gradient(psi, axis=0)
        dy = np.gradient(psi, axis=1)
        berry = np.imag(dx * np.conj(dy) - dy * np.conj(dx))
        sums.append(float(np.sum(berry)))
        prob = np.abs(psi) ** 2
        prob = prob / (np.sum(prob) + 1e-12)
        entropies.append(float(-np.sum(prob * np.log(prob + 1e-15))))
    return tau_space, np.array(sums), np.array(entropies)


def main():
    tau, sums, entropies = compute()
    path = os.path.join(os.path.dirname(__file__), "finding_mod_grand_finale_999.npz")
    np.savez_compressed(path, tau=tau, berry_sum=sums, shannon=entropies)
    print(f"wrote {path}")
    print(f"index-spacing curvature sum first {sums[0]:.6g} last {sums[-1]:.6g}")
    print(f"shannon of the grid density first {entropies[0]:.6g} last {entropies[-1]:.6g}")
    print("seed 999 is unused; this is not a Chern number")


if __name__ == "__main__":
    main()
