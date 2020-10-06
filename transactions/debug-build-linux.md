# Debug Build Linux

The `configure` command creates the necessary Makefiles - for debugging purposes, disable optimizations using the `-O0` flag.

For self-build dependencies (which you may be using if running the wallet due to the incompatibility of the Berkeley DB version in the Ubuntu package repos):

```bash
./configure --prefix=$PWD/depends/x86_64-pc-linux-gnu CXXFLAGS="-O0 -g" CFLAGS="-O0 -g"
```
