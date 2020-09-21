Bitcoin CLI
===========

Get Pub Key From a Wallet Address
---------------------------------
```bash
# Leave out regtest option as required.
bitcoin-cli -regtest getaddressinfo 2N7wXom7Bo1EyfbwCryGAAMngZAmRzh3Z8J | jq -r .pubkey
```

Build a Manifest of Public Addresses that have Unspent Outputs
--------------------------------------------------------------
Build a manifest file that consists of public addresses controlled by the wallet that have unspent outputs.

Each public address is added on a separate line, which makes it ideal to use as a data-source when looping through `bitcoin-cli` commands.

The `jq` programme greatly eases JSON parsing in BASH - on Ubuntu/Debian, install `jq`: `sudo apt-get install jq`.

If your system has `jq` installed:

```bash
# regtest
bitcoin-cli -regtest listunspent | jq -r '.[] .address' | sort -u > /tmp/manifest

# mainnet
bitcoin-cli listunspent | jq -r '.[] .address' | sort -u > /tmp/manifest
```

If you do not have access to `jq` on your system (you may be running an air-gapped machine) you can achieve the same result with basic GNU/Linux tools:

```bash
bitcoin-cli listunspent | grep address | awk '{print substr($2,2,length($2)-3)}' | sort -u > /tmp/manifest
```
This command:

* Uses `listunspent` to fetch JSON data for public addresses having unspent outputs.
* Passes the result into `grep` which restricts the output to lines containing the word "address".
* Uses `awk` to print a substring from the second column, which is the address.
* The `sort` utility is used with the `-u` option to remove duplicates from the output.
* Redirects stdout to a file `/tmp/manifest`

The `awk` `substring()` function in this case starts at the second character of `$2` and ends at the length of the string minus 3 (to remove the terminating quotation mark, comma & newline).

Get "Foreign" Transaction Data
------------------------------
Firstly the local block database needs to be reindexed:

* Open `bitcoin.conf` and set `txindex=1`
* Run `bitcoind -reindex`

Re-indexing does the following:

* Wipes the chainstate (the UTXO set)
* Wipes & rebuilds the block index - this is a database that holds the location of blocks on disk
* Rebuilds the chainstate, validating all blocks that are now in the index

Re-indexing (and in particular rebuilding the chainstate) is resource intensive and can take a long time.

### IMPORTANT: Pausing Re-Indexing
If you need to pause re-indexing, stop `bitcond` and restart without the `-reindex` option. If you pass in `-reindex` the process will start again from scratch. 

### Get Transaction Data
You can then use the `bitcoin-cli getrawtransaction <txid>` to fetch foreign transaction data. This command displays data as a string of bytes represented in hexadecimal. Append the command with `1` to get formatted JSON output - which can be made even more readable by piping it to `jq`. For example:

```bash
# Output data to /tmp/tx.json
bitcoin-cli getrawtransaction a0f1aaa2fb4582c89e0511df0374a5a2833bf95f7314f4a51b55b7b71e90ce0f 1 | jq > /tmp/tx.json
```

References
----------
* [awk manpage][1]

[1]: https://linux.die.net/man/1/awk
