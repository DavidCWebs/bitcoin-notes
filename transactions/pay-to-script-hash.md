# Pay to Script Hash
Transaction outputs do not need to be sent to a Bitcoin address - they can be sent to a script.

All transaction outputs create a cryptographic puzzle that must be solved in order to spend the output. The puzzle and the solution to the puzzle are represented by two scripts:

* `<scriptPubKey>`: The spending conditions, containing the (usually hashed) public key.
* `<scriptSig>`: Contains a signature that unlocks the `<scriptPubKey>`.

In a Pay-To-Script-Hash (P2SH) transaction, the conditions to redeem the transaction are encoded in the `<scriptSig>` rather than in the `<scriptPubKey>`. The conditions required to spend the UTXO is shifted to the receiver of the funds (i.e. the _input_ in the spending transaction.

Locking Steps
-------------
Create a multi-sig script. For example, 2 of 3 multisig:
```
OP_2 <pubKey 1> <pubKey2> <pubKey3> OP_3 OP_CHECKMULTISIG
```
This is the redemption script.

The hash of the redemption script is computed by SHA256 hashing the serialized byte format, followed by RIPEMD160 hashing the result.

### The Address
The receiver creates an address by converting the hash of the redemption script into a base 58 Bitcoin address by Base58Check. From the serialized byte format of the script the process is as follows: 

* SHA256 hash the serialized bytes of the redemption script
* RIPEMD160 hash the result
* Prepend a version byte: `0x05` for mainnet, `0xc4` for testnet/regtest
* Create a checksum by double SHA256 hashing the RIPEMD160 hash, and appending the first four bytes of this value to the RIPEMD160 hash
* Encode the RIPEMD160 + checksum hash into base 58.

The `scriptPubKey` of the transaction output will be:

```
OP_HASH160 <hash of redemption script>
```

Take values from [this reference][1] as an example:
```bash
Enter a hexstring representation of a P2SH <scriptPubkey>:
522103310188e911026cf18c3ce274e0ebb5f95b007f230d8cb7d09879d96dbeab1aff210243930746e6ed6552e03359db521b088134652905bd2d1541fa9124303a41e95621029e03a901b85534ff1e92c43c74431f7ce72046060fcf7a95c37e148f78c7725553ae
9af61346ce0aa2dffcf697352b4b704c84dcbaff
7d3b5744f0063cb530f56eb3ef24d90a7ea671104f5f69fc47038c7d6e9ba1bb
bf1318f742d47d05f6003816e3b4162b6a7be5b12d727f2468f8fedbcbbcd913
c49af61346ce0aa2dffcf697352b4b704c84dcbaffbf1318f7
2N7NaqSKYQUeM8VNgBy8D9xQQbiA8yiJayk
```
Use `~/Learning/bitcoin/address/cpp/bin/p2sh`

Process of Spending
-------------------
The conditions specified in an output `<scriptPubKey>` must be met to spend the funds contained in that output.

The spending input must provide a `<scriptSig>` that solves the cryptographic puzzle defined by the `<scriptPubKey>`.

The mechanics of this involve the protocol concatenating `<scriptSig>` and `<scriptPubKey>` and running the entire script. If the final result evaluates to true, the transaction is valid. If at any point the script evaluation fails, the transaction is considered invalid and is discarded.

References
----------
* [Worked example, P2SH Multisig Transaction][1]
* [SO Answer][2], David Harding

[1]: https://bitcoin.org/en/developer-examples#p2sh-multisig
[2]: https://bitcoin.stackexchange.com/a/52272/56514
