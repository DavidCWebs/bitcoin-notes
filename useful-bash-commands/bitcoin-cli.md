Bitcoin CLI
===========

Get Pub Key From a Wallet Address
---------------------------------
```bash
# Leave out regtest option as required.
bitcoin-cli -regtest getaddressinfo 2N7wXom7Bo1EyfbwCryGAAMngZAmRzh3Z8J | jq -r .pubkey
```
