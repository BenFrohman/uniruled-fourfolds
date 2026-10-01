# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Shannon entropy of a discrete Gaussian translated on a fixed grid.

np.gradient uses index spacing 1. The grid spacing is 10/39.
The sum of those index gradients is not a physical flux.
"""

import os

import numpy as np


def track(grid_size=40, total_steps=50, sigma=1.0):
    axis = np.linspace(-5.0, 5.0, grid_size)
    x, y = np.meshgrid(axis, axis, indexing="ij")
    entropy = np.zeros(total_steps)
    grad_sum = np.zeros(total_steps)
    for step in range(total_steps):
        center = -1.5 + 3.0 * (step / total_steps)
        density = np.exp(-((x - center) ** 2 + (y - center) ** 2) / (2 * sigma**2))
        grad_x, grad_y = np.gradient(density)
        grad_sum[step] = np.sum(grad_x + grad_y)
        prob = density / np.sum(density)
        entropy[step] = -np.sum(prob * np.log(prob + 1e-15))
    return axis, entropy, grad_sum


def main():
    axis, entropy, grad_sum = track()
    path = os.path.join(os.path.dirname(__file__), "finding_mod_gaussian_shannon_entropy_001.npz")
    np.savez_compressed(path, entropy=entropy, gradient_sum=grad_sum)
    print(f"wrote {path}")
    print(f"grid spacing {axis[1] - axis[0]:.6f}")
    print(f"shannon {entropy[0]:.6f} -> {entropy[-1]:.6f}")
    print(f"index-gradient sum {grad_sum[0]:.6e} -> {grad_sum[-1]:.6e}")


if __name__ == "__main__":
    main()
