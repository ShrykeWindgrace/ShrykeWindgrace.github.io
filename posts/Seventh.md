---
title: Area of a particular triangle
author: me
date: 2024-10-14
tags: maths, tikz
mathjax: on
---

## Geometric problem

I first saw this problem back in school when I was 15, so I do not claim the author.
Given the type of constraints presented in its statement, one could argue that the *generalized* version of this problem is easier to solve.

I used this problem as an excuse to learn new things about `tikz` and `hakyll`.

### Problem statement

Consider a triangle with its sides split with the following proportions:

$$
\frac {AY} {AB} = \frac{BX}{BC} = \frac {CZ}{CA} = \frac 13.
$$

Find the area of $UVW$ if the area of $ABC$ is equal to $S$.


```tikzpicture

\coordinate (A) at (0,0);
    \coordinate (B) at (27,0);
    \coordinate (C) at (21,18);
    \coordinate (X) at (25,6);
    \coordinate (Y) at (9, 0);
    \coordinate (Z) at (14, 12);
    % \node [draw, inner sep=5pt, anchor = north, pos = 5] (A) {A};
    \draw (A) -- (B) -- (C) -- (A); % ...
    \draw [name path = ax] (A) -- (X);
    \draw [name path = cy] (C) -- (Y);
    \draw [name path = bz] (B) -- (Z);
    \fill (A) circle[radius=1pt] node[above left] {\large A};
    \fill (B) circle[radius=1pt] node[above right] {\large B};
    \fill (C) circle[radius=1pt] node[above right] {\large C};
    \fill (X) circle[radius=1pt] node[above right] {\large X};
    \fill (Y) circle[radius=1pt] node[above left] {\large Y};
    \fill (Z) circle[radius=1pt] node[above left] {\large Z};

    \fill [name intersections={of=ax and cy, by = U}]
        (intersection-1) circle[radius=1pt] node[above left] {\large U};
    \fill [name intersections={of=ax and bz, by = V}]
        (intersection-1) circle[radius=1pt] node[above] {\large V};
    \fill [name intersections={of=bz and cy, by = W}]
        (intersection-1) circle[radius=1pt] node[right] {\large W};
    \fill [gray!50] (U) -- (V) -- (W) -- cycle;

```
### Solution
From the very beginning we replace $\frac 13$ by $\alpha \in [0,1/2]$. Just to make things spicy.

Let's denote the areas of the parts of the triangle $ABC$ as follows:

```tikzpicture
\tkzDefPoint(0,0){A}
    \tkzDefPoint(27,0){B}
    \tkzDefPoint(21,18){C};
    \tkzDefBarycentricPoint(A=2,B=1)
    \tkzGetPoint{Y}
    \tkzDefBarycentricPoint(B=2,C=1)
    \tkzGetPoint{X}
    \tkzDefBarycentricPoint(C=2,A=1)
    \tkzGetPoint{Z}

    \draw (A) -- (B) -- (C) -- (A); % ...
    \draw [name path = ax] (A) -- (X);
    \draw [name path = cy] (C) -- (Y);
    \draw [name path = bz] (B) -- (Z);
    \fill (A) circle[radius=1pt] node[above left] {\large A};
    \fill (B) circle[radius=1pt] node[above right] {\large B};
    \fill (C) circle[radius=1pt] node[above right] {\large C};
    \fill (X) circle[radius=1pt] node[above right] {\large X};
    \fill (Y) circle[radius=1pt] node[above left] {\large Y};
    \fill (Z) circle[radius=1pt] node[above left] {\large Z};

    \tkzInterLL(A,X)(C,Y) \tkzGetPoint{U}
    \tkzInterLL(A,X)(B,Z) \tkzGetPoint{V}
    \tkzInterLL(C,Y)(B,Z) \tkzGetPoint{W}

    \fill (U) circle[radius=1pt] node[above left] {\large U};
    \fill (V) circle[radius=1pt] node[above] {\large V};

    \fill (W) circle[radius=1pt] node[right] {\large W};
\begin{scope}[on background layer]
    \fill [gray!40] (U) -- (Y) -- (A) -- cycle;
    \fill [gray!40] (Z) -- (C) -- (W) -- cycle;
    \fill [gray!40] (X) -- (V) -- (B) -- cycle;
    \fill [gray!50] (U) -- (V) -- (W) -- cycle;
\end{scope}

    \tkzDefTriangleCenter[centroid](U,V,W)
    \tkzGetPoint{uvw}
    \tkzDefTriangleCenter[centroid](U,Y,A)
    \tkzGetPoint{uya}
    \tkzDefTriangleCenter[centroid](Z,C,W)
    \tkzGetPoint{zcw}
    \tkzDefTriangleCenter[centroid](X,V,B)
    \tkzGetPoint{xvb}
    \tkzDefMidPoint(A,W) \tkzGetPoint{aw}
    \tkzDefMidPoint(C,V) \tkzGetPoint{cv}
    \tkzDefMidPoint(U,B) \tkzGetPoint{ub}


    \fill (uya) circle[radius=0pt] node[left] {a};
    \fill (zcw) circle[radius=0pt] node[left] {c};
    \fill (uvw) circle[radius=0pt] node[left] {g};
    \fill (xvb) circle[radius=0pt] node[left] {b};

    \fill (aw) circle[radius=0pt] node[left] {d};
    \fill (cv) circle[radius=0pt] node[left] {e};
    \fill (ub) circle[radius=0pt] node[left] {f};

```
Since triangles $ABC$, $ACX$ , and $ABX$ share the same heigth, we can write
$$
a+b+f = \alpha S.
$$
By the same reasoning we obtain similar expressions:
\begin{align*}
a+b+f &= \alpha S\\
b+c+e &= \alpha S\\
c+a+d &= \alpha S
\end{align*}
Obviously,
$$
S = a + b + c + d + e + f + g.
$$

We have only $4$ equations for $7$ variables (assuming that $S$ is a given); one can show that they are not sufficient to find $g$.

However, we can observe that
$$
\frac {CY}{CW} = \frac{b+e+f+g}{b+e},$$
therefore, since the triangles $ACY$ and $ZCW$ share an angle,
$$
\frac{a+c+d}{c} = \frac {AC}{ZC} \cdot \frac{CY}{CW} = \frac 1 \alpha\frac{b+e+f+g}{b+e}
$$
We simplify using $a+b+c = \alpha S = b +c +e$:
$$
\frac{\alpha S}{c} = \frac 1 \alpha \left(1+\frac{f+g}{\alpha S - c}\right)
$$
Since
$$
f+g +\alpha S = f + g + a + d + c = (f + g + a + d) + c = (1 - \alpha )S + c
$$
we can further simplify to get
$$
\frac{\alpha S}{c} = \frac 1 \alpha \left(1+\frac{(1-2\alpha )S  + c}{\alpha S - c}\right) =
\frac 1 \alpha \frac{(1-\alpha )S }{\alpha S - c} 
$$
and hence

$$
\alpha^2 S(\alpha S - c) = (1-\alpha )Sc ,
$$
which gives

$$
c = \frac {\alpha^3} {1-\alpha + \alpha^2}S.
$$

Note that by the symmetry of the problem we get to say that
$$
a = b = c = \frac {\alpha^3} {1-\alpha + \alpha^2}S,
$$
and therefore
$$
d = e = f = \alpha S - 2 a
$$
Finally,
$$
g = S - 3a - 3 d = S - 3a - 3 (\alpha S - 2 a) = S - 3 \alpha S + 3 a = S - 3 \alpha S + 3\frac {\alpha^3} {1-\alpha + \alpha^2}S.
$$

$$
\frac gS = \frac{{1-\alpha + \alpha^2} -3\alpha {1-\alpha + \alpha^2} + 3\alpha^3 }{1-\alpha + \alpha^2} = 
\frac{(1-2\alpha)^2}{1-\alpha + \alpha^2}.
$$

A quick sanity check: if $\alpha = 0$, then $g = S$ (the triangle $UVW$ is equal to the trianlge $ABC$). Similarly, if $\alpha = \frac 12$, then the trianlge $UVW$ degenerates to a point (medians have a common point of intesection).

Finally, the initial problem asked for $\alpha = \frac 13$. The answer is then $\frac gS = \frac 1 7$.