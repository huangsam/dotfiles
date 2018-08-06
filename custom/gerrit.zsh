# Gerrit shortcuts
function gerrit_publish() {
    git push origin "HEAD:refs/for/$1"
}

function gerrit_draft() {
    git push origin "HEAD:refs/drafts/$1"
}
