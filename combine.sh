#!/bin/bash
set -eo pipefail

# Establish bash aliases
ALIAS_PATH="${1:-./bash_aliases}"

# Wipe existing bash aliases
test -f "$ALIAS_PATH" && rm -f "$ALIAS_PATH"

# Combine alias files into one file
for fl in custom/*.zsh
do
    cat "$fl" >> "$ALIAS_PATH"
    echo >> "$ALIAS_PATH"
done
echo "Combine done! Copy $ALIAS_PATH anywhere you like. ✨"
