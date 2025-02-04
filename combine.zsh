#!/bin/zsh
set -eu -o pipefail

# Combine aliases and functions into one file
# https://unix.stackexchange.com/a/541415/140057
for fl in custom/*.zsh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$HOME/.zsh_aliases"

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
