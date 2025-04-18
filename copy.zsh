#!/bin/zsh
set -eu

# Options: default, override
mode="${1:-default}"

# Copy hidden files to home directory
for fl in .*; do
    if [[ "$mode" == "override" && -f "$fl" ]]; then
        cp -v -f "$fl" "$HOME/$fl"
    elif [[ -f "$fl" ]]; then
        # Ignore non-zero exit status when a file is skipped
        # https://stackoverflow.com/a/38332629/2748860
        cp -v -i "$fl" "$HOME/$fl" || :
    fi
done

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "Script complete! $emoji_stars $emoji_cake $emoji_stars"
