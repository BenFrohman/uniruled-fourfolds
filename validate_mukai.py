#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Frohman. All rights reserved.
"""Cross-check the four Mukai rows proved in MukaiLattice.lean.

Square is v2^2 - 2*v0*v4. Primitive means gcd(|v0|, |v2|, |v4|) == 1.
This is integer arithmetic. It does not check a cycle class map.
"""

import math
import sys


def mukai_square(v0: int, v2: int, v4: int) -> int:
    return (v2 * v2) - (2 * v0 * v4)


def is_primitive(v0: int, v2: int, v4: int) -> bool:
    return math.gcd(abs(v0), abs(v2), abs(v4)) == 1


# Same four rows as the `decide` theorems in MukaiLattice.lean.
EXPECTED = {
    (1, 0, -1): (2, True),
    (2, 0, -1): (4, True),
    (0, 1, 0): (1, True),
    (2, 0, -2): (8, False),
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
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
