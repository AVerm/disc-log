module PollardsRho ( discrete_log ) where
import Data.Maybe (listToMaybe)
import Data.List (genericIndex)
import Mod_math (mod_inverse, ord)
import Util (safeHead)

-- This works for $modulus = p*q where p /= q$
-- I got help with this algo from this website:
-- https://programmingpraxis.com/2016/05/27/pollards-rho-algorithm-for-discrete-logarithms/
discrete_log :: Integral a => a -> a -> a -> Maybe a
discrete_log base result modulus = do
    -- Rename to match typical description of algorithm
    let (α, β) = (base, result)
    -- Calculate the order of the generated group
    p <- ord modulus α
    -- Fairly-randomly generate a new valid equation
    let next (x, a, b) = let
        -- The algorithm works best when the parts are
        -- moved randomly and independently, which works
        -- easily when the output is taken by which set
        -- `x` is in of 3 roughly equal sets
              set_no = x `mod` 3
              f x   = (x * (genericIndex [x, α, β] set_no)) `mod` modulus
              g x n = (n + (genericIndex [n, 1, 0] set_no)) `mod` p
              h x n = (n + (genericIndex [n, 0, 1] set_no)) `mod` p
          in (f x, g x a, h x b)
    -- Start with x^1 = α^0 * β^0 (mod modulus)
    let initial = (1, 0, 0)
    let fst3eq = \a b -> (fst3 a) == (fst3 b)
    let crossover_point = first_repeat (fst3eq) (next) initial
    -- Destructure into the variables we want to work with
    let ((x_1, a_1, b_1), (x_2, a_2, b_2)) = crossover_point
    let numerator   = a_1 - a_2
    let denominator = b_2 - b_1
    let d = gcd denominator p
    bottom <- mod_inverse (p `quot` d) denominator
    let l = (numerator * bottom) `mod` p
    case d of
      1         -> return l
      otherwise -> safeHead $ filter (check) ls
          where ms = [0..d-1]
                ls = map (\m -> l + m * (p `quot` d)) ms
                check l' = (base^l' `mod` modulus) == result

-- Simple 3-tuple utility functions
fst3 (x, _, _) = x
snd3 (_, x, _) = x
trd3 (_, _, x) = x

-- Use Floyd's cycle finding algorithm to find
-- the first repeat.
-- Don't pass it something that is not cyclical,
-- it will crash (intentionally, to avoid giving
-- bad results)
first_repeat :: (a -> a -> Bool) -> (a -> a) -> a -> (a, a)
first_repeat equality next initial = meeting
          -- This will trudge slowly one step each time
    where tortoises = iterate        (next) initial
          -- This will bound onwards two steps each time
          hares     = iterate (next . next) initial
          -- Find where they meet
          meeting = head $ filter (on_pair equality) $ drop 1 $ zip tortoises hares

-- Remake a function to operate on a pair
-- A readability alias
on_pair :: (a -> b -> c) -> (a, b) -> c
--on_pair fn (a, b) = fn a b
on_pair = uncurry
