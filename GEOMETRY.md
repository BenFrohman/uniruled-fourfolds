# What this arithmetic is not

Copyright (c) 2026 Benjamin Frohman. MIT License. See LICENSE.

`UniruledFourfolds/MukaiLattice.lean` computes a bilinear form on \(\mathbb{Z}^3\):

\[
\langle (a,b,c), (d,e,f) \rangle = be - af - cd.
\]

Let \(u = (1,0,-1)\) and \(v = (0,1,0)\). Their span is \(\{ (x, y, -x) \mid x, y \in \mathbb{Z} \}\). A vector \(w = (a,b,c)\) pairs to zero with both if and only if \(b = 0\) and \(a = c\). That orthogonal is \(\mathbb{Z}(1,0,1)\), and \(\langle (1,0,1), (1,0,1) \rangle = -2\).

The vector \((-1,0,1)\) is not in that orthogonal. Its pairing with \(u\) is \(-2\).

These statements are not a description of a cubic fourfold. The numerical Grothendieck group of the Kuznetsov component of a smooth cubic fourfold has rank 22, not 3. It is not identified with this \(\mathbb{Z}^3\) anywhere in the Lean file. The orthogonal computed here is not \(H^4(X, \mathbb{Z})_{\mathrm{tr}}\).

For a very general Gushel–Mukai fourfold the numerical Grothendieck group of the Kuznetsov component is isomorphic to \(\mathbb{Z}^2\), with Euler matrix \(\mathrm{diag}(-2,-2)\), not to \(\mathbb{Z}^3\). See Kuznetsov–Perry, Compositio Math. 154 (2018), as cited in Guo–Liu–Zhang, arXiv:2203.05442, Lemma 3.1. The triple \((2,1,-2)\) has square 9 under the form in this repository, so it is not one of those two generators. This file does not identify it with a tautological bundle on \(\mathrm{Gr}(2,5)\).

The boolean `squaresOneAndPairingZero` requires two squares equal to 1 and one pairing equal to 0. For \((1,1,0)\) and \((0,1,0)\) the squares are 1 and 1, and the pairing is 1, so the boolean is false. That does not decide whether an exceptional collection exists in \(D^b(X)\). An exceptional object satisfies \(\mathrm{RHom}(E,E) \simeq \mathbb{C}\). The Kuznetsov component is a K3 category, with Serre functor the shift by 2, so its objects are not exceptional in that sense.

## Gram matrix

`cert_mukai_pairing_is_symmetric` proves \(\langle u, v \rangle = \langle v, u \rangle\) for every pair of these integer triples. `ring` is not used: this project does not import Mathlib. The values below are the ones `validate_mukai.py` checks. The column headings are the triples, not classes on a fourfold.

| | `(1, 0, -1)` | `(2, 1, -2)` | `(0, 1, 0)` |
| --- | ---: | ---: | ---: |
| `(1, 0, -1)` | 2 | 4 | 0 |
| `(2, 1, -2)` | 4 | 9 | 1 |
| `(0, 1, 0)` | 0 | 1 | 1 |

On the coordinate basis `(1,0,0)`, `(0,1,0)`, `(0,0,1)`, the same form has Gram determinant `-1`. That is `cert_coordinate_gram_det`. The form is not positive definite: the square of `(1,0,-1)` is `2` and the square of `(1,0,1)` is `-2`. A free \(\mathbb{Z}\)-module of rank 3 does not, by itself, carry this number.

## No semicircle for these three characters

`LinearMap.det` is not an exterior-algebra computation in this repository, and two calls to `Module.Free.chooseBasis` are not definitionally one basis. Nothing below uses Mathlib.

Take the slope
\[
\nu_{\beta,\alpha}(r,c,s)=\frac{s-\beta c+(\beta^2-\alpha^2)r/2}{c-\beta r}.
\]
Equating \(\nu(E)=\nu(F)\) for \(E=(2,0,-1)\) and the three classes \(F=(1,-1,0)\), \((1,-2,1)\), \((3,-1,-2)\) gives a circle whose center is the displayed quotient
\[
\frac{r_F s_E-r_E s_F}{r_F c_E-r_E c_F},
\]
namely \(-\tfrac12\), \(-\tfrac34\), and \(\tfrac12\). Completing the square gives squared radii \(-\tfrac34\), \(-\tfrac{7}{16}\), and \(-\tfrac34\). Those loci do not meet the half-plane \(\alpha>0\). The square-root expression \(\sqrt{\lvert \mathrm{center}^2+2(s_F/r_F-s_E/r_E)\rvert}\) is a different, positive number, and it is not this radius.

For the same rank and first Chern numbers, \(\mu(F)>\mu(E)\) with positive ranks is the integer inequality \(c_F r_E>c_E r_F\). For \(E=(2,0)\) and \(F=(1,-1)\) that is \(-2>0\), which is false, and the opposite inequality holds. That comparison does not use \(\mathrm{ch}_2\). It is not \(\chi(E(mH))\). A fourfold Hilbert polynomial has degree 4 and needs \(H\) and \(\mathrm{td}(X)\).

If \(c=0\), \(r\ge 0\), and \(s\le 0\), then \(c^2-2rs\ge 0\). That is `disc_nonneg_of_vanishing_ch1`. The product \(c^2\) is not an intersection number, and a nonnegative value is not Bogomolov–Gieseker stability.

If \(c_1 c_3\le 0\) and \(c_0 c_4\ge 0\), then \(3 c_0 c_4 - c_1 c_3 + c_2^2\ge 0\), because each of \(3 c_0 c_4\), \(-(c_1 c_3)\), and \(c_2^2\) is nonnegative. That is `chern_combination_nonneg`. It is not a Gieseker–Yau bound, and the factor \(0.2\) in a contour plot is not a Chern character. The call `v.giesekerYauMetric v` passes the vector twice.

Subtracting \((1,-1,0)\) from \((2,0,-1)\) gives \((1,1,-1)\). That is integer subtraction, not a Harder–Narasimhan factor. The point \((-3/5,4/5)\) has squared distance \(13/20\) from the center \(-1/2\), so it sits inside the stand-in disk of squared radius \(5/4\). The slope equation for this pair has squared radius \(-3/4\), so the label “unstable” from that disk is not a phase comparison, and the outside of the disk is not a Gieseker chamber.

For a smooth cubic fourfold the middle Hodge numbers are \(h^{4,0}=0\), \(h^{3,1}=1\), \(h^{2,2}=21\). The fourth Betti number is \(23\), not \(h^{2,2}\). See Huybrechts, *The geometry of cubic hypersurfaces*, the computation recorded after Exercise 1.15. For a very general cubic, \(H^{2,2}(X,\mathbb{Z})=\mathbb{Z}h^{2}\), so the algebraic rank is \(1\), not \(22\). A heatmap with \(23\) in the \((2,2)\) cell and the annotation “Alg: 22, Trsc: 1” does not state the Hodge conjecture, and this repository does not prove it.

The Mukai lattice of a K3 surface, \(H^0\oplus H^2\oplus H^4\), has rank \(24\) and signature \((4,20)\). It is not signature \((2,20)\). The pairing in this repository is a form on \(\mathbb{Z}^3\) with both a square \(2\) and a square \(-2\), so it is indefinite of rank \(3\). Under the convention \(\chi(E,F)=-\langle v(E),v(F)\rangle\), a spherical object has square \(-2\), not a positive square. A nonnegative integer here is not a spherical object, and the sign of one square does not sort walls into semicircles, parabolas, and hyperbolas.

A direct sum that inserts `Unit` whenever \(p+q\neq k\), and that identifies one ungraded module with every degree, is not the Hodge decomposition. The proposed theorem ends in `sorry`. It was not added.

The curves drawn from \(\sqrt{\langle w,w\rangle + 1/2}\), from the vertical line \(\beta=-1/2\), and from \(\sqrt{\lvert\langle w,w\rangle\rvert+(\beta+1/2)^2}\) are not stability walls. The pairing on this \(\mathbb{Z}^3\) takes integer values, so \(0.2\) and \(-1/2\) do not occur. `SerreDualPairing` asks an arbitrary module over a commutative ring to be linearly equivalent to the algebraic dual of another arbitrary module, and the proof is `sorry`. For \(p\) in `Fin (n+1)`, the hypothesis \(p\le n\) is automatic. That file was not added.
