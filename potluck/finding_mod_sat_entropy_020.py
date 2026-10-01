# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Binary entropy of the drafted sigmoid. It is not a SAT distribution.

H(1/2)=1. The pasted source has its newlines removed, so that text
does not parse. No password is stored.
"""

import os

import numpy as np


def crit(k):
    return 4.26 + 5.67 * (k - 3.0) + 2.72 * (k - 3.0) ** 2


def sigmoid(k, ratio):
    sharpness = 4.0 / (k - 1.9)
    return 1.0 / (1.0 + np.exp(sharpness * (ratio - crit(k))))


def binary_entropy(p):
    p = np.clip(p, 1e-12, 1.0 - 1e-12)
    return float(-p * np.log2(p) - (1.0 - p) * np.log2(1.0 - p))


def main():
    print(f"H(1/2) = {binary_entropy(0.5):.6f}")
    for k in (3.0, 5.0):
        center = sigmoid(k, crit(k))
        far = sigmoid(k, crit(k) + 8.0)
        print(
            f"k={k}: sigmoid at the formula center {center:.4f}, "
            f"H={binary_entropy(center):.4f}; "
            f"eight units above, H={binary_entropy(far):.4f}"
        )
        sharp = 4.0 / (k - 1.9)
        h = binary_entropy(center)
        print(f"  drafted variance at the center {h * (1.0 - h) / (sharp + 0.1):.4f}")
    path = os.path.join(os.path.dirname(__file__), "finding_mod_sat_entropy_020.npz")
    np.savez_compressed(path, half=np.array([binary_entropy(0.5)]))
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
