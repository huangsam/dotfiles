# Change file suffix from .x to .y
filesuffix () {
    local current_suffix="$1"
    local new_suffix="$2"
    if (( $+commands[fd] )); then
        fd -e "$current_suffix" -x sh -c 'mv "$1" "${1%.$2}.$3"' _ {} "$current_suffix" "$new_suffix"
    else
        find . -type f -name "*.$current_suffix" -exec sh -c '
            set -x
            mv "$1" "${1//$2}$3"
        ' _ {} "$current_suffix" "$new_suffix" \;
    fi
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
        target_path="${target_path:h}"
    done
    return 1
}

# File navigation and listing
if (( $+commands[eza] )); then
    alias ls='eza --group-directories-first'
    alias ll='eza -l --group-directories-first'
    alias la='eza -la --group-directories-first'
    alias lt='eza --tree'
    alias lsl='eza -lha --group-directories-first --classify | less'
else
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -CF'
    alias lsl='ls -lhFA | less'
fi
# File content searching and viewing
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

(( $+commands[bat] )) && alias cat='bat --paging=never'
(( $+commands[fd] )) && alias f='fd'

# File transfer
alias rsyncp='rsync -azvhP'
