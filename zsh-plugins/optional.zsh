# Run `git pull` in every repository within current path
alias gpull='find . -type d -name ".glide" -prune -o -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

# List top ten commands from history
function hstats {
    history \
        | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a; }' \
        | grep -v './' \
        | column -c3 -s ' ' -t \
        | sort -nr \
        | nl \
        | head -n10
}

# Download MP4 format
alias ytdl='youtube-dl --format mp4'

# Monitoring
alias osquery='/usr/local/bin/osqueryi'
