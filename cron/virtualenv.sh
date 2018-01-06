#!/bin/bash
VIRTUALENV="/usr/local/bin/virtualenv"
VDIR="$HOME/.virtualenvs"
find "$VDIR" -type l -exec rm {} +
pushd "$VDIR"
venvs=$(find . -type d -depth 1 | xargs basename)
for venv in $venvs ; do
    $VIRTUALENV "$venv"
done
