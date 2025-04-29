---
title: A remarkable identity on cosines
author: me
date: 2025-04-25
tags: maths
mathjax: on
---

## Motivation

Several weeks ago I stumbled upon a problem in one of math-oriented communities (here's their [home page](https://sites.google.com/view/ktrtvseros/%D0%B3%D0%BB%D0%B0%D0%B2%D0%BD%D0%B0%D1%8F-%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0)):

Prove that
$$
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    =\frac {1}{32}.
$$

As I found out later, this problem was proposed at a university admission exam, so it should be accessible for a high-schooler; I did not really try to solve it using standard trigonometrics identities (second part of the post is in order, I guess). Initially I wanted to see if there is a generalization of this result, since we already have the identities like
$$
\cos \left( {\frac{\pi }{3}}\right) = \frac 12
$$
and
$$
\cos \left( {\frac{\pi }{5}}\right)\cos \left( {\frac{2\pi }{5}}\right) = \frac 14.
$$

Whenever there is a strange denominator coming up in trigonometry, it might be useful to reach to Euler identities and roots of unity, so that's what I tested.

## Solution
Let's consider a polynomial $x^{33}-1$.
Its roots are
$$
    e^{\frac{2\pi ki}{33}},\quad k=0,\ldots,32.
$$
We can factorize this polynomial using cyclotomic polynomials (cf. [wikipedia article](https://en.wikipedia.org/wiki/Cyclotomic_polynomial)):
$$
    x^{33}-1 = \Phi_1(x) \Phi_3(x) \Phi_{11}(x)\Phi_{33}(x)
$$
where
$$
    \Phi_n(x) = \prod_{1\le k\le n,\, gcd(k,n)=1}\left(x-e^{\frac{2\pi k i}{n}}\right).
$$
One of useful properties of these cyclotomic polynomials: if $p$ is prime, then
$$
    \Phi_p(x) = \frac{x^p-1}{x-1}.
$$
We are mostly interested in the $\Phi_{33}(x)$.
The indices $k$ coprime with $33$ form a set
$$
    I = \{1, 2, 4, 5, 7, 8, 10, 13, 14, 16, 17, 19, 20, 23, 25, 26, 28, 29, 31, 32\}.
$$
One could also notice that
$$
    e^{\frac{2\pi k i}{n}} = \overline{ e^{\frac{2\pi (n - k)i}{n}}},
$$
and when we regroup the indices in $I$  as $(1, 32)$, $(2,31)$ and so for, we can write
$$
    \Phi_{33}(x) = \prod_{k\in I} \left(x-e^{\frac{2\pi k i}{33}}\right)
    =\prod_{k\in I'} \left(x^2-2x\cos\left( {\frac{2\pi k}{33}}\right)+1\right)
$$
with
$$
    I' = \{1, 2, 4, 5, 7, 8, 10, 13, 14, 16\}.
$$
Now let's plug $x=i$ in the polynomial $x^{33}-1$:
$$
    i^{33}-1 = \Phi_1(i) \Phi_3(i) \Phi_{11}(i)\Phi_{33}(i) = (i-1)\frac{i^3-1}{i-1} \frac{i^{11}-1}{i-1}\Phi_{33}(i).
$$
After simplifying, we get
$$
    \Phi_{33}(i) = -1.
$$
On the other hand, the expression in terms of cosines yields
$$
    \Phi_{33}(i) = \prod_{k\in I'}\left(-2i\cos \left( {\frac{2\pi k}{33}}\right) \right) = -2^{10}
    \prod_{k\in I'}\left(\cos \left( {\frac{2\pi k}{33}}\right) \right)
$$
\begin{align*}
    = -&2^{10}\cos \left( {\frac{2\pi}{33}}\right)
    \cos \left( {\frac{4\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \cos \left( {\frac{16\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{20\pi }{33}}\right)
    \cos \left( {\frac{26\pi }{33}}\right)
    \cos \left( {\frac{28\pi }{33}}\right)
    \cos \left( {\frac{32\pi }{33}}\right)
\end{align*}
\begin{align*}
    = -&2^{10}\cos \left( {\frac{2\pi}{33}}\right)
    \cos \left( {\frac{4\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \cos \left( {\frac{16\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{\pi }{33}}\right)
\end{align*}
Now put the value of $\Phi_{33}(i)$, multiply both sides by $\sin \left(\frac{\pi}{33}\right)$
and reorder the factors:
\begin{align*}
    \sin \left(\frac{\pi}{33}\right) =&\, 2^{10}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)\\
    &\times
    \cos \left( {\frac{16\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \cos \left( {\frac{4\pi }{33}}\right)
    \cos \left( {\frac{2\pi}{33}}\right)
    \cos \left( {\frac{\pi }{33}}\right)
    \sin \left( {\frac{\pi }{33}}\right).
\end{align*}
Notice the formula for the double angle in the last product:
\begin{align*}
    = & \, 2^{9}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{16\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \cos \left( {\frac{4\pi }{33}}\right)
    \cos \left( {\frac{2\pi}{33}}\right)
    \sin \left( {\frac{2\pi }{33}}\right),
\end{align*}
rinse and repeat:
\begin{align*}
    = &\, 2^{8}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{16\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \cos \left( {\frac{4\pi }{33}}\right)
    \sin \left( {\frac{4\pi }{33}}\right)
\end{align*}
\begin{align*}
    = &\, 2^{7}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{16\pi }{33}}\right)
    \cos \left( {\frac{8\pi }{33}}\right)
    \sin \left( {\frac{8\pi }{33}}\right)
\end{align*}
\begin{align*}
    = &\, 2^{6}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \\&\times
    \cos \left( {\frac{16\pi }{33}}\right)
    \sin \left( {\frac{16\pi }{33}}\right)
\end{align*}
$$
    = 2^{5}
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    \sin \left( {\frac{32\pi }{33}}\right).
$$
Finally, $\sin \left( {\frac{32\pi }{33}}\right) = \sin \left( {\frac{\pi }{33}}\right)$, and we conclude that
$$
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
    =\frac {1}{32}.
$$

## Another method

One could also notice that the coefficients $[5,7,10,13,14]$ are stable under multiplication by $2$ in the following sense:
$$
    \cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)
$$
$$
= \frac{\sin\left( {\frac{5\pi }{33}}\right)\cos \left( {\frac{5\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{10\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{2\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{20\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{4\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= -\frac{\sin\left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{13\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{4\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= -\frac{\sin\left( {\frac{26\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{8\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{7\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{8\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{14\pi }{33}}\right)
    \cos \left( {\frac{14\pi }{33}}\right)}{16\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{28\pi }{33}}\right) }
{32\sin\left( {\frac{5\pi }{33}}\right)}
$$
$$
= \frac{\sin\left( {\frac{5\pi }{33}}\right) }
{32\sin\left( {\frac{5\pi }{33}}\right)} = \frac {1} {32}.
$$
I'd wager a guess that this was the intended solution.

## Corollaries

The above techniques allow for the following generalization:

$$
\forall n\ge 1 ,\exists m \ge 0, \exists I \subset [0,\ldots,n],\,I\ne \emptyset: \quad \prod_{k\in I}\cos\left(\frac{k\pi}{2n+1}\right) = \frac{1}{2^m}.
$$
For example, one can show that
\begin{align*}
    2^{-18}=\, &\,
    \cos \left( {\frac{3\pi }{65}}\right)
    \cos \left( {\frac{6\pi }{65}}\right)
    \cos \left( {\frac{7\pi }{65}}\right)
    \cos \left( {\frac{9\pi }{65}}\right)
    \cos \left( {\frac{11\pi }{65}}\right)
    \\&\times
    \cos \left( {\frac{12\pi }{65}}\right)
    \cos \left( {\frac{14\pi }{65}}\right)
    \cos \left( {\frac{17\pi }{65}}\right)
    \cos \left( {\frac{18\pi }{65}}\right)
    \cos \left( {\frac{19\pi }{65}}\right)
    \\&\times
    \cos \left( {\frac{21\pi }{65}}\right)
    \cos \left( {\frac{22\pi }{65}}\right)
    \cos \left( {\frac{23\pi }{65}}\right)
    \cos \left( {\frac{24\pi }{65}}\right)
    \cos \left( {\frac{27\pi }{65}}\right)
    \\&\times
    \cos \left( {\frac{28\pi }{65}}\right)
    \cos \left( {\frac{29\pi }{65}}\right)
    \cos \left( {\frac{31\pi }{65}}\right),
\end{align*}

Good luck proving that using standard trigonometric identities!
