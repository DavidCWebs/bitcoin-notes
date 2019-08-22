jq Notes
========

```bash
bitcoin-cli getpeerinfo | jq '.[] | {addr: .addr, addrlocal: .addrlocal, id: .id, subver: .subver}'
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
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:57614",
  "id": 4,
  "subver": "/Satoshi:0.17.0/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:52570",
  "id": 5,
  "subver": "/Satoshi:0.18.0/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:49308",
  "id": 6,
  "subver": "/Satoshi:0.17.99/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:56362",
  "id": 7,
  "subver": "/Satoshi:0.18.99/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:48434",
  "id": 8,
  "subver": "/Satoshi:0.16.3/"
}
{
  "addr": "x.x.x.x:8333",
  "addrlocal": "y.y.y.y:41162",
  "id": 9,
  "subver": "/Satoshi:0.15.0/"
}

```
References
----------
* [https://stedolan.github.io/jq/tutorial/][1]

[1]: https://stedolan.github.io/jq/tutorial/
