#!/bin/bash
set -eo pipefail

# Establish command
GIT=/usr/bin/git

# Upgrade git repositories
TARGET="$HOME/Playground"

find "$TARGET" -type d -name ".git" | while read -r dir; do
    cd "$dir/../" && pwd && $GIT pull
done
