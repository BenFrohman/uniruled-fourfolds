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
