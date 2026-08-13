#!/bin/zsh
set -eu -o pipefail

TARGET="$HOME/.zsh_aliases"

# Combine aliases and functions into one file
# https://unix.stackexchange.com/a/541415/140057
for fl in custom/*.zsh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$TARGET"

# Indicate completion
echo "Aliases combined into $TARGET!"
