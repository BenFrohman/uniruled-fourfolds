#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. Apache License, Version 2.0.
# Truth Gate verification (see TRUTH_GATE.md). Run on a fresh checkout: it does the only
# lake build of the run, so the full build log covers every module. Fails on: any
# sorry/admit/native_decide/axiom in any tracked Lean file or in the full build log, a module
# not built in this run, a missing or edited lock, a paper hash/quote mismatch, a paper
# statement no claim covers, nonstandard axioms, a definitional (vacuous) correspondence, or a
# correspondence proof that leans on a main theorem.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p truth-gate-report
echo "== 1/4 static checks"
python3 scripts/truth_gate_check.py | tee truth-gate-report/static.txt
echo "== 2/4 lake build (fresh, full log)"
lake build 2>&1 | tee truth-gate-report/build.log
echo "== 3/4 full build log scan"
python3 scripts/check_build_log.py truth-gate-report/build.log | tee truth-gate-report/build-scan.txt
echo "== 4/4 kernel audit of the lock (axioms, non-vacuity, transport)"
lake env lean scripts/TruthGateAudit.lean 2>&1 | tee truth-gate-report/audit.txt
grep -q 'TRUTH GATE AUDIT PASS' truth-gate-report/audit.txt
if grep -qE 'TRUTH GATE FAIL|error:|sorryAx' truth-gate-report/audit.txt; then exit 1; fi
sha256sum TRUTH_GATE.lock UniruledFourfolds/Semantics.lean > truth-gate-report/sha256.txt
echo "TRUTH GATE PASS at $(git rev-parse HEAD)"
