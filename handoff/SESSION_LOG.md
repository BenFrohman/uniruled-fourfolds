# Session log

Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0.

## Repository at the moment of this handoff

- Repository: https://github.com/BenFrohman/uniruled-fourfolds
- Default branch `main` at `78b58561ea5b04436fcea4a2a0c284b6640419a6`
- That commit is the merge of pull request 3, "Paper license CC BY 4.0, layout fixes, re-lock paper hash"
- Merged 2026-11-23T21:07:29Z
- On that push, all four workflows completed with conclusion `success`:
  - Kernel certificate, run 45266412663
  - Lean header, run 45266412655
  - truth-gate, run 45266412538
  - Verify, run 45266412501
- Existing Zenodo software record: https://doi.org/10.5281/zenodo.23652974
- Citation date in CITATION.cff: 2026-10-01
- No file named `zenodo.yml` exists. No workflow calls the Zenodo API.

## Preview tunnel, 2026-11-15

The phone showed, at 01:04 CST:

    Port hds-fuyhqlzr5xje-6014-64xxm is not found
    cf-ray=a5ac67659dd65045-IAH,x-request-id=a5ac67659dd65045-IAH

That hostname belonged to the previous preview session. It was not a failed
`npm run build` and not a failed `lake build`.

- Last write of the wall-ledger page source: 2026-11-10 23:17:14 UTC, `src/routes/index.tsx`
- The replacement dev server process started 2026-11-15 07:04:51 UTC
- At 2026-11-15 07:07:08 UTC the server answered HTTP 200 and served a document whose title is "Wall ledger"

The code was not deleted. The saved preview address was.

## What was asked, and what the gate allows

On 2026-11-15 the session contained the sentence "Wow the Mukai Vector solver resolves clay hodge".
The solver computes the integer square `c*c - 2*r*s` and a gcd primitivity test.
`RELEASES.md` states the limit of that computation. This handoff does not widen it.

The wall-ledger volume is one Three.js scene with eighteen modes, a cut plane,
and a draggable charge. It draws the same stand-in geometry. Tapping the
`h(2,2)=21` cell does not produce an algebraic cycle.

## Drafts

Seventy-six text drafts from the session are copied, unmodified, under
`session-drafts/`. Their sha256 values are in `MANIFEST.json`. They include
exploratory Lean fragments, Python wall plots, GitHub Actions sketches, and
prose that overclaims. The truth gate does not read this directory. A bot
must not promote any of it into `UniruledFourfolds/` or `paper/`.
