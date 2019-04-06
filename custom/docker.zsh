# Containers
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlog='docker logs'
alias dexec='docker exec'
alias drma='docker rm $(docker ps -qa)'
alias dinip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dinim='docker inspect --format="{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}"'
alias dicfg='docker inspect --format="{{json .Config}}"'

# Images
alias di='docker images'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -qa)'
alias drmid='docker rmi $(docker images -qf "dangling=true")'

function dpull() {
    docker images --format '{{.Repository}}:{{.Tag }}' | xargs -L1 docker pull
}

# Volumes
alias dvls='docker volume ls'
alias drmva='docker volume rm $(docker volume ls -q)'
alias drmvd='docker volume rm $(docker volume ls -q -f "dangling=true")'

# Networks
alias dnls='docker network ls'

# Docker Compose
alias fig='docker-compose'
