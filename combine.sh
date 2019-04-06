#!/bin/bash

# Establish bash aliases
ALIAS_LOC="${1:-./bash_aliases}"

# Combine alias files into one file
for fl in custom/*.zsh
do
    cat "$fl" >> "$ALIAS_LOC"
    echo >> "$ALIAS_LOC"
done
echo "Combine done! Copy $ALIAS_LOC anywhere you like :-)"
