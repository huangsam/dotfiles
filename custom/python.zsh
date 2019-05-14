# Update available pip dependencies
function pipup() {
    pip list --format=freeze --outdated \
        | awk -F'==' '{print $1}' \
        | xargs pip install -U
}

# Python helpers
alias venable='source /usr/local/bin/virtualenvwrapper.sh'
alias py='python'
alias py3='python3'
alias pipout='pip list --outdated'
