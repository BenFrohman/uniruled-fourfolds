/-
Copyright (c) 2026 Benjamin Frohman. All rights reserved.
See LICENSE in the repository root.

Conditional sketch for uniruled complex projective fourfolds.

The surjectivity of the codimension-2 cycle class map, for a general
smooth projective variety, is open. This file does not prove it.

The theorem below is one conditional shape of a reduction to the
classical Lefschetz theorem on (1,1)-classes on a threefold. The
proof is `sorry`. Elaborating the file only checks that the statement
is well-formed. It does not check an argument, because there is none.

The types here are placeholders. They are not a development of a
cohomology theory.
-/

structure ComplexProjectiveVariety (dim : Nat) where
  Carrier : Type
  smooth : Bool
  projective : Bool

axiom FourfoldCohomology (X : ComplexProjectiveVariety 4) (n : Nat) : Type
axiom ThreefoldCohomology (Y : ComplexProjectiveVariety 3) (n : Nat) : Type
axiom FourfoldCycles (X : ComplexProjectiveVariety 4) : Type
axiom ThreefoldCycles (Y : ComplexProjectiveVariety 3) (codim : Nat) : Type

/-- A class in middle-dimensional cohomology. Placeholder, not a construction. -/
structure MiddleBidegreeClass (X : ComplexProjectiveVariety 4) where
  val : FourfoldCohomology X 4

axiom cycleClassMap (X : ComplexProjectiveVariety 4) :
  FourfoldCycles X → MiddleBidegreeClass X

axiom isUniruled (X : ComplexProjectiveVariety 4) : Prop

/-- `cycle` represents the class `γ`. Not defined. -/
axiom represents (Y : ComplexProjectiveVariety 3)
    (cycle : ThreefoldCycles Y 1) (γ : ThreefoldCohomology Y 2) : Prop

/-- Classical Lefschetz theorem on (1,1)-classes, cited and not proved here.
    The conclusion is that some codimension-1 cycle represents `γ`. -/
axiom lefschetz11 (Y : ComplexProjectiveVariety 3)
    (γ : ThreefoldCohomology Y 2) :
    ∃ cycle : ThreefoldCycles Y 1, represents Y cycle γ

/-- Data a Bloch–Srinivas decomposition would have to supply.
    Possessing this data is an assumption, not a theorem of this file. -/
structure BlochSrinivasData (X : ComplexProjectiveVariety 4) (h : isUniruled X) where
  skeleton : ComplexProjectiveVariety 3
  lift : MiddleBidegreeClass X → ThreefoldCohomology skeleton 2
  push : ThreefoldCycles skeleton 1 → FourfoldCycles X

/-- If a Bloch–Srinivas package is given, codimension-2 cycle-class
    surjectivity on `X` is claimed. Unproved: the script is `sorry`. -/
theorem conditionalCycleClassReduction
    (X : ComplexProjectiveVariety 4)
    (h : isUniruled X)
    (bs : BlochSrinivasData X h) :
    ∀ γ : MiddleBidegreeClass X, ∃ Z : FourfoldCycles X, cycleClassMap X Z = γ := by
  intro γ
  let _skeleton := bs.skeleton
  let _lifted := bs.lift γ
  let _h := h
  sorry
