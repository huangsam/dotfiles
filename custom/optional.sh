# List top ten commands from history
function hstats() {
    history \
        | awk '{ CMD[$2]++; count++; } END { for (a in CMD) printf("%d %.2f%% %s\n", CMD[a], CMD[a]/count*100, a); }' \
        | column -c3 -s ' ' -t \
        | sort -nr \
        | nl \
        | head -n10
}

# Download MP4 format
alias ytdl='youtube-dl --format mp4'

# Show Homebrew dependency tree
alias brewtree='brew deps --tree --installed'
