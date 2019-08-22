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

An element maps to _k_ bits (because there are _k_ hash functions. Setting any of these _k_ bits to zero is enough to remove the element.

Bloom filters achieve a high degree of data compression at the expense of a prescribed false negative rate.

Bitcoin
-------
In the context of Bitcoin, bloom filters are mainly used by SPV clients.  

References
----------
* [Bloom Filters: Wikipedia][1]
* Bloom Filters in [Bitcoin Developers Guide][2]

[1]: https://en.wikipedia.org/wiki/Bloom_filter
[2]: https://bitcoin.org/en/operating-modes-guide#bloom-filters
