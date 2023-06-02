---
title: test latex in markdown
author: me
date: 2023-06-02
tags: test, latex, draft
mathjax: on
---
## Title

Now we have a set with three elements $G = \{r,p,s\}$ and a binary operation $\ast$ given by the following table:

\begin{array}{c|ccc}
\ast &r&p&s\\\hline
r    &r&p&r\\
p    &p&p&s\\
s    &r&s&s
\end{array}

Let's reason from the other way around and start asking what we want from such a game.
- first of all, the number of elements must not be too high
- the outcome of the game should not depend on the player, only on its choice of the element; in other words, the underlying binary operation is commuatative
- the operations selects one of its arguments as its result
- there are no elements that would always win
- there are no elements that would always loose

Having these conditions, let us see whether we can build anything useful.

If the set of elements has only one element, the game always ends in a draw, and that is not interesting at all.

If we have only two elements in the set $G = \{a,b\}$, the reasoning is rather straightforward.
The operation selects one of its arguments as the result, hence
in particular, we always have $a\ast a=a$ and $b\ast b=b$. One the other hand we have
\[
 a\ast b = b\ast a,
\]
therefore we have only two possible operations:
\begin{array}{c|cc}
\ast_1 &a&b\\\hline
a    &a&b\\
b    &b&b\\
\end{array}
\quad
\begin{array}{c|cc}
\ast_2 &a&b\\\hline
a    &a&a\\
b    &a&b\\
\end{array}

Unfortunately, the $\ast_1$ always selects $b$ as the winner, and $\ast_2$ does the same for $a$.
The conclusion is easy - there no such games for two elements.

In the similar vein building a game with $3$ elements $G=\{a,b,c\}$ boils down to picking values for
$$
a \ast b,\quad b \ast c,\quad c \ast a.
$$

Suppose that $a\ast b = a$, then necessarily $c\ast a = c$ (otherwise $a$ would always win), and therefore $b\ast c = b$ (otherwise $c$ would always win).
The case $a\ast b = b$ is done likewise:

\begin{array}{c|ccc}
\ast_1 &a&b&c\\\hline
a    &a&a&c\\
b    &a&b&b\\
c    &c&b&c
\end{array}
\quad
\begin{array}{c|ccc}
\ast_2 &a&b&c\\\hline
a    &a&b&a\\
b    &b&b&c\\
c    &a&c&c
\end{array}

One can notice that the first solution is isomorphic to the rock-scissors-game as
$\{a=r, b = s, c = p\}$; so is the second solution with $\{a= r, b = p, c = s\}$.
