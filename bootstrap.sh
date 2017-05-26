#!/bin/bash

git pull origin master

function doIt() {
    rsync --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "README.md" \
        -avh --no-perms ./zsh-plugins/* ~/.oh-my-zsh/custom;
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    doIt;
else
    read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
