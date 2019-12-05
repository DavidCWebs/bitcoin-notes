# Bitcoin Transactions
The Bitcoin system works by tracking the transfer of Bitcoins on an append-only decentralised public ledger - the blockchain.

It is called a blockchain because it is made up of a series of linked blocks, with each block containing a set of _transactions_.

Transaction Data Structure
--------------------------
Transactions are made up of:
* Metadata - size of the transaction, number of inputs, number of outputs, hash of the entire transaction (which serves as a unique identifier) and a `lock_time` field
* Inputs - an array of inputs, each referencing a previous transaction by means of a hash pointer - the input transaction hash (txid) and an index specifying the output of that transaction to be used for this input, along with a signature.
* Outputs - an array of one or more outputs, each with two fields: Value, and pubkey script.

Each transaction has at least one input and one output. Each input spends the bitcoin paid to a previous output. The input signature serves to prove that the current signature has the right to redeem the prevous UTXO.

### Metadata
Transactions are prefixed by a 4 byte transaction version number. This specifies how nodes should validate the transaction, and allows new rules to be created for transaction validation in the future without invalidating earlier transactions.

### Inputs
Each input in a transaction spends the satoshis paid to an output in a previous transaction. Inputs contain:
* A Transaction identifier - the hash of the transaction containing the UTXO that will be spent in this transaction input
* Output index - often labelled `vout`. This is an index number that references the specific UTXO in the transaction identified above. In the previous transaction, the index is implied by the order of the UTXO, zero-indexed. This means that a `vout` of 0 refers to the first output in the specified transaction.
* A signature that proves ownership of the private key - unlocking the puzzle constituted by the conditionals in the pubkey script of the referenced UTXO. 

### Outputs
Each output has an implied index number based on it's order in the transaction.

Outputs contain an amount field, specifying the amount to be paid to a conditional pubkey script.

The __pubkey script__ sets the conditions that must be fulfilled for the satoshis associated with an output to be spent. Pubkey scripts are called `<scriptPubKey>` in code. Data that fulfills the spending conditions is provided in the (future) spending transaction as a __signature script__: `<scriptSig>`. 

Each output waits as an UTXO until an input in a later transaction spends it by unlocking it with a valid `<scriptSig>`.

Validity
--------
Because all full nodes have the entire record of all transactions on the Bitcoin blockchain, when a new transaction is received the inputs are checked to ensure that they are valid unspent outputs from previous transactions.

The sum of the inputs must be greater than or equal to the sum of the outputs.

The difference between inputs and outputs (if any) becomes the transaction fee, and is collected by the miner who mines the block that eventually contains the transaction. The transaction fee is included in the coinbase transaction for the successfully mined block.

Outputs can only be spent _once_, and _they must be spent in their entirety_.

If the amount of the combined inputs is greater than the amount to be spent, change is generated. It is important to send this back to a change address (a process which is generally automated by wallet software) that is controlled by the transaction originator - or else the change will constitute an excessive transaction fee.

The change address is generally included as an additional output to the transaction. It is recommended that a new address is generated and used for change - receiving funds to an address more than once is a privacy leak and though possible, is considered bad practice.

Broadcasting Transactions
-------------------------
When a transaction has been constructed, it is broadcast to the Bitcoin network. The first node that receives the transaction checks that it is valid. If it is, the transaction is relayed to other nodes in the network.

Verification
------------
Nodes check that:
* Previous outputs referenced by the transaction exist and are unspent - this is achieved by checking against the UTXO cache.
* The sum of inputs is greater than or equal to the sum of outputs.
* Signatures for each of the provided inputs are valid - each input must be signed with the private key associated with the address referenced by the relevant UTXO.

UTXO Cache
----------
Bitcoin core maintains a database of UTXO. This database is quickly used to check if a new transaction is valid. If it is, further checks are carried out. If it proves invalid at this stage, the transaction is discarded.

P79 UNderstandin Bitcoin Pedro FRanco


Resources
---------
* [bitcoin.org][1] Guide to Transactions

[1]: https://bitcoin.org/en/transactions-guide#introduction
