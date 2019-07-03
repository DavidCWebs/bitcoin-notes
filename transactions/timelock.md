Timelock
========
Can't spend Bitcoin until a certain time. The time may be either:

* Relative to block
* Absolute time

Can be either transaction based (open to double-spend vulnerability) or UTXO based.

Four types:

* nLocktime - absolute timelock
* `CHECKLOCKTIMEVERIFY` (CLTV) - absolute timelock
* nSequence -relative timelock
* `CHECKSEQUENCEVERIFY` (CSV) -relative timelock

nLocktime
---------
* Present since start of bitcoin.
* Transaction level lock - can't add the transaction to the blockchain until the locktime has elapsed.
* Defines the earliest time a tx can be spent - actually added to blockchain.
* If less than 500 million, refers to block height.
* If more than 500 million, refers to Unix epoch timestamp.
* Held by original node, rejected by others.

Check Lock Time Verify (CLTV)
-----------------------------
* Since 2015.
* OP code for script language.
* Output-level lock - can't use the output as an input until the required timelock has elapsed.
* Block height or Unix epoch timestamp.
* Tx can be broadcast, included in block - but no-one will be able to unlock the UTXO until the timelock has elapsed.
* Outputs can't be double spent - they are in the blockchain, but not redeemable until the timelock has elapsed.

Example locking script with CLTV:

```
1585298868 OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 <PubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

Two conditions must be fulfilled to unlock the UTXO:

1. Timestamp must have elapsed (in the example above, it is a Unix epoch timestamp that refers to 27 March 2020 08:47:48).
2. Provide the correct signature and public key as usual.

The payee can be certain that they are the only one able to redeem the UTXO after the required time has elapsed.

Relative Timelocks: nSequence
-----------------------------
Originally intended as a way to update transactions.

* Relative timelock on a transaction.
* Transaction only valid after inputs have aged a specific length of time.
* Can be specified either in blocks or seconds.

If a transaction has an nSequence of 24 hours, it will not be included in a block until 24 hours have elapsed between the mining of the UTXO that is being spent and the broadcast time.

Relative Timelocks: Check Sequence Verify (CSV)
-----------------------------------------------
* Relative timelock on transaction outputs (UTXO).
* Introduced in 2016.
* Restricts spending a UTXO until a certain number of blocks or seconds have elapsed since the transaction was mined.

Requires that the transaction spending the output sets an `nSequence` of at least this value.

Example locking script with CSV:

```
30 OP_CHECKSEQUENCEVERIFY OP_DROP OP_DUP OP_HASH160 <PubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

To redeem this UTXO, an `nSequence` of at least 30 must be set in the spending transaction.


