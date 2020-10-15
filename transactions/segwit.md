# Segregated Witness

References & Further Reading
----------------------------
A native P2WPKH address has prefix bc1q for Bitcoin mainnet, bcrt1q for regtest.

This address uses the same public key format as P2PKH, but the public key used in P2WPKH __must__ be compressed, i.e. 33 bytes in size, starting with a 0x02 or 0x03.

The P2WPKH scriptPubKey is always 22 bytes. It starts with a OP_0, followed by a canonical push of the keyhash `0x0014{20-byte keyhash}`.

The 20 byte keyhash results from:

* Hash the public key once with SHA256
* Hash this result once with RIPEMD160, resulting in a 20 byte (160 bit) hash

* [Description of address][1]
* [Interesting & useful Bitcoin SE question][2]
* [BIP 141][3]: definition of the new data structure (witness), description of the coinbase leaf

[1]: http://bitcoinscri.pt/pages/segwit_native_p2wpkh_address
[2]: https://bitcoin.stackexchange.com/questions/81727/how-can-segwit-increase-transaction-throughput-if-the-same-amount-of-data-is-sto
[3]: https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki
