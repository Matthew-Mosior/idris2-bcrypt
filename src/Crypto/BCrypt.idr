module Crypto.BCrypt

import Crypto.BCrypt.FFI
import Crypto.BCrypt.Types

%default total

--------------------------------------------------------------------------------
--          Salt generation
--------------------------------------------------------------------------------

||| Generate a new bcrypt salt.
|||
||| The supplied cost factor should typically be between 4 and 31 inclusive.
|||
||| Common production values today are 10–14 depending on the desired computational cost.
|||
export
genSalt : WorkFactor -> IO String
genSalt (MkWorkFactor wf) =
  primIO $ prim__bcryptGenSalt wf

--------------------------------------------------------------------------------
--          Password hashing
--------------------------------------------------------------------------------

||| Hash a password using a newly generated bcrypt salt.
|||
||| The supplied cost factor determines the bcrypt work factor.
|||
export
hashPassword : String -> WorkFactor -> IO String
hashPassword password (MkWorkFactor wf) =
  primIO $ prim__bcryptHash password wf

||| Hash a password using an existing bcrypt salt or bcrypt hash.
|||
||| This is useful when reproducing an existing hash or when deterministic hashing is desired for testing.
|||
export
hashPasswordWithSalt : String -> String -> IO String
hashPasswordWithSalt password salt =
  primIO $ prim__bcryptHashWithSalt password salt

--------------------------------------------------------------------------------
--          Password validation
--------------------------------------------------------------------------------

||| Validate a password against a bcrypt hash.
|||
||| Returns `True` when the supplied password matches the bcrypt hash and `False` otherwise.
|||
export
validatePassword : String -> String -> IO Bool
validatePassword password hash = do
  result <- primIO $ prim__bcryptValidate password hash
  pure (result /= 0)
