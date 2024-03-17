# Normalize permissions of files and directories
normalperms () {
    find . -type f -exec chmod 644 {} +
    find . -type d -exec chmod 755 {} +
}

# Change file suffix from .x to .y
filesuffix () {
    current_suffix="$1"
    new_suffix="$2"
    find . -type f -name "*.$current_suffix" -print0 \
        | while IFS= read -r -d '' file; do
            new_file="${file//$current_suffix}$new_suffix"
            echo "Change $file to $new_file"
            mv "$file" "$new_file"
        done
}

# Look for file from target up to root
lookupfile () {
    target_file="$1"
    target_path="${2:-$(pwd)}"
    target_match="$target_path/$target_file"
    if [[ "$target_path" == "/" ]]; then
        false
    elif [[ -f "$target_match" ]]; then
        echo "$target_match"
        true
    else
        lookupfile "$target_file" "$(dirname "$target_path")"
    fi
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
