#!/usr/bin/env bash

set -eu

# Package name
PACKAGE=brave-browser

# Get list of dependencies
DEPS=$(apt-cache depends $PACKAGE | grep -E 'Depends|Recommends|Suggests' | awk '{print $2}')

echo "Dependencies for $PACKAGE:"
echo "$DEPS"

# Check installed packages and compare
echo ""
echo "Checking installed packages:"
for dep in $DEPS; do
	if dpkg-query -W -f='${Status}' $dep 2>/dev/null | grep -q "install ok installed"; then
		echo "$dep is installed"
	else
		echo "------------------------------------------$dep is NOT installed"
	fi
done
