# Update available pip dependencies
function pipup() {
    pip3 list --format=freeze --outdated \
        | awk -F'==' '{print $1}' \
        | xargs pip3 install -U
}

# Python helpers
alias vwrap='source /usr/local/bin/virtualenvwrapper.sh'
alias vmake='test -d venv || virtualenv venv'
alias vunmake='test -d venv && rm -rf venv'
alias vstart='source venv/bin/activate'
alias vstop='deactivate'
alias pipout='pip3 list --outdated'
