#!/bin/zsh
set -eu -o pipefail

SCRIPT_DIR=${0:A:h}

# Allowlist of configuration files to copy to home directory
configs=(
    .digrc
    .editorconfig
    .gitconfig
    .vimrc
)

for fl in "${configs[@]}"; do
    if [[ -n "${FORCE:-}" ]]; then
        cp -f "$SCRIPT_DIR/$fl" "$HOME/$fl"
    elif [[ ! -f "$HOME/$fl" ]]; then
        cp "$SCRIPT_DIR/$fl" "$HOME/$fl"
    fi
done

# Indicate completion
print -r -- "Dotfiles copied to $HOME"
