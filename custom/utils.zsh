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
        echo "Usage: mov2gif <input_file> [width] [fps]" >&2
        return 1
    fi

    local input="$1"
    if [[ ! -f "$input" ]]; then
        echo "Error: File '$input' not found" >&2
        return 1
    fi

    local width="${2:-800}"
    local fps="${3:-15}"
    local output="${input%.*}.gif"

    echo "Converting '$input' to '$output' (width: ${width}px, fps: ${fps})..."

    ffmpeg -i "$input" -vf "fps=${fps},scale=${width}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$output"

    echo "Done! Saved as '$output'"
}

# Refresh Ollama models in alphabetical order
ofresh() {
    ollama list | awk 'NR>1 {print $1}' | sort | while read -r model; do
        echo "==> Pulling $model..."
        ollama pull "$model"
    done
}

# Reset Z shell configuration
alias zset='source ~/.zshrc'

# Shorten command for downloading videos from YouTube
alias ytdl='yt-dlp'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'

# Modern CLI tools aliases
alias loc='scc'
alias rgf='rg -n --hidden --glob "!.git"'
(( $+commands[vim] )) && alias v='vim'
alias t='tldr'
alias ghpr='gh pr status'

# Global aliases (use anywhere in command)
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g J='| jq'

# Initialize modern CLI tools
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
