#!/bin/bash
set -e -u -o pipefail

# Install core developer software
xcode-select --install

# Install Homebrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle install  # Brewfile

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
compaudit | xargs chmod g-w,o-w

# Indicate completion
emoji_stars='\xE2\x9c\xa8'
emoji_cake='\xF0\x9F\x8D\xB0'
echo -e "$0 complete! $emoji_stars $emoji_cake $emoji_stars"
