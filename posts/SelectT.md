---
title: SelectT monad transformer and its laws
author: me
date: 2024-05-17
tags: Haskell
mathjax: off
---

## Motivation

Quite some time ago I learned about positive and negative argument positions and their relation with `Functor` instances.
As an exercise I tried writing a `Functor` instance for the following type:

```haskell
newtype ARA r a = ARA {runAra :: (a -> r) -> a}
```

While this instance and the corresponding laws are rather straightforward, `Applicative` and `Monad` instances proved to be much more complicated.
After a bit of googling, I found that this type has a name and can even made into a monad tranformer; moreover, it exists in [transformers](https://www.stackage.org/haddock/lts-22.21/transformers-0.6.1.0/Control-Monad-Trans-Select.html#t:SelectT)

## Generic definition

Up to order of declarations, a more generic datatype becomes

```haskell
newtype SelectT m r a = SelectT {runSelectT :: (a -> m r) -> m a}
```

Perhaps unsurprisingly, when I introduced additional type parameter `m`, the `Monad` instance became *easier* to write.
Simply because the nimber of possible operations to apply got severely restricted.


``` haskell
instance Functor m => Functor (SelectT m r) where
    fmap :: (a -> b) -> SelectT m r a -> SelectT m r b
    fmap ab (SelectT op) = SelectT $ \bmr -> do
        ab <$> op (bmr . ab)
```

```haskell
instance Monad m => Applicative (SelectT m r) where
    pure :: a -> SelectT m r a
    pure x = SelectT $ \_ -> pure x
    liftA2 :: (a -> b -> c) -> SelectT m r a -> SelectT m r b -> SelectT m r c
    liftA2 = liftM2
```

``` haskell
instance Monad m => Monad (SelectT m r) where
    (>>=) :: SelectT m r a -> (a -> SelectT m r b) -> SelectT m r b
    SelectT op >>= f = SelectT $ \bmr -> do
        let pick x = runSelectT (f x) bmr
        y <- op (pick >=> bmr)
        pick y
```

## Laws and proofs

### Functor laws
```haskell
fmap :: Functor m => (a -> b) -> SelectT m r a -> SelectT m r b
```

#### First law

As I said before, it is rather straightforward. In pseudo-haskell we can write by definition

```haskell
fmap id (SelectT op) = SelectT $ \amr -> id <$> op (amr . id)
```
which, by applying functor laws to inner `Functor m` and recalling that `amr . id = amr`, we rewrite as 

```haskell
fmap id (SelectT op) = SelectT $ \amr -> op amr = SelectT op
```
And the first law is proven.

#### Second law

Just a little more difficult, but easy nonetheless. We use the second law for the inner functor `m` and the associativity of function composition.

```haskell
fmap bc ( fmap ab (SelectT op)) = fmap bc ( SelectT $ \bmr -> ab <$> op (bmr . ab) )

  = SelectT $ \cmr -> bc <$> (\z -> ab <$> op (z . ab)) (cmr . bc)
  = SelectT $ \cmr -> bc <$> ( ab <$> op ((cmr . bc) . ab))
  = SelectT $ \cmr -> (bc . ab) <$> op (cmr . (bc . ab))
  = fmap (bc . ab) (SelectT op)
```
and the second law is proven, too.

### Monad laws

#### Left identity

```haskell
pure a >>= k = k a
```


In our case this becomes (recall that `pure x = SelectT $ \_ -> pure x`)

```haskell
pure a >>= f = SelectT $ \bmr -> do
        let pick x = runSelectT (f x) bmr
        y <- (\_ -> pure a) (pick >=> bmr)
        pick y
```
or
```haskell
pure a >>= f = SelectT $ \bmr -> do
        let pick x = runSelectT (f x) bmr
        y <- pure a
        pick y
```
by left identity law for `m` we get
```haskell
pure a >>= f = SelectT $ \bmr -> do
        let pick x = runSelectT (f x) bmr
        pick a
```
and then
```haskell
pure a >>= f = SelectT $ \bmr -> do
        runSelectT (f a) bmr
```

```haskell
pure a >>= f = SelectT $ runSelectT (f a) = f a
```

#### Right identity
```haskell
m >>= pure = m
```

We write it as
```haskell
SelectT op >>= pure = SelectT $ \bmr -> do
    let pick x = runSelectT (pure x) bmr
    y <- op (pick >=> bmr)
    pick y
```
We plug in the definition of `pure`: 
```haskell
runSelectT (pure x) bmr = runSelectT (SelectT $ \_ -> pure x) bmr = pure x
```
to obtain
```haskell
SelectT op >>= pure = SelectT $ \bmr -> do
    let pick x = pure x
    y <- op (pick >=> bmr)
    pick y
```
or
```haskell
SelectT op >>= pure = SelectT $ \bmr -> do
    y <- op (pure >=> bmr)
    pure y
```
Right and left identity laws for `m` give us
```haskell
SelectT op >>= pure = SelectT $ \bmr -> do
    y <- op bmr
    pure y
```
and then
```haskell
SelectT op >>= pure = SelectT $ \bmr -> op bmr = Select op
```
and the law is proven.

#### Final boss, associativity law

`m >>= (\x -> k x >>= h) = (m >>= k) >>= h`

Stay tuned!

In order to simplify notations, let's introduce an operator 
```haskell
[] :: SelectT m r a -> (a -> m r) -> m a
```
It overrides Haskell's syntax for lists, but we do not use lists anywhere in this post, so this should be fine.

We can write the monad instance as
```haskell
m >>= f = SelectT $ \bmr -> do
    let pick x = [f x] bmr
    y <- [m] ((>>= bmr) . pick)
    pick y
```

With that in mind, we write
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p1 = \a -> [k a >>= h] cmr -- :: a -> m c
    y <- [m] ((>>= cmr) . p1)
    p1 y
```

After that we plug in the definition of `[k a >>= h]`:
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p1 = \a ->
        [SelectT $ \zmr -> let p2 b = [h b] zmr in
            ([k a] ((>>= zmr) . p2)) >>= p2] cmr
    y <- [m] ((>>= cmr) . p1)
    p1 y
```
Since `[]` in our notation is just unwrapping the `SelectT` constructor, we simplify as
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p1 = \a ->
        let p2 = \b -> [h b] cmr in
            ([k a] ((>>= cmr) . p2)) >>= p2
    y <- [m] ((>>= cmr) . p1)
    p1 y
```

Let's keep `p2` there for now and inline only `p1`:
```haskell
p1 = \a -> ([k a] ((>>= cmr) . p2)) >>= p2
```


```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ((>>= cmr) . (\a -> ([k a] ((>>= cmr) . p2)) >>= p2) )
    ([k y] ((>>= cmr) . p2))) >>= p2
```

Rewrite the definition of `y`:

```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ( \a -> (([k a] ((>>= cmr) . p2)) >>= p2) >>= cmr)
    ([k y] ((>>= cmr) . p2))) >>= p2
```

One could notice the parts of the third monad for the underlying monad in the expression `((...) >>= p2) >>= cmr`,
we definitely should use that.

```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ( \a -> (([k a] ((>>= cmr) . p2)) >>= (\x -> p2 x >>= cmr ) ))
    ([k y] ((>>= cmr) . p2))) >>= p2
```
or
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ( \a -> (([k a] ((>>= cmr) . p2)) >>= (\x -> p2 x >>= cmr ) ))
    z <- [k y] ( (>>= cmr) . p2) 
    p2 z
```
or even 
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ( \a -> ([k a] ((>>= cmr) . p2)) >>= ((>>= cmr ) . p2) )
    z <- [k y] ( (>>= cmr) . p2) 
    p2 z
```

Now, let's write the other part of the law:
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    z <- [m >>= k] (( >>= cmr) . p2)
    p2 z
```
Plug the definition of `m >>= k`:
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    z <- [SelectT $ \bmr -> let p1 a = [k a] bmr in
        ([m] ((>>= bmr) . p1)) >>= p1 ] (( >>= cmr) . p2)
    p2 z
```

```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    z <- let p1 a = [k a] (( >>= cmr) . p2) in
        ([m] ((>>= (( >>= cmr) . p2)) . p1)) >>= p1  
    p2 z
```
Scared? I am, too. Anyways,
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    let p1 a = [k a] (( >>= cmr) . p2)
    z <- ([m] ((>>= (( >>= cmr) . p2)) . p1)) >>= p1
    p2 z
```
rewrite that dangling `>>= p1`
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    let p1 a = [k a] (( >>= cmr) . p2)
    y <- [m] ((>>= (( >>= cmr) . p2)) . p1)
    z <- p1 y
    p2 z
```
and inline `p1` once:
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    let p1 a = [k a] (( >>= cmr) . p2)
    y <- [m] ((>>= (( >>= cmr) . p2)) . p1)
    z <- [k y] (( >>= cmr) . p2)
    p2 z
```
Getting something already! Now off to inline the last mention of `p1`:

```haskell
  (>>= (( >>= cmr) . p2)) . p1
= \a -> p1 a >>= (( >>= cmr) . p2)
= \a -> ([k a] (( >>= cmr) . p2)) >>= (( >>= cmr) . p2)
```
Putting this back:
```haskell
(m >>= k) >>= h = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    let p1 a = [k a] (( >>= cmr) . p2)
    y <- [m] ( \a -> ([k a] (( >>= cmr) . p2)) >>= (( >>= cmr) . p2) )
    z <- [k y] (( >>= cmr) . p2)
    p2 z
```

Recall that we already wrote that once:
```haskell
m >>= (\x -> k x >>= h) = SelectT $ \cmr -> do
    let p2 = \b -> [h b] cmr
    y <- [m] ( \a -> ([k a] ((>>= cmr) . p2)) >>= ((>>= cmr ) . p2) )
    z <- [k y] ( (>>= cmr) . p2) 
    p2 z
```
and therefore our arduous work is done, and indeed the third monad law holds for `Select m r`!
