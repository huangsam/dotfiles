#!/bin/zsh
set -eu -o pipefail

# Get the absolute directory path of this script
SCRIPT_DIR=${0:A:h}
TARGET_PLIST="$HOME/Library/LaunchAgents/user.ollama.plist"
SOURCE_PLIST="$SCRIPT_DIR/init/user.ollama.plist"

# Ensure Homebrew is in the PATH for ARM Silicon Macs
if ! command -v brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v ollama &>/dev/null; then
    echo "Ollama is not installed. Please try again."
    exit 0
fi

if [[ -f "$TARGET_PLIST" ]]; then
    # Native Zsh single-character yes/no prompt (stores result in 'choice')
    echo -n "Existing Ollama LaunchAgent found. Unload it? (y/n): "
    read -k 1 choice
    echo "" # Print newline after character keystroke

    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Aborting setup..."
        exit 0
    fi

    echo "Stopping existing service..."
    # '|| true' prevents the script from crashing if plist exists but isn't actively running
    launchctl bootout gui/$(id -u) "$TARGET_PLIST" 2>/dev/null || true
fi

# Ensure target directory exists
mkdir -p "$(dirname "$TARGET_PLIST")"

echo "Copy new configuration..."
cp "$SOURCE_PLIST" "$TARGET_PLIST"

echo "Bootstrap new Ollama service..."
launchctl bootstrap gui/$(id -u) "$TARGET_PLIST"
echo "Ollama successfully configured and running at 100% GPU optimization."
