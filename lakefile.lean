/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lake

/-!
# lakefile

Machine-checked Lean 4 module.
-/

open Lake DSL

/-
Copyright (c) 2026 Benjamin Stanley Frohman. Apache License, Version 2.0.
See LICENSE.

Builds every Lean module in this repository. No file imports
Mathlib. No file contains `sorry` or `axiom`; CI fails on either.
-/

package «uniruled-fourfolds»

@[default_target]
lean_lib UniruledFourfolds where
  roots := #[`UniruledFourfolds.Blueprint, `UniruledFourfolds.NonVacuity, `UniruledFourfolds.Semantics]

@[default_target]
lean_exe mukai where
  root := `UniruledFourfolds.MukaiLattice
