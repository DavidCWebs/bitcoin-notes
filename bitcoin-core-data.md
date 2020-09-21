# Bitcoin Core Data
The data directory of an established Bitcoin Core node looks something like this:

```bash
tree ~/.bitcoin
.
├── banlist.dat
├── bitcoin.conf
├── bitcoind.pid
├── blocks
│   ├── blk00000.dat
│   ├── ... many more .dat files
│   ├── blk02216.dat
│   ├── index
│   │   ├── 000026.ldb
│   │   ├── ... many more .dat files
│   │   ├── 000257.ldb
│   │   ├── CURRENT
│   │   ├── LOCK
│   │   └── MANIFEST-000002
│   ├── rev00000.dat
│   ├── ... many more .dat files
│   └── rev02216.dat
├── chainstate
│   ├── 041953.ldb
│   ├── ... many more .dat files
│   ├── 070943.ldb
│   ├── CURRENT
│   ├── LOCK
│   └── MANIFEST-000002
│   
├── database
│   └── log.0000000001
├── db.log
├── debug.log
├── fee_estimates.dat
├── indexes
│   └── txindex
│       ├── 059647.ldb
│       ├── ... many more .dat files
│       ├── 088302.ldb
│       ├── CURRENT
│       ├── LOCK
│       └── MANIFEST-000002
├── mempool.dat
├── onion_private_key
├── peers.dat
└── wallet.dat
```
This example is a data directory that we created pre Bitcoin Core version 0.16.0 - since this version, `wallet.dat` and `database` are moved into a new subdirectory, `wallets`.

Block Storage
-------------


References
----------
* [bitcoindev.network: Understanding the data behind Bitcoin Core][1]
* [Useful SO Answer][2]
* [Bitcoin Wiki on Data Storage][3] __TODO__

[1]: https://bitcoindev.network/understanding-the-data/
[2]: https://bitcoin.stackexchange.com/a/29418/56514
[3]: https://en.bitcoin.it/wiki/Bitcoin_Core_0.11_(ch_2):_Data_Storage
