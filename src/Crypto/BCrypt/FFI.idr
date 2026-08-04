module Crypto.BCrypt.FFI

%default total

||| Generate a new bcrypt salt.
|||
||| The supplied cost factor should be between 4 and 31 inclusive.
|||
||| Values outside this range are handled according to the underlying libbcrypt implementation.
|||
export %foreign "C:idris2_bcrypt_gensalt,bcrypt-idris"
prim__bcryptGenSalt : Bits8 -> PrimIO String

||| Hash a password using a newly generated bcrypt salt.
|||
||| The supplied cost factor should be between 4 and 31 inclusive.
|||
||| Values outside this range are handled according to the underlying libbcrypt implementation.
|||
export %foreign "C:idris2_bcrypt_hash,bcrypt-idris"
prim__bcryptHash : String -> Bits8 -> PrimIO String

||| Hash a password using an existing bcrypt salt or bcrypt hash.
|||
||| The supplied salt may either be a bcrypt salt or a previously generated bcrypt hash.
|||
||| When a hash is supplied, its embedded salt is reused.
|||
export %foreign "C:idris2_bcrypt_hash_with_salt,bcrypt-idris"
prim__bcryptHashWithSalt : String -> String -> PrimIO String

||| Validate a password against a bcrypt hash.
|||
||| Returns:
||| - 1 if the password matches.
||| - 0 otherwise.
|||
export %foreign "C:idris2_bcrypt_validate,bcrypt-idris"
prim__bcryptValidate : String -> String -> PrimIO Int
