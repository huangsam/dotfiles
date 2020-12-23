#!/bin/bash
set -eo pipefail

# Establish bash aliases
alias_path="${1:-$HOME/.bash_aliases}"

# Wipe existing bash aliases
[[ -f "$alias_path" ]] && rm -f "$alias_path"

# Combine alias files into one file
for fl in custom/*.sh; do
    cat "$fl"
    echo
done | perl -pe 'chomp if eof' > "$alias_path"

# Establish emojis
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'

# Print status and output location
echo -e "Combine done! $emoji_stars $emoji_cake $emoji_stars"

echo "Final output location: $alias_path"
