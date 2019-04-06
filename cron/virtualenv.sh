#!/bin/bash

# Establish workspace of venv directories
VENV_PATH="${VENV_PATH:-$HOME/.local/share/virtualenvs}"

# Run sync on each venv in workspace
find "$VENV_PATH" -type l -exec rm {} +
pushd "$VENV_PATH"
venvs="$(ls)"
for venv in $venvs ; do
    echo $venv
    python -m venv "$venv"
    echo "done."
done
popd
