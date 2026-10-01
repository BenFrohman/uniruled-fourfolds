# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Exhaustive 3-SAT counts on 8 variables.

The draft draws a satisfiability bit from a fixed probability and never
evaluates the clauses it builds. P versus NP is open. This file does
not decide it. No password is stored.
"""

import os

import numpy as np


def exhaustive_rate(num_vars, num_clauses, samples, seed):
    rng = np.random.default_rng(seed)
    hits = 0
    for _ in range(samples):
        clauses = rng.integers(0, num_vars, size=(num_clauses, 3))
        polarities = rng.choice(np.array([-1, 1]), size=(num_clauses, 3))
        sat = False
        for mask in range(1 << num_vars):
            good = True
            for literals, signs in zip(clauses, polarities):
                clause_ok = False
                for lit, sign in zip(literals, signs):
                    bit = (mask >> int(lit)) & 1
                    if (sign == 1 and bit == 1) or (sign == -1 and bit == 0):
                        clause_ok = True
                        break
                if not clause_ok:
                    good = False
                    break
            if good:
                sat = True
                break
        hits += int(sat)
    return hits / samples


def draft_ignores_clauses(ratio):
    if ratio < 4.2:
        return 0.92
    if ratio > 4.6:
        return 0.05
    return 0.45


def main():
    num_vars = 8
    samples = 40
    rows = []
    for ratio in (3.0, 4.2, 5.0):
        rate = exhaustive_rate(num_vars, int(ratio * num_vars), samples, seed=12)
        rows.append((ratio, rate, draft_ignores_clauses(ratio)))
        print(
            f"ratio {ratio}: exhaustive {rate:.3f} on {num_vars} variables, "
            f"{samples} samples; draft probability {draft_ignores_clauses(ratio)}"
        )
    path = os.path.join(os.path.dirname(__file__), "finding_mod_sat_phase_transition_012.npz")
    np.savez_compressed(
        path,
        ratio=np.array([r[0] for r in rows]),
        exhaustive=np.array([r[1] for r in rows]),
        draft_probability=np.array([r[2] for r in rows]),
    )
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
