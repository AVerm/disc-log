# MAT 447 Honors Contract: The Discrete Log Problem

by Alex Vermillion

## Description

In mathematics, logarithms can be thought of as the answer to the
analogy "multiplication : division :: exponentiation : \_?"
In that sense, where division is given `a, b` and finds `c s.t. a
c = b`, a logarithm is given `e, f` and finds `g s.t. e^g = f`.
The discrete logarithm is an extension of this concept with
restricts `g` to integers.
The exact formulation of the problem that is most interesting to
mathematicians at large follows:
> Given some fixed `N ∈ ℤ`, `a, x ∈ ℤ`, and `b ∈ ℤₙ* s.t. b ===
> a^x (mod N)`, find `x`.

### Relevance

The discrete logarithm problem interests mathematicians (more
specifically and more strongly so cryptographers) because it is
generally difficult to find a discrete logarithm for chosen
inputs.
Efficient solutions to this problem constrain which cryptographic
techniques can be used with an expectation of reasonable safety
against cracking.

## Methods

Several methods exist to perform discrete logarithms, which all
come with different drawbacks and requirements.

0. Brute force
1. Pollard's rho
2. Baby-Step Giant-Step
3. Stretch goal: Poligh-Hellman
   - Better: Add memoization
