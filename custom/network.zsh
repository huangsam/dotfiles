# SSH connection
alias sshv='ssh -vvv -o LogLevel=DEBUG3'

# HTTP/S connection
alias curlv='curl -fvso /dev/null'

# Public IP address
# https://unix.stackexchange.com/a/335403
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# List of devices on the local network
alias netlist='arp -a'
if (( $+commands[nmap] )); then
    alias nscan='sudo nmap -sn' # Ping scan
    alias nmapfast='nmap -F'    # Fast scan of most common ports
fi

# Local Wi-Fi information
alias localwifi='networksetup -getinfo Wi-Fi'
