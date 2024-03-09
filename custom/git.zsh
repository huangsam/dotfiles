# Pull latest changes and prune remote for multiple repos
gpull () {
    remote="${1:-origin}"
    find . -type d -name ".git" | while read -r dir; do
        if grep -qs "remote .$remote." "$dir/config"; then
            echo "$dir"
            git -C "$dir/../" pull --rebase "$remote"
            git -C "$dir/../" remote prune "$remote"
        fi
    done
}

# Run `git` command with / without args for multiple repos
gmap () {
    find . -type d -name '.git' | while read -r dir; do
        echo "$dir"

        # Here is the difference between $@ and $*
        # https://unix.stackexchange.com/q/129072
        git -C "$dir/../" "$@"
    done
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
