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
    launchctl kickstart -k "gui/$(id -u)/com.$USER.ollama"
    sleep 1
    local client_ver server_ver
    client_ver=$(ollama --version 2>/dev/null | awk '{print $NF}')
    server_ver=$(curl -s http://localhost:11434/api/version 2>/dev/null | sed -E 's/.*"version":"([^"]+)".*/\1/')
    print -r -- "==> Ollama restarted: client ($client_ver) | server (${server_ver:-unknown})"
}

# Launch OpenCode with Ollama model selection
alias ocode='ollama launch opencode'
