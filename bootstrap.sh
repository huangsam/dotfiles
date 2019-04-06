#!/bin/bash

# Transfer diffs from repo over to oh-my-zsh
function doIt() {
    rsync --exclude '.DS_Store' \
        --exclude '.osx' \
        --exclude 'README.md' \
        -avh --no-perms ./custom/* ~/.oh-my-zsh/custom
}

# Prompt user for bootstrap process
if [ "$1" == '--force' ] || [ "$1" == '-f' ]; then
    doIt
else
    read -r -p 'This may overwrite files. Are you sure? (y/n) ' -n 1
    echo ''
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt
