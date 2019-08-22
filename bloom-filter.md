Bloom Filter
============
Used by Simplified Payment Verification (SPV) Nodes as a way of accessing transactions that are relevant to the keys held by the wallet without:

* Downloading the entire blockchain.
* Compromising privacy by exposing the public keys under management by the wallet. 

Logic
-----
Bloom filters are used to test whether an element is a member of a set.

False positives are possible - a non-belonging element can be mistakenly included.

False negatives are not possible - an element which is a member of the set cannot be excluded by the bloom filter.

Algorithm
---------
An empty bloom filter is an array of _n_ bits all set to zero, along with _k_ different hash functions, each of which maps a set element to on e of the bit array positions.


When adding an element to the filter, it is hashed _k_ times (using each of the _k_ hashing algorithms). Each output is an integer between 1 and _n_, and this integer is used to set the bit positon in the bit array (bloom filter). 

For example:

```
k₁(el) → filter[i] = 1
k₂(el) → filter[j] = 1
k₃(el) → filter[k] = 1
```
To query against the filter, the element to be tested is hashed with hash functions k₁, k₂ and k₃.

If any of the bits at positions i, j and k on the filter array are __not__ set, the tested element is definitely not in the set.

If all bits are set, the tested element __might__ be in the set.

An element maps to _k_ bits (because there are _k_ hash functions). Setting any of these _k_ bits to zero is enough to remove the element.

Bloom filters achieve a high degree of data compression at the expense of a prescribed false negative rate.

Multiple Elements
-----------------
Adding a second pattern to the bloom filter just involves repeating the process. As more patterns set overlapping bits, the filter becomes saturated (more bits are set) and the accuracy decreases - there is a higher likelihood of false positives.

Bitcoin
-------
In the context of Bitcoin, bloom filters are mainly used by SPV clients.

SPV clients do not store the full blockchain - they are typically run on resource-limited devices (e.g. phones), or as light desktop clients. They generally do not download transactions, instead storing block headers only. In this way, they store much less data.


SPV Clients/Nodes
-----------------
Simple Payment Verification (SPV) is a technique described by Satoshi Nakamoto in the [Bitcoin white paper][4]. The technique allows a light client to determine that a transaction is in the Bitcoin blockchain without downloading the entire blockchain.

> It is possible to verify payments without running a full network node. A user only needs to keep a copy of the block headers of the longest proof-of-work chain, which he can get by querying network nodes until he's convinced he has the longest chain, and obtain the Merkle branch linking the transaction to the block it's timestamped in. He can't check the transaction for himself, but by linking it to a place in the chain, he can see that a network node has accepted it, and blocks added after it further confirm the network has accepted it.
>
> -- Satoshi Nakamoto, [Bitcoin: A Peer-to-Peer Electronic Cash System][4]

SPV clients must be able to tell the user the amount of Bitcoin available for spending - in particular, it is essential that the wallet determines whether Bitcoin received by wallet addresses is reliably spendable by the wallet owner. It must reliably determine that  UTXOs associated with wallet addresses have not been previously double spent.

SPV nodes can't directly parse the blockchain to determine which UTXOs are available for spending by the keys that they manage - they don't have a copy of the blockchain.

The initial syncing process involves downloading the __headers__ of all blocks. After initial synchronisation, the SPV node requests all block headers since the last received header. The SPV client also requests transactions that involve addresses managed by the SPV client - and __only__ these transactions. SPV clients request and receive this information from full nodes on the network.

To verify that a transaction is in a block, an SPV node requires a proof of inclusion provided from a full node. This takes the form of a Merkle branch.

Merkle trees are an efficient way to prove that an element is in a set, without having to store the full set. Each non-leaf node of a merkle tree is a hash of the concatenation of it's immediate children. The leaves of the tree are the elements of the set to which the Merkle tree proves membership. In the case of Bitcoin, the leaves of the Merkle tree are the transaction identifiers (the hash of a raw transaction). Leaves are concatenated pair-wise and hashed to provide parent nodes. If there are an odd number of transactions/leaves, the final leaf is concatenated with itself. Parent nodes are in turn concatenated in pairs and hashed, with the process repeated until a single Merkle hash remains - the Merkle root.

The Merkle root is stored in a block header, where it serves to make transactions tamper-proof - if a transaction is changed, the Merkle root would be thrown off. Because the hash of each block is included in subsequent blocks, the tamper would be immediately evident and the block with the tampered transaction would not be accepted as valid by the Bitcoin consensus rules.

To verify a transaction - check that a transaction is in a valid block - you just need the hashes of Merkle branch to compute the Merkle root, not the entire set of transactions in the block. 

SPV Clients and Bloom Filters
-----------------------------
If an SPV client simply requested specific transaction data - such as the Merkle branch required to verify a particular transaction - sensitive information would be revealed.

The SPV client could download the entire contents of blocks and all broadcast transactions, discarding the (majority) transactions that are not relevant to the wallet. This would be incredibly wasteful in terms of bandwidth (which may be limited), memory and time taken. But it would maintain privacy.

[BIP 37][5] introduced bloom filters as a way for SPV nodes to request relevant transactions without overly compromising privacy.

The SPV client creates a bloom filter based on the desired transactions - transactions that the SPV wallet needs to verify UTXOs for keys under it's management. The bloom filter also includes dummy data

@TODO
How SPV clients tune bloom filters, interaction with full nodes.

References
----------
* [Bloom Filters: Wikipedia][1]
* Bloom Filters in [Bitcoin Developers Guide][2]
* [Simplified Payment Verification][3]
* [Bitcoin white paper][4]
* [BIP 37][5]: Connection Bloom Filtering

[1]: https://en.wikipedia.org/wiki/Bloom_filter
[2]: https://bitcoin.org/en/operating-modes-guide#bloom-filters
[3]: https://bitcoin.org/en/operating-modes-guide#simplified-payment-verification-spv
[4]: https://bitcoin.org/bitcoin.pdf
[5]: https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki
