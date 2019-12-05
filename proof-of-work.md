Proof of Work
=============
Proof of work involves solving a computational puzzle in order to create new blocks in a blockchain.

This process is known as "mining". Nodes have an incentive to mine - the minor who successfully adds a new block to the blockchain receives a reward (e.g. 12.5 BTC and a small transaction fee).

Proof of Work is the outcome of a successful mining process - though hard to create, it is easy to verify.

An example proof of work in Python is shown below.

In this case, the POW:
* Concatenates a variable number with the last proof
* Hashes this
* Checks for four leading zeros in the resultant hash (success)
* If unsuccessful, the variable number is incremented and the process is repeated

The solution, by design, must be brute-forced in this way - there is no other way of determining a successful proof.

Though solving the proof requires a committment of significant computing power, checking that the proof is valid is trivial - nodes just need to concatenate the found proof with the previous proof and check for four leading zeros.
~~~py
# ...

class Blockchain(object):
    # ...
    def proof_of_work(self, last_proof):
        """
        Simple POW algorithm:
        - Find a number p' such that hash(p+p') contains 4 leading zeroes
        - where p is the previous proof and p' is the current proof
        :param last_proof: <int>
        :return: <int>
        """
        proof = 0
        while self.valid_proof(last_proof, proof) is False:
            proof += 1

        logging.debug("Proof: {}".format(proof))
        check = hashlib.sha256((str(last_proof) + str(proof)).encode()).hexdigest()
        logging.info("Check: {}".format(check))
        return proof

    @staticmethod
    def valid_proof(last_proof, proof):
        """
        Validates the proof: Does the hash of last_proof * proof contain 4 leading zeros?

        :param last_proof: <int> Previous proof
        :param proof: <int> Current proof
        :return: <bool> True if correct, otherwise False
        """
        guess = (str(last_proof) + str(proof)).encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"

    # ...

~~~
