# Bitcoin Blockchain Structure

Blockchain data structure:
Ordered, back-linked list of blocks. Blocks contain transaction data.

Bitcoin core client stores blockchain metadata using the Google LevelDB database.

Visualisation: First "Genesis" block, with subsequent blocks stacked on top. This gives rise to the concept of block height and terms like "top" and "tip" to refer to the most recent block.

The Bitcoin blockchain contains every transaction ever executed in the currency.
## Blocks
The block header contains a "previous block hash" field, which references the previous block. The sequences of hashes linking blocks is a chain which goes back to the genesis block.

At the highest level, blocks contain:

* Block size field (4 bytes)
* 80 byte block header
* VarInt for the number of transactions in the block (N): 1-9 bytes
* Transaction data for N transactions: Variable size

The 80 byte block header contains metadata:
* A 4 byte version number
* A hash pointer referencing the previous block
* Merkle hash/root of the N transactions in the block. (See What is the Merkle root?)
* Block timestamp
* Difficulty to solve the block encoded as an integer.
* Nonce - an easy number to change to try different hash values.
See [https://bitcoin.stackexchange.com/a/41612/56514][1]

The "Previous block hash" field is inside the block header (referencing the block's parent) - it thereby affects the __current__ block's hash. If the parent block were to be modified, the parent block hash would change. For an adversary to tamper with transaction records (for example, to enable funds to be spent more tha once), the child block's "previous block hash" would also need to be amended. This in turn would change the hash of the child block. For a malicious adversary to successfully alter transaction records in a block, the cascade effect inherent in the blockchain design would necessitate all subsequent blocks to be re-calculated. This would require enormous computing power (plus these block records are built in to many nodes?? Check this!!) - and would be effectively impossible. __In this way, the blockchain history (beyond a certain point) is to all intents and purposes immutable.__

![Blockchain Immutability](images/blockchain-immutability.png)
[Image from Linux Foundation "Blockchain for Business" EdX Course][2]

[1]: https://bitcoin.stackexchange.com/a/41612/56514
[2]: https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS171x+3T2017/courseware/4bdba5353739430592043585c7fbf044/bf7a3e04813b46e79773b5b55f339861/?activate_block_id=block-v1%3ALinuxFoundationX%2BLFS171x%2B3T2017%2Btype%40sequential%2Bblock%40bf7a3e04813b46e79773b5b55f339861
## References
* [Blockchain Description, Bitcoin Wiki](https://en.bitcoin.it/wiki/Block_chain)
