# Fuzzy search files, then open the selection in VS Code
fso () {
    if (( $+commands[fd] )) && (( $+commands[fzf] )) && (( $+commands[code] )); then
        local file
        file=$(fd --type f --hidden --exclude .git | fzf)
        [[ -n "$file" ]] && code "$file"
    else
        echo "Error: fso requires fd, fzf, and code to be installed."
        return 1
    fi
}

# Look for file from target path up to root directory
flook () {
    local target_file="$1"
    local target_path="$PWD"
    while true; do
        if [[ -f "$target_path/$target_file" ]]; then
            echo "$target_path/$target_file"
            return 0
        fi
        [[ "$target_path" == "/" ]] && break
        target_path="${target_path:h}"
    done
    return 1
}

# Change file suffix from .x to .y
fext () {
    local current_suffix="$1"
    local new_suffix="$2"
    if (( $+commands[fd] )); then
        fd -e "$current_suffix" -0 | while IFS= read -r -d '' file; do
            mv "$file" "${file%.$current_suffix}.$new_suffix"
        done
    else
        find . -type f -name "*.$current_suffix" -print0 | while IFS= read -r -d '' file; do
            mv "$file" "${file%.$current_suffix}.$new_suffix"
        done
    fi
}

# Create directory and cd into it
mkcd () {
    mkdir -p "$1" && cd "$1"
}

# File navigation and listing
if [[ -o interactive && -t 1 ]]; then
    if (( $+commands[eza] )); then
        alias ls='eza --group-directories-first'
        alias ll='eza -l --group-directories-first'
        alias la='eza -la --group-directories-first'
    else
        alias ll='ls -l'
        alias la='ls -la'
        alias l='ls -CF'
    fi
fi

# File content searching and viewing
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Modern alternatives for cat and find
(( $+commands[bat] )) && alias cat='bat --paging=never'
(( $+commands[fd] )) && alias f='fd'

# File transfer
alias rsyncp='rsync -azvhP'
