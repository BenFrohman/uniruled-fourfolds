---
name: Peer review
about: Ask for a check of a specific file in this repository.
title: "[review]: "
labels: []
assignees: []
---

Copyright (c) 2026 Benjamin Stanley Frohman (GitHub: BenFrohman). Apache License, Version 2.0.

## Scope

Name the file. `UniruledFourfolds/MukaiLattice.lean` is integer arithmetic.
`UniruledFourfolds/Blueprint.lean` proves conditional theorems from the named
hypotheses (L11), (BS), (CL), (U). A review that says the repository proves
those hypotheses, or any case of the Hodge conjecture, is wrong.

## Checks

- [ ] `lake build` was run on Lean 4.34.1 with no `sorry` warning, and `bash scripts/verify-lock.sh` passed.
- [ ] `./verify_lean.sh` passed.
- [ ] `python3 validate_mukai.py` passed.
- [ ] No comment describes `(1, 0, -1)` and `(0, 1, 0)` as classes in \(K_0(\mathcal{A}_X)\), or their orthogonal in \(\mathbb{Z}^3\) as \(H^4(X, \mathbb{Z})_{\mathrm{tr}}\).

## Notes
