#!/bin/bash

# Install hidden files to home directory
for fl in .*; do
    if [[ -f "$fl" ]]; then
        cp -i "$fl" "$HOME"
    fi
done
