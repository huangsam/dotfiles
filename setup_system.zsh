#!/bin/zsh
set -eu -o pipefail

# Install core developer software
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install oh-my-zsh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"

# Install Homebrew artifacts
brew bundle install

# Generate .zsh_aliases file at the home directory
zsh combine_aliases.zsh

# Copy all dotfiles to the home directory
zsh copy_configs.zsh

# Indicate completion
emoji_stars='\U00002728'
emoji_cake='\U0001F370'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
