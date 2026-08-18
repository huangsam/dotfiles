# List process running on a specific port
portlist() {
    local port="$1"
    if [[ -z "$port" ]]; then
        print -u2 -r -- "Usage: portlist <port>"
        return 1
    fi
    [[ "$port" = <-> ]] || { print -u2 -r -- "Error: Port must be a number"; return 1; }
    lsof -i :"$port"
}

# Kill process running on a specific port
portkill() {
    local port="$1"
    if [[ -z "$port" ]]; then
        print -u2 -r -- "Usage: portkill <port>"
        return 1
    fi
    [[ "$port" = <-> ]] || { print -u2 -r -- "Error: Port must be a number"; return 1; }
    local -a pids
    pids=($(lsof -t -i:"$port" 2>/dev/null))
    if (( ${#pids} > 0 )); then
        print -r -- "Killing process(es) ${pids[*]} on port $port..."
        kill -9 "${pids[@]}"
    else
        print -r -- "No process running on port $port"
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

# Local Wi-Fi information
alias localwifi='networksetup -getinfo Wi-Fi'
