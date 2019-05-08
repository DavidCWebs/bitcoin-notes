Unspent Transaction Outputs
===========================
Transaction outputs are indivisible chunks of bitcoin that are recorded on the blockchain and recognised as valid by the entire network.

Bitcoin full nodes track all available and spendable outputs, known as Unspent Transaction Outputs or UTXOs.

All UTXOs together are known collectively as the UTXO set.

When a wallet "receives" bitcoin, it has actually detected that a UTXO that can be spent by one of the wallet's keys has been added to the UTXO set. The bitcoin "balance" of the wallet is the total of all UTXOs that can be spent by that wallet - these UTXOs may be spread across many transactions in many blocks.

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

Note that the difference between input and output value constitutes the fee paid to the miner. This fee should be large enough to provide a financial incentive for miners to include the transaction in a block.

By manipulating the value sent to the change address, wallets can adjust the transaction fee offered to miners for the transaction. If the fee is higher, it is likely that the transaction will be built into the blockchain more quickly.

Spending Conditions for UTXOs
-----------------------------
UTXOs contain a locking script - created such that it can be unlocked by the private key of the receiving address. To spend a UTXO, you must provide a solution to the locking script - which is basically a cryptographic puzzle that proves you possess a private key, without exposing that private key.

When you add an input to a transaction, you must provide a valid unlocking script for the UTXO input.

Locking and unlocking scripts are built in the "script" language.
