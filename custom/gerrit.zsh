# Publish changes to Gerrit SCM
function gerrit_publish() {
    git push origin "HEAD:refs/for/$1"
}

# Create draft in Gerrit SCM
function gerrit_draft() {
    git push origin "HEAD:refs/drafts/$1"
}
