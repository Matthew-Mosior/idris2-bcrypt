module Crypto.BCrypt.Types

import Derive.Prelude

%language ElabReflection

||| The bcrypt work factor.
|||
||| The work factor determines the computational cost of hashing a password.
|||
||| Each increment approximately doubles the amount of work required to compute and verify a bcrypt hash.
|||
||| Valid bcrypt work factors are in the range 4 to 31 inclusive.
|||
||| Values outside this range are handled according to the underlying libbcrypt implementation.
|||
public export
record WorkFactor where
    constructor MkWorkFactor
    value : Bits8

%runElab derive "WorkFactor" [Show,Eq,Ord] 
