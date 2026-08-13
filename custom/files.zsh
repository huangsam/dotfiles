# Fuzzy search files, then open the selection in terminal editor
fo() {
    local file
    file=$(fd --type f --hidden --exclude .git | fzf)
    [[ -n "$file" ]] && "${EDITOR:-vim}" "$file"
}

# Fuzzy search files, then open the selection in VS Code
fso() {
    local file
    file=$(fd --type f --hidden --exclude .git | fzf)
    [[ -n "$file" ]] && code "$file"
}

# Look for file from target path up to root directory
flook() {
    if [[ -z "$1" ]]; then
        echo "Usage: flook <target_file>" >&2
        return 1
    fi
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
fext() {
    local current_suffix="$1"
    local new_suffix="$2"
    if [[ -z "$current_suffix" || -z "$new_suffix" ]]; then
        echo "Usage: fext <current_extension> <new_extension>" >&2
        return 1
    fi
    fd -e "$current_suffix" -0 | while IFS= read -r -d '' file; do
        mv "$file" "${file%.$current_suffix}.$new_suffix"
    done
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# File navigation and listing
# Overrides system and oh-my-zsh for interactive shells
if [[ -o interactive && -t 1 ]] && (( $+commands[eza] )); then
    alias ls='eza --group-directories-first'
    alias l='eza --group-directories-first'
    alias ll='eza -l --group-directories-first'
    alias la='eza -la --group-directories-first'
fi

# File content searching and viewing
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# File transfer
alias rsyncp='rsync -azvhP'
