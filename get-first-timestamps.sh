#!/bin/bash
for i in {000..099}; do
	# Get the timestamp bytes
	v=$(xxd -s 76 -l 4 -psr /media/secure-hdd-2/bitcoin-data/blocks/blk00$i.dat);
	
	# Convert to big-endian
	v="${v:6:2}${v:4:2}${v:2:2}${v:0:2}"
	
	echo "Hex timestamp, big-endian: $v"
	
	# Convert to a decimal integer: Unix epoch timestamp
	timestamp=$((16#$v))
	echo "Unix epoch timestamp: $timestamp"

	# Report human readable date
	date -d @$timestamp
	echo "---"
done > ~/Documents/learning-resources/bitcoin/bitcoin-notes/blk00000-00999-timestamps-hex.txt
