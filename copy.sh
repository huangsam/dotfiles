#!/bin/bash
set -u -o pipefail

# Install hidden files to home directory
for fl in .*; do
    if [[ -f "$fl" ]]; then
        cp -i "$fl" "$HOME/$fl"
    fi
done

# Indicate completion
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
