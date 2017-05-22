# Removal utilties
alias drma='docker rm $(docker ps -a -q)'
alias drmia='docker rmi $(docker images -q --filter "dangling=true")'
alias drmv='docker volume rm $(docker volume ls -q)'

# Docker Compose
alias fig='docker-compose'