# Pull changes for multiple Git repos
gpull() {
    local remote="${1:-origin}"
    local -a repos
    repos=(${(f)"$(fd -H -t d -g '.git' 2>/dev/null)"})

    if (( ${#repos} == 0 )); then
        return 0
    fi

    local repo
    for repo in "${repos[@]}"; do
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

    local -a repos
    repos=(${(f)"$(fd -H -t d -g '.git' 2>/dev/null)"})

    if (( ${#repos} == 0 )); then
        return 0
    fi

    local repo
    for repo in "${repos[@]}"; do
        print -r -- "Running in $repo..."
        git -C "$repo/.." "$@"
    done
}

# List secondary branches of current remote for single Git repo
glist() {
    local remote="${1:-origin}"
    local -a raw_branches
    raw_branches=(${(f)"$(git branch -r --list "$remote/*" --format='%(refname:short)' 2>/dev/null)"})
    raw_branches=(${raw_branches:#$remote/HEAD*})
    raw_branches=(${raw_branches:#$remote/(main|master)})

    if (( ${#raw_branches} == 0 )); then
        return 0
    fi

    local selected
    selected=$(printf "%s\n" "${raw_branches#$remote/}" | fzf --height 40% --layout=reverse --border)
    [[ -n "$selected" ]] && git checkout "$selected" # no-op if fzf selection dismissed
}

# Redate the current HEAD commit (author and committer)
gdate() {
    local d="${1:-$(date -R)}"
    GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date="$d"
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
