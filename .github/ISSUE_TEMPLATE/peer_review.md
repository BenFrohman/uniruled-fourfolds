---
name: Peer review
about: Ask for a check of a specific file in this repository.
title: "[review]: "
labels: []
assignees: []
---

## Scope

Name the file. `UniruledFourfolds/MukaiLattice.lean` is integer arithmetic.
`UniruledFourfolds/Blueprint.lean` ends in `sorry`. A review that says the
repository contains no `sorry` is wrong.

## Checks

- [ ] `lake build` was run on Lean 4.34.1. The Blueprint warning is expected.
- [ ] `./verify_lean.sh` passed.
- [ ] `python3 validate_mukai.py` passed.
- [ ] No comment describes `(1, 0, -1)` and `(0, 1, 0)` as classes in \(K_0(\mathcal{A}_X)\), or their orthogonal in \(\mathbb{Z}^3\) as \(H^4(X, \mathbb{Z})_{\mathrm{tr}}\).

## Notes
