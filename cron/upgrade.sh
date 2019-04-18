#!/bin/bash

# Establish commands
BREW=/usr/local/bin/brew
GIT=/usr/bin/git

# Upgrade brew plugins
echo -n 'brew updates...'
$BREW upgrade && $BREW cleanup
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
