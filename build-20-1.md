Install build dependencies, _except_ for BerkeleyDB:

```bash
sudo apt install libevent-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev
```


Build Berkely DB 4.8 - necessary if the compiled programme needs to interact with wallets created by the distributed binaries.

Use the provided installation script, run from project root:

```bash
./contrib/install_db4.sh `pwd`
```

When complete, run `./configure` in the following way:

```bash
export BDB_PREFIX='/home/david/bitcoin/db4'

# Generate the configure script
./autogen.sh

# Configure with the build DB
./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include"

# Build the programmes
make
```

This links/compiles `bitcoind` against the build database binaries.
