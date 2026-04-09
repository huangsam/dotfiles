# Pull changes for multiple Git repos
gpull () {
    local remote="${1:-origin}"
    local search_cmd="find . -type d -name '.git'"
    (( $+commands[fd] )) && search_cmd="fd -H -t d -g '.git'"
    eval "$search_cmd" | xargs -I {} sh -c "
        if grep -qs 'remote \"$remote\"' '{}/config'; then
            echo 'Updating {}...'
            git -C '{}/..' pull '$remote'
        fi
    "
}

# Run command with arguments for multiple Git repos
gmap () {
    local arguments="$*"
    local search_cmd="find . -type d -name '.git'"
    (( $+commands[fd] )) && search_cmd="fd -H -t d -g '.git'"
    eval "$search_cmd" | xargs -I {} sh -c "
        echo 'Running in {}...'
        git -C '{}/..' $arguments
    "
}

# List secondary branches of current remote for single Git repo
glist () {
    local exclude_branches='(main|master)'
    local remote="${1:-origin}"
    local branches
    branches=$(git branch -r \
        | grep "$remote/" \
        | grep -v 'HEAD' \
        | grep -Ev "$exclude_branches" \
        | cut -d'/' -f 2,3)

    if [[ -z "$branches" ]]; then
        return 0
    fi

    if (( $+commands[fzf] )); then
        local selected
        selected=$(echo "$branches" | fzf --height 40% --layout=reverse --border)
        [[ -n "$selected" ]] && git checkout "$selected"
    else
        echo "$branches"
    fi
}

# Redate the current HEAD commit (author and committer)
gdate () {
    local d="${1:-$(date -R)}"
    GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date="$d"
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'

# GitHub CLI helpers
alias ghp='gh pr create --fill'
alias ghs='gh pr status'
alias ghv='gh repo view --web'
alias ghc='gh pr checkout'
