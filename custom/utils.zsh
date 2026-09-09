# List top ten commands from history
hstats() {
    history 1 | awk '
        {
            command_count[$2]++;
            total_count++;
        }
        END {
            for (cmd in command_count) {
                printf("%6d  %6.2f%%  %s\n", command_count[cmd], (command_count[cmd] / total_count) * 100, cmd);
            }
        }' | sort -nr | head -n 10
}

# Reset Z shell configuration
alias zset='source ~/.zshrc'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'

# Shorten commands for modern tools
alias rgh='rg --hidden'

# Initialize zoxide for smart navigation
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
