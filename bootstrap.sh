#!/bin/bash
set -eo pipefail

# Establish target path for diffs
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Transfer diffs over to target path
function doIt() {
    rsync -avh --exclude '.DS_Store' --no-perms \
        ./custom/* "$ZSH_CUSTOM"
}

# Prompt user for diff transfers
if [ "$1" == '--force' ] || [ "$1" == '-f' ]; then
    doIt
else
    read -r -p 'This may overwrite files. Are you sure? (y/n) ' -n 1
    echo ''
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
