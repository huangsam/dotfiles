# Run `git pull` and `git remote prune` for remote repos
function gpull() {
    find . -type d -name ".git" -exec sh -c '
        dir="$1"
        repo="$2"
        if grep -qs "remote .$repo." $dir/config; then
            echo "$dir"
            git -C "$dir/../" pull "$repo"
            git -C "$dir/../" remote prune origin
        fi
    ' _ {} "${1:-origin}" \;
}

# Run any `git` command for all repos
function gmap() {
    find . -type d -name '.git' -exec sh -c '
        dir="$1"
        command="$2"
        echo "$dir"
        git -C "$dir/../" $command
    ' _ {} "$*" \;
}

# Sync origin/target with upstream/target
function gsync() {
    target="${1:-master}"
    git checkout "$target"
    git fetch upstream
    git reset --hard "upstream/$target"
    git push origin "$target"
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
