# jq Notes

Make a Manifest File for Addresses that Have Unspent Balances
-------------------------------------------------------------
```bash
bitcoin-cli -regtest listunspent | jq -r '.[] .address' > /tmp/manifest
```

List Connected Nodes
--------------------
List connected nodes, with output restricted to the fields `addr`, `addrlocal`, `id` and `subver`.

```bash
bitcoin-cli getpeerinfo | jq '.[] | {addr: .addr, addrlocal: .addrlocal, id: .id, subver: .subver}'
# Output:
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:57322",
  "id": 0,
  "subver": "/Satoshi:0.14.0/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:42008",
  "id": 1,
  "subver": "/Satoshi:0.17.1/"
}
...
```
To see all available fields, run `bitcoin-cli getpeerinfo --help`. Useful fields include:

* `"inbound"`: true|false (boolean) Inbound (true) or Outbound (false)
* `"servicesnames"`: A JSON array of services offered in human-readable form

Filter Results
--------------
The `jq` `select()` function filters for input truth. So `jq '.[] | select(.inbound | select(true)))'` first selects (filters all other records) which have the `.inbound` key, feeding this into the next select which filters for records that have the value `true` for the key `inbound`.

```bash
bitcoin-cli getpeerinfo | jq '.[] | {addr: .addr, addrlocal: .addrlocal, id: .id, subver: .subver, inbound: .inbound} | select(.inbound | select(true))'
```
Output all records for a given txid:

```bash
bitcoin-cli -regtest listunspent | jq '.[] | select(.txid == "acb1e896dd379786ab05b0ef1125d4a06f3cf5cb62f564f72b86e3ef6b0371ff")'

# Outputs the record with the specified txid:
{
  "txid": "acb1e896dd379786ab05b0ef1125d4a06f3cf5cb62f564f72b86e3ef6b0371ff",
  "vout": 0,
  "address": "2N3JHAtRLTy4dG7Zt1mEfGd3mWSsYBvckQC",
  "redeemScript": "0014b453772eccddf7ab719c6fce5ef8dc5a3ccbf8e8",
  "scriptPubKey": "a9146e4529a080512843f3fbef5c3945376ed8e51b8087",
  "amount": 7.9999664,
  "confirmations": 111,
  "spendable": true,
  "solvable": true,
  "desc": "sh(wpkh([90ba3d87/0'/1'/5']029f237151af6c79dad738e78bcd633469671a80640311a39f5b706a6a3048820b))#2ntw8u5u",
  "safe": true
}
```


References
----------
* [https://stedolan.github.io/jq/tutorial/][1]
* [jq filters][2]

[1]: https://stedolan.github.io/jq/tutorial/
[2]: https://stedolan.github.io/jq/manual/#Basicfilters
