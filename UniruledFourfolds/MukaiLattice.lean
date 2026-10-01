/-
Copyright (c) 2026 Benjamin Frohman. All rights reserved.
See LICENSE in the repository root.

Integer arithmetic on a rank-3 Mukai vector (v0, v2, v4).

  square     = v2^2 - 2 * v0 * v4
  primitive  iff  gcd(|v0|, |v2|, |v4|) = 1

This file does not state or prove any cycle-class surjectivity claim.
-/

structure MukaiVector where
  v0 : Int
  v2 : Int
  v4 : Int

def mukaiSquareNorm (v : MukaiVector) : Int :=
  v.v2 * v.v2 - 2 * v.v0 * v.v4

def isPrimitive (v : MukaiVector) : Bool :=
  Nat.gcd (Nat.gcd v.v0.natAbs v.v2.natAbs) v.v4.natAbs == 1

def vectorK3 : MukaiVector := { v0 := 1, v2 := 0, v4 := -1 }
def vectorTransverse : MukaiVector := { v0 := 2, v2 := 0, v4 := -1 }
def vectorSurface : MukaiVector := { v0 := 0, v2 := 1, v4 := 0 }
def vectorNonPrim : MukaiVector := { v0 := 2, v2 := 0, v4 := -2 }

/-
These are proofs about the four integer vectors above.
They use only Lean's `Int` and `Nat.gcd`. They do not import Mathlib,
and they do not mention cycles or the Hodge conjecture.
-/

theorem cert_k3_norm : mukaiSquareNorm vectorK3 = 2 := by decide
theorem cert_k3_primitive : isPrimitive vectorK3 = true := by decide

theorem cert_transverse_norm : mukaiSquareNorm vectorTransverse = 4 := by decide
theorem cert_transverse_primitive : isPrimitive vectorTransverse = true := by decide

theorem cert_surface_norm : mukaiSquareNorm vectorSurface = 1 := by decide
theorem cert_surface_primitive : isPrimitive vectorSurface = true := by decide

theorem cert_nonprim_norm : mukaiSquareNorm vectorNonPrim = 8 := by decide
theorem cert_nonprim_not_primitive : isPrimitive vectorNonPrim = false := by decide

def main : IO Unit := do
  IO.println s!"(1, 0, -1) square {mukaiSquareNorm vectorK3} primitive {isPrimitive vectorK3}"
  IO.println s!"(2, 0, -1) square {mukaiSquareNorm vectorTransverse} primitive {isPrimitive vectorTransverse}"
  IO.println s!"(0, 1, 0) square {mukaiSquareNorm vectorSurface} primitive {isPrimitive vectorSurface}"
  IO.println s!"(2, 0, -2) square {mukaiSquareNorm vectorNonPrim} primitive {isPrimitive vectorNonPrim}"
