#!/bin/zsh
set -eu -o pipefail

# Install core developer software
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure Homebrew is in the PATH of the current script execution (ARM Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Homebrew to ~/.zprofile for future shell sessions (ARM Silicon)
if ! grep -q "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" "$HOME/.zprofile" 2>/dev/null; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    echo "Added Homebrew to ~/.zprofile"
fi

# Install oh-my-zsh (unattended to prevent it from launching a new shell and halting execution)
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" "" --unattended

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
