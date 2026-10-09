# Refresh Ollama models in alphabetical order
ofresh() {
    ollama list | awk 'NR>1 {print $1}' | sort | while read -r model; do
        print -r -- "==> Pulling $model..."
        ollama pull "$model"
    done
}

# Unload Ollama models and terminate runners to reclaim VRAM
okill() {
    if [[ -n "${1:-}" ]]; then
        print -r -- "==> Stopping model $1..."
        ollama stop "$1" 2>/dev/null
    else
        print -r -- "==> Stopping all active Ollama models..."
        ollama ps 2>/dev/null | awk 'NR>1 {print $1}' | while read -r model; do
            [[ -n "$model" ]] && ollama stop "$model" 2>/dev/null
        done
        # Force-kill any lingering runner subprocesses (GGUF llama-server or MLX runner)
        pkill -9 -f "(llama-server|ollama runner)" 2>/dev/null || true
    fi
    ollama ps
}

# Restart the Ollama launchd background service and verify version sync
orestart() {
    print -r -- "==> Restarting Ollama service..."
    local label="com.$USER.ollama"
    local plist="$HOME/Library/LaunchAgents/$label.plist"
    if [[ ! -f "$plist" ]]; then
        print -r -- "==> Missing launchd plist: $plist" >&2
        return 1
    fi

    # Full unload/reload (unlike kickstart) so launchd re-validates a freshly upgraded binary
    launchctl bootout "gui/$(id -u)/$label" 2>/dev/null
    # bootout is async; wait until the service is fully unloaded before bootstrapping
    local client_ver server_ver response i
    for (( i = 0; i < 20; i++ )); do
        launchctl print "gui/$(id -u)/$label" &>/dev/null || break
        sleep 0.25
    done
    launchctl bootstrap "gui/$(id -u)" "$plist" || return 1

    # Poll until the server answers (up to ~30s)
    for (( i = 0; i < 60; i++ )); do
        response=$(curl -fs --max-time 1 http://localhost:11434/api/version 2>/dev/null) && [[ -n "$response" ]] && break
        sleep 0.5
    done

    client_ver=$(ollama --version 2>/dev/null | awk '{print $NF}')
    if [[ -z "$response" ]]; then
        print -r -- "==> Ollama did not respond after 30s: client ($client_ver) | server (unknown)" >&2
        print -r -- "    Check: /tmp/ollama.stderr.log, /tmp/ollama.stdout.log, launchctl print gui/$(id -u)/$label" >&2
        return 1
    fi
    server_ver=$(print -r -- "$response" | sed -nE 's/.*"version":"([^"]+)".*/\1/p')
    print -r -- "==> Ollama restarted: client ($client_ver) | server (${server_ver:-unknown})"
}

# Launch OpenCode with Ollama model selection
alias ocode='ollama launch opencode'
