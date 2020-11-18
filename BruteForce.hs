module BruteForce ( discrete_log ) where
import Data.Maybe (listToMaybe)
import Data.List (genericTake)
import Mod_math (mult_mod)

-- This finds any solutions that exist, slowly
discrete_log :: (Integral a, Enum a) => a -> a -> a -> Maybe a
discrete_log base result modulus = listToMaybe exponents
  where guesses = iterate (mult_mod modulus base) 1
        unique_guesses_mod = genericTake (modulus - 1) guesses
        indexed_guesses = zip [0..] unique_guesses_mod
        matches = filter ((== result) . snd) indexed_guesses
        exponents = map (fst) matches
