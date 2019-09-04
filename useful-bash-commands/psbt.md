Partially Signed Bitcoin Transaction
====================================

For this example, create a multi-sig address that requires 2 of 2 signatures.

```bash
# Get first address
bitcoin-cli -regtest getnewaddress
# returns:
2N7wXom7Bo1EyfbwCryGAAMngZAmRzh3Z8J

bitcoin-cli -regtest getaddressinfo 2N7wXom7Bo1EyfbwCryGAAMngZAmRzh3Z8J | jq -r .pubkey
# Pubkey of address 1:
0338d89429d2142f258be80cfe6ff5a579dba74d786fcc5efc8d15c4b29cb1b8fa

# Get second addresss:
bitcoin-cli -regtest getnewaddress
2NAXFLJH1qvExhSPhprTzp7BuXZwh92KwqE
bitcoin-cli -regtest getaddressinfo 2NAXFLJH1qvExhSPhprTzp7BuXZwh92KwqE | jq -r .pubkey
# Pubkey of address 2:
029264baf71f8c3103e6194d436198e0abbee4964c899ac78b30bdae26ddbf4915

# 
bitcoin-cli -regtest addmultisigaddress 2 '["0338d89429d2142f258be80cfe6ff5a579dba74d786fcc5efc8d15c4b29cb1b8fa", "029264baf71f8c3103e6194d436198e0abbee4964c899ac78b30bdae26ddbf4915"]'
{
  "address": "2Mv3MWrRp82i589P24Tv2d3neRRshq7178Y",
  "redeemScript": "52210338d89429d2142f258be80cfe6ff5a579dba74d786fcc5efc8d15c4b29cb1b8fa21029264baf71f8c3103e6194d436198e0abbee4964c899ac78b30bdae26ddbf491552ae"
}
