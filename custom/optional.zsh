# List top ten commands from history
hstats () {
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

# List line-of-code metrics for given directory and extension
locstats () {
    local target_dir="$1"
    local extension="$2"
    local pattern="*.${extension#.}"
    if [[ ! -d "$target_dir" || -z "$extension" ]]; then
        return 1
    fi
    {
        local current=''
        current=$(find "$target_dir" -maxdepth 1 -type f -name "$pattern" -exec cat {} + | wc -l)
        echo ". $current"

        find "$target_dir" -mindepth 1 -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir; do
            local inner=''
            inner=$(find "$dir" -type f -name "$pattern" -exec cat {} + | wc -l)
            echo "$(basename "$dir") $inner"
        done
    } | column -t
}

# Reset Z shell configuration
alias zset='source ~/.zshrc'

# Shorten command for downloading videos from YouTube
alias ytdl='yt-dlp'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'

# Modern CLI tools aliases
(( $+commands[dust] )) && alias du='dust'
(( $+commands[scc] )) && alias loc='scc'
(( $+commands[rg] )) && alias rgf='rg -n --hidden --glob "!.git"'
(( $+commands[nvim] )) && alias v='nvim'
(( $+commands[tldr] )) && alias t='tldr'
(( $+commands[gh] )) && alias ghpr='gh pr status'

# Global aliases (use anywhere in command)
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g J='| jq'

# Initialize modern CLI tools
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
