#!/bin/bash

for fl in custom/*.zsh
do
    cat "${fl}" >> bash_aliases
    echo >> bash_aliases
done
