#!/bin/bash

# Establish commands
BREW=/usr/local/bin/brew
GIT=/usr/bin/git

# Upgrade brew plugins
$BREW upgrade && $BREW cleanup

# Upgrade git repositories
REPOS=(
    "$HOME/.oh-my-zsh"
    "$HOME/.vim_runtime"
    "$HOME/.dotfiles"
)

for repo in "${REPOS[@]}"
do
    if [[ -d "$repo" ]]
    then
        echo -n "$repo..."
        cd "$repo" && $GIT pull > /dev/null
        echo 'done.'
    fi
done
