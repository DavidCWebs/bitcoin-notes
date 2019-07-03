Unspent Transaction Outputs
===========================
Transaction outputs are indivisible chunks of bitcoin that are recorded on the blockchain and recognised as valid by the entire network.

Bitcoin full nodes track all available and spendable outputs, known as Unspent Transaction Outputs or UTXOs.

All UTXOs together are known collectively as the UTXO set.

When a wallet "receives" bitcoin, it has actually detected a UTXO that can be spent by one of the wallet's keys has been added to the UTXO set. The bitcoin "balance" of the wallet is the total of all UTXOs that can be spent by that wallet - these UTXOs may be spread across many transactions in many blocks.

Bitcoin Balance?
----------------
The bitcoin protocol has no concept of balance. Wallets aggregate the value of any UTXO that the wallet controls and present this as the balance.

To determine the amount of available bitcoin controlled by a wallet, the wallet needs to scan the blockchain to determine UTXO associated with keys controlled by the wallet. Most wallets maintain a collection of UTXOs that can be spent with the wallet's keys.

Indivisibility
--------------
UTXOs cannot be split - they must be spent in their entirety. UTXOs are discrete and indivisible units of value, denominated in __integer__ satoshis (10e-8 BTC).

Transactions
------------
Transactions involve creating new UTXOs that can be in turn spent by different keys. They take previous UTXOs as inputs, and create new UTXOs as outputs. 

Change Addresses & Mining Fee
-----------------------------
If a UTXO is larger than the required value of a transaction, it must still be spent entirely. Usually this involves wallets creating a change address, and adding the change address as an output from the new transaction.

Note that the difference between input and output value for a given transaction constitutes the fee paid to the miner. This fee should be large enough to provide a financial incentive for miners to include the transaction in a block.

By manipulating the value sent to the change address, wallets can adjust the transaction fee offered to miners for the transaction. If the fee is higher, it is likely that the transaction will be built into the blockchain more quickly.

**Be careful**: if you do not specify a change address, the entire difference between transaction input and output is available as a mining fee.

Fortunately, most (all?) major bitcoin wallets automatically generate change addresses and allow the transaction fees to be set appropriately.

**Heuristic for paper wallets/manually created transactions:** Do not attempt to partially spend from a UTXO. Transfer all value - to multiple addresses if necessary - and set an appropriate miner's fee.

Spending Conditions for UTXOs
-----------------------------
UTXOs contain a locking script - created such that it can be unlocked by the private key of the receiving address. To spend a UTXO, you must provide a solution to the locking script - which is basically a cryptographic puzzle that proves you possess a private key, without exposing that private key.

When you add an input to a transaction, you must provide a valid unlocking script for the UTXO input.

Locking and unlocking scripts are built in the "script" language.

Sample Transaction
------------------
Get data regarding an address which the wallet manages and which has control over funds:

```bash
bitcoin-cli -regtest listunspent 0 9999999 "[\"2NEVJfcNaCSGEYGu78sEy1iP5cbwAwwH7yu\"]"
[
  {
    "txid": "6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea",
    "vout": 1,
    "address": "2NEVJfcNaCSGEYGu78sEy1iP5cbwAwwH7yu",
    "label": "",
    "redeemScript": "00145e3ce6f54cf312d8e6456fc2f69b566f13553d30",
    "scriptPubKey": "a914e9045eb5c979a83dc61efaf7d1003b1d58dbcc6687",
    "amount": 99.90000000,
    "confirmations": 1,
    "spendable": true,
    "solvable": true,
    "desc": "sh(wpkh([90ba3d87/0'/0'/26']03fc58cb2061f37c45221382a4d1cc20395e682d666dabe8335a47ab0b027fbea1))#79kzpz6m",
    "safe": true
  }
]

```
This tells us that the address `2NEVJfcNaCSGEYGu78sEy1iP5cbwAwwH7yu` has access to 99.9 bitcoins, and that the UTXO originated in the 2nd output (`vout`) of transaction with id (`txid`) `6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea`.

To get the transaction data:

```bash
# start bitcoind in regtest mode:
bitcoind -regtest

# In another terminal, get the raw transaction:
bitcoin-cli -regtest getrawtransaction 6d2808d5544748c63de8a32ca96741a5ad11922f3adf827fc3568a785e64c3ea

# Decode to view full transaction data - $RAW is output of above:
bitcoin-cli -regtest decoderawtransaction $RAW
```
Output:

```json
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
How Do Nodes Track Unspent Outputs?
-----------------------------------



>Every full Bitcoin node maintains a database of which unspent outputs are left.
>
>When verifying a transaction, all its inputs are fetched from the database. If one is missing, validation fails. Among the data retrieved is the value of those unspent outputs, and their script (od address), which define the conditions under which the output can be spent. This information is necessary to validate whether the spending transaction has the correct signatures and does not create more bitcoin than it consumes.
>
>If all validation of all transactions in a block succeed, the consumed inputs are removed from the database, and all outputs of those transactions added as fresh unspent outputs in the database, allowing them to be spent by future blocks.
>
>As this database only contains outputs (so no signatures, for example), and even only the unspent ones, it is much smaller than the entire blockchain (some 450 MB as of juli 2014). So, no, we don't go scan through the entire blockchain to know whether outputs are not double-spent - we keep a separate database with just the data we need from it for validation.
> [Pieter Wuille][1], SO 2 July 2014

[1]: https://bitcoin.stackexchange.com/a/28260/56514
