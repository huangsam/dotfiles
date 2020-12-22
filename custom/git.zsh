# Run `git pull` and `git remote prune` for remote repos
function gpull() {
    # shellcheck disable=SC2156
    find . -type d -name ".git" -exec sh -c '
        if grep -qs "remote \"origin\"" {}/config; then
            echo {}
            git -C {}/../ pull
            git -C {}/../ remote prune origin
        fi
    ' \;
}

# Run any `git` command for all repos
function gmap() {
    # shellcheck disable=SC2156
    find . -type d -name '.git' -exec sh -c "echo {}; git -C {}/../ $*" \;
}

# Sync origin/target with upstream/target
function gsync() {
    target="${1:-master}"
    git checkout "$target"
    git fetch upstream
    git reset --hard "upstream/$target"
    git push origin "$target"
}

# Enable assumption for file in repository
alias gignore='git update-index --assume-unchanged'

# Disable assumption for file in repository
alias gremind='git update-index --no-assume-unchanged'

# Run submodule update
alias gupdate='git submodule update --recursive --remote'

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
