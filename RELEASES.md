# What is checked, and what is not

Copyright (c) 2026 Benjamin Stanley Frohman. Apache License, Version 2.0. See LICENSE.

There is no release of this repository that certifies a case of the Hodge conjecture. Conte–Murre (1978), Zucker (1977), and Kollár–Miyaoka–Mori (1992) are citations in [docs/special-cases.md](docs/special-cases.md). They are not formalized here.

## Current state (November 23, 2026)

`UniruledFourfolds/Blueprint.lean` contains no `sorry` and no `axiom`. The former eight axioms and the `sorry` are now the named hypotheses (L11) `Lefschetz11`, (BS) `BSDecomposition`, (CL) `ClCompatible` and (U) `BlochSrinivasHypothesis`. `conditionalCycleClassReduction` and `uniruled_cycleClassSurjective` are proved from them, and `UniruledFourfolds/NonVacuity.lean` proves in finite models that the hypotheses are jointly consistent and that none can be dropped. The hypotheses are open assumptions; the groups and maps are uninterpreted fields of `CycleClassSetting`. The paper is locked by the Truth Gate (`TRUTH_GATE.lock`). The certificates are the official artifacts of the `Kernel certificate` and `truth-gate` workflows.

## History

- v1.0.0 (tag `v1.0.0`, commit `7f24320`, October 2026): historical. At that version `Blueprint.lean` ended in `sorry` and postulated its data with eight `axiom` declarations. The `audit/TITAN_AUDIT_CERTIFICATE.json` committed then recorded `sorry_count` 2 with the verdict `PASS_ZERO_SORRY_HONEST_BOUNDARY`, which was false; it was not a certificate. Its content, and that of `audit/SEALGUARD_CLASSIFIED_MANIFEST.json` and `PROVENANCE_MERKLE_ROOT.json` committed at the same time, is now a pointer to the official `kernel-certificate` and `truth-gate-report` artifacts; the originals remain in git history at `7f24320`.


## Checked

Lean 4.34.1, no Mathlib. `lake build` builds every module. The description below of `MukaiLattice.lean` is unchanged. `MukaiLattice.lean` proves, by `decide`, the four rows of the integer table:

| Vector | Square | Primitive |
|---|---|---|
| `(1, 0, -1)` | 2 | true |
| `(2, 0, -1)` | 4 | true |
| `(0, 1, 0)` | 1 | true |
| `(2, 0, -2)` | 8 | false |

Those theorems are about `Int` and `Nat.gcd`. They are not a lattice-theoretic certification of a hyper-Kähler moduli space.

GitHub Actions runs `lake build`, the full build-log scan, `#print axioms`, the external kernel re-check and the Truth Gate. The local script `scripts/pre-commit` also requires `lake exe mukai` to print this table.

## Not scheduled as a proof development

Homological projective duality, Hochschild homology, the Artin–Mumford invariant, and Bridgeland stability are not implemented in this repository. Adding them as axioms, or as `sorry`, would not be a later version of a verified Hodge proof.
