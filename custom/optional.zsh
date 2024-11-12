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
