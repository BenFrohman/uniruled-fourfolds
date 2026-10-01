/-
Copyright (c) 2026 Benjamin Frohman. MIT License.
GitHub account: BenFrohman.
See LICENSE in the repository root.

Integer arithmetic on a rank-3 vector (v0, v2, v4).

  square     = v2^2 - 2 * v0 * v4
  pairing    = u2 * v2 - u0 * v4 - u4 * v0
  primitive  iff  gcd(|v0|, |v2|, |v4|) = 1

The square is the pairing of a vector with itself.
This file does not state or prove any cycle-class surjectivity claim.
-/

structure MukaiVector where
  v0 : Int
  v2 : Int
  v4 : Int

def mukaiSquareNorm (v : MukaiVector) : Int :=
  v.v2 * v.v2 - 2 * v.v0 * v.v4

def mukaiPairing (u v : MukaiVector) : Int :=
  u.v2 * v.v2 - u.v0 * v.v4 - u.v4 * v.v0

def isPrimitive (v : MukaiVector) : Bool :=
  Nat.gcd (Nat.gcd v.v0.natAbs v.v2.natAbs) v.v4.natAbs == 1

def isOrthogonal (u v : MukaiVector) : Bool :=
  mukaiPairing u v == 0

def subLatticeDiscriminant (u v : MukaiVector) : Int :=
  mukaiSquareNorm u * mukaiSquareNorm v - mukaiPairing u v * mukaiPairing u v

def vectorK3 : MukaiVector := { v0 := 1, v2 := 0, v4 := -1 }
def vectorTransverse : MukaiVector := { v0 := 2, v2 := 0, v4 := -1 }
def vectorSurface : MukaiVector := { v0 := 0, v2 := 1, v4 := 0 }
def vectorNonPrim : MukaiVector := { v0 := 2, v2 := 0, v4 := -2 }
def vectorNegK3 : MukaiVector := { v0 := -1, v2 := 0, v4 := 1 }

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

theorem cert_square_is_self_pairing (v : MukaiVector) :
    mukaiSquareNorm v = mukaiPairing v v := by
  unfold mukaiSquareNorm mukaiPairing
  rw [Int.mul_comm v.v4 v.v0, Int.mul_assoc, Int.two_mul, ← Int.sub_sub]

theorem cert_pair_neg_k3 : mukaiPairing vectorK3 vectorNegK3 = -2 := by decide
theorem cert_k3_not_orthogonal_to_neg : isOrthogonal vectorK3 vectorNegK3 = false := by decide
theorem cert_k3_surface_orthogonal : isOrthogonal vectorK3 vectorSurface = true := by decide

theorem cert_k3_surface_discriminant :
    subLatticeDiscriminant vectorK3 vectorSurface = 2 := by decide

theorem disc_of_orthogonal_pair (u v : MukaiVector) (h : mukaiPairing u v = 0) :
    subLatticeDiscriminant u v = mukaiSquareNorm u * mukaiSquareNorm v := by
  unfold subLatticeDiscriminant
  rw [h, Int.mul_zero, Int.sub_zero]

/-
`inSpan u v z` means z = x * u + y * v in Z^3.
`IsPrimitiveSpan` is the torsion-free condition on Z^3 / Z u + Z v:
if n * z is in the span and n ≠ 0, then z is in the span.
This is not a check that gcd(anything, 1) = 1. That equality is true
for every pair of vectors, and it does not mention an ambient lattice.
-/

def inSpan (u v z : MukaiVector) : Prop :=
  ∃ x y : Int,
    z.v0 = x * u.v0 + y * v.v0 ∧
    z.v2 = x * u.v2 + y * v.v2 ∧
    z.v4 = x * u.v4 + y * v.v4

def scaled (n : Int) (z : MukaiVector) : MukaiVector :=
  { v0 := n * z.v0, v2 := n * z.v2, v4 := n * z.v4 }

def IsPrimitiveSpan (u v : MukaiVector) : Prop :=
  ∀ n z, n ≠ 0 → inSpan u v (scaled n z) → inSpan u v z

theorem cert_k3_surface_span_primitive :
    IsPrimitiveSpan vectorK3 vectorSurface := by
  intro n z hn h
  rcases h with ⟨x, _, h0, _, h4⟩
  have hx : n * z.v0 = x := by
    simpa [vectorK3, vectorSurface, scaled] using h0
  have h4' : n * z.v4 = -x := by
    simpa [vectorK3, vectorSurface, scaled] using h4
  have hmul : n * (z.v0 + z.v4) = 0 := by
    calc
      n * (z.v0 + z.v4) = n * z.v0 + n * z.v4 := by rw [Int.mul_add]
      _ = x + -x := by rw [hx, h4']
      _ = 0 := by rw [Int.add_right_neg]
  have hsum : z.v0 + z.v4 = 0 := by
    rcases (Int.mul_eq_zero.mp hmul) with hn0 | hz
    · exact absurd hn0 hn
    · exact hz
  have hv4 : z.v4 = -z.v0 :=
    (Int.neg_eq_of_add_eq_zero hsum).symm
  refine ⟨z.v0, z.v2, ?_, ?_, ?_⟩
  · simp [vectorK3, vectorSurface]
  · simp [vectorK3, vectorSurface]
  · simp [vectorK3, vectorSurface, hv4]


def main : IO Unit := do
  IO.println s!"(1, 0, -1) square {mukaiSquareNorm vectorK3} primitive {isPrimitive vectorK3}"
  IO.println s!"(2, 0, -1) square {mukaiSquareNorm vectorTransverse} primitive {isPrimitive vectorTransverse}"
  IO.println s!"(0, 1, 0) square {mukaiSquareNorm vectorSurface} primitive {isPrimitive vectorSurface}"
  IO.println s!"(2, 0, -2) square {mukaiSquareNorm vectorNonPrim} primitive {isPrimitive vectorNonPrim}"
  IO.println s!"pairing (1, 0, -1) (-1, 0, 1) = {mukaiPairing vectorK3 vectorNegK3}"
  IO.println s!"orthogonal (1, 0, -1) (0, 1, 0) = {isOrthogonal vectorK3 vectorSurface}"
