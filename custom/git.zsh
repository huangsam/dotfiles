# Sync origin/master with upstream/master
function gsync() {
    BRANCH="${1:-master}"
    git checkout "$BRANCH"
    git fetch upstream
    git reset --hard "upstream/$BRANCH"
    git push origin "$BRANCH"
}

# Publish changes to Gerrit SCM
function gerrit_publish() {
    git push origin "HEAD:refs/for/$1"
}

# Create draft in Gerrit SCM
function gerrit_draft() {
    git push origin "HEAD:refs/drafts/$1"
}

# Run `git pull` in every repository within current path
alias gpull='find . -type d -name ".git" -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

# Enable assumption for file in repository
alias gignore='git update-index --assume-unchanged'

# Disable assumption for file in repository
alias gremind='git update-index --no-assume-unchanged'

# Run submodule update
alias gupdate='git submodule update --recursive --remote'

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'
