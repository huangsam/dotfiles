# List top ten commands from history
hstats () {
    history \
        | awk '{ CMD[$2]++; count++; } END { for (a in CMD) printf("%d %.2f%% %s\n", CMD[a], CMD[a]/count*100, a); }' \
        | column -c3 -s ' ' -t \
        | sort -nr \
        | nl \
        | head -n10
}

# Shorten command for downloading videos from YouTube
alias ytdl='yt-dlp'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'

# Show Mac system information
alias macinfo='system_profiler SPHardwareDataType'
