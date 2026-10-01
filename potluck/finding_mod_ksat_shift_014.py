# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Evaluate the drafted probability formula. It does not build clauses.

The pasted module also contains the syntax error `for k in:`, so that
text does not run. P versus NP is open. No password is stored.
"""

import os

import numpy as np


def draft_probability(ratio, critical):
    if ratio < critical - 1.0:
        return 0.98
    if ratio > critical + 1.0:
        return 0.01
    return float(np.clip(0.5 * (1.0 - (ratio - critical)), 0.0, 1.0))


def main():
    thresholds = {3: 4.26, 4: 9.93, 5: 21.11}
    for k, critical in thresholds.items():
        at = draft_probability(critical, critical)
        below = draft_probability(critical - 1.5, critical)
        above = draft_probability(critical + 1.5, critical)
        print(f"k={k} critical={critical}: formula gives {below}, {at}, {above}")
        print(f"  at the threshold the formula is {at}, not a count of models")
    path = os.path.join(os.path.dirname(__file__), "finding_mod_ksat_shift_014.npz")
    ks = np.array(sorted(thresholds))
    np.savez_compressed(
        path,
        k=ks,
        at_threshold=np.array([draft_probability(thresholds[int(k)], thresholds[int(k)]) for k in ks]),
    )
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
