# Run `git pull` and `git remote prune` for remote repos
gpull () {
    repo="${1:-origin}"
    find . -type d -name ".git" | while read dir; do
        if grep -qs "remote .$repo." $dir/config; then
            echo "$dir"
            git -C "$dir/../" pull "$repo"
            git -C "$dir/../" remote prune "$repo"
        fi
    done
}

# Run any `git` command for all repos
gmap () {
    command="$*"
    find . -type d -name '.git' | while read dir; do
        echo "$dir"
        git -C "$dir/../" $command
    done
}

# Sync branch on current_remote with parent_remote
gsync () {
    branch="$(git symbolic-ref --short HEAD)"
    current_remote="${1:-origin}"
    parent_remote="${2:-upstream}"
    git fetch "$parent_remote"
    git reset --hard "$parent_remote/$branch"
    git push "$current_remote" "$branch"
}

# List secondary branches for remote repos
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
