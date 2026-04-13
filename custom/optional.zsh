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
