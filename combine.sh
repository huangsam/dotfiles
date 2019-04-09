#!/bin/bash
set -eo pipefail

# Establish bash aliases
export ALIAS_PATH="${ALIAS_PATH:-./bash_aliases}"

# Wipe existing bash aliases
[[ -f "$ALIAS_PATH" ]] && rm -f "$ALIAS_PATH"

# Combine alias files into one file
for fl in custom/*.zsh
do
    cat "$fl" >> "$ALIAS_PATH"
    echo >> "$ALIAS_PATH"
done
echo "Combine done! Copy $ALIAS_PATH anywhere you like. ✨"
