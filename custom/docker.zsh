# Containers
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlog='docker log'
alias dexec='docker exec'
alias drm='docker rm'
alias drma='docker rm $(docker ps -q -a)'
alias drmav='docker rm -v $(docker ps -q -a)'
alias drms='docker rm $(docker ps -q -f "status=exited")'
alias drmsv='docker rm -v $(docker ps -q -f "status=exited")'
alias dinip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dinim='docker inspect --format="{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}"'
alias dicfg='docker inspect --format="{{json .Config}}"'

# Images
alias di='docker images'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -q -a)'
alias drmid='docker rmi $(docker images -q -f "dangling=true")'

function dpull() {
    docker images | grep -v REPOSITORY | awk '{print $1 ":" $2}' | xargs -L1 docker pull
}

# Volumes
alias dvls='docker volume ls'
alias drmva='docker volume rm $(docker volume ls -q)'
alias drmvd='docker volume rm $(docker volume ls -q -f "dangling=true")'

# Networks
alias dnls='docker network ls'
alias drmn='docker network rm'

# Docker Compose
alias fig='docker-compose'
