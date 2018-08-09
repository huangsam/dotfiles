# Python helpers
alias venable='source /usr/local/bin/virtualenvwrapper.sh'
alias py='python'
alias py3='python3'
alias penv='pipenv'

function pipup() {
    pip list --outdated | awk '{if (NR > 2) print $1"=="$3}' | xargs pip install
}
