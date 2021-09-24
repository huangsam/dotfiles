# SSH connection
alias sshv='ssh -vvv -o LogLevel=DEBUG3'

# HTTP/S connection
alias curlv='curl -fvso /dev/null'

# My IP address
alias curlip='curl bot.whatismyipaddress.com'
alias digip='dig +short myip.opendns.com @resolver1.opendns.com'

# Clear DNS cache on Mac OS
alias cleardns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
