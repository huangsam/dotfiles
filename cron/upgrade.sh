#!/bin/bash
BREW=/usr/local/bin/brew
GIT=/usr/bin/git
$BREW upgrade && $BREW cleanup
cd "$HOME/.oh-my-zsh" && $GIT pull
cd "$HOME/.vim_runtime" && $GIT pull
