#!/bin/zsh
set -eu -o pipefail

# Combine aliases and functions into one file
# https://unix.stackexchange.com/a/541415/140057
for fl in custom/*.zsh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$HOME/.zsh_aliases"

# Indicate completion
echo "$0 complete! ✨ 🍰 ✨"
