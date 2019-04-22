#!/bin/bash

# Establish commands
BREW=/usr/local/bin/brew
GIT=/usr/bin/git

# Upgrade brew software
echo -n 'brew update...'
$BREW update > /dev/null
echo 'done.'

$BREW upgrade

echo -n 'brew cleanup...'
$BREW cleanup > /dev/null
echo 'done.'

# Upgrade git repositories
REPOS=(
    "$HOME/.oh-my-zsh"
    "$HOME/.vim_runtime"
    "$HOME/.dotfiles"
)

for repo in "${REPOS[@]}"; do
    if [[ -d $repo ]]; then
        echo -n "git $repo..."
        cd "$repo" && $GIT pull > /dev/null
        echo 'done.'
    fi
done
