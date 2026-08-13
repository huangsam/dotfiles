#!/bin/zsh

# Ensure Homebrew is in the PATH for both ARM Silicon and Intel Macs
# Usage: ensure_brew_in_path
ensure_brew_in_path() {
    if ! command -v brew &>/dev/null; then
        if [[ -x "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            print -u2 -r -- "Error: Homebrew executable not found"
            return 1
        fi
    fi
}
