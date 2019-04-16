#!/bin/bash
set -eo pipefail

# Establish bash aliases
export ALIAS_PATH="${ALIAS_PATH:-./bash_aliases}"

# Wipe existing bash aliases
[[ -f "$ALIAS_PATH" ]] && rm -f "$ALIAS_PATH"

# Combine alias files into one file
for fl in custom/*.zsh; do
    cat "$fl" >> "$ALIAS_PATH"
    echo >> "$ALIAS_PATH"
done

# Establish emojis
EMOJI_STARS="\xE2\x9c\xa8"
EMOJI_CAKE="\xF0\x9F\x8D\xB0"

# Print status and output location
echo -e "Combine done! $EMOJI_STARS $EMOJI_CAKE $EMOJI_STARS"
echo "Final output location: $ALIAS_PATH"
