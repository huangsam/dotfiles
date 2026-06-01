#!/bin/zsh
set -eu -o pipefail

# Get the absolute directory path of this script
SCRIPT_DIR=${0:A:h}
TARGET_PLIST="$HOME/Library/LaunchAgents/user.ollama.plist"
SOURCE_TEMPLATE="$SCRIPT_DIR/init/user.ollama.plist.template"

# Ensure Homebrew is in the PATH for both ARM Silicon and Intel Macs
if ! command -v brew &>/dev/null; then
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if ! command -v ollama &>/dev/null; then
    echo "Ollama is not installed. Please try again."
    exit 0
fi

OLLAMA_PATH=$(command -v ollama)

# Define profile configuration parameters
typeset -A max_models parallel keep_alive context kv_cache

max_models[high]="2"
parallel[high]="2"
keep_alive[high]="2h"
context[high]="131072"
kv_cache[high]="q8_0"

max_models[medium]="1"
parallel[medium]="1"
keep_alive[medium]="1h"
context[medium]="65536"
kv_cache[medium]="q8_0"

max_models[low]="1"
parallel[low]="1"
keep_alive[low]="30m"
context[low]="8192"
kv_cache[low]="f16"

# Auto-detects the hardware profile and returns 'high', 'medium', or 'low'
detect_profile() {
    local cpu_brand mem_bytes mem_gb profile
    cpu_brand=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "")
    mem_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
    mem_gb=$(( mem_bytes / 1024 / 1024 / 1024 ))

    echo "System Specs Detected:" >&2
    echo "  CPU: ${cpu_brand:-Unknown}" >&2
    echo "  RAM: ${mem_gb} GB" >&2

    if [[ "$cpu_brand" == *Intel* ]]; then
        profile="low"
    elif [[ "$cpu_brand" == *Apple* ]]; then
        if (( mem_gb > 64 )); then
            profile="high"
        elif (( mem_gb >= 16 )); then
            profile="medium"
        else
            profile="low"
        fi
    else
        if (( mem_gb > 64 )); then
            profile="high"
        elif (( mem_gb >= 16 )); then
            profile="medium"
        else
            profile="low"
        fi
    fi
    echo "$profile"
}

PROFILE=""
FORCE="n"

# Command line arguments parsing
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--profile)
            if [[ -z "${2:-}" ]]; then
                echo "Error: --profile requires an argument (high, medium, low)." >&2
                exit 1
            fi
            PROFILE="$2"
            shift 2
            ;;
        --high)
            PROFILE="high"
            shift
            ;;
        --medium)
            PROFILE="medium"
            shift
            ;;
        --low)
            PROFILE="low"
            shift
            ;;
        -f|--force)
            FORCE="y"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -p, --profile <name>   Set profile explicitly (high, medium, low)"
            echo "  --high                 Alias for '--profile high'"
            echo "  --medium               Alias for '--profile medium'"
            echo "  --low                  Alias for '--profile low'"
            echo "  -f, --force            Force run (skip interactive prompts)"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Validate and determine profile
if [[ -n "$PROFILE" ]]; then
    if [[ "$PROFILE" != "high" && "$PROFILE" != "medium" && "$PROFILE" != "low" ]]; then
        echo "Error: Invalid profile '$PROFILE'. Valid options are: high, medium, low." >&2
        exit 1
    fi
    echo "Profile selected manually: $PROFILE"
else
    echo "Detecting hardware specifications..."
    PROFILE=$(detect_profile)
    echo "Auto-detected recommended profile: $PROFILE"
fi

# Display the configuration values
echo "Applying values for profile '$PROFILE':"
echo "  OLLAMA_MAX_LOADED_MODELS: ${max_models[$PROFILE]}"
echo "  OLLAMA_NUM_PARALLEL:      ${parallel[$PROFILE]}"
echo "  OLLAMA_KEEP_ALIVE:       ${keep_alive[$PROFILE]}"
echo "  OLLAMA_CONTEXT_LENGTH:    ${context[$PROFILE]}"
echo "  OLLAMA_KV_CACHE_TYPE:     ${kv_cache[$PROFILE]}"

if [[ -f "$TARGET_PLIST" ]]; then
    local proceed="n"
    if [[ "$FORCE" == "y" || ! -t 0 ]]; then
        proceed="y"
    else
        # Native Zsh single-character yes/no prompt (stores result in 'choice')
        echo -n "Existing Ollama LaunchAgent found. Unload and update it? (y/n): "
        read -k 1 choice
        echo "" # Print newline after character keystroke
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            proceed="y"
        fi
    fi

    if [[ "$proceed" != "y" ]]; then
        echo "Aborting setup..."
        exit 0
    fi

    echo "Stopping existing service..."
    # '|| true' prevents the script from crashing if plist exists but isn't actively running
    launchctl bootout gui/$(id -u) "$TARGET_PLIST" 2>/dev/null || true
fi

# Ensure template file exists
if [[ ! -f "$SOURCE_TEMPLATE" ]]; then
    echo "Error: Template file not found at $SOURCE_TEMPLATE" >&2
    exit 1
fi

# Ensure target directory exists
mkdir -p "$(dirname "$TARGET_PLIST")"

# Perform template variable substitution
local plist_content
plist_content=$(<"$SOURCE_TEMPLATE")
plist_content="${plist_content//\{\{OLLAMA_PATH\}\}/$OLLAMA_PATH}"
plist_content="${plist_content//\{\{OLLAMA_MAX_LOADED_MODELS\}\}/${max_models[$PROFILE]}}"
plist_content="${plist_content//\{\{OLLAMA_NUM_PARALLEL\}\}/${parallel[$PROFILE]}}"
plist_content="${plist_content//\{\{OLLAMA_KEEP_ALIVE\}\}/${keep_alive[$PROFILE]}}"
plist_content="${plist_content//\{\{OLLAMA_CONTEXT_LENGTH\}\}/${context[$PROFILE]}}"
plist_content="${plist_content//\{\{OLLAMA_KV_CACHE_TYPE\}\}/${kv_cache[$PROFILE]}}"

echo "Writing configuration..."
echo "$plist_content" > "$TARGET_PLIST"

echo "Bootstrap new Ollama service..."
launchctl bootstrap gui/$(id -u) "$TARGET_PLIST"
echo "Ollama successfully configured with profile '$PROFILE'!"
