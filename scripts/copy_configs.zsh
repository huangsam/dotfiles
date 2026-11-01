#!/bin/zsh
set -eu -o pipefail

SCRIPT_DIR=${0:A:h}
DOTFILES_DIR=${SCRIPT_DIR:h}

# Allowlist of configuration files to copy to home directory
configs=(
    .digrc
    .editorconfig
    .gitconfig
    .vimrc
)

TARGET_DIR="${TARGET_DIR:-$HOME}"

for fl in "${configs[@]}"; do
    if [[ -n "${FORCE:-}" ]]; then
        cp -f "$DOTFILES_DIR/$fl" "$TARGET_DIR/$fl"
    elif [[ ! -f "$TARGET_DIR/$fl" ]]; then
        cp "$DOTFILES_DIR/$fl" "$TARGET_DIR/$fl"
    fi
done

# Indicate completion
print -r -- "Dotfiles copied to $TARGET_DIR"
