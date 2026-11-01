#!/bin/zsh
set -eu -o pipefail

# Get the absolute directory path of this script
SCRIPT_DIR=${0:A:h}

# Source shared Homebrew utility
source "$SCRIPT_DIR/lib/brew_setup.zsh"
ensure_brew_in_path || exit 1

print -r -- "Setting up Docker CLI plugins and Colima..."

# 1. Symlink Docker CLI plugins so `docker compose` and `docker buildx` work
mkdir -p "$HOME/.docker/cli-plugins"
for plugin in docker-compose docker-buildx; do
    if command -v "$plugin" &>/dev/null; then
        ln -sfn "$(command -v "$plugin")" "$HOME/.docker/cli-plugins/$plugin"
        print -r -- "Linked $plugin into ~/.docker/cli-plugins"
    fi
done

# 2. Start Colima background service via Homebrew
if command -v colima &>/dev/null; then
    brew services start colima
fi

# 3. Ensure Docker context points to Colima
if command -v docker &>/dev/null; then
    docker context use colima 2>/dev/null || true
fi

print -r -- "Colima setup complete!"
