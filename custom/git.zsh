# Pull changes for multiple Git repos
gpull () {
    local remote="${1:-origin}"
    find . -type d -name ".git" -exec sh -c '
        if grep -qs "remote .$2." "$1/config"; then
            set -x
            git -C "$1/../" pull "$2"
        fi
    ' _ {} "$remote" \;
}

# Run command with arguments for multiple Git repos
gmap () {
    # Here is the difference between $@ and $*
    # https://unix.stackexchange.com/q/129072
    local arguments="$*"
    find . -type d -name '.git' -exec sh -c '
        set -x
        git -C "$1/../" $2
    ' _ {} "$arguments" \;
}

# List secondary branches of current remote for single Git repo
glist () {
    local exclude_branches='(main|master)'
    local remote="${1:-origin}"
    git branch -r \
        | grep "$remote/" \
        | grep -v 'HEAD' \
        | grep -Ev "$exclude_branches" \
        | cut -d'/' -f 2,3
}

# Run `git fetch` with tracing enabled
alias gtrace='GIT_TRACE=1 git fetch'

# Redate the current HEAD commit (author and committer)
gdate() {
    local d="${1:-now}"
    GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date="$d"
}

# GitHub CLI helpers
alias ghp='gh pr create --fill'
alias ghs='gh pr status'
alias ghv='gh repo view --web'
alias ghc='gh pr checkout'
