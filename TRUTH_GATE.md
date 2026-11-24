# TRUTH_GATE.md

Load this file first. Author: Benjamin Stanley Frohman.

## The vacuity trap
A paper's claim is English, so Lean can only check `formal_claim ↔ paper_claim` once
`paper_claim` is itself written in Lean. If `paper_claim` is defined as `formal_claim`, or
unfolds to it, the correspondence is `Iff.rfl` and proves nothing. That is forbidden here.

## The lock in this repository
- Semantics file: `UniruledFourfolds/Semantics.lean`, one `formal_claim_X`, `paper_claim_X`,
  `intended_correspondence_X` triple for every theorem and proposition of the paper.
- Paper: `paper/uniruled_fourfolds_Technical_Monograph_2026.tex`, sha256 `6f0222333b757415a454c0a219b1888e274d0029a7a34f01b3bb0d54e1ed9f65`.
- Claims: `reduction` (thm:reduction), `uniruled` (thm:uniruled), `consistent` (prop:consistent), `l11_needed` (prop:independent), `bs_needed` (prop:independent), `cl_needed` (prop:independent), `u_needed` (prop:independent).
- Whole paper: `scripts/truth_gate_check.py` fails if any `theorem`, `proposition`, `lemma` or
  `corollary` environment of the paper has a label that no claim covers.
- `scripts/verify-lock.sh` (run by `.github/workflows/truth-gate.yml` on push and pull request)
  fails on any sorry/admit/native_decide/axiom in any tracked Lean file or in the full build log,
  on a nonstandard axiom in any locked theorem, on a paper hash or quote mismatch, on an edited
  lock region, on `paper_claim_X` mentioning `formal_claim_X` or a repository Prop, on a
  correspondence proved by `rfl`, on definitionally equal claims, and on a correspondence proof
  that uses the main theorems. There is no author-approval job.

## Scope
CONDITIONAL. (L11), (BS), (CL) and (U) are named hypotheses, not theorems of this
development. Nothing here proves the Hodge conjecture or any case of it. Nothing is
published or claimed unless this gate passes.

## Locked paper text (verbatim)
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
