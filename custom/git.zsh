# Pull changes for multiple Git repos
gpull() {
    local remote="${1:-origin}"
    fd -H -t d -g '.git' | while read -r repo; do
        if grep -qs "remote \"$remote\"" "$repo/config"; then
            print -r -- "Updating $repo..."
            git -C "$repo/.." pull "$remote"
        fi
    done
}

# Run command with arguments for multiple Git repos
gmap() {
    if [[ $# -eq 0 ]]; then
        print -u2 -r -- "Usage: gmap <command> [args...]"
        return 1
    fi
    fd -H -t d -g '.git' | while read -r repo; do
        print -r -- "Running in $repo..."
        git -C "$repo/.." "$@"
    done
}

# List secondary branches of current remote for single Git repo
glist() {
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

    local selected
    selected=$(print -r -- "$branches" | fzf --height 40% --layout=reverse --border)
    [[ -n "$selected" ]] && git checkout "$selected" # no-op if fzf selection dismissed
}

# Redate the current HEAD commit (author and committer)
gdate() {
    local d="${1:-$(date -R)}"
    GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date="$d"
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
