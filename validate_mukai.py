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
    # Gram matrix of (1,0,-1), (2,1,-2), (0,1,0). Indices are 0,1,2, not 4.
    basis = [(1, 0, -1), (2, 1, -2), (0, 1, 0)]
    expected_gram = [
        [2, 4, 0],
        [4, 9, 1],
        [0, 1, 1],
    ]
    gram = [[mukai_pairing(u, v) for v in basis] for u in basis]
    ok = gram == expected_gram
    print(f"{'ok' if ok else 'FAIL'} gram {gram} (expected {expected_gram})")
    failed = failed or not ok
    labels = ["(1, 0, -1)", "(2, 1, -2)", "(0, 1, 0)"]
    header = "| | " + " | ".join(labels) + " |"
    separator = "| --- | " + " | ".join("---" for _ in labels) + " |"
    lines = [header, separator]
    for label, row in zip(labels, gram):
        lines.append("| " + label + " | " + " | ".join(str(val) for val in row) + " |")
    print("\n".join(lines))
    # det of the Gram matrix of (1,0,0), (0,1,0), (0,0,1)
    b0, b2, b4 = (1, 0, 0), (0, 1, 0), (0, 0, 1)
    rows = [
        [mukai_pairing(b0, b0), mukai_pairing(b0, b2), mukai_pairing(b0, b4)],
        [mukai_pairing(b2, b0), mukai_pairing(b2, b2), mukai_pairing(b2, b4)],
        [mukai_pairing(b4, b0), mukai_pairing(b4, b2), mukai_pairing(b4, b4)],
    ]
    a, b, c = rows[0]
    d, e, f = rows[1]
    g, h, i = rows[2]
    det = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
    ok = det == -1
    print(f"{'ok' if ok else 'FAIL'} coordinate gram det {det} (expected -1)")
    failed = failed or not ok
    from fractions import Fraction

    def tilt_circle(E, F):
        """Center and squared radius of nu(E)=nu(F), where
        nu = (s - beta*c + (beta**2 - alpha**2)*r/2) / (c - beta*r).
        """
        def mul(left, right):
            out = {}
            for (i, j), a in left.items():
                for (k, l), b in right.items():
                    out[(i + k, j + l)] = out.get((i + k, j + l), 0) + a * b
            return {monomial: coeff for monomial, coeff in out.items() if coeff}

        def add(left, right, sign=1):
            out = dict(left)
            for monomial, coeff in right.items():
                out[monomial] = out.get(monomial, 0) + sign * coeff
            return {monomial: coeff for monomial, coeff in out.items() if coeff}

        def term(i, j, coeff):
            return {(i, j): Fraction(coeff)}

        def two_num(rank, c1, ch2):
            return add(
                add(term(0, 0, 2 * ch2), term(1, 0, -2 * c1)),
                add(term(2, 0, rank), term(0, 2, -rank)),
            )

        def den(c1, rank):
            return add(term(0, 0, c1), term(1, 0, -rank))

        rE, cE, sE = E
        rF, cF, sF = F
        poly = add(
            mul(two_num(rE, cE, sE), den(cF, rF)),
            mul(two_num(rF, cF, sF), den(cE, rE)),
            sign=-1,
        )
        A = poly.get((2, 0), 0)
        if A == 0 or poly.get((0, 2), 0) != A:
            return None
        extra = [m for m in poly if m not in {(2, 0), (0, 2), (1, 0), (0, 0)}]
        if extra:
            return None
        B = poly.get((1, 0), 0)
        C = poly.get((0, 0), 0)
        center = -B / (2 * A)
        rad2 = center ** 2 - C / A
        return center, rad2

    expected_walls = [
        ((1, -1, 0), (Fraction(-1, 2), Fraction(-3, 4))),
        ((1, -2, 1), (Fraction(-3, 4), Fraction(-7, 16))),
        ((3, -1, -2), (Fraction(1, 2), Fraction(-3, 4))),
    ]
    for sub, expected in expected_walls:
        got = tilt_circle((2, 0, -1), sub)
        ok = got == expected and expected[1] < 0
        print(f"{'ok' if ok else 'FAIL'} empty wall F={sub} {got} (expected {expected})")
        failed = failed or not ok
    # Pairings with (3, 2, -1). Not wall radii. The 1e-5 term is not in the formula.
    parent = (3, 2, -1)
    for other, expected_pair in [((1, 0, 1), -2), ((2, 1, -2), 10), ((1, -1, 0), -1)]:
        got = mukai_pairing(parent, other)
        ok = got == expected_pair
        print(f"{'ok' if ok else 'FAIL'} pairing {parent} {other} = {got} (expected {expected_pair})")
        failed = failed or not ok
    # (-3/5, 4/5) lies in the stand-in disk of squared radius 5/4 and not on a slope wall.
    center = Fraction(-1, 2)
    dist = (Fraction(-3, 5) - center) ** 2 + Fraction(4, 5) ** 2
    ok = dist == Fraction(13, 20) and dist < Fraction(5, 4)
    print(f"{'ok' if ok else 'FAIL'} fake-disk distance {dist} (expected 13/20)")
    failed = failed or not ok
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
