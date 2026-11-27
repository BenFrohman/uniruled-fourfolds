# Handoff for Actions and Zenodo

Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0. See LICENSE.

Author: Benjamin Stanley Frohman. ORCID 0009-0006-7068-3718.

This directory is a session handoff. It is not a theorem, not a new paper, and not a
proof of the Hodge conjecture. The truth gate in TRUTH_GATE.md remains the only
publication rule. Load that file before this one.

## What the bots must do

1. Run the four workflows already on this repository. Do not add a fifth workflow
   in this handoff. Do not edit a check so that it can pass over a file.
2. Leave these files byte-for-byte as they are on `78b58561ea5b04436fcea4a2a0c284b6640419a6`:
   `paper/uniruled_fourfolds_Technical_Monograph_2026.tex`,
   `UniruledFourfolds/Semantics.lean`, `TRUTH_GATE.lock`, `TRUTH_GATE.md`,
   `.zenodo.json`, `CITATION.cff`.
3. Treat every file under `handoff/session-drafts/` as raw session input.
   Several of those drafts say, in English, that a Mukai calculator closes the
   Clay Hodge problem. That sentence is false, and it is not a statement of
   this repository. Do not copy it into the paper, the Lean sources, the
   README, the citation, or a Zenodo description.
4. Do not open a Zenodo version from this handoff. The software record already
   exists: 10.5281/zenodo.23652974. There is no Zenodo workflow in this
   repository. A later deposit, if the author orders one, must keep the title
   and the conditional description already in `.zenodo.json`.

## What is in this handoff

| Path | Role |
|---|---|
| `BOT_CONTRACT.json` | Machine-readable copy of the rules above. |
| `SESSION_LOG.md` | Dates, the dead preview hostname, the verified Mukai table, workflow run ids. |
| `MANIFEST.json` | sha256 of every session draft, every screenshot frame, and the six wall-ledger sources. |
| `session-drafts/` | All 76 text drafts, complete, unmodified. |
| `wall-ledger/` | The interactive volume as it was served on 2026-11-15. TypeScript and CSS only. Not Lean. Not checked by `lake build`. |

The 38 screenshot frames are listed in `MANIFEST.json` with sizes and sha256.
They are not committed. The plots they depict are the ones `plots/render_formulas.py`
already regenerates, plus the WebGL volume whose source is in `wall-ledger/`.

## Status of the mathematics, for the deposit text

Conditional. (L11), (BS), (CL) and (U) are hypotheses. `Blueprint.lean` ends in
`sorry` and is not part of the certified kernel. The integer table in
`RELEASES.md` is what the Mukai calculator proves:

| Vector | Square | Primitive |
|---|---|---|
| (1, 0, -1) | 2 | true |
| (2, 0, -1) | 4 | true |
| (0, 1, 0) | 1 | true |
| (2, 0, -2) | 8 | false |

Conte–Murre (1978) is a citation in `docs/special-cases.md`. It is not formalized here.
