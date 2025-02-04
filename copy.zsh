#!/bin/zsh
set -eu

# Copy hidden files to home directory
for fl in .*; do
    if [[ -f "$fl" ]]; then
        cp -i "$fl" "$HOME/$fl" || :
    fi
done

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
