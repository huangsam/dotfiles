# Gerrit shortcuts
function git_publish() {
    git push origin "HEAD:refs/for/${1}"
}

function git_draft() {
    git push origin "HEAD:refs/drafts/${1}"
}
