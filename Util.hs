module Util
( binary_rep
, firstJust
, safeHead
, safeLast
, divides
, linear_diophantine
) where
import Data.Foldable (foldr')

-- Gives the binary representation of a number in little-endian
-- format (the first element of the list represents the smallest
-- power).
-- If this is working correctly, the following line will return
-- `True` for any input number:
-- `\n -> (== n) $ sum $ zipWith (*) (binary_rep n) $ (1 : iterate (*2) 2)`
binary_rep :: Integral a => a -> [a]
binary_rep number
  | (number <  0) = undefined
  | (number == 0) = []
  | (number  > 0) = remainder : (binary_rep ((number - remainder) `quot` 2))
    where remainder = number `rem` 2

-- Returns the first `Just a` value in  a list of `Maybe`
-- or `Nothing` if it canno tdo that
firstJust :: [Maybe a] -> Maybe a
firstJust []  = Nothing
firstJust [x] = x
firstJust (first@(Just _):_) = first
firstJust (Nothing:xs) = firstJust xs

-- Safe (returning `Nothing` instead of crashing on empty)
-- list functions
safeHead, safeLast :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x
safeLast = safeHead . reverse

divides :: Integral a => a -> a -> Bool
x `divides` y = (y `rem` x) == 0

-- Shows the two values needed to perform the euclidean algorithm
euclidean_algorithm :: Integral a => a -> a -> [(a, a)]
euclidean_algorithm bigger smaller = init $ takeWhile ((/= 0) . snd) $ iterate (euclid_step) (bigger, smaller)
          -- How to advance to the next step in the Euclidean algorithm
    where euclid_step (product, dividend) = (dividend, product `rem` dividend)
          -- The steps of the Euclidean algorithm

-- For input $x, y$, calculate and return
-- $(gcd(x, y), a, b) s.t ax + by = gcd(x, y)$
-- using the Extended Euclidean Algorithm
linear_diophantine :: Integral a => a -> a -> Maybe (a, a, a)
linear_diophantine bigger smaller = do
    -- Get the stages of the euclidean algorithm
    -- Extend them to have the
    -- product, dividend, divisor, and remainder
    let extend (p, d) = (p, d, p `quot` d, p `rem` d)
    let euclideans = map (extend) $ euclidean_algorithm bigger smaller
    -- The last step, which holds the gcd and
    -- is the first stage of the algorithm
    final <- safeLast euclideans
    -- Take apart the last step
    let (p_1, d_1, b_1, r_1) = final
    -- The first equation in setup starts like this
    -- r_1 = (p_1 * r_1) - (d_1 * b_1)
    -- which must be represented as
    -- r_1 = (p_1 * r_1) + (d_1 * :b_1)
    -- for the algorithm to keep its form
    let start = (p_1, r_1, d_1, -b_1)
    -- r_1 = (product - (dividend * (product `quot` dividend))
    -- Use the previous step's extended euclideans along with
    -- $a, b, c, d s.t. a*b + c*d = 1$
    -- Note: `a == d'`, `c == r'`
    let extended_euclid_step (p', d', b', r') (a, b, c, d) = (p', d, a, b - b' * d)
    -- Do the extended Euclidean algorithm
    let (x, a, y, b) = foldr' (extended_euclid_step) start (init euclideans)
    -- Return Nothing or Just!
    return (r_1, a, b)
