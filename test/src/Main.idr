module Main

import Crypto.BCrypt
import Crypto.BCrypt.Types
import Data.String
import System

||| Ensures salts are generated correctly.
|||
test_SaltGeneration : IO ()
test_SaltGeneration = do
  salt <- genSalt (MkWorkFactor 10)
  case length salt == 29 && isPrefixOf "$2" salt of
    True  =>
      pure ()
    False =>
      die "test_saltGeneration: salt == \{show salt}"

||| Hash a password.
|||
test_HashPassword : IO ()
test_HashPassword = do
  hash <- hashPassword "hunter2" (MkWorkFactor 10)
  case length hash == 60 && isPrefixOf "$2" hash of
    True  =>
      pure ()
    False =>
      die "test_hashPassword: hash == \{show hash}"

||| Validation succeeds.
|||
test_ValidationSucceeds : IO ()
test_ValidationSucceeds = do
  hash <- hashPassword "correct horse battery staple" (MkWorkFactor 10)
  ok   <- validatePassword "correct horse battery staple" hash 
  pure ()

||| Validation fails.
|||
test_ValidationFails : IO ()
test_ValidationFails = do
  hash <- hashPassword "password1" (MkWorkFactor 10)
  ok   <- validatePassword "password2" hash
  case ok of
    True  =>
      die $ "test_validationFails: hash == \{show hash}, " ++ "ok == \{show ok}"
    False =>
      pure ()

||| Hashing with an existing salt.
|||
test_HashingWithAnExistingSalt : IO ()
test_HashingWithAnExistingSalt = do
  salt <- genSalt (MkWorkFactor 10)
  hash1 <- hashPasswordWithSalt "hello" salt
  hash2 <- hashPasswordWithSalt "hello" salt
  case hash1 == hash2 of
    True  =>
      pure ()
    False =>
      die $ "test_hashingWithAnExistingSalt: hash1 == \{show hash1}, " ++ "hash2 == \{show hash2}"

||| Different salts produce different hashes.
|||
test_DifferentSaltsProduceDifferentHashes : IO ()
test_DifferentSaltsProduceDifferentHashes = do
  hash1 <- hashPassword "hello" (MkWorkFactor 10)
  hash2 <- hashPassword "hello" (MkWorkFactor 10)
  case hash1 /= hash2 of
    True  =>
      pure ()
    False =>
      die $ "test_hashingWithAnExistingSalt: hash1 == \{show hash1}, " ++ "hash2 == \{show hash2}"

||| Salt extracted from hash.
|||
test_SaltExtractedFromHash : IO ()
test_SaltExtractedFromHash = do
  hash1 <- hashPassword "password" (MkWorkFactor 10)
  hash2 <- hashPasswordWithSalt "password" hash1
  case hash1 == hash2 of
    True  =>
      pure ()
    False =>
      die $ "test_SaltExtractedFromHash: hash1 == \{show hash1}, " ++ "hash2 == \{show hash2}"

||| Cost embedded in hash.
|||
test_CostEmbeddedInHash : IO ()
test_CostEmbeddedInHash = do
  hash <- hashPassword "password" (MkWorkFactor 13)
  case isPrefixOf "$2a$13$" hash || isPrefixOf "$2b$13$" hash || isPrefixOf "$2y$13$" hash of
    True  =>
      pure ()
    False =>
      die $ "test_CostEmbeddedInHash: hash == \{show hash}"

main : IO ()
main = do
  () <- test_SaltGeneration
  () <- test_HashPassword
  () <- test_ValidationSucceeds
  () <- test_ValidationFails
  () <- test_HashingWithAnExistingSalt
  () <- test_DifferentSaltsProduceDifferentHashes
  () <- test_SaltExtractedFromHash
  test_CostEmbeddedInHash
