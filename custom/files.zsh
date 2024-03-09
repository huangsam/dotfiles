# Normalize permissions of files and directories
function normalperms {
    find . -type f -exec chmod 644 {} +
    find . -type d -exec chmod 755 {} +
}

# Change file suffix from X to Y
function filesuffix {
    cur_ext="$1"
    new_ext="$2"
    find . -type f -name "*.$cur_ext" | while read file; do
        new_file=${file//$cur_ext}$new_ext
        echo "Change $file to $new_file"
        mv "$file" "$new_file"
    done
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
