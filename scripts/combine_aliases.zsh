#!/bin/zsh
set -eu -o pipefail
setopt nullglob

TARGET="${TARGET:-$HOME/.zsh_aliases}"
SCRIPT_DIR=${0:A:h}
DOTFILES_DIR=${SCRIPT_DIR:h}

# Combine aliases and functions into one file
{
    first=1
    for fl in "$DOTFILES_DIR/custom/"*.zsh; do
        (( first )) || print ""
        cat "$fl"
        first=0
    done
} > "$TARGET"

# Indicate completion
print -r -- "Aliases combined into $TARGET"
