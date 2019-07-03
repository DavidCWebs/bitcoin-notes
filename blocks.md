Blocks & Blockchain
===================

Blockchain Structure
--------------------
The Bitcoin blockchain is a data structure consisting of an ordered, back-linked set of blocks. Blocks contain transaction data.

The blockchain can be thought of as a set of blocks stacked on top of one another in order, with each block linked to the block below (the previous block).

Block height refers to the number of blocks since the inital (Genesis) block. The "top" or "tip" of the blockchain refers to the most recent block.

The Bitcoin blockchain contains every transaction ever executed in the currency.


Bitcoin Core Data Store
-----------------------
The Bitcoin Core client stores blockchain metadata in the `blocks` directory in the Bitcoin data directory.

The default location of the data directory is `~/.bitcoin` in Linux.

View the Genesis block message:

```
# Hexdump the first 256 bytes of the first block
xxd -l 256 /path/to/bitcoin-datadir/blocks/blk00000.dat
```

using the Google LevelDB database.

Blocks
------
The block header contains a "previous block hash" field, which references the previous block. The sequences of hashes linking blocks is a chain which goes back to the genesis block.

A single block contains:

- 4 Byte magic id: 0xD9B4BEF9
- 4 Byte block length value

This is followed by an 80 byte block header, comprised of 6 sequential pieces of data:
- 4 Byte version number
- 32 Byte previous block hash - the result of hashing the previous block header
- 32 Byte Merkle root of the transactions within this block
- 4 Byte timestamp
- 4 Byte Target difficulty - integer
- 4 Byte Nonce
- 1, 3, 5 or 9 Bytes (variable length) Transaction count

See [https://bitcoin.stackexchange.com/a/41612/56514][1]

Examine Selected Block Data
---------------------------
Get the timestamp of the first block in `blk00003.dat`:

```bash
xxd -ps -s 76 -l 4 blocks/blk00003.dat
```
Returns hex encoded unix epoch timestamp in little-endian order.

Get timestamps of first block in bitcoin `.dat` files:

```bash
for i in {000..099}; do v=$(xxd -s 76 -l 4 -psr blk00$i.dat); echo ${v:6:2}${v:4:2}${v:2:2}${v:0:2}; done > ~/path/block0-999-timestamps-hex.txt
```
Report human readable timestamps for the first block in each file for files `blk00000.dat` to `blk00999.dat`:

```bash

#!/bin/bash
for i in {000..099}; do
	# Get the timestamp bytes
	v=$(xxd -s 76 -l 4 -psr /media/secure-hdd-2/bitcoin-data/blocks/blk00$i.dat);
	
	# Convert to big-endian
	v="${v:6:2}${v:4:2}${v:2:2}${v:0:2}"
	
	echo "Hex timestamp, big-endian: $v"
	
	# Convert to a decimal integer: Unix epoch timestamp
	timestamp=$((16#$v))
	echo "Unix epoch timestamp: $timestamp"

	# Report human readable date
	date -d @$timestamp
	echo "---"
done > ~/Documents/learning-resources/bitcoin/bitcoin-notes/blk00000-00999-timestamps-hex.txt
```

"Chaining" Blocks
-----------------
The 32 byte previous block hash field references the block's parent. Because it is in the block header, it affects the __current__ block's hash.

If the parent block were to be modified, the value obtained by hashing the parent block's header would not match the previous block hash field in the child block. For an adversary to tamper with transaction records (for example, to enable funds to be spent more than once), the child block's "previous block hash" would also need to be amended. This in turn would change the hash of the child block.

For an adversary to successfully alter transaction records in a block, the cascade effect inherent in the blockchain design would necessitate all subsequent blocks to be re-calculated. This would require enormous computing power (plus these block records are built in to many nodes?? Check this!!) - and would be effectively impossible. __In this way, the blockchain history (beyond a certain point) is to all intents and purposes immutable.__

![Blockchain Immutability](images/blockchain-immutability.png)
[Image from Linux Foundation "Blockchain for Business" EdX Course][2]

* [Blockchain Description, Bitcoin Wiki](https://en.bitcoin.it/wiki/Block_chain)

Re-Orgs
-------
* Involves rewinding one or more blocks, applying blocks on other side of the fork.
* Nodes store data that allows them to rewind most recent blocks.
* Bitcoin Core stores rewind data in `blocks/revxxxxx.dat` files in bitcoin `datadir`.

Segregated Witness
------------------
The signatures of transactions are kept separate from transactions themselves.


Segwit prevents transaction malleability - this is an attack whereby an adversary changes the transaction signature. Prior to segwit, this would change the unique transaction id - calculated 
Signatures (witnesses) are still checked (by validating nodes?), but __are not__ taken into account when calculating the transaction identifier. In this way, transaction malleability attacks are prevented.

References
----------
* [BIP 141: segwit][2]

[1]: https://bitcoin.stackexchange.com/a/41612/56514
[2]: https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki

Answer this: https://bitcoin.stackexchange.com/questions/62044/how-to-compute-segwit-txid


