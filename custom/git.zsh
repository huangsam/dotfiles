# Run `git pull` for online repos in a specific path
function gpull() {
    # shellcheck disable=SC2156
    find "${1:-.}" -type d -name ".git" -exec bash -c '
        cd {}/../
        if grep -qs "remote" .git/config; then
            pwd && git pull
        fi
    ' \;
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
