# Pay to Script Hash
Transaction outputs do not need to be sent to a Bitcoin public key - they can be sent to a script hash. This allows complex spending conditions to be attached to a UTXO in a way that does not increase the size of the transaction and which places the burden of complexity on the receiver.

P2SH involves:

1. The receiver generates a set of spending conditions - a redeemScript
2. The receiver generates an address by hashing the redeemScript and encoding this in an address format
3. The sender sends to the address, which locks the funds according to the conditions set in step 1
4. To spend the funds, the receiver must provide a valid redeemScript the hash of which matches that represented by the address

All transaction outputs create a cryptographic puzzle that must be solved in order to spend the output. The puzzle and the solution to the puzzle are represented by two scripts:

* `<scriptPubKey>`: The locking script which specifies the conditions which must be met for the output to be spent
* `<scriptSig>`: Contains a signature that unlocks the `<scriptPubKey>` - if the transaction is P2PKH, this is a cryptographic proof that the spender controls the private key associated with the address public key

In a Pay-To-Script-Hash (P2SH) transaction, the conditions to redeem the transaction are encoded in the `<scriptSig>` rather than in the `<scriptPubKey>`. The `<scriptPubKey>` contains the hash and opcodes necessary to check that the spenders redeemScript matches the original script used to generate the Bitcoin address. Once this has been checked, the redeemScript (present in the `<scriptSig>`) is permitted to execute.

In this way, the conditions required to spend the UTXO are shifted to the receiver of the funds (i.e. the _input_ in the spending transaction).

This has several benefits:

* The sender can send without concerning themselves with the spending conditions specified by the receiver - the sender focuses solely on transferring funds to the receiver
* For multi-signature transactions, funds are sent without exposing the public keys of the recipient(s) - this increases privacy since these public keys are not exposed until the recipient spends the funds
* The receiving address is short compared to a full redeemScript - typically a 34 character base58Check encoded address
* UTXOs do not contain long locking scripts - the burden is shifted to transaction inputs which are stored in the blockchain, reducing the memory footprint of the UTXO set

>The purpose of pay-to-script-hash is to move the responsibility for supplying the conditions to redeem a transaction from the sender of the funds to the redeemer.
>
>The benefit is allowing a sender to fund any arbitrary transaction, no matter how complicated, using a fixed-length 20-byte hash that is short enough to scan from a QR code or easily copied and pasted. 
>— [BIP 0016][BIP 0016] 

Locking Steps
-------------
The receiver decides the spending conditions for the funds that they will receive. These conditions are bounded by what is possible in a regular Bitcoin script. 

Create a multi-sig script. For example, 2 of 3 multisig:

```
OP_2 <pubKey 1> <pubKey2> <pubKey3> OP_3 OP_CHECKMULTISIG
```
This is the redemption script.

The hash of the redemption script is computed by SHA256 hashing the serialized byte format, followed by RIPEMD160 hashing the result.

### The Address
The receiver creates an address by converting the hash of the redemption script into a base 58 Bitcoin address by Base58Check. From the serialized byte format of the script the process is as follows: 

* SHA256 hash the serialized bytes of the redemption script
* RIPEMD160 hash the result
* Prepend a version byte: `0x05` for mainnet, `0xc4` for testnet/regtest
* Create a checksum by double SHA256 hashing the RIPEMD160 hash, and appending the first four bytes of this value to the RIPEMD160 hash
* Encode the RIPEMD160 + checksum hash into base 58.

The `scriptPubKey` of the transaction output will be:

```
OP_HASH160 <hash of redemption script> OP_EQUAL
```
Worked Example: 2 of 3 Multisig as a P2SH
-----------------------------------------
Create a 2-of-3 Multisignature address and send coins to the address.

### Step 1: Construct the Multisig Script
The Multisig script requires the public keys that will be used to lock the output, as well as the total number of public keys used ($n$) and the threshold number of keys required for the funds to be unlocked ($m$).

To create the multisig:

```bash
# Make an array of public keys to be used - not strictly necessary, but handling keys
# in this way makes the command much cleaner:
pubkeys[0]=02c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c # first
pubkeys[1]=02b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814 # second
pubkeys[2]=0234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f # third

# Create a multisig redeem script using these keys. The jq utility is used to pass the full array pubkeys
# into the command in the required JSON format:
bitcoin-cli -regtest createmultisig 2 $(jq -nc '$ARGS.positional' --args "${pubkeys[@]}")

# If you'd rather not use jq, escape the quotations within the JSON array:
bitcoin-cli -regtest createmultisig 2 "[\"${pubkeys[0]}\", \"${pubkeys[1]}\", \"${pubkeys[2]}\"]"

# These commands are effectively identical. The result is:
{
  "address": "2N2Zxm7Kf3v4DKMSWW3zYz5Szi8tmGCvtKx",
  "redeemScript": "522102c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c2102b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814210234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f53ae",
  "descriptor": "sh(multi(2,02c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c,02b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814,0234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f))#q6zdklmm"
}
```
The `redeemScript` is constructed by:

1. Setting the first byte to an [opcode][opcodes] that pushes the number $m$ (the threshold) onto the stack - in this case 0x52 (an instruction to "push the number 2 onto the stack")
2. The next byte is in the range 0x01-0x4b, which denotes that this value is the next number of bytes to be pushed to the stack
	- In the case of a multisig redeem script, this byte is 0x21, which denotes that the following 33 bytes are to be pushed onto the stack
3. The next bytes to be added are the first public key
4. Steps 2 and 3 are repeated until all public keys have been added to the script
5. After the final key, the next byte is an opcode that pushes the number $n$ (the total number of public keys) onto the stack - in this case, 0x53 (an instruction to "push the number 3 onto the stack")
6. Finally the opcode `OP_CHECKMULTISIG` is added - the value 0xae

The address for the multisig is computed by:

1. SHA256 hash the input bytes - the input bytes are the bytes of the entire redeem script as described above
2. RIPEMD160 the result of step 1
3. Prepend the network byte to the hash
4. Perform SHA256 twice on the concatenated (network byte || RIPEMD160 hash) - the checksum is the first four bytes of the result.
5. Append the 4 byte checksum to the concatenated (network byte || RIPEMD160 hash), resulting in 25 bytes
6. Base58 encode the result
	
Use `~/Learning/bitcoin/address/cpp/bin/p2sh`

Storage in Chainstate DB: UTXO
------------------------------

The scriptPubKey that is stored in the chainstate database is the value of the hashed redeemScript:

    66445308b05d3eec5aab83dceb5cc87a759bd7d5

Because we know the script type, the scriptPubKey can be assembled by adding the appropriate opcodes:

OP_HASH160  Push next 0x14 bytes    data                                        OP_EQUAL    
a9          14                      66445308b05d3eec5aab83dceb5cc87a759bd7d5    87

### Compute address
Get address from UTXO:
* extract hash from DB
* Prepend network designator byte (0xc4 for regtest)
* Compute checksum and append
* Base58 encode

Network Byte    data                                        Checksum
c4              66445308b05d3eec5aab83dceb5cc87a759bd7d5b7  86084f

Expressed as Base58:
2N2Zxm7Kf3v4DKMSWW3zYz5Szi8tmGCvtKx

Process of Spending
-------------------
The conditions specified in an output `<scriptPubKey>` must be met to spend the funds contained in that output.

The locking script - `<scriptPubKey>` is a hash of the original custom locking script (`<redeemScriptHash>`) prepended with the `OP_HASH160` opcode and appended with the `OP_EQUAL` opcode.

The spending input must provide the original `<redeemScript>` along with the required number of signatures as a `<scriptSig>`.

Once it has been verified that the hash of the `<redeemScript>` in the `<scriptSig>` is equal to the hash contained in the `<scriptPubKey>`, the `<redeemScript>` provided in the `<scriptSig>` can be deserialized and processed. If the provided signatures match, the transaction is considered valid and the funds can be spent.

The mechanics of this involve the protocol concatenating `<scriptSig>` and `<scriptPubKey>` and running the entire script. If the final result evaluates to true, the transaction is valid. If at any point the script evaluation fails, the transaction is considered invalid and is discarded.

### Step 1: Add scriptSig to Stack
The `<scriptSig>` consists of the serialized `<redeemScript>` and the required signatures. This is pushed onto the stack:

| <redeemScript>	|
| <sig 2>		|
| <sig 1>		|

At this point, a copy is made of the stack - this measure is peculiar to P2SH scripts.

The original locking script (`<scriptPubKey>`) is now run:

`OP_HASH160 0x14 <redeemScriptHash> OP_EQUAL`

1. `OP_HASH160`: The top item (`<redeemScript>`) is popped off the stack, hashed with `RIPEMD160(SHA256())` (the same hashing process used to generate the `<redeemScriptHash>` provided by the locking script) and pushed back onto the stack.
2. The next 0x14 bytes (the `<redeemScriptHash>`) are pushed onto the stack
3. `OP_EQUAL` is executed - the top two elements are popped from the stack and compared. If they are equal, the integer 1 is pushed onto the stack. Otherwise, a zero is pushed.

At this point, if the stack contains the value 1, the `<redeemScript>` supplied by the unlocking `<scriptSig>` matches the original script contained within the locking script, and execution can continue. Otherwise, execution stops at this point.

### Step 2: Execution of redeemScript
Once it has been determined that the `<redeemScript>` matches the `<redeemScriptHash>`, the `<redeemScript>` provided by the `<scriptSig>` is deserialized and considered as a locking script to be run against the signatures. This is achieved by:

1. Operating on the copy of the stack that was made in step 1
2. Popping the `<redeemScript>` and deserializing it
3. Executing the `<redeemScript>` against the stack contents 

References
----------
* [Worked example, P2SH Multisig Transaction][1]
* [SO Answer][2], David Harding
* [P2SH on Learn Me A Bitcoin][3]

[1]: https://developer.bitcoin.org/examples/transactions.html#p2sh-multisig
[2]: https://bitcoin.stackexchange.com/a/52272/56514
[3]: https://learnmeabitcoin.com/technical/p2sh
[BIP 0016]: https://en.bitcoin.it/wiki/BIP_0016
[opcodes]: https://en.bitcoin.it/wiki/Script
