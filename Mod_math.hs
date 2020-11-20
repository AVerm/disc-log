module Mod_math
( mult_mod
, mod_inverse
, ord
) where
import Util (safeHead, linear_diophantine)

-- Multiplies two numbers modulo another.
-- Given as a convenience function
mult_mod n x y = (x * y) `mod` n

-- Find a modular inverse
mod_inverse :: Integral a => a -> a -> Maybe a
mod_inverse modulus 0 = Nothing
mod_inverse modulus 1 = Just 1
mod_inverse modulus number = do 
    -- Find -- $(g, a, b) s.t. g = gcd(n, m) = a*m + b*n$
    -- if $number | modulus$, this will fail and
    -- return `Nothing`, which will propagate
    -- out of the function safely
    (g, a, b) <- linear_diophantine modulus (number `mod` modulus)
    -- If there is an inverse, `g` is 1
    case g of
        -- If there is an inverse, return it
        -- (No inverse -> Nothing,
        -- inverse -> Just inverse)
        1         -> return $ b `mod` modulus
        -- No inverse
        otherwise -> Nothing

ord :: Integral a => a -> a -> Maybe a
ord n a = safeHead ks
    -- Find pairs `(k, r) s.t. r ≡ a^k (mod n) ∀ k ∈ ℤ+`
    where ks = map (fst) $ filter (\(k, r) -> r == 1) $ map (\k -> (k, a^k `mod` n)) [1..]

