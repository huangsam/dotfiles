#!/bin/zsh
set -eu -o pipefail

# Install core developer software (if not already installed)
xcode-select -p &>/dev/null || xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure Homebrew is in the PATH of the current script execution
local brew_cmd=""
if [[ -x "/opt/homebrew/bin/brew" ]]; then
    brew_cmd="/opt/homebrew/bin/brew"
elif [[ -x "/usr/local/bin/brew" ]]; then
    brew_cmd="/usr/local/bin/brew"
else
    echo "Error: Homebrew executable not found." >&2
    exit 1
fi
eval "$($brew_cmd shellenv)"

# Add Homebrew to ~/.zprofile for future shell sessions
if ! grep -q "eval \"\$($brew_cmd shellenv)\"" "$HOME/.zprofile" 2>/dev/null; then
    echo "eval \"\$($brew_cmd shellenv)\"" >> "$HOME/.zprofile"
    echo "Added Homebrew to ~/.zprofile"
fi

# Install oh-my-zsh (unattended if not already installed)
[[ -d "$HOME/.oh-my-zsh" ]] || /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" "" --unattended

# Ensure ~/.zsh_aliases is sourced in ~/.zshrc
if ! grep -q "source ~/.zsh_aliases" "$HOME/.zshrc" 2>/dev/null; then
    echo -e "\n# Load custom aliases\n[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases" >> "$HOME/.zshrc"
    echo "Added ~/.zsh_aliases sourcing to ~/.zshrc"
fi

# Install Homebrew artifacts
brew bundle install

# Generate .zsh_aliases file at the home directory
zsh combine_aliases.zsh

# Copy all dotfiles to the home directory
zsh copy_configs.zsh

# Indicate completion
echo "$0 complete! ✨ 🍰 ✨"
