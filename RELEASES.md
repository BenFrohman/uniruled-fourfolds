# What is checked, and what is not

Copyright (c) 2026 Benjamin Frohman. MIT License. See LICENSE.

There is no release of this repository that certifies a case of the Hodge conjecture. Conte–Murre (1978), Zucker (1977), and Kollár–Miyaoka–Mori (1992) are citations in [docs/special-cases.md](docs/special-cases.md). They are not formalized here. `Blueprint.lean` ends in `sorry`.

## Checked

Lean 4.34.1, no Mathlib. `lake build` elaborates both sources. `MukaiLattice.lean` proves, by `decide`, the four rows of the integer table:

| Vector | Square | Primitive |
|---|---|---|
| `(1, 0, -1)` | 2 | true |
| `(2, 0, -1)` | 4 | true |
| `(0, 1, 0)` | 1 | true |
| `(2, 0, -2)` | 8 | false |

Those theorems are about `Int` and `Nat.gcd`. They are not a lattice-theoretic certification of a hyper-Kähler moduli space.

GitHub Actions runs `lake build`. A green check means elaboration. The local script `scripts/pre-commit` also requires `lake exe mukai` to print this table.

## Not scheduled as a proof development

Homological projective duality, Hochschild homology, the Artin–Mumford invariant, and Bridgeland stability are not implemented in this repository. Adding them as axioms, or as `sorry`, would not be a later version of a verified Hodge proof.
