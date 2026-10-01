# Uniruled fourfolds: conditional cycle reductions and Mukai lattice tools

Copyright (c) 2026 Benjamin Frohman. All rights reserved.
Author: Benjamin Frohman.
License: see [LICENSE](LICENSE). No use or redistribution without prior written permission.

This repository contains a Lean 4 sketch and a Mukai-vector arithmetic program for uniruled complex projective fourfolds.

## Status

The surjectivity of the cycle class map on middle-dimensional classes of a general smooth projective variety is **open**. Nothing in this repository proves that statement, and nothing here claims a general resolution.

`Blueprint.lean` is a conditional sketch: *if* a Bloch–Srinivas package is supplied for a uniruled fourfold, the file *states* that codimension-2 cycle-class surjectivity would reduce to the classical Lefschetz theorem on (1,1)-classes on a threefold. The proof is `sorry`. Lean 4.34.1 elaborates the file and reports that `sorry`. Elaboration is not a proof.

`MukaiLattice.lean` is only the integer form

\[
\langle v, v \rangle = v_2^2 - 2 v_0 v_4, \qquad \text{primitive} \iff \gcd(|v_0|, |v_2|, |v_4|) = 1.
\]

It was executed with `lean --run` under Lean 4.34.1. That checks the arithmetic in the table. It does not check geometry.

## Repository contents

| File | Role |
|---|---|
| `Blueprint.lean` | Conditional statement. Unproved (`sorry`). |
| `MukaiLattice.lean` | Square and primitivity, with a `main` that prints four vectors. |
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

The second command succeeds only as elaboration. It prints a warning that `conditionalCycleClassReduction` uses `sorry`.
