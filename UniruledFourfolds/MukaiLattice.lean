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

/-- The triple (2, 1, -2). This is not a class on a Gushel–Mukai fourfold. -/
def vectorTwoOneNegTwo : MukaiVector := { v0 := 2, v2 := 1, v4 := -2 }

/-- The triple (1, 1, 0). Not an exceptional object of a derived category. -/
def vectorOneOneZero : MukaiVector := { v0 := 1, v2 := 1, v4 := 0 }

def basisV0 : MukaiVector := { v0 := 1, v2 := 0, v4 := 0 }
def basisV4 : MukaiVector := { v0 := 0, v2 := 0, v4 := 1 }

/-- Determinant of the 3×3 Gram matrix of three vectors. -/
def gramDet (u v w : MukaiVector) : Int :=
  let a := mukaiPairing u u
  let b := mukaiPairing u v
  let c := mukaiPairing u w
  let d := mukaiPairing v u
  let e := mukaiPairing v v
  let f := mukaiPairing v w
  let g := mukaiPairing w u
  let h := mukaiPairing w v
  let i := mukaiPairing w w
  a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)

/--
Squares equal to 1 and one pairing equal to 0. This is a boolean on two
integer triples. It is not the definition of an exceptional collection.
-/
def squaresOneAndPairingZero (u v : MukaiVector) : Bool :=
  (mukaiSquareNorm u == 1) && (mukaiSquareNorm v == 1) && (mukaiPairing v u == 0)

/--
Integer recipe `v4 = c1^2 - 2*c2 + tdFactor`. The summand `tdFactor` is an
input, not the Todd class. This is not the Grothendieck–Riemann–Roch theorem.
-/
def chernRecipe (rank c1 c2 tdFactor : Int) : MukaiVector :=
  { v0 := rank, v2 := c1, v4 := c1 * c1 - 2 * c2 + tdFactor }

/-
These are proofs about the four integer vectors above.
They use only Lean's `Int` and `Nat.gcd`. They do not import Mathlib,
and they do not mention cycles or the Hodge conjecture.
-/

theorem cert_k3_norm : mukaiSquareNorm vectorK3 = 2 := by decide
theorem cert_k3_primitive : isPrimitive vectorK3 = true := by decide

theorem cert_two_one_neg_two_norm : mukaiSquareNorm vectorTwoOneNegTwo = 9 := by decide
theorem cert_two_one_neg_two_primitive : isPrimitive vectorTwoOneNegTwo = true := by decide
theorem cert_k3_pairs_two_one_neg_two :
    mukaiPairing vectorK3 vectorTwoOneNegTwo = 4 := by decide

/-- The pairing is a positive integer. This is not a Bridgeland wall. -/
def pairingPositive (u v : MukaiVector) : Bool :=
  decide (mukaiPairing u v > 0)

theorem cert_k3_two_one_neg_two_pairing_positive :
    pairingPositive vectorK3 vectorTwoOneNegTwo = true := by decide

theorem cert_mukai_pairing_is_symmetric (u v : MukaiVector) :
    mukaiPairing u v = mukaiPairing v u := by
  unfold mukaiPairing
  rw [Int.mul_comm u.v2 v.v2, Int.mul_comm u.v0 v.v4, Int.mul_comm u.v4 v.v0]
  -- a - x - y = a - y - x
  rw [Int.sub_sub, Int.sub_sub, Int.add_comm]

theorem cert_one_one_zero_norm : mukaiSquareNorm vectorOneOneZero = 1 := by decide
theorem cert_surface_pairs_one_one_zero :
    mukaiPairing vectorSurface vectorOneOneZero = 1 := by decide
theorem cert_one_one_zero_surface_not_this_boolean :
    squaresOneAndPairingZero vectorOneOneZero vectorSurface = false := by decide

theorem cert_chern_recipe_hits_k3 :
    chernRecipe 1 0 1 1 = vectorK3 := by
  unfold chernRecipe vectorK3
  rfl

/--
The Gram matrix of the coordinate basis `(1,0,0)`, `(0,1,0)`, `(0,0,1)`
has determinant `-1`. The form is nondegenerate. It is not positive definite:
`(1,0,-1)` has square `2` and `(1,0,1)` has square `-2`.
-/
theorem cert_coordinate_gram_det :
    gramDet basisV0 vectorSurface basisV4 = -1 := by decide

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

/-
A vector w is in the orthogonal of span(u, v) when it pairs to 0 with both
generators. For u = (1, 0, -1) and v = (0, 1, 0) that is the line Z(1, 0, 1).
The vector (-1, 0, 1) pairs to -2 with u, so it is not in the orthogonal.
-/

def inOrthogonalComplement (u v w : MukaiVector) : Prop :=
  mukaiPairing u w = 0 ∧ mukaiPairing v w = 0

def vectorComplement : MukaiVector := { v0 := 1, v2 := 0, v4 := 1 }

theorem cert_neg_k3_not_in_complement :
    ¬ inOrthogonalComplement vectorK3 vectorSurface vectorNegK3 := by
  intro h
  have : mukaiPairing vectorK3 vectorNegK3 = 0 := h.1
  rw [cert_pair_neg_k3] at this
  cases this

theorem cert_complement_witness :
    inOrthogonalComplement vectorK3 vectorSurface vectorComplement := by
  unfold inOrthogonalComplement mukaiPairing vectorK3 vectorSurface vectorComplement
  constructor <;> rfl

theorem cert_complement_square : mukaiSquareNorm vectorComplement = -2 := by
  decide

theorem cert_basis_v0_square : mukaiSquareNorm basisV0 = 0 := by
  decide

/-- `sign = -1` is the formula in the draft. With square `-2`, the reflection is `sign = 1`. -/
def shiftByPairing (v s : MukaiVector) (sign : Int) : MukaiVector :=
  let p := mukaiPairing v s
  { v0 := v.v0 + sign * p * s.v0
    v2 := v.v2 + sign * p * s.v2
    v4 := v.v4 + sign * p * s.v4 }

theorem cert_minus_shift_transverse :
    shiftByPairing vectorTransverse vectorComplement (-1)
      = { v0 := 3, v2 := 0, v4 := 0 } := by
  unfold shiftByPairing mukaiPairing vectorTransverse vectorComplement
  rfl

theorem cert_plus_shift_transverse :
    shiftByPairing vectorTransverse vectorComplement 1
      = { v0 := 1, v2 := 0, v4 := -2 } := by
  unfold shiftByPairing mukaiPairing vectorTransverse vectorComplement
  rfl

def vectorAdd (v1 v2 : MukaiVector) : MukaiVector :=
  { v0 := v1.v0 + v2.v0, v2 := v1.v2 + v2.v2, v4 := v1.v4 + v2.v4 }

theorem shift_of_orthogonal (v s : MukaiVector) (sign : Int)
    (h : mukaiPairing v s = 0) :
    shiftByPairing v s sign = v := by
  unfold shiftByPairing
  rw [h]
  simp [Int.mul_zero, Int.zero_mul, Int.add_zero]

theorem pairing_add_left (v1 v2 s : MukaiVector) :
    mukaiPairing (vectorAdd v1 v2) s = mukaiPairing v1 s + mukaiPairing v2 s := by
  unfold mukaiPairing vectorAdd
  simp [Int.add_mul, Int.sub_eq_add_neg, Int.neg_add, Int.add_assoc, Int.add_left_comm]

def braidA : MukaiVector := { v0 := -2, v2 := -2, v4 := -1 }
def braidB : MukaiVector := { v0 := -1, v2 := -2, v4 := -1 }
def braidV : MukaiVector := { v0 := -1, v2 := -1, v4 := -1 }

theorem braid_pair : mukaiPairing braidA braidB = 1 := by
  unfold mukaiPairing braidA braidB
  rfl

def braidLeft : MukaiVector :=
  shiftByPairing (shiftByPairing (shiftByPairing braidV braidA (-1)) braidB (-1)) braidA (-1)

def braidRight : MukaiVector :=
  shiftByPairing (shiftByPairing (shiftByPairing braidV braidB (-1)) braidA (-1)) braidB (-1)

theorem braid_left_coord : braidLeft.v0 = -6 := by
  unfold braidLeft shiftByPairing mukaiPairing braidA braidB braidV
  rfl

theorem braid_right_coord : braidRight.v0 = -2 := by
  unfold braidRight shiftByPairing mukaiPairing braidA braidB braidV
  rfl

theorem braid_fails : braidLeft ≠ braidRight := by
  intro h
  have : braidLeft.v0 = braidRight.v0 := congrArg MukaiVector.v0 h
  rw [braid_left_coord, braid_right_coord] at this
  cases this

def smulVec (c : Int) (v : MukaiVector) : MukaiVector :=
  { v0 := c * v.v0, v2 := c * v.v2, v4 := c * v.v4 }

def twist (v s : MukaiVector) : MukaiVector :=
  vectorAdd v (smulVec (-(mukaiPairing v s)) s)

theorem pairing_smul_left (c : Int) (v s : MukaiVector) :
    mukaiPairing (smulVec c v) s = c * mukaiPairing v s := by
  unfold mukaiPairing smulVec
  simp [Int.mul_assoc, Int.mul_sub]

theorem pairing_twist (v a b : MukaiVector) :
    mukaiPairing (twist v a) b = mukaiPairing v b + (-(mukaiPairing v a)) * mukaiPairing a b := by
  unfold twist
  rw [pairing_add_left, pairing_smul_left]

theorem chain_clause_contradicts (a b : MukaiVector)
    (h1 : mukaiPairing a b = 1) (h0 : mukaiPairing b a = 0) : False := by
  rw [cert_mukai_pairing_is_symmetric b a, h1] at h0
  cases h0

theorem twists_commute_of_orthogonal (v a b : MukaiVector) (h : mukaiPairing a b = 0) :
    twist (twist v a) b = twist (twist v b) a := by
  have hba : mukaiPairing b a = 0 := by rw [cert_mukai_pairing_is_symmetric b a, h]
  have left_pair : mukaiPairing (twist v a) b = mukaiPairing v b := by
    rw [pairing_twist, h, Int.mul_zero, Int.add_zero]
  have right_pair : mukaiPairing (twist v b) a = mukaiPairing v a := by
    rw [pairing_twist, hba, Int.mul_zero, Int.add_zero]
  have hL : mukaiPairing (vectorAdd v (smulVec (-(mukaiPairing v a)) a)) b = mukaiPairing v b := by
    simpa [twist] using left_pair
  have hR : mukaiPairing (vectorAdd v (smulVec (-(mukaiPairing v b)) b)) a = mukaiPairing v a := by
    simpa [twist] using right_pair
  unfold twist
  rw [hL, hR]
  unfold vectorAdd smulVec
  simp [Int.add_assoc, Int.add_left_comm, Int.add_comm]

theorem complement_of_k3_surface (w : MukaiVector) :
    inOrthogonalComplement vectorK3 vectorSurface w ↔ w.v2 = 0 ∧ w.v0 = w.v4 := by
  unfold inOrthogonalComplement mukaiPairing vectorK3 vectorSurface
  refine ⟨?_, ?_⟩
  · intro h
    rcases h with ⟨hu, hv⟩
    have hv2 : w.v2 = 0 := by
      simpa [Int.mul_zero, Int.zero_mul, Int.sub_zero] using hv
    have hu' : -w.v4 + w.v0 = 0 := by
      simpa [Int.zero_mul, Int.one_mul, Int.neg_one_mul, Int.sub_eq_add_neg] using hu
    have hv4 : w.v4 = w.v0 := by
      have := Int.neg_eq_of_add_eq_zero hu'
      simpa [Int.neg_neg] using this
    exact ⟨hv2, hv4.symm⟩
  · intro h
    rcases h with ⟨hv2, h04⟩
    refine ⟨?_, ?_⟩
    · simp [hv2, h04, Int.one_mul, Int.neg_one_mul, Int.sub_self]
    · simp [hv2, Int.mul_zero, Int.zero_mul]

/-
μ(F) > μ(E) for positive ranks means ch1(F) * ch0(E) > ch1(E) * ch0(F).
This is slope comparison. It is not the Hilbert polynomial
χ(E(mH)), and it does not use ch2, ch3, or ch4.
-/

structure ChernData where
  ch0 : Int
  ch1 : Int

def higherSlope (F E : ChernData) : Prop :=
  F.ch0 > 0 ∧ E.ch0 > 0 ∧ F.ch1 * E.ch0 > E.ch1 * F.ch0

def slopeParent : ChernData := { ch0 := 2, ch1 := 0 }
def slopeSub : ChernData := { ch0 := 1, ch1 := -1 }

theorem sub_not_higher_slope : ¬ higherSlope slopeSub slopeParent := by
  intro h
  rcases h with ⟨_, _, hlt⟩
  simp [slopeParent, slopeSub] at hlt

theorem parent_higher_slope : higherSlope slopeParent slopeSub := by
  unfold higherSlope slopeParent slopeSub
  exact ⟨by decide, by decide, by decide⟩

/--
If `ch1 = 0`, `ch0 ≥ 0`, and `ch2 ≤ 0`, then `ch1^2 - 2 ch0 ch2 ≥ 0`.
This is an integer sign check. It is not the Bogomolov–Gieseker theorem:
nonnegative discriminant does not mean a sheaf is stable, and `ch1^2`
here is a product of integers, not an intersection number.
-/
theorem disc_nonneg_of_vanishing_ch1
    (ch0 ch1 ch2 : Int) (hc1 : ch1 = 0) (hr : 0 ≤ ch0) (hs : ch2 ≤ 0) :
    ch1 * ch1 - 2 * ch0 * ch2 ≥ 0 := by
  rw [hc1]
  have hneg : 0 ≤ -ch2 := Int.neg_nonneg_of_nonpos hs
  have hprod : 0 ≤ ch0 * -ch2 := Int.mul_nonneg hr hneg
  have htwo : (0 : Int) ≤ 2 := by decide
  have hscaled : 0 ≤ 2 * (ch0 * -ch2) := Int.mul_nonneg htwo hprod
  have heq : (0 : Int) * 0 - 2 * ch0 * ch2 = 2 * (ch0 * -ch2) := by
    rw [Int.mul_zero, Int.zero_sub, Int.neg_mul_eq_mul_neg, ← Int.mul_assoc]
  rw [heq]
  exact hscaled

/--
If `ch1 * ch3 ≤ 0` and `ch0 * ch4 ≥ 0`, then
`3 ch0 ch4 - ch1 ch3 + ch2^2 ≥ 0`.
This is a sum of nonnegative integers. It is not a Gieseker–Yau inequality.
-/
theorem chern_combination_nonneg
    (ch0 ch1 ch2 ch3 ch4 : Int)
    (h13 : ch1 * ch3 ≤ 0)
    (h04 : 0 ≤ ch0 * ch4) :
    0 ≤ 3 * ch0 * ch4 - ch1 * ch3 + ch2 * ch2 := by
  have h3 : (0 : Int) ≤ 3 := by decide
  have h04s : 0 ≤ 3 * (ch0 * ch4) := Int.mul_nonneg h3 h04
  have hpair : 0 ≤ -(ch1 * ch3) := Int.neg_nonneg_of_nonpos h13
  have hsq : 0 ≤ ch2 * ch2 := by
    have : ch2 * ch2 = ch2 ^ 2 := by rw [Int.pow_succ, Int.pow_one]
    rw [this]
    exact Int.sq_nonneg ch2
  have hsum : 0 ≤ 3 * (ch0 * ch4) + -(ch1 * ch3) + ch2 * ch2 :=
    Int.add_nonneg (Int.add_nonneg h04s hpair) hsq
  have heq :
      3 * ch0 * ch4 - ch1 * ch3 + ch2 * ch2
        = 3 * (ch0 * ch4) + -(ch1 * ch3) + ch2 * ch2 := by
    rw [Int.mul_assoc, Int.sub_eq_add_neg]
  rw [heq]
  exact hsum

/-
Adjunction for a smooth hypersurface of degree `d` and dimension `n`
in projective space: the canonical class is `(d - n - 2)` times the
hyperplane class. These two rows store that coefficient and the
classical Euler numbers. They are not computed from a Chern character
in this file, and `-4` is not the coefficient for a cubic fourfold.
-/

structure VarietyNumbers where
  dimension : Nat
  degree : Int
  canonical : Int
  euler : Int

def cubicFourfoldNumbers : VarietyNumbers :=
  { dimension := 4, degree := 3, canonical := -3, euler := 27 }

def quinticThreefoldNumbers : VarietyNumbers :=
  { dimension := 3, degree := 5, canonical := 0, euler := -200 }

theorem cubic_fourfold_adjunction :
    cubicFourfoldNumbers.degree - (cubicFourfoldNumbers.dimension : Int) - 2
      = cubicFourfoldNumbers.canonical := by decide

theorem quintic_threefold_adjunction :
    quinticThreefoldNumbers.degree - (quinticThreefoldNumbers.dimension : Int) - 2
      = quinticThreefoldNumbers.canonical := by decide

theorem cubic_fourfold_euler : cubicFourfoldNumbers.euler = 27 := by decide

theorem quintic_threefold_euler : quinticThreefoldNumbers.euler = -200 := by decide

theorem cubic_fourfold_not_zero_canonical :
    cubicFourfoldNumbers.canonical ≠ 0 := by decide

theorem cubic_anticanonical :
    -cubicFourfoldNumbers.canonical = 3 := by decide

theorem quintic_anticanonical :
    -quinticThreefoldNumbers.canonical = 0 := by decide

/-- A reflexive relation is not well-founded: `a` related to `a` blocks accessibility. -/
theorem acc_irrefl {α : Type} {r : α → α → Prop} {a : α} (h : Acc r a) : ¬ r a a := by
  induction h with
  | intro x _ ih =>
    intro hxx
    exact ih x hxx hxx

theorem nat_ge_not_wellFounded : ¬ WellFounded (fun a b : Nat => b ≤ a) := by
  intro h
  exact acc_irrefl (h.apply 0) (Nat.le_refl 0)

def IsPolynomialTimeBounded (f : Nat → Nat) : Prop :=
  ∃ k : Nat, ∀ n : Nat, f n ≤ n ^ k + k

/-- The draft sets both machine predicates to `True`, so they do not mention a machine. -/
def VacuousTime (_L : List Bool → Prop) (_f : Nat → Nat) : Prop := True

theorem zero_is_poly : IsPolynomialTimeBounded (fun _ : Nat => 0) := by
  refine ⟨1, ?_⟩
  intro n
  exact Nat.zero_le _

theorem vacuous_class_nonempty (L : List Bool → Prop) :
    ∃ f : Nat → Nat, IsPolynomialTimeBounded f ∧ VacuousTime L f := by
  exact ⟨fun _ => 0, zero_is_poly, trivial⟩

theorem vacuous_separation_false :
    ¬ ∃ L : List Bool → Prop,
        (∃ f, IsPolynomialTimeBounded f ∧ VacuousTime L f) ∧
        ¬ (∃ g, IsPolynomialTimeBounded g ∧ VacuousTime L g) := by
  intro h
  obtain ⟨_L, hyes, hno⟩ := h
  exact hno hyes

/-- `timeFn` is not a bound on the number of steps used to compute `map`. -/
structure PolyTimeLabel where
  map : List Bool → List Bool
  timeFn : Nat → Nat
  isPoly : IsPolynomialTimeBounded timeFn

theorem reduction_refl (L : List Bool → Prop) :
    ∃ f : PolyTimeLabel, ∀ x, L x ↔ L (f.map x) := by
  refine ⟨{ map := id, timeFn := fun _ => 0, isPoly := zero_is_poly }, ?_⟩
  intro x
  rfl

structure SatFormula where
  vars : Nat
  clauses : Nat

def DraftSatisfiable (_f : SatFormula) : Prop := True

def DraftSAT : List Bool → Prop := fun _str => ∃ f : SatFormula, DraftSatisfiable f

theorem draft_sat_holds (x : List Bool) : DraftSAT x :=
  ⟨{ vars := 0, clauses := 0 }, trivial⟩

theorem draft_cook_false :
    ¬ ((True : Prop) ∧ ∀ L : List Bool → Prop, True →
        ∃ f : PolyTimeLabel, ∀ x, L x ↔ DraftSAT (f.map x)) := by
  intro h
  obtain ⟨_, hred⟩ := h
  obtain ⟨f, hf⟩ := hred (fun _ => False) trivial
  exact (hf []).mpr (draft_sat_holds (f.map []))

theorem two_le_pow (m : Nat) : m ≤ 2 ^ m := by
  induction m with
  | zero => decide
  | succ m ih =>
    calc
      m + 1 ≤ 2 ^ m + 1 := Nat.add_le_add_right ih 1
      _ ≤ 2 ^ m + 2 ^ m := Nat.add_le_add_left (Nat.one_le_pow m 2 (by decide)) _
      _ = 2 ^ (m + 1) := by
        rw [← Nat.two_mul, Nat.pow_succ]
        omega

theorem base_le_pow {n m : Nat} (hn : 2 ≤ n) : m ≤ n ^ m :=
  Nat.le_trans (two_le_pow m) (Nat.pow_le_pow_left hn m)

theorem comp_bound (a b n : Nat) :
    (n ^ a + a) ^ b + b ≤ n ^ (a * b + (a + 1) ^ b + b) + (a * b + (a + 1) ^ b + b) := by
  let k := a * b + (a + 1) ^ b + b
  have hk_big : (a + 1) ^ b + b ≤ k := by
    calc
      (a + 1) ^ b + b ≤ a * b + ((a + 1) ^ b + b) := Nat.le_add_left _ _
      _ = k := by simp [k, Nat.add_assoc]
  cases n with
  | zero =>
    have h0a : 0 ^ a ≤ 1 := by
      cases a with
      | zero => simp
      | succ _ => simp
    have hsum : 0 ^ a + a ≤ a + 1 := by
      calc
        0 ^ a + a ≤ 1 + a := Nat.add_le_add_right h0a a
        _ = a + 1 := by omega
    have hp : (0 ^ a + a) ^ b ≤ (a + 1) ^ b := Nat.pow_le_pow_left hsum b
    have hlhs : (0 ^ a + a) ^ b + b ≤ k := Nat.le_trans (Nat.add_le_add_right hp b) hk_big
    have hkpos : 0 < k := by
      have h1 : 1 ≤ (a + 1) ^ b := Nat.one_le_pow b (a + 1) (by omega)
      have : 1 ≤ k := Nat.le_trans h1 (by
        calc
          (a + 1) ^ b ≤ a * b + (a + 1) ^ b := Nat.le_add_left _ _
          _ ≤ k := Nat.le_add_right _ _)
      omega
    have hzero : 0 ^ k = 0 := Nat.zero_pow hkpos
    simpa [k, hzero] using hlhs
  | succ n1 =>
    cases n1 with
    | zero =>
      have hone : 1 ^ a + a = 1 + a := by simp [Nat.one_pow]
      have hcomm : (1 + a) ^ b = (a + 1) ^ b := by
        have : 1 + a = a + 1 := by omega
        rw [this]
      have hrhs : k ≤ 1 ^ k + k := by simp [Nat.one_pow]
      have hlhs : (1 ^ a + a) ^ b + b ≤ k := by
        rw [hone, hcomm]
        exact hk_big
      exact Nat.le_trans hlhs hrhs
    | succ n2 =>
      let m := n2 + 2
      have hm : m = n2 + 2 := rfl
      have hn : 2 ≤ m := by simp [m]
      have hna : 1 ≤ m ^ a := Nat.one_le_pow a m (by omega)
      have ha_le : a ≤ a * m ^ a := by
        calc
          a = a * 1 := by omega
          _ ≤ a * m ^ a := Nat.mul_le_mul_left a hna
      have hsum : m ^ a + a ≤ (a + 1) * m ^ a := by
        calc
          m ^ a + a ≤ m ^ a + a * m ^ a := Nat.add_le_add_left ha_le _
          _ = (1 + a) * m ^ a := by rw [Nat.add_mul, Nat.one_mul]
          _ = (a + 1) * m ^ a := by
            have : 1 + a = a + 1 := by omega
            rw [this]
      have hmul : ((a + 1) * m ^ a) ^ b = (a + 1) ^ b * m ^ (a * b) := by
        rw [Nat.mul_pow, Nat.pow_mul]
      have hbase : (a + 1) ^ b ≤ m ^ ((a + 1) ^ b) := base_le_pow hn
      have hprod : (a + 1) ^ b * m ^ (a * b) ≤ m ^ ((a + 1) ^ b + a * b) := by
        calc
          (a + 1) ^ b * m ^ (a * b) ≤ m ^ ((a + 1) ^ b) * m ^ (a * b) :=
            Nat.mul_le_mul_right _ hbase
          _ = m ^ ((a + 1) ^ b + a * b) := by rw [← Nat.pow_add]
      have hexp : (a + 1) ^ b + a * b ≤ k := by
        simp only [k]
        omega
      have hpowk : m ^ ((a + 1) ^ b + a * b) ≤ m ^ k := Nat.pow_le_pow_right (by omega) hexp
      have hb_le : b ≤ k := by simp [k]
      have hfinal : m ^ ((a + 1) ^ b + a * b) + b ≤ m ^ k + k := Nat.add_le_add hpowk hb_le
      have hleft : (m ^ a + a) ^ b ≤ ((a + 1) * m ^ a) ^ b := Nat.pow_le_pow_left hsum b
      calc
        (m ^ a + a) ^ b + b ≤ ((a + 1) * m ^ a) ^ b + b := Nat.add_le_add_right hleft b
        _ = (a + 1) ^ b * m ^ (a * b) + b := by rw [hmul]
        _ ≤ m ^ ((a + 1) ^ b + a * b) + b := Nat.add_le_add_right hprod b
        _ ≤ m ^ k + k := hfinal

theorem suggested_degree_fails :
    ¬ ((1 ^ 2 + 2) ^ 2 + 2 ≤ 1 ^ (2 * 2 + 2 + 1) + (2 * 2 + 2 + 1)) := by
  decide

theorem poly_composition_coherence (f g : Nat → Nat)
    (hf : IsPolynomialTimeBounded f) (hg : IsPolynomialTimeBounded g) :
    IsPolynomialTimeBounded (g ∘ f) := by
  rcases hf with ⟨a, ha⟩
  rcases hg with ⟨b, hb⟩
  refine ⟨a * b + (a + 1) ^ b + b, ?_⟩
  intro n
  have hgf : g (f n) ≤ (f n) ^ b + b := hb (f n)
  have hpow : (f n) ^ b ≤ (n ^ a + a) ^ b := Nat.pow_le_pow_left (ha n) b
  exact Nat.le_trans (Nat.le_trans hgf (Nat.add_le_add_right hpow b)) (comp_bound a b n)

def DraftTimeClass (_f : Nat → Nat) : Prop := True

theorem draft_time_class_ignores_bound (f g : Nat → Nat) :
    DraftTimeClass f ↔ DraftTimeClass g := by
  simp [DraftTimeClass]

theorem theta_does_not_preserve_sign :
    (∃ C, ∀ _n : Nat, Int.natAbs (1 : Int) ≤ C * Int.natAbs (-1)) ∧
    (∃ C, ∀ _n : Nat, Int.natAbs (-1) ≤ C * Int.natAbs (1 : Int)) ∧
    (∀ _n : Nat, (0 : Int) ≤ 1) ∧
    ¬ (∀ _n : Nat, (0 : Int) ≤ -1) := by
  refine ⟨⟨1, ?_⟩, ⟨1, ?_⟩, ?_, ?_⟩
  · intro _; decide
  · intro _; decide
  · intro _; decide
  · intro h
    have h0 : (0 : Int) ≤ -1 := h 0
    omega

def DraftChern : Int := 1

theorem draft_chern_ignores_gauge (_gauge : Nat) : DraftChern = 1 := rfl

theorem id_slope (x h : Int) (hh : h ≠ 0) : ((x + h) - x) / h = 1 := by
  have : (x + h) - x = h := by omega
  rw [this]
  exact Int.ediv_self hh

theorem nat_offset_sub_self (x h : Nat) : (x + h) - x = h :=
  Nat.add_sub_cancel_left x h

theorem id_difference_quotient_rat (x h : Rat) (hh : h ≠ 0) :
    ((x + h) - x) / h = 1 := by
  grind

/--
The degree-3 piece of a product of two integer series.
The Todd class of a variety has rational coefficients, and there is no
pushforward here, so this is not the Grothendieck–Riemann–Roch theorem.
-/
def chernToddDegree3 (ch0 ch1 ch2 ch3 td0 td1 td2 td3 : Int) : Int :=
  ch3 * td0 + ch2 * td1 + ch1 * td2 + ch0 * td3

theorem degree3_when_higher_todd_vanishes (ch0 ch1 ch2 ch3 : Int) :
    chernToddDegree3 ch0 ch1 ch2 ch3 1 0 0 0 = ch3 := by
  unfold chernToddDegree3
  simp [Int.mul_one, Int.mul_zero, Int.add_zero]

def main : IO Unit := do
  IO.println s!"(1, 0, -1) square {mukaiSquareNorm vectorK3} primitive {isPrimitive vectorK3}"
  IO.println s!"(2, 0, -1) square {mukaiSquareNorm vectorTransverse} primitive {isPrimitive vectorTransverse}"
  IO.println s!"(0, 1, 0) square {mukaiSquareNorm vectorSurface} primitive {isPrimitive vectorSurface}"
  IO.println s!"(2, 0, -2) square {mukaiSquareNorm vectorNonPrim} primitive {isPrimitive vectorNonPrim}"
  IO.println s!"pairing (1, 0, -1) (-1, 0, 1) = {mukaiPairing vectorK3 vectorNegK3}"
  IO.println s!"orthogonal (1, 0, -1) (0, 1, 0) = {isOrthogonal vectorK3 vectorSurface}"
