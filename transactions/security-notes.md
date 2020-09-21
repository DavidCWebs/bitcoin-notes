# Bitcoin Security Notes

Or: Ways You Can Lose Your Bitcoin

Wallet Address Swapper
----------------------
### Issue
When sending Bitcoin, you may use the clipboard to copy and paste the recipient address into the wallet software.

Malware detects likely Bitcoin addresses in the clipboard, and replaces these with an address controlled by the attacker.

The user does not notice the difference until after funds have been sent - by which time it is likely too late.

### Mitigation
Always check the recipient address before the final confirmation when sending funds.

Do not use computers that are likely to have malware installed when transacting.

Consider a completely clean OS install to manage funds - learn how to boot into a Tails instance from your regular computer, a measure which is likely to prevent malware attacks of this type. You may need to learn how to securely use your favourite wallet within Tails, or you could use the Electrum Bitcoin wallet that comes bundled with Tails.

