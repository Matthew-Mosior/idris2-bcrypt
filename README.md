# Idris2 bindings to the libbcrypt library

This library provides a modern bcrypt password hashing library for Idris2 built on top of Ricardo Garcia's [libbcrypt](https://github.com/rg3/libbcrypt). It combines a small low-level FFI layer with a type-safe Idris2 API for generating salts, hashing passwords, and securely validating bcrypt hashes.

The goal of this library is to provide an idiomatic Idris2 interface while preserving compatibility with the widely used bcrypt algorithm and existing bcrypt implementations.

> [!NOTE]
> This library is a thin Idris2 wrapper around libbcrypt. The underlying cryptographic implementation is provided by libbcrypt and the Blowfish-based bcrypt algorithm implementation it contains.

## Building

Running:

```bash
make build
```

builds the library.

This can also be done using:

```
pack build
```

## Installation

Running:

```
make install
```

Installs the library into your Idris2 package environment.

## Features

-   **bcrypt password hashing**
    -   Generate bcrypt hashes
    -   Configure bcrypt work factors
    -   Hash passwords using generated salts
    -   Hash passwords using existing salts
-   **Password verification**
    -   Validate passwords against bcrypt hashes
    -   Constant-time comparison through libbcrypt
    -   Safe password checking API
-   **Salt management**
    -   Generate bcrypt salts
    -   Reuse existing bcrypt salts
    -   Deterministic hashing for testing
-   **Idris2 API**
    -   Small, composable API
    -   Safe wrappers around raw FFI functions
    -   Strongly typed configuration values
-   **Low-level FFI support**
    -   Direct bindings to the C wrapper layer
    -   Minimal abstraction overhead
    -   Compatible with existing libbcrypt implementations
-   **Testing**
    -   Salt generation tests
    -   Hash generation tests
    -   Password validation tests
    -   Deterministic hashing tests

## Why use this library?

Many password hashing libraries expose one of two extremes:

-   Low-level C bindings that require users to manually manage buffers, C strings, and error codes.
-   Large frameworks that hide the underlying cryptographic primitive behind complex abstractions.

This library aims for a middle ground.

It exposes bcrypt through a small Idris2 API while keeping the underlying behavior explicit. Password hashes remain ordinary Idris2 `String` values, work factors are represented explicitly, and the unsafe details of the C API are isolated behind a minimal FFI boundary.

The result is a library that provides the portability and compatibility of libbcrypt while taking advantage of Idris2's type system and expressive API design.

## Architecture

The library is intentionally split into two layers:

-   `Crypto.BCrypt`
    -   User-facing Idris2 API
    -   Handles `IO`
    -   Provides typed abstractions
    -   Exposes convenient password hashing operations
-   `Crypto.BCrypt.FFI`
    -   Raw foreign bindings
    -   Mirrors the C wrapper API
    -   Contains no higher-level logic
- `Crypto.BCrypt.Types`
    -   Contains types (`WorkFactor`)

The C wrapper isolates Idris2 from libbcrypt implementation details while providing a stable interface.

## Generating salts

A bcrypt salt can be generated with:

```
salt <- genSalt (MkCost 12)
```

The resulting value is a normal bcrypt salt string:

```
$2a$12$...
```

The cost factor controls the computational work required by bcrypt.

## Password hashing

The recommended way to hash passwords is:

```
hash <- hashPassword
    "correct horse battery staple"
    (MkCost 12)
```

The returned hash contains:

-   bcrypt version information
-   cost factor
-   salt
-   password hash

For example:

```
$2a$12$abcdefghijklmnopqrstuuXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Hashing with an existing salt

For deterministic hashing, an existing bcrypt salt can be supplied:

```
hash <- hashPasswordWithSalt
    "password"
    "$2a$12$abcdefghijklmnopqrstuu"
```

This is useful for:

-   Testing
-   Interoperability
-   Reproducing existing bcrypt hashes

A full bcrypt hash may also be supplied because the embedded salt is reused.

## Validating passwords

Password verification is performed using:

```
valid <- validatePassword
    "correct horse battery staple"
    hash
```

The result is:

```
Bool
```

A successful validation returns `True` and a failed validation returns `False`.

## Work factors

bcrypt's computational cost is controlled through the `WorkFactor` type:

```
public export
record WorkFactor where
    constructor MkWorkFactor
    value : Bits8
```

Valid bcrypt costs range from:

```
4 - 31
```

Higher values increase resistance against brute-force attacks but require more computation.

Applications should select a cost appropriate for their deployment environment.

## Error handling

The high-level API follows Idris2 conventions by keeping the FFI boundary small.

The raw C API uses failure values:

-   `NULL` for failed string operations
-   `0` / `1` for validation results

The Idris2 layer is responsible for converting these into appropriate Idris values.

## Advanced Usage

Most applications should use:

```
hashPassword
validatePassword
genSalt
```

However, the lower-level primitives are also available:

```
Crypto.BCrypt.FFI
```

This allows applications requiring finer control to directly interact with the C wrapper layer.

## Testing

The library includes tests covering:

-   bcrypt salt generation
-   password hashing
-   password validation
-   incorrect password rejection
-   deterministic hashing with supplied salts
-   random salt generation
-   bcrypt cost encoding

## Security considerations

bcrypt is designed specifically for password hashing and includes:

-   adaptive computational cost
-   per-password salts
-   resistance to large-scale brute-force attacks

Applications should:

-   choose an appropriate cost factor
-   never store plaintext passwords
-   never reuse salts between passwords
-   always validate passwords using bcrypt verification functions rather than comparing hashes directly
