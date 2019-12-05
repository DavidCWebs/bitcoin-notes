# Bitcoin RPC Through SSH Tunnel
Running `bitcoind` allows Bitcoin Core to function as a HTTP JSON-RPC server. This means that Bitcoin Core can be controlled remotely.

JSON-RPC is a lightweight remote procedure call protocol. It allows a client to send a request in JSON format to a server. The server executes the required function and sends a serialized JSON object back to the client as a response.

Requirements
------------
You can either pass command-line options when starting `bitcoind` to enable the RPC interface and control other necessary settings, or you can add configuration data in a config file.

The config file approach is probably the most practical, and is the method covered in this article.

When started, `bitcoind` looks for a configuration file named `bitcoin.conf` in the bitcoin data directory (under Linux, this is `~/.bitcoin` by default.



Security of the JSON-RPC Server
-------------------------------
The JSON-RPC server requires basic HTTP authentication. For example, to send a request using `curl`:

```bash
curl --user alice:password123 \
--data-binary '{"jsonrpc":"1.0","id":"curltext","method":"listunspent","params":[]}' \
-H 'content-type:text/plain;' http://192.168.122.18:18443/ \
```
In this case, the username is `alice` and the (obviously inadequate) password is 'password123'.

The request is made to `http://192.168.122.18:18443` - a virtual machine that shares a network with the client machine making the request. In this case, the local network IP address of the client machine is `192.168.122.1`.

The request sends the method `listunspent`, which is processed by Bitcoin Core and the result returned as a JSON object.

### Authentication Data is Sent in Plaintext
Authentication data (user name and password) is sent as base 64 encoded plaintext. This example shows the HTTP header packets including the authorization data.

```data
0000:  504f 5354 202f 2048 5454 502f 312e 310d  POST / HTTP/1.1.
0010:  0a48 6f73 743a 2031 3932 2e31 3638 2e31  .Host: 192.168.1
0020:  3232 2e31 383a 3138 3434 330d 0a41 7574  22.18:18443..Aut
0030:  686f 7269 7a61 7469 6f6e 3a20 4261 7369  horization: Basi
0040:  6320 5957 7870 5932 5536 6347 467a 6333  c YWxpY2U6cGFzc3
0050:  6476 636d 5178 4d6a 4d3d 0d0a 5573 6572  dvcmQxMjM=..User
0060:  2d41 6765 6e74 3a20 6375 726c 2f37 2e34  -Agent: curl/7.4
0070:  372e 300d 0a41 6363 6570 743a 202a 2f2a  7.0..Accept: */*
0080:  0d0a 636f 6e74 656e 742d 7479 7065 3a74  ..content-type:t
0090:  6578 742f 706c 6169 6e3b 0d0a 436f 6e74  ext/plain;..Cont
00a0:  656e 742d 4c65 6e67 7468 3a20 3638 0d0a  ent-Length: 68..
00b0:  0d0a                                             ..

```
These packets were captured on the server hosting `bitcoind`, but they show how the data is transmitted over the network.

Note that in the above block `YWxpY2U6cGFzc3dvcmQxMjM=` base64 decodes to alice:password123. Obviously this is a security vulnerability - an eavesdropper can easily determine the user name and password.

In the case of basic HTTP authentication like this, the [connection is not secure][5] unless the exchange takes place over HTTPS(TLS).

The Bitcoin RPC API does not allow connection via SSL - [this functionality was dropped in 2015][3].

Restrict IP Address
-------------------
By default, `bitcoind` only allows RPC connections from localhost. You can ease this restriction by specifying an IP address in the `rpcallowip` field in the `~/.bitcoin/bitcoin.conf` configuration file.

Example `bitcoin.conf` allowing RPC access from the `192.168.122` subnet to the `regtest` network:

```bash
# /path/to/bitcoin.conf

# These settings apply to the regtest network only
[regtest]
rpcbind=0.0.0.0
rpcallowip=192.168.122.0/24 # Allow access fromm the 192.168.122 subnet
server=1 # Tells the bitcoin server to accept JSON-RPC commands
rpcuser=yourusername # Required for the JSON-RPC API
rpcpassword=yourpassword # Required
rest=1
```

SSH Tunnel
----------
If the computer hosting `bitcoind` is set up to communicate with a client machine by means of SSH, it is pretty straightforward to set up an SSH tunnel.

```bash
ssh -v -fNL 5555:192.168.122.18:18443 david@192.168.122.18
```
To send traffic through the ssh tunnel, you now use the `127.0.0.1:5555` host:port combination.

The same data shown above now results in the following packet - approximately, since the data is encrypted and there is no way to tell which bytes constitute the HTTP header:
```
20:43:28.404868 IP _gateway.44348 > donnager.ssh: Flags [P.], seq 100:376, ack 45, win 296, options [nop,nop,TS val 5081969 ecr 985853552], length 276
0000:  4510 0148 828f 4000 4006 41ac c0a8 7a01  E..H..@.@.A...z.
0010:  c0a8 7a12 ad3c 0016 af75 982e c79e cd40  ..z..<...u.....@
0020:  8018 0128 f86f 0000 0101 080a 004d 8b71  ...(.o.......M.q
0030:  3ac2 ee70 fb68 ceb4 aa74 80d3 aef4 f56b  :..p.h...t.....k
0040:  3794 e39d 9468 888a 7aa4 44d4 377e b1b3  7....h..z.D.7~..
0050:  9a87 f91a d4eb 9650 cb7a 2906 ae71 fca8  .......P.z)..q..
0060:  bd0b c8ec bbe6 01f0 42d1 6c11 e560 ddae  ........B.l..`..
0070:  817e 2fa0 df1c 6f70 ca19 b5d9 bb8e 0dca  .~/...op........
0080:  f5ff 0d3e ab69 a43b 1cc6 cfb7 e8f2 1bca  ...>.i.;........
0090:  cae2 14c4 85a7 f06f 33be f097 f904 713b  .......o3.....q;
00a0:  13cf a482 19d4 b3a2 6ede 887d 2749 b897  ........n..}'I..
00b0:  ed27 3deb d8a2 a60e 96ee 074f 085f d134  .'=........O._.4
```

References & Resources
----------------------
* [JSON-RPC specifications][1]
* [JSON Reference][2]
* [HTTP Authentication][5]
* [Bitcoin Wiki: configuration][6]

[1]: https://www.jsonrpc.org/specification_v1
[2]: https://www.json.org/json-en.html
[3]: https://github.com/bitcoin/bitcoin/blob/d6a92dd0ea42ec64f15b81843b4db62c7b186bdb/doc/release-notes.md#ssl-support-for-rpc-dropped
[4]: https://osric.com/chris/accidental-developer/2018/07/curl-basic-auth-base64-encoded-credentials/
[5]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication
[6]: https://en.bitcoin.it/wiki/Running_Bitcoin

https://www.ssh.com/ssh/tunneling/example

https://www.golinuxcloud.com/configure-ssh-port-forwarding-tunneling-linux/
