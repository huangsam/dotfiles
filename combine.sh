#!/bin/bash
set -eo pipefail

# Combine alias files into one file
for fl in custom/*.sh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$HOME/.bash_aliases"

# Print status
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'
echo -e "$0 done! $emoji_stars $emoji_cake $emoji_stars"
