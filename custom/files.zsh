# Normalize permissions of files and directories
filenorm () {
    find . -type f -exec chmod 644 {} +
    find . -type d -exec chmod 755 {} +
}

# Change file suffix from .x to .y
filesuffix () {
    local current_suffix="$1"
    local new_suffix="$2"
    find . -type f -name "*.$current_suffix" -exec sh -c '
        set -x
        mv "$1" "${1//$2}$3"
    ' _ {} "$current_suffix" "$new_suffix" \;
}

# Look for file from target path up to root directory
filelookup () {
    local target_file="$1"
    local target_path="$PWD"
    while [[ "$target_path" != "/" ]]; do
        if [[ -f "$target_path/$target_file" ]]; then
            echo "$target_path/$target_file"
            return 0
        fi
        target_path="$(dirname "$target_path")"
    done
    return 1
}

# File navigation and listing
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'
alias sl='ls'
alias lsl='ls -lhFA | less'

# File content searching
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# File transfer
alias rsyncp='rsync -azvhP'
