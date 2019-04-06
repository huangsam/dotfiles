#!/bin/bash

# Establish commands
BREW=/usr/local/bin/brew
GIT=/usr/bin/git

# Upgrade brew plugins
$BREW upgrade && $BREW cleanup

# Upgrade git plugins
cd "$HOME/.oh-my-zsh" && $GIT pull
cd "$HOME/.vim_runtime" && $GIT pull
cd "$HOME/.dotfiles" && $GIT pull
