#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Frohman. MIT License.
"""Cross-check the four Mukai rows proved in MukaiLattice.lean.

Square is v2^2 - 2*v0*v4. Primitive means gcd(|v0|, |v2|, |v4|) == 1.
This is integer arithmetic. It does not check a cycle class map.
"""

import math
import sys


def mukai_square(v0: int, v2: int, v4: int) -> int:
    return (v2 * v2) - (2 * v0 * v4)


def mukai_pairing(u: tuple[int, int, int], v: tuple[int, int, int]) -> int:
    u0, u2, u4 = u
    v0, v2, v4 = v
    return (u2 * v2) - (u0 * v4) - (u4 * v0)


def is_primitive(v0: int, v2: int, v4: int) -> bool:
    return math.gcd(abs(v0), abs(v2), abs(v4)) == 1


# Same four rows as the `decide` theorems in MukaiLattice.lean.
EXPECTED = {
    (1, 0, -1): (2, True),
    (2, 0, -1): (4, True),
    (0, 1, 0): (1, True),
    (2, 0, -2): (8, False),
    (2, 1, -2): (9, True),
    (1, 1, 0): (1, True),
}


def main() -> int:
    failed = False
    for (v0, v2, v4), (square, primitive) in EXPECTED.items():
        got_square = mukai_square(v0, v2, v4)
        got_primitive = is_primitive(v0, v2, v4)
        ok = got_square == square and got_primitive is primitive
        status = "ok" if ok else "FAIL"
        print(
            f"{status} {(v0, v2, v4)} square {got_square} "
            f"(expected {square}) primitive {got_primitive} "
            f"(expected {primitive})"
        )
        failed = failed or not ok
    pairings = [
        ((1, 0, -1), (-1, 0, 1), -2),
        ((1, 0, -1), (0, 1, 0), 0),
        ((1, 0, -1), (2, 1, -2), 4),
        ((0, 1, 0), (1, 1, 0), 1),
    ]
    for u, v, expected_pair in pairings:
        got = mukai_pairing(u, v)
        ok = got == expected_pair
        status = "ok" if ok else "FAIL"
        print(f"{status} pairing {u} {v} = {got} (expected {expected_pair})")
        failed = failed or not ok
    disc = mukai_square(1, 0, -1) * mukai_square(0, 1, 0) - mukai_pairing((1, 0, -1), (0, 1, 0)) ** 2
    ok = disc == 2
    print(f"{'ok' if ok else 'FAIL'} discriminant (1, 0, -1), (0, 1, 0) = {disc} (expected 2)")
    failed = failed or not ok
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
