module BabyStepGiantStep ( discrete_log ) where
import Data.Tuple (swap)
import Data.Hashable
import qualified Data.HashMap.Strict as HashMap
import Util (firstJust)
import Mod_math (mult_mod, mod_inverse)
import Exp_mod (exp_mod'')

discrete_log :: (Integral a, Hashable a) => a -> a -> a -> Maybe a
discrete_log base result modulus = do
    -- Rename to match typical description of algorithm
    let (alpha, beta) = (base, result)
    -- Useful shorthand while we are here
    let mult = mult_mod modulus
    -- m = ceil(sqrt(n))
    let m = ceiling $ sqrt $ fromIntegral modulus
    let a_to_m = exp_mod'' alpha m modulus
    a_to_minus_m <- mod_inverse modulus a_to_m
    -- Efficiently calculate steps using iteration
    let baby_step  = mult alpha
    let giant_step = mult a_to_minus_m
    -- Get steps with indices
    let baby_steps          = zip [0..m-1] $ iterate (baby_step) 1
    let giant_steps_no_beta = iterate (giant_step) 1
    let giant_steps         = zip [0..m-1] $ map (mult beta) giant_steps_no_beta
    -- Convert for efficient lookup
    let baby_map = HashMap.fromList $ map (swap) baby_steps
    -- Find valid pairs
    let joined = 
            let lookup (i, y) = case (HashMap.lookup y baby_map) of
                                (Just j) -> Just (i, j)
                                Nothing  -> Nothing
          in map (lookup) giant_steps
    -- Get the first pair
    (i, j) <- firstJust joined
    -- Return the exponent
    return $ (i * m + j) `mod` modulus
