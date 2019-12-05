Digital Signatures
==================
Cryptographic primitive.

1. Only you can sign, but anyone can verify
2. Signature is associated with a particular document

## API for Digital Signatures
Signature scheme:
The first two functions in the scheme can (should be) randomised algorithms - but `isValid()` will be deterministic.
~~~
# Generate sk (secret key) and pk (public verification key), generate keys of a specific size
(sk, pk) := generateKeys(keysize)

# Return a string of bits representing the signature
sig := sign(sk, message)

isValid := verify(pk, message, sig)
~~~

## Requirements
* Valid signatures are verifiably Valid
* Signatures can't be forged: adversary knows public key, gets to see signatures on other messages, still can't produce a valid signature on another message.

Algorithms need a good source of randomness - this is often targeted by intelligence agencies.

Limit on message size - could use a Hash(message) rather than the message itself (the sender can sign the hash of the message, and the receiver can hash the massage and check the hash for validity)

Signing a hash pointer - the signature refers to the entire data structure.

## Bitcoin
Uses ECDSA standard (Elliptic Curve Digital Signature Algorithm).

Good randomness is essential. If `generateKeys()` or `sign()` do not have a good source of randomness, the private key may be leaked.
