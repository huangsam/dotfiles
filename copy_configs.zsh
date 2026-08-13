#!/bin/zsh
set -u

# Allowlist of configuration files to copy to home directory
configs=(
    .digrc
    .editorconfig
    .gitconfig
    .vimrc
)

for fl in "${configs[@]}"; do
    if [[ -n "${FORCE:-}" ]]; then
        cp -f "$fl" "$HOME/$fl"
    else
        cp -n "$fl" "$HOME/$fl"
    fi
done

# Indicate completion
echo "Dotfiles copied to $HOME!"
