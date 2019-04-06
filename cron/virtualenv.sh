#!/bin/bash
VDIR="$HOME/.local/share/virtualenvs"
find "$VDIR" -type l -exec rm {} +
pushd "$VDIR"
venvs="$(ls)"
for venv in $venvs ; do
    echo $venv
    python -m venv "$venv"
    echo "done."
done
popd
