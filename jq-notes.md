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


References
----------
* [https://stedolan.github.io/jq/tutorial/][1]
* [jq filters][2]

[1]: https://stedolan.github.io/jq/tutorial/
[2]: https://stedolan.github.io/jq/manual/#Basicfilters
