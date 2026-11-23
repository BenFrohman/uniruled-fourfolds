/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import UniruledFourfolds.Blueprint
import UniruledFourfolds.NonVacuity

/-!
# UniruledFourfolds.Semantics

Truth Gate lock for the whole paper. Every theorem and proposition of the paper
(thm:reduction, thm:uniruled, prop:consistent, prop:independent (a)-(d)) has a
`formal_claim_X` (the Lean theorem's statement), an independent `paper_claim_X`
transcribed from the quoted English with every named hypothesis written out from
Section sec:setting (no paper_claim names `Lefschetz11`, `BSDecomposition`,
`ClCompatible`, `BlochSrinivasHypothesis`, `CycleClassSurjective` or `Represents`), and
`intended_correspondence_X : formal_claim_X ↔ paper_claim_X` proved by reasoning, not `rfl`.

PAPER_PATH: paper/uniruled_fourfolds_Technical_Monograph_2026.tex
PAPER_SHA256: 189b6e1abf0bcc5f7eeb34ba03180262e220744c32e47d54211c179cae120526
PAPER_SECTION: Sections 2 (sec:setting) and 3 (sec:results), Theorems 3-4 and Propositions 5-6

PAPER_QUOTE_BEGIN
\begin{definition}[Cycle-class setting, Lean \texttt{CycleClassSetting}]\label{def:setting}
A cycle-class setting $S$ assigns to every fourfold label $X$ types $\mathrm{Hdg}^4(X)$ (rational Hodge classes $H^4(X,\mathbb{Q})\cap H^{2,2}(X)$) and $\mathrm{CH}^2(X)_{\mathbb{Q}}$, and a map $\mathrm{cl}_X:\mathrm{CH}^2(X)_{\mathbb{Q}}\to\mathrm{Hdg}^4(X)$; to every threefold label $Y$ types $\mathrm{Hdg}^2(Y)$ and $\mathrm{CH}^1(Y)_{\mathbb{Q}}$, and a map $\mathrm{cl}_Y:\mathrm{CH}^1(Y)_{\mathbb{Q}}\to\mathrm{Hdg}^2(Y)$; and a predicate ``$X$ is uniruled''. These are uninterpreted data.
\end{definition}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\begin{definition}[Correspondence, Lean \texttt{Correspondence}]\label{def:corr}
A correspondence $\Gamma$ for $X$ consists of a threefold label $\tilde Y$ and maps $\Gamma^*:\mathrm{Hdg}^4(X)\to\mathrm{Hdg}^2(\tilde Y)$, $\Gamma_*:\mathrm{Hdg}^2(\tilde Y)\to\mathrm{Hdg}^4(X)$ and $\Gamma_*:\mathrm{CH}^1(\tilde Y)_{\mathbb{Q}}\to\mathrm{CH}^2(X)_{\mathbb{Q}}$.
\end{definition}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
The named hypotheses are:
\begin{itemize}
  \item \textbf{(L11)} \emph{Lefschetz $(1,1)$ on $Y$}, Lean \texttt{Lefschetz11}: for every $\beta\in\mathrm{Hdg}^2(Y)$ there is $z\in\mathrm{CH}^1(Y)_{\mathbb{Q}}$ with $\mathrm{cl}_Y(z)=\beta$.
  \item \textbf{(BS)} \emph{Bloch--Srinivas decomposition on Hodge classes}, Lean \texttt{BSDecomposition}: $\Gamma_*\Gamma^*\gamma=\gamma$ for every $\gamma\in\mathrm{Hdg}^4(X)$.
  \item \textbf{(CL)} \emph{Compatibility of the cycle class map}, Lean \texttt{ClCompatible}: $\mathrm{cl}_X(\Gamma_* z)=\Gamma_*(\mathrm{cl}_{\tilde Y}z)$ for every $z\in\mathrm{CH}^1(\tilde Y)_{\mathbb{Q}}$.
  \item \textbf{(U)} \emph{Bloch--Srinivas correspondences for uniruled fourfolds}, Lean \texttt{BlochSrinivasHypothesis}: every uniruled $X$ has a correspondence $\Gamma$ satisfying (BS) and (CL).
\end{itemize}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\begin{theorem}[Conditional reduction, Lean \texttt{conditionalCycleClassReduction}]\label{thm:reduction}
Let $S$ be a cycle-class setting, $X$ a fourfold label and $\Gamma$ a correspondence for $X$ with threefold $\tilde Y$. If $\Gamma$ satisfies (BS) and (CL), and (L11) holds on $\tilde Y$, then for every $\gamma\in\mathrm{Hdg}^4(X)$ there is $Z\in\mathrm{CH}^2(X)_{\mathbb{Q}}$ with $\mathrm{cl}_X(Z)=\gamma$.
\end{theorem}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\begin{theorem}[Conditional statement for uniruled fourfolds, Lean \texttt{uniruled\_cycleClassSurjective}]\label{thm:uniruled}
Let $S$ be a cycle-class setting. If (U) holds and (L11) holds on every threefold label, then for every uniruled fourfold label $X$ and every $\gamma\in\mathrm{Hdg}^4(X)$ there is $Z\in\mathrm{CH}^2(X)_{\mathbb{Q}}$ with $\mathrm{cl}_X(Z)=\gamma$.
\end{theorem}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\begin{proposition}[Consistency, Lean \texttt{hypotheses\_consistent}]\label{prop:consistent}
There are a cycle-class setting $S$, a uniruled fourfold label $X$ and a correspondence $\Gamma$ for $X$ such that (U) holds, (L11) holds on every threefold label, and $\Gamma$ satisfies (BS) and (CL).
\end{proposition}
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\begin{proposition}[No hypothesis can be dropped, Lean \texttt{lefschetz\_not\_redundant}, \texttt{decomposition\_not\_redundant}, \texttt{compatibility\_not\_redundant}, \texttt{blochSrinivas\_not\_redundant}]\label{prop:independent}
(a) There are $S$, $X$, $\Gamma$ such that $\Gamma$ satisfies (BS) and (CL), (L11) fails on $\tilde Y$, and some $\gamma\in\mathrm{Hdg}^4(X)$ is not $\mathrm{cl}_X(Z)$ for any $Z$.
(b) There are $S$, $X$, $\Gamma$ such that (L11) holds on $\tilde Y$, $\Gamma$ satisfies (CL), (BS) fails, and some $\gamma\in\mathrm{Hdg}^4(X)$ is not $\mathrm{cl}_X(Z)$ for any $Z$.
(c) There are $S$, $X$, $\Gamma$ such that (L11) holds on $\tilde Y$, $\Gamma$ satisfies (BS), (CL) fails, and some $\gamma\in\mathrm{Hdg}^4(X)$ is not $\mathrm{cl}_X(Z)$ for any $Z$.
(d) There are $S$ and a uniruled $X$ such that (L11) holds on every threefold label, (U) fails, and some $\gamma\in\mathrm{Hdg}^4(X)$ is not $\mathrm{cl}_X(Z)$ for any $Z$.
\end{proposition}
PAPER_QUOTE_END

Scope: CONDITIONAL. (L11), (BS), (CL) and (U) are assumptions, not theorems of this
development; the groups, maps and the uniruledness predicate are uninterpreted fields of
`CycleClassSetting`. The kernel certifies the implications and the finite-model
propositions only. Lock written 2026-11-23 under the author's instruction of that day
(restate the axioms and the sorry as named hypotheses, paper says conditional). Approval is
recorded under the author's standing rule of 2026-11-17, 12:55 AM CT (America/Chicago), in his
words: "my approval auto records as yes if the lean kernel and mathcing paper are aligned and
all checks pass less the author truth gate". On 2026-11-23 the Truth Gate alignment and every
other check passed on PR #3 (runs 45265634643, 45265634605, 45265568312, 45265633840).
-/

namespace UniruledFourfolds.TruthGate

open UniruledFourfolds

-- TRUTH-GATE LOCK BEGIN
/-- Theorem thm:reduction, formal side: the statement of `conditionalCycleClassReduction`. -/
def formal_claim_reduction : Prop :=
  ∀ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    Lefschetz11 S Γ.Y → BSDecomposition S Γ → ClCompatible S Γ → CycleClassSurjective S X

/-- Theorem thm:reduction, paper side, transcribed from the English: "If Γ satisfies (BS)
and (CL), and (L11) holds on Ỹ, then for every γ ∈ Hdg⁴(X) there is Z ∈ CH²(X)_ℚ with
cl_X(Z) = γ", with (BS), (CL), (L11) written out from Section sec:setting. -/
def paper_claim_reduction : Prop :=
  ∀ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    ((∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
     (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z)) ∧
     (∀ β : S.Hdg2 Γ.Y, ∃ z : S.CH1 Γ.Y, S.cl2 Γ.Y z = β)) →
    ∀ γ : S.Hdg4 X, ∃ Z : S.CH2 X, S.cl4 X Z = γ

theorem intended_correspondence_reduction : formal_claim_reduction ↔ paper_claim_reduction := by
  constructor
  · intro hf S X Γ hyp γ
    obtain ⟨hBS, hCL, hL⟩ := hyp
    exact hf S X Γ (fun β => hL β) (fun g => hBS g) (fun z => hCL z) γ
  · intro hp S X Γ hL hBS hCL γ
    exact hp S X Γ ⟨fun g => hBS g, fun z => hCL z, fun β => hL β⟩ γ

/-- Theorem thm:uniruled, formal side: the statement of `uniruled_cycleClassSurjective`. -/
def formal_claim_uniruled : Prop :=
  ∀ (S : CycleClassSetting), BlochSrinivasHypothesis S →
    (∀ Y : ComplexProjectiveVariety 3, Lefschetz11 S Y) →
    ∀ X : ComplexProjectiveVariety 4, S.IsUniruled X → CycleClassSurjective S X

/-- Theorem thm:uniruled, paper side: "If (U) holds and (L11) holds on every threefold label,
then for every uniruled fourfold label X and every γ ∈ Hdg⁴(X) there is Z ∈ CH²(X)_ℚ with
cl_X(Z) = γ", with (U) written out from Section sec:setting. -/
def paper_claim_uniruled : Prop :=
  ∀ (S : CycleClassSetting),
    ((∀ X : ComplexProjectiveVariety 4, S.IsUniruled X →
        ∃ Γ : Correspondence S X,
          (∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
          (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z))) ∧
     (∀ (Y : ComplexProjectiveVariety 3) (β : S.Hdg2 Y), ∃ z : S.CH1 Y, S.cl2 Y z = β)) →
    ∀ X : ComplexProjectiveVariety 4, S.IsUniruled X →
      ∀ γ : S.Hdg4 X, ∃ Z : S.CH2 X, S.cl4 X Z = γ

theorem intended_correspondence_uniruled : formal_claim_uniruled ↔ paper_claim_uniruled := by
  constructor
  · intro hf S hyp X hX γ
    obtain ⟨hU, hL⟩ := hyp
    refine hf S ?_ (fun Y β => hL Y β) X hX γ
    intro X' hX'
    obtain ⟨Γ, hBS, hCL⟩ := hU X' hX'
    exact ⟨Γ, fun g => hBS g, fun z => hCL z⟩
  · intro hp S hU hL X hX γ
    refine hp S ⟨?_, fun Y β => hL Y β⟩ X hX γ
    intro X' hX'
    obtain ⟨Γ, hBS, hCL⟩ := hU X' hX'
    exact ⟨Γ, fun g => hBS g, fun z => hCL z⟩

/-- Proposition prop:consistent, formal side: the statement of `hypotheses_consistent`. -/
def formal_claim_consistent : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    S.IsUniruled X ∧ Lefschetz11 S Γ.Y ∧ BSDecomposition S Γ ∧ ClCompatible S Γ ∧
    BlochSrinivasHypothesis S ∧ (∀ Y, Lefschetz11 S Y)

/-- Proposition prop:consistent, paper side: "There are a cycle-class setting S, a uniruled
fourfold label X and a correspondence Γ for X such that (U) holds, (L11) holds on every
threefold label, and Γ satisfies (BS) and (CL)." -/
def paper_claim_consistent : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    S.IsUniruled X ∧
    (∀ X' : ComplexProjectiveVariety 4, S.IsUniruled X' →
        ∃ Γ' : Correspondence S X',
          (∀ γ : S.Hdg4 X', Γ'.pushH (Γ'.pullH γ) = γ) ∧
          (∀ z : S.CH1 Γ'.Y, S.cl4 X' (Γ'.pushCH z) = Γ'.pushH (S.cl2 Γ'.Y z))) ∧
    (∀ (Y : ComplexProjectiveVariety 3) (β : S.Hdg2 Y), ∃ z : S.CH1 Y, S.cl2 Y z = β) ∧
    (∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
    (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z))

theorem intended_correspondence_consistent : formal_claim_consistent ↔ paper_claim_consistent := by
  constructor
  · intro ⟨S, X, Γ, hX, _, hBS, hCL, hU, hL⟩
    refine ⟨S, X, Γ, hX, ?_, fun Y β => hL Y β, fun g => hBS g, fun z => hCL z⟩
    intro X' hX'
    obtain ⟨Γ', h1, h2⟩ := hU X' hX'
    exact ⟨Γ', fun g => h1 g, fun z => h2 z⟩
  · intro ⟨S, X, Γ, hX, hU, hL, hBS, hCL⟩
    refine ⟨S, X, Γ, hX, fun β => hL Γ.Y β, fun g => hBS g, fun z => hCL z, ?_,
      fun Y β => hL Y β⟩
    intro X' hX'
    obtain ⟨Γ', h1, h2⟩ := hU X' hX'
    exact ⟨Γ', fun g => h1 g, fun z => h2 z⟩

/-- "Some γ ∈ Hdg⁴(X) is not cl_X(Z) for any Z" is the negation of cycle-class surjectivity. -/
theorem exists_not_class_iff (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) :
    (∃ γ : S.Hdg4 X, ∀ Z : S.CH2 X, S.cl4 X Z ≠ γ) ↔ ¬ CycleClassSurjective S X := by
  constructor
  · intro ⟨γ, hγ⟩ hs
    obtain ⟨Z, hZ⟩ := hs γ
    exact hγ Z hZ
  · intro hn
    apply Classical.byContradiction
    intro hne
    apply hn
    intro γ
    apply Classical.byContradiction
    intro hno
    exact hne ⟨γ, fun Z hZ => hno ⟨Z, hZ⟩⟩

/-- Proposition prop:independent (a), formal side: the statement of `lefschetz_not_redundant`. -/
def formal_claim_l11_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    BSDecomposition S Γ ∧ ClCompatible S Γ ∧ ¬ Lefschetz11 S Γ.Y ∧
    ¬ CycleClassSurjective S X

/-- Proposition prop:independent (a), paper side. -/
def paper_claim_l11_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    (∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
    (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z)) ∧
    ¬ (∀ β : S.Hdg2 Γ.Y, ∃ z : S.CH1 Γ.Y, S.cl2 Γ.Y z = β) ∧
    ∃ γ : S.Hdg4 X, ∀ Z : S.CH2 X, S.cl4 X Z ≠ γ

theorem intended_correspondence_l11_needed : formal_claim_l11_needed ↔ paper_claim_l11_needed := by
  constructor
  · intro ⟨S, X, Γ, hBS, hCL, hnL, hns⟩
    exact ⟨S, X, Γ, fun g => hBS g, fun z => hCL z, fun hL => hnL (fun β => hL β),
      (exists_not_class_iff S X).mpr hns⟩
  · intro ⟨S, X, Γ, hBS, hCL, hnL, hγ⟩
    exact ⟨S, X, Γ, fun g => hBS g, fun z => hCL z, fun hL => hnL (fun β => hL β),
      (exists_not_class_iff S X).mp hγ⟩

/-- Proposition prop:independent (b), formal side: the statement of
`decomposition_not_redundant`. -/
def formal_claim_bs_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    Lefschetz11 S Γ.Y ∧ ClCompatible S Γ ∧ ¬ BSDecomposition S Γ ∧
    ¬ CycleClassSurjective S X

/-- Proposition prop:independent (b), paper side. -/
def paper_claim_bs_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    (∀ β : S.Hdg2 Γ.Y, ∃ z : S.CH1 Γ.Y, S.cl2 Γ.Y z = β) ∧
    (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z)) ∧
    ¬ (∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
    ∃ γ : S.Hdg4 X, ∀ Z : S.CH2 X, S.cl4 X Z ≠ γ

theorem intended_correspondence_bs_needed : formal_claim_bs_needed ↔ paper_claim_bs_needed := by
  constructor
  · intro ⟨S, X, Γ, hL, hCL, hnBS, hns⟩
    exact ⟨S, X, Γ, fun β => hL β, fun z => hCL z, fun h => hnBS (fun g => h g),
      (exists_not_class_iff S X).mpr hns⟩
  · intro ⟨S, X, Γ, hL, hCL, hnBS, hγ⟩
    exact ⟨S, X, Γ, fun β => hL β, fun z => hCL z, fun h => hnBS (fun g => h g),
      (exists_not_class_iff S X).mp hγ⟩

/-- Proposition prop:independent (c), formal side: the statement of
`compatibility_not_redundant`. -/
def formal_claim_cl_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    Lefschetz11 S Γ.Y ∧ BSDecomposition S Γ ∧ ¬ ClCompatible S Γ ∧
    ¬ CycleClassSurjective S X

/-- Proposition prop:independent (c), paper side. -/
def paper_claim_cl_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4) (Γ : Correspondence S X),
    (∀ β : S.Hdg2 Γ.Y, ∃ z : S.CH1 Γ.Y, S.cl2 Γ.Y z = β) ∧
    (∀ γ : S.Hdg4 X, Γ.pushH (Γ.pullH γ) = γ) ∧
    ¬ (∀ z : S.CH1 Γ.Y, S.cl4 X (Γ.pushCH z) = Γ.pushH (S.cl2 Γ.Y z)) ∧
    ∃ γ : S.Hdg4 X, ∀ Z : S.CH2 X, S.cl4 X Z ≠ γ

theorem intended_correspondence_cl_needed : formal_claim_cl_needed ↔ paper_claim_cl_needed := by
  constructor
  · intro ⟨S, X, Γ, hL, hBS, hnCL, hns⟩
    exact ⟨S, X, Γ, fun β => hL β, fun g => hBS g, fun h => hnCL (fun z => h z),
      (exists_not_class_iff S X).mpr hns⟩
  · intro ⟨S, X, Γ, hL, hBS, hnCL, hγ⟩
    exact ⟨S, X, Γ, fun β => hL β, fun g => hBS g, fun h => hnCL (fun z => h z),
      (exists_not_class_iff S X).mp hγ⟩

/-- Proposition prop:independent (d), formal side: the statement of
`blochSrinivas_not_redundant`. -/
def formal_claim_u_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4),
    S.IsUniruled X ∧ (∀ Y, Lefschetz11 S Y) ∧ ¬ BlochSrinivasHypothesis S ∧
    ¬ CycleClassSurjective S X

/-- Proposition prop:independent (d), paper side. -/
def paper_claim_u_needed : Prop :=
  ∃ (S : CycleClassSetting) (X : ComplexProjectiveVariety 4),
    S.IsUniruled X ∧
    (∀ (Y : ComplexProjectiveVariety 3) (β : S.Hdg2 Y), ∃ z : S.CH1 Y, S.cl2 Y z = β) ∧
    ¬ (∀ X' : ComplexProjectiveVariety 4, S.IsUniruled X' →
        ∃ Γ' : Correspondence S X',
          (∀ γ : S.Hdg4 X', Γ'.pushH (Γ'.pullH γ) = γ) ∧
          (∀ z : S.CH1 Γ'.Y, S.cl4 X' (Γ'.pushCH z) = Γ'.pushH (S.cl2 Γ'.Y z))) ∧
    ∃ γ : S.Hdg4 X, ∀ Z : S.CH2 X, S.cl4 X Z ≠ γ

theorem intended_correspondence_u_needed : formal_claim_u_needed ↔ paper_claim_u_needed := by
  constructor
  · intro ⟨S, X, hX, hL, hnU, hns⟩
    refine ⟨S, X, hX, fun Y β => hL Y β, ?_, (exists_not_class_iff S X).mpr hns⟩
    intro hU
    apply hnU
    intro X' hX'
    obtain ⟨Γ', h1, h2⟩ := hU X' hX'
    exact ⟨Γ', fun g => h1 g, fun z => h2 z⟩
  · intro ⟨S, X, hX, hL, hnU, hγ⟩
    refine ⟨S, X, hX, fun Y β => hL Y β, ?_, (exists_not_class_iff S X).mp hγ⟩
    intro hU
    apply hnU
    intro X' hX'
    obtain ⟨Γ', h1, h2⟩ := hU X' hX'
    exact ⟨Γ', fun g => h1 g, fun z => h2 z⟩
-- TRUTH-GATE LOCK END

theorem formal_claim_reduction_holds : formal_claim_reduction :=
  @UniruledFourfolds.conditionalCycleClassReduction

theorem paper_claim_reduction_holds : paper_claim_reduction :=
  intended_correspondence_reduction.mp formal_claim_reduction_holds

theorem formal_claim_uniruled_holds : formal_claim_uniruled :=
  @UniruledFourfolds.uniruled_cycleClassSurjective

theorem paper_claim_uniruled_holds : paper_claim_uniruled :=
  intended_correspondence_uniruled.mp formal_claim_uniruled_holds

theorem formal_claim_consistent_holds : formal_claim_consistent :=
  @UniruledFourfolds.hypotheses_consistent

theorem paper_claim_consistent_holds : paper_claim_consistent :=
  intended_correspondence_consistent.mp formal_claim_consistent_holds

theorem formal_claim_l11_needed_holds : formal_claim_l11_needed :=
  @UniruledFourfolds.lefschetz_not_redundant

theorem paper_claim_l11_needed_holds : paper_claim_l11_needed :=
  intended_correspondence_l11_needed.mp formal_claim_l11_needed_holds

theorem formal_claim_bs_needed_holds : formal_claim_bs_needed :=
  @UniruledFourfolds.decomposition_not_redundant

theorem paper_claim_bs_needed_holds : paper_claim_bs_needed :=
  intended_correspondence_bs_needed.mp formal_claim_bs_needed_holds

theorem formal_claim_cl_needed_holds : formal_claim_cl_needed :=
  @UniruledFourfolds.compatibility_not_redundant

theorem paper_claim_cl_needed_holds : paper_claim_cl_needed :=
  intended_correspondence_cl_needed.mp formal_claim_cl_needed_holds

theorem formal_claim_u_needed_holds : formal_claim_u_needed :=
  @UniruledFourfolds.blochSrinivas_not_redundant

theorem paper_claim_u_needed_holds : paper_claim_u_needed :=
  intended_correspondence_u_needed.mp formal_claim_u_needed_holds

end UniruledFourfolds.TruthGate
