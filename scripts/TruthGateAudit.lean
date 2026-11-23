/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lean
import UniruledFourfolds.Semantics

/-!
# Truth Gate kernel audit

For every locked claim `X` (thm:reduction, thm:uniruled, prop:consistent, prop:independent):
* `formal_claim_X`, `paper_claim_X`, `intended_correspondence_X`, `formal_claim_X_holds`,
  `paper_claim_X_holds` and the main theorem exist with the required types;
* each depends only on `propext`, `Classical.choice`, `Quot.sound`;
* `paper_claim_X` does not mention `formal_claim_X`, the bodies differ, and the two claims are
  not definitionally equal (no vacuous lock);
* the proof of `intended_correspondence_X` does not use any main theorem or `*_holds` lemma;
* `formal_claim_X_holds` uses the main theorem, whose statement is `formal_claim_X`;
* `paper_claim_X_holds` is transported across `intended_correspondence_X`.
-/

open Lean Meta Elab Command

namespace TruthGateAudit

def standard : List Name := [``propext, ``Classical.choice, ``Quot.sound]
def ns : Name := `UniruledFourfolds.TruthGate
def claims : List (String × Name) :=
  [("reduction", `UniruledFourfolds.conditionalCycleClassReduction),
   ("uniruled", `UniruledFourfolds.uniruled_cycleClassSurjective),
   ("consistent", `UniruledFourfolds.hypotheses_consistent),
   ("l11_needed", `UniruledFourfolds.lefschetz_not_redundant),
   ("bs_needed", `UniruledFourfolds.decomposition_not_redundant),
   ("cl_needed", `UniruledFourfolds.compatibility_not_redundant),
   ("u_needed", `UniruledFourfolds.blochSrinivas_not_redundant)]

partial def reach (env : Environment) (todo : List Name) (seen : NameSet) : NameSet :=
  match todo with
  | [] => seen
  | n :: rest =>
    if seen.contains n then reach env rest seen else
    let seen := seen.insert n
    let upstream := match env.getModuleIdxFor? n with
      | some i => let m := env.header.moduleNames[i.toNat]!
          [`Init, `Std, `Lean, `Lake].any (·.isPrefixOf m)
      | none => false
    if upstream then reach env rest seen else
    match env.find? n with
    | none => reach env rest seen
    | some ci =>
      let cs := ci.type.getUsedConstants ++ (match ci.value? (allowOpaque := true) with
        | some v => v.getUsedConstants | none => #[])
      reach env (cs.toList ++ rest) seen

def directUses (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some ci => ((ci.value? (allowOpaque := true)).map (·.getUsedConstants) |>.getD #[]).foldl (·.insert ·) {}
  | none => {}

end TruthGateAudit

open TruthGateAudit in
run_cmd do
  let env ← getEnv
  let mut ok := true
  let allMains := claims.map (·.2)
  let allHolds := claims.foldl (fun acc (c, _) =>
    acc ++ [ns ++ Name.mkSimple s!"formal_claim_{c}_holds", ns ++ Name.mkSimple s!"paper_claim_{c}_holds"]) []
  for (c, main) in claims do
    let fcN := ns ++ Name.mkSimple s!"formal_claim_{c}"
    let pcN := ns ++ Name.mkSimple s!"paper_claim_{c}"
    let icN := ns ++ Name.mkSimple s!"intended_correspondence_{c}"
    let fhN := ns ++ Name.mkSimple s!"formal_claim_{c}_holds"
    let phN := ns ++ Name.mkSimple s!"paper_claim_{c}_holds"
    let req := [fcN, pcN, icN, fhN, phN, main]
    let missing := req.filter (fun n => !env.contains n)
    unless missing.isEmpty do
      logInfo m!"TRUTH GATE FAIL [{c}]: missing declarations {missing}"; ok := false; continue
    let fc := mkConst fcN
    let pc := mkConst pcN
    unless (← getConstInfo icN).type == mkApp2 (mkConst ``Iff) fc pc do
      logInfo m!"TRUTH GATE FAIL [{c}]: {icN} does not have type formal ↔ paper"; ok := false
    for (n, t) in [(fhN, fc), (phN, pc)] do
      unless (← getConstInfo n).type == t do
        logInfo m!"TRUTH GATE FAIL [{c}]: {n} does not have the locked type"; ok := false
    for n in req do
      let axs ← collectAxioms n
      let bad := axs.filter (fun a => !standard.contains a)
      logInfo m!"AXIOMS {n}: {axs.toList}"
      unless bad.isEmpty do
        logInfo m!"TRUTH GATE FAIL [{c}]: {n} uses nonstandard axioms {bad.toList}"; ok := false
    let fv := ((← getConstInfo fcN).value? (allowOpaque := true)).getD fc
    let pv := ((← getConstInfo pcN).value? (allowOpaque := true)).getD pc
    if pv.getUsedConstants.any (fun n => (toString n).startsWith (toString ns ++ ".formal_claim")) then
      logInfo m!"TRUTH GATE FAIL [{c}]: paper_claim mentions a formal_claim (alias)"; ok := false
    if fv == pv then
      logInfo m!"TRUTH GATE FAIL [{c}]: formal and paper claims have equal bodies"; ok := false
    let defeq? : Option Bool ← liftTermElabM <| withTransparency .all <| withoutModifyingState <|
      withTheReader Core.Context (fun c => { c with maxHeartbeats := 2000000 }) <|
        (try some <$> isDefEq fc pc catch _ => pure none)
    match defeq? with
    | some true =>
      logInfo m!"TRUTH GATE FAIL [{c}]: formal and paper claims are definitionally equal (vacuous lock)"; ok := false
    | some false => logInfo m!"NON-DEFEQ [{c}]: formal_claim_{c} and paper_claim_{c} are not definitionally equal"
    | none =>
      logInfo m!"TRUTH GATE FAIL [{c}]: definitional-equality check inconclusive"; ok := false
    let r := reach env [icN] {}
    for n in allMains ++ allHolds do
      if r.contains n then
        logInfo m!"TRUTH GATE FAIL [{c}]: {icN} depends on {n}"; ok := false
    unless (reach env [fhN] {}).contains main do
      logInfo m!"TRUTH GATE FAIL [{c}]: {fhN} does not use {main}"; ok := false
    let mt := (← getConstInfo main).type
    let same ← liftTermElabM <| withTransparency .default <| withoutModifyingState <|
      (try isDefEq mt fc catch _ => pure false)
    unless same do
      logInfo m!"TRUTH GATE FAIL [{c}]: the statement of {main} is not formal_claim_{c}"; ok := false
    unless (directUses env phN).contains icN do
      logInfo m!"TRUTH GATE FAIL [{c}]: {phN} is not transported across {icN}"; ok := false
  if ok then
    logInfo m!"TRUTH GATE AUDIT PASS: {claims.length} claims locked, standard axioms only"
  else
    throwError "TRUTH GATE FAIL"

#print axioms UniruledFourfolds.conditionalCycleClassReduction
#print axioms UniruledFourfolds.uniruled_cycleClassSurjective
#print axioms UniruledFourfolds.hypotheses_consistent
#print axioms UniruledFourfolds.lefschetz_not_redundant
#print axioms UniruledFourfolds.decomposition_not_redundant
#print axioms UniruledFourfolds.compatibility_not_redundant
#print axioms UniruledFourfolds.blochSrinivas_not_redundant
#print axioms UniruledFourfolds.TruthGate.paper_claim_reduction_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_uniruled_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_consistent_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_l11_needed_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_bs_needed_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_cl_needed_holds
#print axioms UniruledFourfolds.TruthGate.paper_claim_u_needed_holds
