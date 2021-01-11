---
title: Scaling
---

The Bitcoin network primarily provides the utility of _payments_. Users use the network to transfer value by means of payments. In the Bitcoin protocol, payments are encapsulated in transactions, with value being transferred by means of Unspent Transaction Outputs (UTXO). Transactions consume UTXO and generate new UTXO, with spending conditions applied to the generated UTXO such that only the receiver(s) of funds can spend them.

A transaction refers to a transformation on the global set of unspent transaction outputs - consuming UTXO and generating new UTXO. It also refers to the data structure that is passed through the P2P network describing the transformation and carrying witness data proving that the transaction is valid.

Transactions __do not correspond to payments__. Transactions can include one, many or no payments. As such, the _transactions per second_ metric is not particularly significant. One transaction might include batched payments such that a single transaction makes payments to multiple recipients.
