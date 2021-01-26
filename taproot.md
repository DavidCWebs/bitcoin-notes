# Taproot

Taproot is a way of enhancing privacy and improving efficiency/scalability in Bitcoin. 

The spending conditions for bitcoins (UTXOs) are generally locked by means of a script. The UTXO cannot be spent unless the conditions specified by the script are fulfilled.

P2SH Recap
----------
Spending conditions generally involve proof of ownership - in the simplest case, the spending party must provide a signature proving that they possess the private key associated with the public key specified in the spending conditions.

Rather than expose the public key in the UTXO script (which would constitute a privacy leak), the spending condition script may be hashed - and this hash is included in the UTXO as the `scriptPubKey`. To spend the UTXO, the original locking script must be provided. This can be hashed and checked against the hash held in the UTXO. If the hashes match, the locking script can be executed. As part of this, a public key and signature must be provided. If these are valid, the new transaction is valid and the UTXO can be spent.

This type of transaction is known as Pay to Script Hash (P2SH) and it allows complex scripts to be used as spending conditions. The UTXO only needs to hold the hash of the script, which in the case of P2SH is a 20 byte RIPEMD-160 hash. Regardless of the script complexity, the UTXO just needs 20 bytes to hold the script hash.

The locking script may be comprised of more complex spending conditions, such as a n of m multisig transaction. Even though the complex script is reduced to a uniform-sized hash as part of the `scriptPubKey`, the original locking script must be presented when the UTXO is spent - as part of the `scriptSig` unlocking script. This means:

* Information about the transaction is publicly available once the UTXO has been spent - this constitutes a privacy leak
* The amount of information stored on the blockchain may be sub-optimal - for example, if the locking script is a 2 of 5 multisig, all 5 public keys must be included even though only two are required for a valid spend 

References
----------

* [Original Taproot proposal, Gregory Maxell][1]
* [Taproot, and Schnorr, and SIGHASH_NOINPUT, oh my!][2] - Peter Wuille video presentation

[1]: https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-January/015614.html
[2]: https://www.youtube.com/watch?v=YSUVRj8iznU&feature=youtu.be
