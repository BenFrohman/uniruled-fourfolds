# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Evaluate the drafted cliff curve. It is not a SAT count.

At k=5 the expression equals 26.48, not 21.11. No password is stored.
"""

import os

import numpy as np


def crit(k):
    return 4.26 + 5.67 * (k - 3.0) + 2.72 * (k - 3.0) ** 2


def main():
    ks = np.array([3.0, 4.0, 5.0])
    values = np.array([crit(k) for k in ks])
    for k, value in zip(ks, values):
        print(f"k={k}: cliff formula {value:.4f}")
    path = os.path.join(os.path.dirname(__file__), "finding_mod_sat_wireframe_018.npz")
    np.savez_compressed(path, k=ks, threshold=values)
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
