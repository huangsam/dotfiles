# Run `git pull` for online repos in a specific path
function gpull() {
    find "${1:-.}" -type d -name '.git' | while read -r dir; do
        cd "$dir/../" || return
        dir="$(pwd)"
        if grep -qs "remote" .git/config; then
            echo "= pull $dir"
            git pull -q
        else
            echo "x skip $dir"
        fi
    done
}

# Sync origin/master with upstream/master
function gsync() {
    BRANCH="${1:-master}"
    git checkout "$BRANCH"
    git fetch upstream
    git reset --hard "upstream/$BRANCH"
    git push origin "$BRANCH"
}

# Enable assumption for file in repository
alias gignore='git update-index --assume-unchanged'

# Disable assumption for file in repository
alias gremind='git update-index --no-assume-unchanged'

# Run submodule update
alias gupdate='git submodule update --recursive --remote'

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
