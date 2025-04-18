#!/bin/zsh
set -eu -o pipefail

# Options: default, override
mode="${1:-default}"

# Generate combined aliases if in default mode (file doesn't exist)
# or override mode (file exists)
if [ "${mode}" = "default" ] && [ ! -f "$HOME/.zsh_aliases" ] || [ "${mode}" = "override" ] && [ -f "$HOME/.zsh_aliases" ]; then
    echo "Generate combined aliases"
    # Combine aliases and functions into one file
    # https://unix.stackexchange.com/a/541415/140057
    cat custom/*.zsh | perl -pe 'chomp if eof' > "$HOME/.zsh_aliases"
else
    echo "Skip combined aliases"
fi

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "Script complete! $emoji_stars $emoji_cake $emoji_stars"
