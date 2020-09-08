RSA rests on the difficulty of factoring large primes

Factoring algorithm:
1. Start with small chunks
2. Build up over time

World champion factoring algorithm

Language Features:
* Want BigInt support
* Linear algebra stage

Let `N = pq`
1. Find `x, y` s.t. `x^2 === y^2 (mod n)` and `x \=== +- y (mod N)`

=> `N | x^2 - y^2 => `N | (x-y)(x+y)`

`N | x - y <=> x === y (mod N)`
`N | x + y <=> x === -y (mod N)`

Take `g = gcd(N, x-y)`
`g = N => N | x-y ...\*`
`g = 1 => N | x+y ...\*`

Otherwise, we have a factor

-----------------------------

Test different methods
* BOGO
* (Maybe linear)
* Fermat factorization
* Continued fractions
* Factor-base
* Quadratic-sieve

-----------------------------

## Discrete log problem

Fix `N, a`
(secret `x`)

Compute `a^x mod N = b`
(`a^x === b (mod N)`)

Idea: From `a, b, N`, find `x`

NOTE: Diffie-Hellman

-----------------------------

* "Pollard's Rho" for both factoring and discrete log

* "Baby step giant step" discrete log in ~`O(sqrt(N))` space and time
