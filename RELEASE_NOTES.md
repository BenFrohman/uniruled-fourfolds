# What the four vectors are

Copyright (c) 2026 Benjamin Frohman. MIT License. See LICENSE.

This is not a v1.0.1 release, and it is not a computation in \(K_0(\mathcal{A}_X)\). The repository pins `leanprover/lean4:v4.34.1` in `lean-toolchain`. It does not target Lean 4.11.0.

`UniruledFourfolds/MukaiLattice.lean` proves these integer rows with `decide`. `validate_mukai.py` recomputes them with `math.gcd` and exits 1 if a row disagrees. Labels such as "K3" in older notes are names for the triples, not a classification of a variety.

| Vector | Square \(v_2^2 - 2 v_0 v_4\) | `gcd` of the absolute values is 1 |
|---|---|---|
| `(1, 0, -1)` | 2 | yes |
| `(2, 0, -1)` | 4 | yes |
| `(0, 1, 0)` | 1 | yes |
| `(2, 0, -2)` | 8 | no, the gcd is 2 |

The same file proves, for every vector `v`, that the square equals the pairing of `v` with itself: \(v_2^2 - 2 v_0 v_4 = \langle v, v \rangle\). It also proves \(\langle (1,0,-1), (-1,0,1) \rangle = -2\) and \(\langle (1,0,-1), (0,1,0) \rangle = 0\). For that orthogonal pair the Gram determinant is \(2 \cdot 1 - 0^2 = 2\). The same two vectors span a primitive subgroup of \(\mathbb{Z}^3\): if \(n z\) is an integral combination of them and \(n \neq 0\), then \(z\) is too. That is `cert_k3_surface_span_primitive`. It is not an embedding into the Mukai lattice of a K3 surface, and `gcd(_, 1) = 1` is not that statement. No Mathlib import.

`scripts/pre-push` runs `verify_lean.sh` and `validate_mukai.py` before a push. GitHub Actions does the same in `.github/workflows/verify.yml`.

The package options `-DautoParam=true` and `-Doptimize=true` are not Lean 4.34.1 configuration options. `lake build` rejects `autoParam`. `-march=native` was not added. The `lakefile.lean` in this repository is unchanged.
