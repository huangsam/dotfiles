#!/bin/zsh
set -eu

# Copy hidden files to home directory
for fl in .*; do
    # Skip directories and internal repo files
    if [[ "$fl" == ".git" || "$fl" == ".gitignore" || "$fl" == ".DS_Store" ]]; then
        continue
    fi

    if [[ -f "$fl" ]]; then
        # Ignore non-zero exit status when a file is skipped
        cp -i "$fl" "$HOME/$fl" || :
    fi
done

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
