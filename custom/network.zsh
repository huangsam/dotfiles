# SSH connection
alias sshv='ssh -vvv -o LogLevel=DEBUG3'

# HTTP/S connection
alias curlv='curl -fvso /dev/null'

# My IP address
alias curlip='curl icanhazip.com'
alias digip='dig +short myip.opendns.com @resolver1.opendns.com'

# List of devices on the local network
alias netlist='arp -a'

# Network adapters
alias ifdev='ifconfig en0'
alias ifall='ifconfig -a'
