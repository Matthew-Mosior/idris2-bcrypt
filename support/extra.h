#ifndef IDRIS2_BCRYPT_WRAPPER_H
#define IDRIS2_BCRYPT_WRAPPER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Generate a bcrypt salt.
 *
 * cost must be between 4 and 31. Invalid values use libbcrypt's default cost.
 *
 * Returns:
 *   Newly allocated bcrypt salt.
 *   NULL on failure.
 */
char *idris2_bcrypt_gensalt(uint8_t cost);

/*
 * Hash a password using a newly generated salt.
 *
 * Returns:
 *   Newly allocated bcrypt hash.
 *   NULL on failure.
 */
char *idris2_bcrypt_hash(
    const char *password,
    uint8_t cost);

/*
 * Hash a password using an existing bcrypt salt or hash.
 *
 * Returns:
 *   Newly allocated bcrypt hash.
 *   NULL on failure.
 */
char *idris2_bcrypt_hash_with_salt(
    const char *password,
    const char *salt);

/*
 * Validate a password against a bcrypt hash.
 *
 * Returns:
 *   1 if the password matches.
 *   0 otherwise.
 */
int idris2_bcrypt_validate(
    const char *password,
    const char *hash);

#ifdef __cplusplus
}
#endif

#endif
