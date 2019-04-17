# Pull available Docker images
function dpull() {
    docker images --format '{{.Repository}}:{{.Tag }}' \
        | xargs -L1 docker pull
}

# Retrieve ids of cacheable Docker layers
function dcache() {
    docker history -q "$1" \
        | awk '{if ($1 !~ /missing/) print $1}'
}

# Save tar of cacheable Docker layers
function dsave() {
    docker save -o "${2:-output.tar}" $(dcache "$1")
}

# Docker containers
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlogs='docker logs'
alias dexec='docker exec'
alias drma='docker rm $(docker ps -qa)'
alias dinip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dinim='docker inspect --format="{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}"'
alias dicfg='docker inspect --format="{{json .Config}}"'

# Docker images
alias di='docker images'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -qa)'
alias drmid='docker rmi $(docker images -qf "dangling=true")'

# Docker volumes
alias dvls='docker volume ls'
alias drmva='docker volume rm $(docker volume ls -q)'
alias drmvd='docker volume rm $(docker volume ls -q -f "dangling=true")'

# Docker networks
alias dnls='docker network ls'
