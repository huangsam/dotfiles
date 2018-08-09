# Python helpers
alias venable='source /usr/local/bin/virtualenvwrapper.sh'
alias penv='pipenv'

function pipup() {
    pip list --outdated | awk '{if (NR > 2) print $1"=="$3}' | xargs pip install
}
