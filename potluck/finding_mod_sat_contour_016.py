# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Evaluate the drafted threshold curve. It is not a SAT count.

At k=5 the expression equals 26.78, not 21.11. The grid is a sigmoid
of that curve. P versus NP is open. No password is stored.
"""

import os

import numpy as np


def crit(k):
    return 4.26 + (9.93 - 4.26) * (k - 3.0) + 0.5 * (k - 3.0) * (k - 4.0) * (21.11 - 9.93)


def sigmoid(k, ratio):
    steepness = 3.0 / (k - 2.0)
    return 1.0 / (1.0 + np.exp(steepness * (ratio - crit(k))))


def main():
    ks = np.array([3.0, 4.0, 5.0])
    values = np.array([crit(k) for k in ks])
    for k, value in zip(ks, values):
        print(f"k={k}: threshold formula {value:.4f}, sigmoid at that ratio {sigmoid(k, value):.4f}")
    path = os.path.join(os.path.dirname(__file__), "finding_mod_sat_contour_016.npz")
    np.savez_compressed(path, k=ks, threshold=values)
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
