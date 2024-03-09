# Normalize permissions of files and directories
function normalperms {
    find . -type f -exec chmod 644 {} +
    find . -type d -exec chmod 755 {} +
}

# Change file suffix from X to Y
function filesuffix {
    find . -type f -name "*.$1" -exec sh -c '
        cur_file="$1"
        cur_ext="$2"
        new_ext="$3"
        new_file=${cur_file//$cur_ext}$new_ext
        echo "Change $cur_file to $new_file"
        mv "$cur_file" "$new_file"
    ' _ {} $1 $2 \;
}

# File navigation and listing
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'
alias sl='ls'
alias lsl='ls -lhFA | less'
alias cd..='cd ..'
alias ..='cd ..'

# File content searching
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# File transfer
alias rsyncp='rsync -azvhP'
