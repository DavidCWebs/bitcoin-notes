# Bitcoin Core Architecture


User Interfaces: P2P
--------------------
Bitcoin forms a TCP overlay network of nodes passing messages to one another.

Messages are defined in `src/protocol.h`

Each node has a set of outbound and inbound peers they exchange data with:

* Manual, e.g. config in `bitcoin.conf` or when running `bitcoin-cli`? `-addnode=<addr>`
* Manual `-maxconnections=<n>`
* See `src/net.h` for constants: `MAX_OUTBOUND_CONNECTIONS`, `DEFAULT_MAX_PEER_CONNECTIONS`

Peers can be manually added using `-addnode` or are discovered from DNS seeds - these are DNS servers that randomly resolve to known Bitcoin nodes.

###DoS Protection
Implemented to prevent malicious peers from disrupting the network.

Configured by `-banscore=<n>`which sets sensitivity, defaults to 100.

###SPV Nodes
Simple Payment Verification nodes query full nodes for Merkle proofs - retrieve txout proofs.

User Interfaces: RPC/HTTP
-------------------------
Remote Procedure Call allows users to programmatically interact with Bitcoin Core over HTTP.

* Block explorers can query blockchain & mempool data.
* External wallets can construct & sign transactions.
* Miners & pool operators can use `getblocktemplate` for block construction.
* `bitcoin-cli` accesses the RPC interface on the command line.

User Interfaces: Qt
-------------------
GUI that provides:

* Wallet functionality.
* Basic network statistics.
* RPC console.

User Interface: ZMQ
-------------------
Publishes notifications over a socket on receipt of:

* new block (raw): `rawblock`
* new block (hash): `hashblock`
* new transaction (raw): `rawtx`
* new transaction (hash): `hashtx`

Allows external software to perform some action on these events.

Concurrency Model
-----------------
* Bitcoin Core performs a number of tasks simultaneously.
* Has a model of concurrent execution to support this based on `{std, boost}::threads` shared state, and a number of locks.
* Threads started (directly or indirectly) in `init.cpp`
* P2P networking is enabled by a single `select` loop: `CConman::ThreadSocketHandler`

All changes to chainstate are effectively single-threaded - see `cs_main`.

* Grep for `CCriticalSection` to find (most) lock definitions.
* Grep for `TraceThread` to find threads and where they are spawned.

Regions
-------
"Regions"(JOB) consist of state and procedures necessary for Bitcoin's operation.

Each region is a subsystem within Bitcoin Core that handles a certain domain of tasks at a certain layer of abstraction.

Gives a high-level sense of which parts of the system perform which tasks.

* `net`: Socket networking, tracking of peers.
* `net_processing`: Routes P2P messages into validation calls and response P2P messages.
* `validation`: Defines how we update our validated state (chain, mempool).
* `txmempool`: Mempool data structures.
* `coins` & `txdb`: Interface for in-memory view of the UTXO set.
* `script/`: Script execution & caching.
* `consensus/`: Consensus parameters, Merkle roots, some tx validation.
* `policy/`: Fee estimation, replace-by-fee.
* `indexes/`: Peripheral index building (e.g. `txindex`).
* `wallet/`: Wallet db, coin selection.

Regions: `net.{h,cpp}`
----------------------
The bottom of the Bitcoin stack: handles network communication with the P2P network.

Contains addresses and statistics (`CNodeStats`) for peers (`CNodes`) that the running node is aware of. Determine good/bad peers.

`CConman` is the main class in this region - manages socket connections (and network interaction generally) for each peer. Forwards messages to the `net_processing` region via `CConman::ThreadMessageHandler`.

The globally accessible `CConman` instance is called `g_conman`.

Regions: `net_processing.{h, cpp}`
----------------------------------
Adapts the network layer to the chainstate validation layer. Translates network messages into calls for local state changes.

"Validation" specific (i.e. info relating to chainstate) data is maintained per-node using `CNodeState` instances.

Much of this region is `ProcessMessage()`: a giant conditional for rendering particular network message types to calls deeper in Bitcoin. E.g.:

* `NetMsgType::BLOCK`
* `NetMsgType::HEADERS`

Peers area also penalized here based on the network messages they send. See `Misbehaving`.








