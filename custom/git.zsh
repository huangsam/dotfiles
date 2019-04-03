# Run `git pull` in every repository within current path
alias gpull='find . -type d -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

# Run generic `git` command in every repository within current path
function gcomm() {
    find . -type d -name ".glide" -prune -o -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git $1" \;
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
