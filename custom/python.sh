# Python helpers
alias vwrap='source /usr/local/bin/virtualenvwrapper.sh'
alias vmake='test -d venv || virtualenv venv'
alias vunmake='test -d venv && rm -rf venv'
alias vstart='source venv/bin/activate'
alias vstop='deactivate'
alias pipout='pip list --outdated'
