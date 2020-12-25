#!/bin/bash
set -eo pipefail

# Install hidden files to home directory
for fl in .*; do
    if [[ -f "$fl" ]]; then
        cp "$fl" "$HOME"
    fi
done

# Establish bash aliases
alias_path="$HOME/.bash_aliases"

# Combine alias files into one file
for fl in custom/*.sh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$alias_path"

# Establish emojis
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'

# Print status and output location
echo -e "Installation done! $emoji_stars $emoji_cake $emoji_stars"
