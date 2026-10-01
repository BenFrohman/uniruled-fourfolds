# Uniruled fourfolds: conditional cycle reductions and Mukai lattice tools

Copyright (c) 2026 Benjamin Frohman. All rights reserved.
Author: Benjamin Frohman.
License: see [LICENSE](LICENSE). No use or redistribution without prior written permission.

**The Clay Mathematics Institute Hodge conjecture is open. This repository does not resolve it.**

What the literature already contains, and what this repository does not formalize, is recorded in [docs/special-cases.md](docs/special-cases.md). Short form:

| Statement | Status |
|---|---|
| Hodge conjecture for a general smooth complex projective variety | **Open.** |
| Rational Hodge conjecture for fourfolds covered by rational curves | **Theorem** of Conte–Murre, Math. Ann. **238** (1978). Not proved in this repository. |
| Smooth cubic fourfolds | **Theorem** of Zucker, Compositio Math. **34** (1977). They are also Fano, so Conte–Murre applies. |
| Smooth complex Fano fourfolds | **Corollary** of Conte–Murre plus Kollár–Miyaoka–Mori, J. Diff. Geom. **36** (1992). Not a case beyond uniruled fourfolds. |
| Rationality of a general cubic fourfold, Kuznetsov's conjecture | **Open.** |

The uniruled reduction uses a rational curve through a general point. It stops there. It is not a route to the general fourfold.

## What is in this repository

`Blueprint.lean` is a conditional sketch: *if* a Bloch–Srinivas package is supplied for a uniruled fourfold, the file *states* that codimension-2 cycle-class surjectivity would reduce to the classical Lefschetz theorem on (1,1)-classes on a threefold. The proof is `sorry`. Elaborating the file only checks that the statement is well-formed.

`MukaiLattice.lean` is only the integer form

\[
\langle v, v \rangle = v_2^2 - 2 v_0 v_4, \qquad \text{primitive} \iff \gcd(|v_0|, |v_2|, |v_4|) = 1.
\]

It does not check geometry.

| File | Role |
|---|---|
| `Blueprint.lean` | Conditional statement. Unproved (`sorry`). |
| `MukaiLattice.lean` | Square and primitivity, with a `main` that prints four vectors. |
| `docs/special-cases.md` | Citations, the holes in a five-line pathway, and where the method ends. |
| `LICENSE` | All rights reserved to Benjamin Frohman. |
| `COPYRIGHT` | Authorship and copyright notice. |

## Arithmetic table

| Vector \((v_0, v_2, v_4)\) | Square \(v_2^2 - 2 v_0 v_4\) | Primitive? |
|---|---|---|
| `(1, 0, -1)` | \(2\) | true |
| `(2, 0, -1)` | \(4\) | true |
| `(0, 1, 0)` | \(1\) | true |
| `(2, 0, -2)` | \(8\) | false (`gcd = 2`) |

## Commands

```bash
lean --run MukaiLattice.lean
lean Blueprint.lean
```

The second command succeeds only as elaboration. It warns that `conditionalCycleClassReduction` uses `sorry`.

## Not included

No file here declares the cycle class map surjective for every fourfold. That would assume the Clay problem. No `lakefile` is committed: a requirement URL of `https://github.com` does not load Mathlib. A theorem named as a Clay-problem verification for cubic fourfolds is the cubic case, already due to Zucker, and is not a formalization.
