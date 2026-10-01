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

`MukaiLattice.lean` defines the integer form

\[
\langle v, v \rangle = v_2^2 - 2 v_0 v_4, \qquad \text{primitive} \iff \gcd(|v_0|, |v_2|, |v_4|) = 1
\]

and proves the four rows below with `decide`. No Mathlib. No cycle-class statement.

| File | Role |
|---|---|
| `Blueprint.lean` | Conditional statement. Unproved (`sorry`). |
| `MukaiLattice.lean` | Square and primitivity, proved for four vectors by `decide`, plus a `main` that prints them. |
| `docs/special-cases.md` | Citations, the holes in a five-line pathway, and where the method ends. |
| `RELEASES.md` | What the build checks. It does not list a Hodge-conjecture release. |
| `scripts/pre-commit` | Optional local hook: `lake build`, then the Mukai table must match. |
| `lakefile.lean`, `lean-toolchain`, `lake-manifest.json` | Lean 4.34.1 build of the two sources above. No Mathlib. |
| `.github/workflows/lean.yml` | CI: `lake build`. Green means elaboration, not a proof. |
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

Pinned toolchain: Lean 4.34.1 (`lean-toolchain`). There is no Mathlib dependency.

```bash
lake build
lake exe mukai
```

`lake build` elaborates `Blueprint.lean` and compiles `MukaiLattice.lean`. It exits successfully while warning that `conditionalCycleClassReduction` uses `sorry`. Elaboration is not a proof.

GitHub Actions (`.github/workflows/lean.yml`) runs that same build on pushes and pull requests to `main`. A green check means the files elaborated. It does not mean a theorem was proved.


## Not included

No file here declares the cycle class map surjective for every fourfold. That would assume the Clay problem. The committed `lakefile.lean` does not require Mathlib. A theorem named as a Clay-problem verification for cubic fourfolds is the cubic case, already due to Zucker, and is not a formalization.
