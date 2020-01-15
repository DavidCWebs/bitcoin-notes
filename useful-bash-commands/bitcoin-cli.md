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

References
----------
* [awk manpage][1]

[1]: https://linux.die.net/man/1/awk
