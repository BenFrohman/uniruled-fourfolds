#!/bin/sh
# Copyright (c) 2026 Benjamin Frohman. All rights reserved.
# Typecheck MukaiLattice.lean and require main to print the proved table.
# This does not check Blueprint.lean and does not bear on the Hodge conjecture.

set -e
cd "$(dirname "$0")"

LEAN_FILE="MukaiLattice.lean"
if [ ! -f "$LEAN_FILE" ]; then
  echo "Error: $LEAN_FILE not found." >&2
  exit 1
fi

echo "lean $LEAN_FILE"
lean "$LEAN_FILE"

echo "lean --run $LEAN_FILE"
out=$(lean --run "$LEAN_FILE")
printf '%s\n' "$out"

expected="(1, 0, -1) square 2 primitive true
(2, 0, -1) square 4 primitive true
(0, 1, 0) square 1 primitive true
(2, 0, -2) square 8 primitive false"

if [ "$out" != "$expected" ]; then
  echo "Runtime output did not match the proved table." >&2
  exit 1
fi

echo "Mukai table matches."
