---
title: Fox and Rabbit
author: me
date: 2025-03-15
tags: maths, tikz
mathjax: on
---

## Problem statement

A rabbit sits in the point $(0,0)$ and a fox sits in $(0, -1)$.
At time $t=0$ they both start running: the rabbit runs with the speed $(1,0)$ and the fox runs towards the rabbit with a speed of euclidean norm $1$.

Let $L(t)$ be the distance between the rabbit and the fox; find $L_\infty = \lim_{t\to\infty} \|L(t)\|$.

## Solution

First, let us draw a picture for a time $t>0$:

```tikzpicture
\coordinate (R) at (5,0);
    \coordinate (F) at (1,-1);
    %\node [draw, inner sep=5pt, anchor = north, pos = 5] (R) {Ra};
    \draw (F) -- (R); % ...

    % Draw x-axis and y-axis
    \draw[-stealth, thick] (-5,0) -- (5,0) node[right] {$x$};
    \draw[-stealth, thick] (0,-5) -- (0,5) node[above] {$y$};

    % Draw ticks on x-axis and y-axis
    \foreach \x in {-2,-1,...,2}
        \draw (\x,0.1) -- (\x,-0.1);
    \foreach \y in {-2,-1,...,2}
        \draw (0.1,\y) -- (-0.1,\y);

    % Draw grid
    \foreach \x in {-3,-2,...,3}
        \draw[dashed] (\x,-3) -- (\x,3);
    \foreach \y in {-3,-2,...,3}
        \draw[dashed] (-3,\y) -- (3,\y);

    % Draw origin
    \filldraw[black] (0,0) circle[radius=1pt];
```

Clearly, the rabbit's position, as a function of $t$ is $(t,0)$.
If we try to solve the differential equation for the fox's position in cartesian coordinates (denote them $(x(t), y(t))$), we obtain a complicated system which does not lend itself easily to finding the limit of $L$, therefore, we use polar coordinates:

\begin{align*}
x' &= \cos \alpha,\\
y' &= \sin \alpha,\\
x(0) &= 0,\\
y(0) &= -1
\end{align*}

On the other hand,
$$
x(t) = t - L\cos\alpha,\quad y(t) = - L\sin\alpha,
$$
which gives us a system
$$
1 - L'\cos\alpha + L\alpha'\sin\alpha = \cos\alpha,\quad -L'\sin\alpha -L\alpha'\cos\alpha = \sin\alpha.
$$

After simplifying this system we get 
\begin{align*}
L' &= \cos \alpha - 1,\\
L\alpha' &= -\sin \alpha,\\
L(0) &= 1,\\
\alpha(0) &= \frac \pi 2
\end{align*}

We can already deduce that both $L$ and $\alpha$ are decreasing. Since both these valus remain strictly positive, we can conclude that the limit indeed exists.
For obvious reasons, $\lim_{t\to\infty} \alpha(t) = 0$, hence one can write via integration by parts
$$
\int_0^{\infty}\frac{L'}{L}dt = \int_0^\infty\frac{\cos\alpha - 1}{\sin\alpha}\alpha'dt
$$
or
$$
\int_{L(0)}^{L_\infty}\frac{du}{u} = \int_{\alpha(0)}^{0}\frac{\cos s - 1}{\sin s}ds
$$
$$
\ln L_\infty = -\int_{\pi/2}^0\tan \left(\frac s 2\right) ds = 2 \ln(\cos s/2)\int_0^{\pi/2} = 2 \ln \frac{1}{\sqrt 2}
$$
Finally,
$$
L_\infty = \frac 12.
$$