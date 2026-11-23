/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import UniruledFourfolds.Blueprint

/-
See LICENSE in the repository root.

Non-vacuity of the named hypotheses in `Blueprint.lean`, proved by finite models.

* `hypotheses_consistent`: all hypotheses hold together in one setting with a uniruled `X`,
  so the conditional theorems are not true merely because their hypotheses are contradictory.
* `lefschetz_not_redundant`, `decomposition_not_redundant`, `compatibility_not_redundant`:
  for each of (L11), (BS), (CL) there is a setting where the other two hold and the
  conclusion fails. No hypothesis restates the conclusion, and none can be dropped.
* `blochSrinivas_not_redundant`: (L11) on every threefold, with `X` uniruled, does not
  give the conclusion without (U).

The models use `Unit`, `Bool` and `Empty` for the groups. They show the logical form of
the hypotheses only; they are not geometry.
-/

/-!
# UniruledFourfolds.NonVacuity

Machine-checked Lean 4 module.
-/

namespace UniruledFourfolds

/-- The one variety label used by the finite models. -/
def pt4 : ComplexProjectiveVariety 4 := ⟨Unit, true, true⟩
/-- The one threefold label used by the finite models. -/
def pt3 : ComplexProjectiveVariety 3 := ⟨Unit, true, true⟩

/-- A setting from its four groups and two maps, with every `X` uniruled. -/
def mkSetting (H4 H2 C2 C1 : Type) (c4 : C2 → H4) (c2 : C1 → H2) : CycleClassSetting where
  Hdg4 := fun _ => H4
  Hdg2 := fun _ => H2
  CH2 := fun _ => C2
  CH1 := fun _ => C1
  cl4 := fun _ => c4
  cl2 := fun _ => c2
  IsUniruled := fun _ => True

/-- All hypotheses hold at once, with `X` uniruled. -/
theorem hypotheses_consistent :
    ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
      S.IsUniruled X ∧ Lefschetz11 S Γ.Y ∧ BSDecomposition S Γ ∧ ClCompatible S Γ ∧
      BlochSrinivasHypothesis S ∧ (∀ Y, Lefschetz11 S Y) := by
  let S := mkSetting Unit Unit Unit Unit id id
  let Γ : Correspondence S pt4 := ⟨pt3, id, id, id⟩
  refine ⟨S, pt4, Γ, trivial, ?_, ?_, ?_, ?_, ?_⟩
  · intro β; exact ⟨β, rfl⟩
  · intro γ; rfl
  · intro z; rfl
  · intro X _
    exact ⟨⟨pt3, id, id, id⟩, fun _ => rfl, fun _ => rfl⟩
  · intro Y β; exact ⟨β, rfl⟩

/-- (BS) and (CL) hold, (L11) fails, and `cl_X` is not surjective. -/
theorem lefschetz_not_redundant :
    ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
      BSDecomposition S Γ ∧ ClCompatible S Γ ∧ ¬ Lefschetz11 S Γ.Y ∧
      ¬ CycleClassSurjective S X := by
  let S := mkSetting Bool Bool Empty Empty (fun e => nomatch e) (fun e => nomatch e)
  let Γ : Correspondence S pt4 := ⟨pt3, id, id, fun e => nomatch e⟩
  refine ⟨S, pt4, Γ, fun _ => rfl, (fun z => nomatch z), ?_, ?_⟩
  · intro h; obtain ⟨z, _⟩ := h true; exact nomatch z
  · intro h; obtain ⟨Z, _⟩ := h true; exact nomatch Z

/-- (L11) and (CL) hold, (BS) fails, and `cl_X` is not surjective. -/
theorem decomposition_not_redundant :
    ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
      Lefschetz11 S Γ.Y ∧ ClCompatible S Γ ∧ ¬ BSDecomposition S Γ ∧
      ¬ CycleClassSurjective S X := by
  let S := mkSetting Bool Unit Unit Unit (fun _ => true) id
  let Γ : Correspondence S pt4 := ⟨pt3, fun _ => (), fun _ => true, id⟩
  refine ⟨S, pt4, Γ, fun β => ⟨β, rfl⟩, fun _ => rfl, ?_, ?_⟩
  · intro h; exact Bool.noConfusion (h false)
  · intro h; obtain ⟨Z, hZ⟩ := h false; exact Bool.noConfusion hZ

/-- (L11) and (BS) hold, (CL) fails, and `cl_X` is not surjective. -/
theorem compatibility_not_redundant :
    ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
      Lefschetz11 S Γ.Y ∧ BSDecomposition S Γ ∧ ¬ ClCompatible S Γ ∧
      ¬ CycleClassSurjective S X := by
  let S := mkSetting Bool Bool Unit Bool (fun _ => true) id
  let Γ : Correspondence S pt4 := ⟨pt3, id, id, fun _ => ()⟩
  refine ⟨S, pt4, Γ, fun β => ⟨β, rfl⟩, fun _ => rfl, ?_, ?_⟩
  · intro h; exact Bool.noConfusion (h false)
  · intro h; obtain ⟨Z, hZ⟩ := h false; exact Bool.noConfusion hZ

/-- (L11) holds on every threefold and `X` is uniruled, (U) fails, and `cl_X` is not
surjective. -/
theorem blochSrinivas_not_redundant :
    ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4),
      S.IsUniruled X ∧ (∀ Y, Lefschetz11 S Y) ∧ ¬ BlochSrinivasHypothesis S ∧
      ¬ CycleClassSurjective S X := by
  let S := mkSetting Bool Unit Unit Unit (fun _ => true) id
  have hns : ¬ CycleClassSurjective S pt4 := by
    intro h; obtain ⟨Z, hZ⟩ := h false; exact Bool.noConfusion hZ
  refine ⟨S, pt4, trivial, fun _ β => ⟨β, rfl⟩, ?_, hns⟩
  intro hU
  exact hns (uniruled_cycleClassSurjective S hU (fun _ β => ⟨β, rfl⟩) pt4 trivial)

end UniruledFourfolds
