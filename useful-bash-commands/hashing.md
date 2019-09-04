Bash Hashing Utilities
======================

In Bitcoin Core, the last 32 bytes of `peers.dat` files consist of a checksum - a double sha256 hash of the file.

Note that the checksum is not included in the hash - the file is double hashed, and the resulting 32 bytes are appended to the file.

Get the checksum from the end of `peers.dat`:

```bash
tail -c 32 peers.dat | xxd -p | tr -d '\n'
```

Double sha256 hash the file, excluding the checksum:

```
head -c -32 peers.dat | openssl dgst -sha256 -binary | openssl dgst -sha256
```
