# Special cases, stated precisely

Copyright (c) 2026 Benjamin Frohman. All rights reserved. See LICENSE.

The general Hodge conjecture is open. The statements below are textbooks cases. None of them is a proof written in this repository, and none of them is the Clay problem.

## Theorem (Conte–Murre, 1978)

Let \(X\) be a smooth complex projective variety with \(\dim_{\mathbb{C}} X = 4\). If \(X\) admits a covering by rational curves, then the rational Hodge conjecture holds for classes of degree 4: the cycle class map

\[
\mathrm{cl}\colon A^{2}(X)_{\mathbb{Q}} \longrightarrow H^{4}(X,\mathbb{Q})\cap H^{2,2}(X)
\]

is surjective. Every such class is a rational linear combination of classes of closed algebraic surfaces.

Source: A. Conte and J. P. Murre, Mathematische Annalen **238** (1978), 79–88, [doi:10.1007/BF01351457](https://doi.org/10.1007/BF01351457).

For smooth projective varieties over \(\mathbb{C}\), “covered by rational curves” is uniruledness. On a fourfold the other bidegrees are not open: codimension 1 is Lefschetz (1,1), codimension 3 follows by hard Lefschetz, and codimension 4 is zero-cycles of the right degree. So this theorem is the rational Hodge conjecture for uniruled fourfolds. It is not the Hodge conjecture.

## Why a five-line reduction is not the proof

A correct skeleton, and the places it has to be filled, is the following.

1. Uniruledness gives a dominant rational map \(\psi\colon Y\times\mathbb{P}^{1}\dashrightarrow X\) with \(Y\) smooth projective of dimension 3.
2. Hironaka produces a smooth projective \(W\) and a generically finite surjective morphism \(m\colon W\to X\) through which \(\psi\) factors, after a birational morphism \(W\to Y\times\mathbb{P}^{1}\).
3. For a class \(\gamma\) on \(X\), the class one must prove algebraic is \(m^{*}\gamma\) on \(W\), not an arbitrary class of \(W\). If that pullback is algebraic and represented by a cycle \(\beta\), then
   \[
   \gamma=\frac{1}{\deg(m)}\,m_{*}\mathrm{cl}(\beta),
   \]
   because \(m_{*}m^{*}=\deg(m)\) on cohomology and the cycle class map commutes with proper pushforward. Pushing an unrelated algebraic class of \(W\) forward does not recover a prescribed \(\gamma\).
4. Algebraicity of \(m^{*}\gamma\) does **not** follow from the sentence “Künneth sends \(H^{4}(W)\) to a single class in \(H^{2}(Y)\cap H^{1,1}(Y)\).” Even on the product, before any blowup,
   \[
   H^{4}(Y\times\mathbb{P}^{1})\;\cong\; H^{4}(Y)\;\oplus\;\bigl(H^{2}(Y)\otimes H^{2}(\mathbb{P}^{1})\bigr).
   \]
   Rational \((2,2)\)-classes have two pieces. The second is a \((1,1)\)-class on \(Y\) times the hyperplane class of \(\mathbb{P}^{1}\). The first is a degree-4 class on the threefold \(Y\), which is algebraic only after hard Lefschetz identifies it with a \((1,1)\)-class. Both pieces use Lefschetz (1,1). Neither step is optional.
5. Passing from \(Y\times\mathbb{P}^{1}\) to its Hironaka resolution \(W\) needs the blowup formula for cohomology, once per blowup. Hodge classes on a blowup are not an arbitrary pullback from \(Y\). Codimension-2 Hodge conjecture is a birational invariant (Hu, arXiv:math/0511725, 2005/2006), but that paper is thirty years later than Conte–Murre and cannot be cited as a step inside the 1978 proof.
6. “Stable under products” is not a general theorem. The product \(Y\times\mathbb{P}^{1}\) is special because one factor is a curve.

Those missing sentences are the proof. They are written in Conte–Murre and, in the Chow-theoretic form, in Bloch–Srinivas and in Voisin, *Hodge Theory and Complex Algebraic Geometry II*, §10.2, Proposition 10.26. This repository does not replace those papers.

## Bloch–Srinivas (1983)

If \(X\) is smooth, complex, and projective, and \(CH_{0}(X)\) is supported on a closed subvariety of dimension at most 3, then rational Hodge classes of degree 4 on \(X\) are algebraic.

A uniruled fourfold satisfies the support hypothesis, so this recovers Conte–Murre. A fourfold that is not uniruled need not satisfy it. Reference for the statement used here: Voisin, op. cit., Proposition 10.26, attributed there to Bloch–Srinivas, with the fourfold case of a covering by rational curves attributed to Conte–Murre.

## Fano fourfolds, as a corollary

A smooth complex projective variety is Fano when \(-K_{X}\) is ample. Over an algebraically closed field of characteristic zero, every Fano manifold is rationally connected, hence uniruled.

Source: J. Kollár, Y. Miyaoka, and S. Mori, *Rational connectedness and boundedness of Fano manifolds*, Journal of Differential Geometry **36** (1992), 765–779, Theorem 0.1.

Combined with Conte–Murre: every smooth complex Fano fourfold satisfies the rational Hodge conjecture. This adds no fourfold that was not already covered by “uniruled.” Rational connectedness is the stronger geometric input; the cycle-class surjectivity is still the 1978 theorem.

## Cubic fourfolds

A smooth cubic hypersurface \(X\subset\mathbb{P}^{5}\) is a fourfold with \(K_{X}\cong\mathcal{O}_{X}(-3)\) by adjunction, so \(-K_{X}\) is ample and \(X\) is Fano, hence uniruled. Conte–Murre applies.

The rational Hodge conjecture for these hypersurfaces was also proved directly, a year earlier: S. Zucker, *The Hodge conjecture for cubic fourfolds*, Compositio Mathematica **34** (1977), 199–209, [numdam](https://www.numdam.org/item/CM_1977__34_2_199_0/).

There is no 1985 Zucker–Voisin theorem that first settles cubic fourfolds. Later work of Voisin, Hassett, and others is about rationality, special cubics, and derived categories. Rationality of a general cubic fourfold is open. Kuznetsov’s conjecture is open. Those questions are not the Hodge conjecture.

## Where this method ends

The Clay problem asks for an arbitrary smooth complex projective variety. The argument above spends its only geometric input in step 1: a rational curve through a general point, or equivalently a dominant map from a threefold times \(\mathbb{P}^{1}\).

If \(K_{X}\) is pseudo-effective, there is no such map. A variety of general type is not uniruled, so the cover does not exist. When \(p_{g}(X)>0\), Mumford's theorem is a separate obstruction: \(CH_{0}\) is not supported on any proper closed subset. Lefschetz (1,1) remains true and does not see \(H^{2,2}\). No rearrangement of the uniruled reduction proves the missing case.

Known unconditional range, and no further:

| Year | What was proved | What it does not prove |
|---|---|---|
| 1924 | Lefschetz (1,1): codimension-1 rational Hodge classes are algebraic on every smooth complex projective variety | Any \(H^{2,2}\) class |
| 1977 | Zucker: rational Hodge conjecture for smooth cubic fourfolds | A general fourfold |
| 1978 | Conte–Murre: rational Hodge conjecture for fourfolds covered by rational curves | A fourfold with no covering family of rational curves |
| 1983 | Bloch–Srinivas: degree-4 rational Hodge classes, when \(CH_{0}\) is supported in dimension \(\le 3\) | Varieties whose zero-cycles are not so supported |
| 1992 | Kollár–Miyaoka–Mori: Fano manifolds are rationally connected | Any non-Fano, non-uniruled fourfold |

Dimension 4 is the first dimension in which the rational Hodge conjecture is not settled by Lefschetz (1,1) and duality alone. It is settled for the uniruled ones. It is open in general.
