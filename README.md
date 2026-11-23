# Uniruled fourfolds: conditional cycle reductions and Mukai lattice tools

[![verify.yml](https://github.com/BenFrohman/uniruled-fourfolds/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/BenFrohman/uniruled-fourfolds/actions/workflows/verify.yml)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23652974.svg)](https://doi.org/10.5281/zenodo.23652974) [![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

Copyright (c) 2026 Benjamin Stanley Frohman.
Author: Benjamin Stanley Frohman (GitHub: BenFrohman).
License: [Apache-2.0](LICENSE). Copies must keep the copyright notice and the permission notice.

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

`Blueprint.lean` proves a **conditional** reduction, with no `sorry` and no `axiom`: if a correspondence Γ from a threefold Ỹ satisfies **(BS)** `Γ_* Γ^* γ = γ` on `Hdg⁴(X)` and **(CL)** `cl_X(Γ_* z) = Γ_*(cl_Ỹ z)`, and **(L11)** Lefschetz (1,1) holds on Ỹ, then `cl_X : CH²(X)_ℚ → Hdg⁴(X)` is surjective (`conditionalCycleClassReduction`); and under **(U)** (every uniruled fourfold has such a Γ) plus (L11) on every threefold, `cl_X` is surjective for every uniruled `X` (`uniruled_cycleClassSurjective`). (L11), (BS), (CL) and (U) are named hypotheses, **open assumptions of this repository, not proved here**. The groups, cycle class maps and the uniruledness predicate are uninterpreted fields of `CycleClassSetting`; nothing here constructs cohomology or Chow groups. `NonVacuity.lean` shows with finite models that the hypotheses are consistent and that none can be dropped. The Truth Gate (`TRUTH_GATE.md`, `UniruledFourfolds/Semantics.lean`) locks every theorem and proposition of the paper.

`MukaiLattice.lean` defines the integer form

\[
\langle v, v \rangle = v_2^2 - 2 v_0 v_4, \qquad \text{primitive} \iff \gcd(|v_0|, |v_2|, |v_4|) = 1
\]

and proves the four rows below with `decide`. The pairing is \(\langle u, v \rangle = u_2 v_2 - u_0 v_4 - u_4 v_0\), and the square is that pairing on the diagonal. No Mathlib. No cycle-class statement.

| File | Role |
|---|---|
| `UniruledFourfolds/Blueprint.lean` | Conditional theorems `hypotheses ⇒ conclusion`, proved; no `sorry`, no `axiom`. |
| `UniruledFourfolds/NonVacuity.lean` | Finite models: hypotheses consistent, each one needed. |
| `UniruledFourfolds/Semantics.lean` | Truth Gate lock of the whole paper. |
| `UniruledFourfolds/MukaiLattice.lean` | Square and primitivity, proved for four vectors by `decide`, plus a `main` that prints them. |
| `docs/special-cases.md` | Citations, the holes in a five-line pathway, and where the method ends. |
| `RELEASES.md` | What the build checks. It does not list a Hodge-conjecture release. |
| `scripts/pre-commit` | Optional local hook: `lake build`, then the Mukai table must match. |
| `scripts/pre-push` | Optional local hook: `verify_lean.sh`, then `validate_mukai.py`. |

`plots/render_formulas.py` writes PNG files of the submitted expressions to `plots/out/`. Those files are not committed. A successful render is not a wall, a filtration, or a Hodge number. The cubic-fourfold value \(h^{2,2}=21\) is not the \(23\) drawn in the center of `submitted_array.png`.
| `RELEASE_NOTES.md` | The four integer rows. Not a class in \(K_0\), and not Lean 4.11.0. |
| `GEOMETRY.md` | The orthogonal in \(\mathbb{Z}^3\). Not the transcendental lattice of a cubic fourfold. |
| `verify_lean.sh` | `lean UniruledFourfolds/MukaiLattice.lean` and `lean --run`; output must match the table. |
| `validate_mukai.py` | The same four rows in Python. Exits 1 on a mismatch. |
| `lakefile.lean`, `lean-toolchain`, `lake-manifest.json` | Lean 4.34.1 build of the two sources above. No Mathlib. |
| `.github/workflows/verify.yml` | CI: `lake build`, then `verify_lean.sh` and `validate_mukai.py`. Green means those checks passed. |
| `LICENSE` | Apache License, Version 2.0. Copyright Benjamin Stanley Frohman (GitHub: BenFrohman). |
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

`lake build` builds every module. CI fails on any `sorry`, `admit`, `native_decide` or `axiom` in any tracked Lean file or in the full build log, on any tracked Lean file that is not built (file list from `git ls-files`), and on any theorem whose `#print axioms` goes beyond `propext`, `Classical.choice`, `Quot.sound`. `bash scripts/verify-lock.sh` runs the Truth Gate.

GitHub Actions (`verify.yml`, `kernel-certificate.yml`, `truth-gate.yml`) run these checks. A green check means the conditional theorems are proved from their named hypotheses. It does not mean the hypotheses hold, or that any case of the Hodge conjecture was proved here.


## Not included

No file here declares the cycle class map surjective for every fourfold. That would assume the Clay problem. The committed `lakefile.lean` does not require Mathlib. A theorem named as a Clay-problem verification for cubic fourfolds is the cubic case, already due to Zucker, and is not a formalization.

---
## Archival DOI & Cryptographic Provenance

- **Dedicated 1-to-1 Zenodo DOI:** [10.5281/zenodo.23652974](https://doi.org/10.5281/zenodo.23652974)
- **Author:** Benjamin Stanley Frohman (ORCID: [0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718))
- **License:** Apache License, Version 2.0 (`Copyright (c) 2026 Benjamin Stanley Frohman`)
- **Earliest Commit Provenance:** `18b62b11b26338ecab62426eaf4844cc57e8353b` (2026-10-01 04:51:29 PM CDT (UTC-5))
- **SealGuard SHA-256 Merkle Root:** `a3938bf57c8da3312b6d062bbee49a32fd2312ba31c4a6e0bf7730252547a0c6` (`PROVENANCE_MERKLE_ROOT.json`)
- **Titan Audit Certificate:** `audit/TITAN_AUDIT_CERTIFICATE.json` (Ed25519 key `b428fb72676f1c52`)
- **Scope & Scientific Boundary:** All cycle-class surjectivity deductions in this repository are conditional on explicit geometric correspondence hypotheses; this repository does not claim an unconditional proof of any open Hodge surjectivity conjecture.

## Zenodo archive

- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23652973.svg)](https://doi.org/10.5281/zenodo.23652973) Uniruled Fourfolds and Mukai Lattice Cycle Reductions in Lean 4: Conditional Cycle-Class Frameworks — all versions: [10.5281/zenodo.23652973](https://doi.org/10.5281/zenodo.23652973); latest version: [10.5281/zenodo.23652974](https://doi.org/10.5281/zenodo.23652974)
- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23632803.svg)](https://doi.org/10.5281/zenodo.23632803) Cohomological Obstructions, Atiyah-Hirzebruch Integral Torsion Differentials, and Conditional Mukai-Lattice Cycle Reductions on Smooth Projective Fourfolds — all versions: [10.5281/zenodo.23632803](https://doi.org/10.5281/zenodo.23632803); latest version: [10.5281/zenodo.23632804](https://doi.org/10.5281/zenodo.23632804)
- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23867557.svg)](https://doi.org/10.5281/zenodo.23867557) Uniruled Fourfolds and Mukai Lattice Cycle Reductions in Lean 4: Conditional Cycle-Class Frameworks — all versions: [10.5281/zenodo.23867557](https://doi.org/10.5281/zenodo.23867557); latest version: [10.5281/zenodo.23867558](https://doi.org/10.5281/zenodo.23867558)
