/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-
See LICENSE in the repository root.

Conditional cycle-class reduction for uniruled complex projective fourfolds.

This file contains no `axiom` and no `sorry`. Every object that an earlier
version postulated with `axiom` is now a field of the structure
`CycleClassSetting`, and every geometric input is a named hypothesis
(a `Prop`) that the theorems take as an explicit argument. The theorems
prove `hypotheses → conclusion` and nothing more.

The rational Hodge conjecture for uniruled fourfolds is a theorem of
Conte–Murre (Math. Ann. 238, 1978), via Bloch–Srinivas (Amer. J. Math. 105,
1983). This file does NOT prove it: the cohomology groups, Chow groups,
cycle class maps and the uniruledness predicate are uninterpreted fields,
and the geometric inputs (Lefschetz (1,1), the Bloch–Srinivas
decomposition, functoriality of the cycle class) are hypotheses, not
theorems of this development.

Map from the removed axioms to this file:
  axiom FourfoldCohomology  ↦ field `Hdg4`  (Hdg⁴(X) = H⁴(X,ℚ) ∩ H^{2,2}(X))
  axiom ThreefoldCohomology ↦ field `Hdg2`  (Hdg²(Y) = H²(Y,ℚ) ∩ H^{1,1}(Y))
  axiom FourfoldCycles      ↦ field `CH2`   (CH²(X)_ℚ)
  axiom ThreefoldCycles     ↦ field `CH1`   (CH¹(Y)_ℚ)
  axiom cycleClassMap       ↦ field `cl4`   (cl_X : CH²(X)_ℚ → Hdg⁴(X))
  axiom isUniruled          ↦ field `IsUniruled`
  axiom represents          ↦ field `cl2`   (cl_Y = c₁ : CH¹(Y)_ℚ → Hdg²(Y)),
                              with `Represents S Y z β := S.cl2 Y z = β`
  axiom lefschetz11         ↦ named hypothesis `Lefschetz11 S Y`
  `sorry` in conditionalCycleClassReduction ↦ named hypotheses
                              `BSDecomposition` and `ClCompatible`
                              (and `BlochSrinivasHypothesis` for the
                              uniruled form), proof now complete.
-/

/-!
# UniruledFourfolds.Blueprint

Machine-checked Lean 4 module.
-/

namespace UniruledFourfolds

/-- A label for a complex projective variety of dimension `dim`. Placeholder, not a
construction of varieties. -/
structure ComplexProjectiveVariety (dim : Nat) where
  Carrier : Type
  smooth : Bool
  projective : Bool

/-- The cycle-class setting. Each field is data that the theorems are stated over; none
of it is constructed here. -/
structure CycleClassSetting where
  /-- `Hdg⁴(X) = H⁴(X, ℚ) ∩ H^{2,2}(X)`, rational Hodge classes of degree 4 on a fourfold. -/
  Hdg4 : ComplexProjectiveVariety 4 → Type
  /-- `Hdg²(Y) = H²(Y, ℚ) ∩ H^{1,1}(Y)`, rational Hodge classes of degree 2 on a threefold. -/
  Hdg2 : ComplexProjectiveVariety 3 → Type
  /-- `CH²(X)_ℚ`, codimension-2 cycles on `X` modulo rational equivalence. -/
  CH2 : ComplexProjectiveVariety 4 → Type
  /-- `CH¹(Y)_ℚ`, divisors on `Y` modulo rational equivalence. -/
  CH1 : ComplexProjectiveVariety 3 → Type
  /-- The cycle class map `cl_X : CH²(X)_ℚ → Hdg⁴(X)`. -/
  cl4 : (X : ComplexProjectiveVariety 4) → CH2 X → Hdg4 X
  /-- The cycle class map on divisors, `cl_Y = c₁ : CH¹(Y)_ℚ → Hdg²(Y)`. -/
  cl2 : (Y : ComplexProjectiveVariety 3) → CH1 Y → Hdg2 Y
  /-- `X` is uniruled (covered by rational curves). Uninterpreted predicate. -/
  IsUniruled : ComplexProjectiveVariety 4 → Prop

variable (S : CycleClassSetting)

/-- The divisor `z` represents the class `β` on `Y`: `cl_Y(z) = β`. -/
def Represents (Y : ComplexProjectiveVariety 3) (z : S.CH1 Y) (β : S.Hdg2 Y) : Prop :=
  S.cl2 Y z = β

/-- **Named hypothesis (L11).** Lefschetz theorem on (1,1)-classes for `Y`: every class in
`Hdg²(Y)` is the class of a divisor. Classical (Lefschetz 1924), not proved here. -/
def Lefschetz11 (Y : ComplexProjectiveVariety 3) : Prop :=
  ∀ β : S.Hdg2 Y, ∃ z : S.CH1 Y, Represents S Y z β

/-- A correspondence `Γ` between a smooth projective threefold `Ỹ` and `X`, with its actions
`Γ^* : Hdg⁴(X) → Hdg²(Ỹ)`, `Γ_* : Hdg²(Ỹ) → Hdg⁴(X)` and `Γ_* : CH¹(Ỹ)_ℚ → CH²(X)_ℚ`. -/
structure Correspondence (X : ComplexProjectiveVariety 4) where
  /-- The threefold `Ỹ` (in Bloch–Srinivas, a desingularized divisor of `X`). -/
  Y : ComplexProjectiveVariety 3
  /-- `Γ^*` on Hodge classes. -/
  pullH : S.Hdg4 X → S.Hdg2 Y
  /-- `Γ_*` on Hodge classes. -/
  pushH : S.Hdg2 Y → S.Hdg4 X
  /-- `Γ_*` on cycles. -/
  pushCH : S.CH1 Y → S.CH2 X

/-- **Named hypothesis (BS).** Bloch–Srinivas decomposition on `Hdg⁴(X)`: every Hodge class
`γ` satisfies `Γ_* Γ^* γ = γ`, so the identity of `Hdg⁴(X)` factors through `Hdg²(Ỹ)`.
Not proved here. -/
def BSDecomposition {X : ComplexProjectiveVariety 4} (Γ : Correspondence S X) : Prop :=
  ∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ

/-- **Named hypothesis (CL).** The cycle class map commutes with the correspondence:
`cl_X(Γ_* z) = Γ_*(cl_Ỹ z)` for every divisor `z` on `Ỹ`. Not proved here. -/
def ClCompatible {X : ComplexProjectiveVariety 4} (Γ : Correspondence S X) : Prop :=
  ∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z)

/-- **Named hypothesis (U).** Every uniruled fourfold carries a correspondence satisfying
(BS) and (CL). This is the step that Bloch–Srinivas supply from uniruledness; here it is
assumed, not proved. -/
def BlochSrinivasHypothesis : Prop :=
  ∀ X : ComplexProjectiveVariety 4, S.IsUniruled X →
    ∃ Γ : Correspondence S X, BSDecomposition S Γ ∧ ClCompatible S Γ

/-- Codimension-2 cycle-class surjectivity on `X`: every class in `Hdg⁴(X)` is `cl_X(Z)`. -/
def CycleClassSurjective (X : ComplexProjectiveVariety 4) : Prop :=
  ∀ γ : S.Hdg4 X, ∃ Z : S.CH2 X, S.cl4 X Z = γ

/-- **Conditional reduction.** If `Γ` satisfies (BS) and (CL) and Lefschetz (1,1) holds on
`Ỹ`, then `cl_X : CH²(X)_ℚ → Hdg⁴(X)` is surjective.
Proof: given `γ`, Lefschetz gives a divisor `z` with `cl_Ỹ z = Γ^* γ`; then
`cl_X(Γ_* z) = Γ_*(cl_Ỹ z) = Γ_* Γ^* γ = γ`. -/
theorem conditionalCycleClassReduction
    (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X)
    (hL : Lefschetz11 S Γ.Y) (hBS : BSDecomposition S Γ) (hCL : ClCompatible S Γ) :
    CycleClassSurjective S X := by
  intro γ
  obtain ⟨z, hz⟩ := hL (Γ.pullH γ)
  refine ⟨Γ.pushCH z, ?_⟩
  have hz' : S.cl2 Γ.Y z = Γ.pullH γ := hz
  rw [hCL z, hz', hBS γ]

/-- **Conditional statement for uniruled fourfolds.** Under (U) and Lefschetz (1,1) on every
threefold, every uniruled `X` has surjective `cl_X`. -/
theorem uniruled_cycleClassSurjective
    (hU : BlochSrinivasHypothesis S)
    (hL : ∀ Y : ComplexProjectiveVariety 3, Lefschetz11 S Y)
    (X : ComplexProjectiveVariety 4) (hX : S.IsUniruled X) :
    CycleClassSurjective S X := by
  obtain ⟨Γ, hBS, hCL⟩ := hU X hX
  exact conditionalCycleClassReduction S X Γ (hL Γ.Y) hBS hCL

end UniruledFourfolds
