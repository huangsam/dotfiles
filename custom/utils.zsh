# List top ten commands from history
hstats() {
    history |
        awk '{
            command_count[$2]++;
            total_count++;
        }
        END {
            for (cmd in command_count) {
                printf("%d %.2f%% %s\n",
                    command_count[cmd],
                    command_count[cmd]/total_count*100,
                    cmd);
            }
        }' | sort -nr | head -n10 | column -c3 -s ' ' -t | nl
}

# Convert video (MOV, MP4, etc.) to optimized GIF using ffmpeg
mov2gif() {
    if [[ -z "$1" ]]; then
        print -u2 -r -- "Usage: mov2gif <input_file> [width] [fps]"
        return 1
    fi

    local input="$1"
    if [[ ! -f "$input" ]]; then
        print -u2 -r -- "Error: File '$input' not found"
        return 1
    fi

    local width="${2:-800}"
    local fps="${3:-15}"
    local output="${input%.*}.gif"

    print -r -- "Converting '$input' to '$output' (width: ${width}px, fps: ${fps})..."

    ffmpeg -i "$input" -vf "fps=${fps},scale=${width}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$output"

    print -r -- "Done! Saved as '$output'"
}

# Refresh Ollama models in alphabetical order
ofresh() {
    ollama list | awk 'NR>1 {print $1}' | sort | while read -r model; do
        print -r -- "==> Pulling $model..."
        ollama pull "$model"
    done
}

# Reset Z shell configuration
alias zset='source ~/.zshrc'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'

# Shorten commands for modern tools
alias loc='scc'
alias rgf='rg -n --hidden --glob "!.git"'
alias ghpr='gh pr status'
alias ytdl='yt-dlp'
alias ocode='ollama launch opencode'

# Initialize zoxide for smart navigation
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
