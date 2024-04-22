# Python helpers
alias vmake='test -d venv || virtualenv venv'
alias vunmake='test -d venv && rm -rf venv'
alias vstart='source venv/bin/activate'
alias vstop='deactivate'

# Python HTTP server
alias pyhttp='python3 -m http.server --directory'
