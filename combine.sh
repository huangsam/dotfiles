#!/bin/bash

# Establish bash aliases
ALIAS_LOC="${1:-./bash_aliases}"

# Wipe bash aliases clean
test -f "$ALIAS_LOC" && rm -f "$ALIAS_LOC"

# Combine alias files into one file
for fl in custom/*.zsh
do
    cat "$fl" >> "$ALIAS_LOC"
    echo >> "$ALIAS_LOC"
done
echo "Combine done! Copy $ALIAS_LOC anywhere you like :-)"
