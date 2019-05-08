Bitcoin Transaction Structure
=============================

Unlocking Script
----------------
Used to validate a transaction - demonstrates that a UTXO can be spent, because the relevant private key has been used to sign the unlocking script.

A UTXO contains a locking script.

A transaction input (UTXO) `vin` contains a reference to the transaction that created the UTXO. This transaction contains a locking script.

The transaction is validated by using an unlocking script `scriptSig` to unlock the locking script from the original transaction (the one that generated the UTXO).

**For a transaction to be considered valid, the unlocking script must satisfy the condition set in the locking script.**

Example Transaction
-------------------
To view a complete transaction in regtest:

```
RAW=$(bitcoin-cli -regtest getrawtransaction 6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea)

bitcoin-cli -regtest decoderawtransaction $RAW | jq

```
Output:

```
{
  "txid": "6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea",
  "hash": "6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea",
  "version": 2,
  "size": 300,
  "vsize": 300,
  "weight": 1200,
  "locktime": 105,
  "vin": [
    {
      "txid": "ffaca45dfe44106c86b3c5b9c77ea1c09a9795d54d1975c24bd9da6b3cf572b9",
      "vout": 0,
      "scriptSig": {
        "asm": "304402207b1b5a8d377ddbdd652f141065b26bef13d6cdd258e8e62f4289e4457ed7044902201fc4b66a296d2ebbfba876098c3e6ab6d49e013664da68cb87646971f1263463[ALL]",
        "hex": "47304402207b1b5a8d377ddbdd652f141065b26bef13d6cdd258e8e62f4289e4457ed7044902201fc4b66a296d2ebbfba876098c3e6ab6d49e013664da68cb87646971f126346301"
      },
      "sequence": 4294967294
    },
    {
      "txid": "d78c5a5943de9ab7a12f61ff29ff9acdf426fb9e6f098a2e34ecdfb6b788263a",
      "vout": 0,
      "scriptSig": {
        "asm": "304402206ccdf9aaff463f33578308b7dcf5857f48d002a1319f69c256b32321c3cc4dad0220137f65047eb4c3eb4aa2fcab8ea4e2a0496b54901edb60b56aa426bdfc301064[ALL]",
        "hex": "47304402206ccdf9aaff463f33578308b7dcf5857f48d002a1319f69c256b32321c3cc4dad0220137f65047eb4c3eb4aa2fcab8ea4e2a0496b54901edb60b56aa426bdfc30106401"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 0.09994,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 179a747f5caa93d99a6065b08658f62b9b92574f OP_EQUAL",
        "hex": "a914179a747f5caa93d99a6065b08658f62b9b92574f87",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "2MuQ2ZRT1wLsZKevD9biPDzb5WosXyyDQER"
        ]
      }
    },
    {
      "value": 99.9,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_HASH160 e9045eb5c979a83dc61efaf7d1003b1d58dbcc66 OP_EQUAL",
        "hex": "a914e9045eb5c979a83dc61efaf7d1003b1d58dbcc6687",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "2NEVJfcNaCSGEYGu78sEy1iP5cbwAwwH7yu"
        ]
      }
    }
  ]
}
```

