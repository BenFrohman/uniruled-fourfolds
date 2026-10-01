import Lake
open Lake DSL

/-
Copyright (c) 2026 Benjamin Frohman. All rights reserved.
See LICENSE.

Builds the two Lean files in this repository. Neither file imports
Mathlib. `Blueprint.lean` contains `sorry`; a successful build only
means the file elaborates.
-/

package «uniruled-fourfolds»

@[default_target]
lean_lib UniruledFourfolds where
  roots := #[`UniruledFourfolds.Blueprint]

@[default_target]
lean_exe mukai where
  root := `UniruledFourfolds.MukaiLattice
