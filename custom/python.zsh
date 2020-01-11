# Update available pip dependencies
function pipup() {
    pip3 list --format=freeze --outdated \
        | awk -F'==' '{print $1}' \
        | xargs pip3 install -U
}

# Python helpers
alias vwrap='source /usr/local/bin/virtualenvwrapper.sh'
alias vmake='virtualenv venv'
alias vstart='source venv/bin/activate'
alias vstop='deactivate'
alias py='python'
alias py3='python3'
alias pipout='pip3 list --outdated'
