module Exp_mod
( exp_mod
, exp_mod'
, exp_mod''
) where
import Data.List (genericIndex)
import Util (binary_rep)
import Mod_math (mult_mod)

-- This can be used to apply some obvious transformations to
-- an exponential modular function
optimize_exp_mod :: Integral a => (a -> a -> a -> a) -> a -> a -> a -> a
optimize_exp_mod exp_mod_fn base exponent modulus
  | (base == 0) = 0
  | (base == 1) = 1
  | (exponent == 0) = 1
  | (exponent == 1) = base
  | otherwise = exp_mod_fn base exponent modulus

-- A naive version of modular exponentiation.
-- Fairly space and time in-efficient.
exp_mod :: Integral a => a -> a -> a -> a
exp_mod = optimize_exp_mod naive
  where naive base exponent modulus = (base ^ exponent) `mod` modulus

-- An optimized version of modular exponentiation.
-- Uses iteration (through recursion) with modulus after each
-- step for space efficiency.
-- Fairly space efficient.
exp_mod' :: Integral a => a -> a -> a -> a
exp_mod' = optimize_exp_mod iterative
  where iterative base exponent modulus = (`genericIndex` exponent) $ iterate (mult_mod modulus base) 1

-- An optimized version of modular exponentiation.
-- Uses square and multiply.
-- Fairly space and time efficient.
exp_mod'' :: Integral a => a -> a -> a -> a
exp_mod'' = optimize_exp_mod square_and_multiply
  where square_and_multiply base exponent modulus = result `mod` modulus
          where powers = iterate (\i -> i^2 `mod` modulus) base
                zipped = zip (binary_rep exponent) powers
                filtered = filter ((/= 0) . fst) zipped
                result = product $ map (snd) filtered
