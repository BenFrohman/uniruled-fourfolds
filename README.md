# Uniruled fourfolds and the Hodge conjecture

**The Clay Mathematics Institute Hodge conjecture is open. This repository does not resolve it, close it, or claim a proof of it.**

The goal of this repository is narrower and exact: record a classical theorem, separate it from the Millennium problem, and ship a small checked calculator for integer Mukai vectors. It does not push the frontier. It refuses a false closure.

## Status

| Statement | Status |
|---|---|
| Clay Hodge conjecture: for every smooth projective complex variety, every rational Hodge class is a rational linear combination of classes of algebraic cycles | **Open.** Millennium Prize problem. |
| Rational Hodge conjecture for a smooth complex projective **fourfold covered by rational curves** (a uniruled fourfold) | **Theorem.** Conte–Murre, 1978. |
| Lefschetz theorem on (1,1)-classes | **Theorem.** Classical (Lefschetz, 1924). |
| Rational Hodge conjecture for smooth cubic fourfolds | **Theorem.** Zucker, Compositio Math. **34** (1977). Also a special case of Conte–Murre, since a smooth cubic in \(\mathbb{P}^{5}\) is Fano. |
| Smooth complex Fano fourfolds | **Corollary** of Conte–Murre, once rational connectedness is known (Kollár–Miyaoka–Mori, J. Diff. Geom. **36** (1992)). Not a new case beyond uniruled fourfolds. |
| Kuznetsov's conjecture on rationality of cubic fourfolds | **Open.** |
| Categorical Torelli, Lehn's conjecture on tautological rings | **Open.** Not treated here. |
| Any Lean file in this repository | **Not a proof.** See below. |

## The theorem that is actually known

Conte and Murre proved:

> The Hodge conjecture holds for smooth complex projective fourfolds that admit a covering by rational curves.

A. Conte and J. P. Murre, *The Hodge conjecture for fourfolds admitting a covering by rational curves*, Mathematische Annalen **238** (1978), 79–88. [doi:10.1007/BF01351457](https://doi.org/10.1007/BF01351457).

Bloch and Srinivas later gave the form quoted in textbooks. Claire Voisin, *Hodge Theory and Complex Algebraic Geometry II*, Proposition 10.26:

> Let \(X\) be a smooth complex projective variety. If there is a closed subvariety \(X'\subset X\) of dimension at most 3 such that \(CH_0(X')\to CH_0(X)\) is surjective, then the Hodge conjecture holds for rational Hodge classes of degree 4 on \(X\).

A uniruled smooth projective fourfold has its Chow group of zero-cycles supported on a proper closed subset, hence on something of dimension at most 3. Degree 4 is the only open bidegree on a fourfold: codimension 1 is Lefschetz (1,1), codimension 3 follows by hard Lefschetz, and codimension 4 is points. So the rational Hodge conjecture for these fourfolds is the Conte–Murre theorem. It was not proved in this repository. The precise statement, the Fano and cubic corollaries, the holes in a five-line “direct pathway,” and the reason the pathway cannot reach a general fourfold are in [docs/special-cases.md](docs/special-cases.md).

The same argument does **not** apply to a general fourfold. A general fourfold is not uniruled, and \(CH_0\) is not supported in dimension \(\le 3\). That is why the Clay problem is still open. Cubic fourfolds are uniruled, so their *rational Hodge* classes of type \((2,2)\) are algebraic by the theorem above. Rationality of a general cubic fourfold is a different question and is open.

## What the reduction actually says

The Bloch–Srinivas decomposition is not an extra hypothesis one is free to assume or deny for these varieties. For a uniruled \(X\) it is available, and the proof that degree-4 Hodge classes are algebraic runs through it:

1. Spread the diagonal of \(X\) so that one piece is supported on \(Y\times X\) with \(\dim Y\le 3\), and the other piece does not act on \(H^4\) in the way that produces new transcendental classes (the precise support statement is in Bloch–Srinivas and in Voisin, §10.2).
2. A rational Hodge class \(\alpha\in H^4(X,\mathbb{Q})\cap H^{2,2}(X)\) is recovered from the action of that correspondence.
3. The surviving piece factors through a smooth projective threefold (a resolution of a component of the support).
4. On a smooth projective threefold, rational Hodge classes are algebraic: \(H^2\) by the Lefschetz (1,1)-theorem, \(H^4\) by hard Lefschetz from \(H^2\).
5. Push the resulting cycle forward to \(X\).

That is an outline of a published proof, not a new one. A file that assumes the conclusion, returns `True`, or ends in `sorry` does not check this argument.

## Why the accompanying Lean sketch is not a formal proof

[`lean/UniruledFourfoldHodge.lean`](lean/UniruledFourfoldHodge.lean) is a specification of the *shape* of the statement. It was not compiled. Lean is not run in the workflow that added it. There is no `lakefile`, no Mathlib pin, and the proof is `sorry`.

Earlier drafts of this material were not formalizations. Typical failures, which this file is written to avoid repeating:

- `axiom`s whose conclusion is `True`, so they assert nothing.
- A "theorem" whose goal is `∃ Z, true`. In Lean 4, `true` is a `Bool` constructor, not the proposition `True`. Even the proposition `∃ Z, True` does not mention the cycle class map, so it is not the Hodge conjecture and not the Conte–Murre theorem.
- A predicate `verifyLehnsConjectureRelations` defined to return `true`.
- Comments that say a development "compiles flawlessly" when the statements do not typecheck against Mathlib, because the cohomology and Chow types used there are not Mathlib's.

A `sorry` under a correctly spelled statement would still only be a claim that a proof exists. Conte–Murre already supplied that proof, on paper, in 1978.

## Mukai vectors

[`python/mukai.py`](python/mukai.py) computes the rank-3 integer Mukai square

\[
v^2 = v_2^2 - 2\, v_0 v_4
\]

and primitivity \(\gcd(|v_0|,|v_2|,|v_4|)=1\).

This is the quadratic form \(\langle(r,c,s),(r',c',s')\rangle = c\cdot c' - rs' - sr'\) specialized to integer middle component. It is not the Beauville–Bogomolov form of a hyper-Kähler fourfold, and it does not detect algebraicity of Hodge classes.

Corrected table (the triple \((2,0,-1)\) is primitive):

| \((v_0,v_2,v_4)\) | square | primitive |
|---|---|---|
| \((1,0,-1)\) | \(2\) | yes |
| \((2,0,-1)\) | \(4\) | yes |
| \((0,1,0)\) | \(1\) | yes |
| \((2,0,-2)\) | \(8\) | no |

```bash
cd python && python -m unittest test_mukai.py -v
```

## What this repository will not do

It will not state that a Millennium problem has been solved. It will not treat an LLM transcript, a Boolean flag, or an unfinished Lean file as a refereed proof. It will not carry a Lean declaration that the cycle class map is surjective for every fourfold: that declaration is the Clay problem, assumed rather than proved. A `lakefile` whose `require` URL is `https://github.com` does not load Mathlib and is not part of this repository.
