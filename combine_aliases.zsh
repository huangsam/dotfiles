#!/bin/zsh
set -eu -o pipefail
setopt nullglob

TARGET="$HOME/.zsh_aliases"
SCRIPT_DIR=${0:A:h}

# Combine aliases and functions into one file
{
    for fl in "$SCRIPT_DIR/custom/"*.zsh; do
        cat "$fl"
        print ""
    done
} > "$TARGET"

# Indicate completion
print -r -- "Aliases combined into $TARGET"
