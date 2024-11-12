# SSH connection
alias sshv='ssh -vvv -o LogLevel=DEBUG3'

# HTTP/S connection
alias curlv='curl -fvso /dev/null'

# Public IP address
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# List of devices on the local network
alias netlist='arp -a'

# Local Wi-Fi information
alias localwifi='networksetup -getinfo Wi-Fi'
