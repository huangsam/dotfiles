# Containers
alias dps='docker ps'
alias dlog='docker log'
alias dexec='docker exec'
alias drm='docker rm'
alias drma='docker rm $(docker ps -q -a)'
alias drmav='docker rm -v $(docker ps -q -a)'
alias drmavf='docker rm -v -f $(docker ps -q -a)'
alias drms='docker rm $(docker ps -q -f "status=exited")'
alias drmsv='docker rm -v $(docker ps -q -f "status=exited")'

# Images
alias di='docker images'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -q --filter "dangling=true")'

# Volumes
alias dvls='docker volume ls'
alias drmv='docker volume rm $(docker volume ls -q)'

# Docker Compose
alias fig='docker-compose'