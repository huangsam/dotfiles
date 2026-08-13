#!/bin/zsh
set -eu -o pipefail

# Source shared Homebrew utility
SCRIPT_DIR=${0:A:h}
source "$SCRIPT_DIR/utils/brew_setup.zsh"

print -r -- "Starting core system setup..."

# 1. Install Xcode Command Line Tools if missing
xcode-select -p &>/dev/null || xcode-select --install

# 2. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    print -r -- "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure Homebrew is in the PATH of the current script execution
ensure_brew_in_path || exit 1

# Add Homebrew to ~/.zprofile for future shell sessions
if ! grep -q "eval \"\$($brew_cmd shellenv)\"" "$HOME/.zprofile" 2>/dev/null; then
    print -r -- "eval \"\$($brew_cmd shellenv)\"" >> "$HOME/.zprofile"
    print -r -- "Added Homebrew to ~/.zprofile"
fi

# 3. Install Oh-My-Zsh (unattended) if not already installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print -r -- "Installing Oh-My-Zsh..."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" "" --unattended
fi

# 4. Install Homebrew bundle artifacts (Brewfile)
print -r -- "Installing Homebrew packages from Brewfile..."
brew bundle install --no-upgrade --file="$SCRIPT_DIR/Brewfile"

print -r -- "Core bootstrapping complete"
