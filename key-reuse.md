Do Not Reuse Bitcoin Addresses
==============================

It is advisable to use a new Bitcoin address for all transactions - you should not re-use Bitcoin addresses. There are two main reasons for this.

1. Prevent Theoretical Attacks Against a Public Key
---------------------------------------------------
Before spending, the public key associated with a Bitcoin address is not publicly(!) known since the process of deriving the address from the public key involves one-way hashing functions - the Bitcoin address doesn't provide any information about the public key used to derive it.

When Bitcoin is spent, the public key associated with the Bitcoin address is revealed in the spending transaction. This exposes the public key to theoretical cryptographic attacks - such attacks would mean that the sending address would be vulnerable if it received funds in the future.

Such an attack against the public key cryptography securing a novel Bitcoin address would only be feasible by a quantum computer that could break the key in the short time period between sending the transaction and it's incorporation into a block [^1]. Address reuse might make the attack more feasible - the attacker has more time to work on the exposed public key of a re-used Bitcoin address.

2. Privacy
----------

References
-----------
* [Quantum computing & Bitcoin][1]

[1]: https://en.bitcoin.it/wiki/Quantum_computing_and_Bitcoin

