#!/bin/sh

for x in *.txt; do
	y=$(echo "$x" | tr '[A-Z ]' '[a-z-]');

	if [ "'$x'" != "'$y'" ]; then
		echo "RENAME: $x => $y"
		git mv "$x" "$y"
	fi
done
