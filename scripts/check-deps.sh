#!/usr/bin/env bash

set -eu

# File containing the list of dependencies
DEPS_FILE="$1"

if [[ ! -f "$DEPS_FILE" ]]; then
	echo "Dependencies file not found: $DEPS_FILE"
	exit 1
fi

# Read dependencies from file
DEPS=$(cat "$DEPS_FILE")

echo "Dependencies for brave-browser:"
echo "$DEPS"

# Check installed packages and compare
echo ""
echo "Need to install these packages:"
for dep in $DEPS; do
	if ! dpkg-query -W -f='${Status}' $dep 2>/dev/null | grep -q "install ok installed"; then
		echo $dep
	fi
done
