# Multisig with Bech32 in Bitcoin Core

Create Regtest Addresses
------------------------
For convenience, make a Bash array of new addresses:

```bash
for i in $(seq 0 2); do adds[$i]=$(bitcoin-cli -regtest getnewaddress); done
```

The Bash array `adds` now contains 3 new Bech32 bitcoin addresses:

```bash
# List addresses
for el in "${adds[@]}"; do echo $el; done

# Output:
bcrt1qrysdnwhhdtus6xr5pvkgkl7v783vn0avl3ghf2
bcrt1qzv7uezurelrf40z28depl5f9ren6vd0hqtnyqk
bcrt1q4ns8g5cgdlg8neftxy6eetfc3n73628vm6ze2c

# Make array of public keys
i=0
for el in "${adds[@]}"; do
	keys[i]=$(bitcoin-cli -regtest getaddressinfo ${el} | jq -r .pubkey)
	i=$((i+1))
done

# The $keys array now contains the public keys for the relevant addresses:
for el in "${keys[@]}"; do echo $el; done

# Output:
02c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c
02b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814
0234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f

```
If you're building the script from disparate sources, combine the public keys into an array like this:

```bash
# Get each public key from an address if necessary (requires jq utility):
address=bcrt1qrysdnwhhdtus6xr5pvkgkl7v783vn0avl3ghf2
bitcoin-cli -regtest getaddressinfo ${address} | jq -r .pubkey

# Set the pubkeys array:
pubkeys[0]=02c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c # first
pubkeys[1]=02b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814 # second
pubkeys[2]=0234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f # third
```

Create a Multisig 
-----------------
```bash
bitcoin-cli -regtest createmultisig 2 $(jq -nc '$ARGS.positional' --args "${keys[@]}")

# Output
{
  "address": "2N2Zxm7Kf3v4DKMSWW3zYz5Szi8tmGCvtKx",
  "redeemScript": "522102c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c2102b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814210234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f53ae",
  "descriptor": "sh(multi(2,02c3eb5147ead06273e48b71fb2ce3e0f1484b3222c75b2039beb720c480ecb00c,02b6d8bd0cd403f488df6dccc5281c61029052a31d6ce57a0d6dcb64890a4ea814,0234965dbaff057b7a1fd08b8e40b3117c23abaa05345ab3cedf129c0c50b17e5f))#q6zdklmm"
}
```


