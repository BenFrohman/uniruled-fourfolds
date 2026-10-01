#!/bin/bash
# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
# Runs the three numerical modules. This host is not macOS and has no
# PostgreSQL. A database write happens only inside a module when
# STABILITY_DB_URI is set. Exiting zero is not a proof.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

echo "[config] python3 and optional lake"
command -v python3
if command -v lake >/dev/null 2>&1; then
  lake build
else
  echo "[warn] lake is not on PATH"
fi
if command -v pg_isready >/dev/null 2>&1 && pg_isready -h localhost -p 5432 >/dev/null 2>&1; then
  echo "[config] PostgreSQL is accepting connections"
else
  echo "[warn] no PostgreSQL on localhost:5432"
fi

python3 potluck/sync_manifest.py
python3 potluck/finding_mod_spectral_map_002.py
python3 potluck/finding_mod_nmf_factor_003.py
python3 potluck/finding_mod_navier_stokes_007.py
python3 potluck/finding_mod_navier_stokes_pressure_010.py
python3 potluck/finding_mod_sat_phase_transition_012.py
python3 potluck/finding_mod_ksat_shift_014.py
python3 potluck/finding_mod_sat_contour_016.py
python3 potluck/finding_mod_sat_wireframe_018.py
python3 potluck/finding_mod_sat_entropy_020.py
python3 potluck/finding_mod_grand_finale_999.py
python3 potluck/finding_mod_gaussian_shannon_entropy_001.py

echo "[done] numerical modules finished"
