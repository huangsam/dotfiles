# List process running on a specific port
portlist () {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: portlist <port>"
        return 1
    fi
    lsof -i :"$port"
}

# Kill process running on a specific port
portkill () {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: portkill <port>"
        return 1
    fi
    local pid
    pid=$(lsof -t -i:"$port")
    if [[ -n "$pid" ]]; then
        echo "Killing process $pid on port $port..."
        kill -9 "$pid"
    else
        echo "No process running on port $port"
    fi
}

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
