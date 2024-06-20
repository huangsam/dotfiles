# Pull latest changes and prune remote for multiple repos
gpull () {
    remote="${1:-origin}"
    find . -type d -name ".git" -exec sh -c '
        if grep -qs "remote .$2." "$1/config"; then
            set -x
            git -C "$1/../" pull "$2"
            git -C "$1/../" remote prune "$2"
        fi
    ' _ {} "$remote" \;
}

# Run Git command with arguments for multiple repos
gmap () {
    # Here is the difference between $@ and $*
    # https://unix.stackexchange.com/q/129072
    command="$*"
    find . -type d -name '.git' -exec sh -c '
        set -x
        git -C "$1/../" $2
    ' _ {} "$command" \;
}

# Sync branch on current remote with parent remote for one repo
gsync () {
    branch="$(git symbolic-ref --short HEAD)"
    current_remote="${1:-origin}"
    parent_remote="${2:-upstream}"
    git fetch "$parent_remote"
    git reset --hard "$parent_remote/$branch"
    git push "$current_remote" "$branch"
}

# List secondary branches of current remote for one repo
glist () {
    exclude_pattern="${1:-(main|master)}"
    repo="${2:-origin}"
    git branch -r \
        | grep "$repo/" \
        | grep -v 'HEAD' \
        | grep -Ev "$exclude_pattern" \
        | cut -d'/' -f 2,3
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
