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

# List line of code for a given extension by subfolders
locstats () {
    local target_dir="$1"
    local extension="$2"
    local pattern="*.${extension#.}"
    find "$target_dir" -mindepth 1 -maxdepth 1 -type d -print0 \
            | while IFS= read -r -d '' dir; do
        local dir="${dir#target_dir/}"
        local count=$(find "$dir" -type f -name "$pattern" -exec cat {} + | wc -l | xargs)
        echo "$(basename $dir) ${count:-0}"
    done | column -t
}

# Reset Z shell configuration
alias zset='source ~/.zshrc'

# Shorten command for downloading videos from YouTube
alias ytdl='yt-dlp'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'
