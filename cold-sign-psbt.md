Cold Signing Workflow: PSBT
===========================

Generate a Cold Wallet
----------------------
Run Bitcoin Core in a Tails session in an air-gapped computer.

Use `importmulti` command to import addresses, redeemScripts and witness scripts (if any).

Hot Wallet
----------
Generate a hot wallet **with no keys**. This means you won't have change addresses in the online wallet - only available addresses will be the imported ones.

```bash
createwallet "hot-wallet-name" true
```

References
----------
* [][1]


[1]:

