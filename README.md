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
  * Simplest method
    * Try all exponents in a loop and see if they give the
      correct result
  * The slowest method
    * Slower methods are possible, but they would necessarily
      need to re-use exponents or test invalid exponents
1. Pollard's rho
  * Fairly Complex
    * A combination of two algorithms really
    * When randomly (but deterministically) walking over valid
      equations, we must hit a cycle which is determined by the
      exponent
    * Use the tortoise and hare algorithm (also referred to as
      slow runner and fast runner or walker and runner) to find
      the repeat
    * Take the information held in the repeat and use it to
      reconstruct the exponent
  * Fairly Quick
2. Baby-Step Giant-Step
  * Moderately Complex
    * Calculate a boundary `m ~ ceil(sqrt(modulus))`
    * Create a list of `0 <= j < m`s and a list of `0 <= k < m`s
    * Try to find `j, k s.t. α^j === βα^{-Nk} (mod modulus)`
    * Give `i * m + j` as the result
    * This relies on a decomposition of the exponent into two
      parts, which makes searching easier
  * Fairly Quick
3. Stretch goal: Poligh-Hellman
  * Breaks discrete log problem into smaller discrete log
    problems
  * Requires sharing of work so that computations are not redone
    * This should be easy in Haskell if things are well defined
      using one of many memoization monads
