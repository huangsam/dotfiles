# Navigation and Listing
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'
alias sl='ls'
alias lsl='ls -lhFA | less'
alias cd..='cd ..'
alias ..='cd ..'

# Searching
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System Aliases
alias du='du -ach | sort'

# Miscellaneous
alias gpull='find . -type d -name ".glide" -prune -o -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

function hstats {
    history \
        | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a; }' \
        | grep -v './' \
        | column -c3 -s ' ' -t \
        | sort -nr \
        | nl \
        | head -n10
}

alias hstats=hstats

alias ytdl='youtube-dl --format mp4'
alias osquery='/usr/local/bin/osqueryi'

alias fig='docker-compose'
alias drma='docker rm $(docker ps -a -q)'
alias drmia='docker rmi $(docker images -q --filter "dangling=true")'
