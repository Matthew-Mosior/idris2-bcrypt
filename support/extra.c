/*
 * Idris2 wrapper for libbcrypt.
 *
 * This file provides a small, stable C API for the Idris2 FFI. All returned
 * strings are heap allocated and owned by the caller.
 */

#include "extra.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "bcrypt.h"

////////////////////////////////////////////////////////////////////////////////
// Salt generation
////////////////////////////////////////////////////////////////////////////////

char *idris2_bcrypt_gensalt(uint8_t cost)
{
    char salt[BCRYPT_HASHSIZE];

    if (bcrypt_gensalt(cost, salt) != 0)
        return NULL;

    return strdup(salt);
}

////////////////////////////////////////////////////////////////////////////////
// Password hashing
////////////////////////////////////////////////////////////////////////////////

char *idris2_bcrypt_hash(
    const char *password,
    uint8_t cost)
{
    char salt[BCRYPT_HASHSIZE];
    char hash[BCRYPT_HASHSIZE];

    if (bcrypt_gensalt(cost, salt) != 0)
        return NULL;

    if (bcrypt_hashpw(password, salt, hash) != 0)
        return NULL;

    return strdup(hash);
}

char *idris2_bcrypt_hash_with_salt(
    const char *password,
    const char *salt)
{
    char hash[BCRYPT_HASHSIZE];

    /*
     * bcrypt_hashpw() accepts either a bcrypt salt or an existing bcrypt
     * hash. When a full hash is supplied, only the salt portion is used.
     */

    if (bcrypt_hashpw(password, salt, hash) != 0)
        return NULL;

    return strdup(hash);
}

////////////////////////////////////////////////////////////////////////////////
// Password validation
////////////////////////////////////////////////////////////////////////////////

int idris2_bcrypt_validate(
    const char *password,
    const char *hash)
{
    /*
     * bcrypt_checkpw() returns:
     *
     *   0  Password matches.
     *   1  Password does not match.
     *  -1  Internal error.
     *
     * Normalize this to a boolean value for the Idris FFI.
     */

    return bcrypt_checkpw(password, hash) == 0;
}
