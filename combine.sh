#!/bin/bash
set -e -u -o pipefail

# Combine alias files into one file
for fl in custom/*.sh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$HOME/.bash_aliases"

# Indicate completion
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
