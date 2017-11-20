#!/bin/bash

for i in custom/*.zsh
do
    cat $i >> bash_aliases
    echo >> bash_aliases
done
