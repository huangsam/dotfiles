# Run `git pull` in every repository within current path
alias gpull='find . -type d -name ".glide" -prune -o -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

# Run generic `git` command in every repository within current path
function gcomm() {
    find . -type d -name ".glide" -prune -o -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git $1" \;
}

# Enable assumption for file in repository
alias gignore='git update-index --assume-unchanged'

# Disable assumption for file in repository
alias gremind='git update-index --no-assume-unchanged'

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

# SSH connection
alias sshv='ssh -vvv -o LogLevel=DEBUG3'
