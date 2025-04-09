# Manage Go module dependencies
gomo () {
    local cmd="${1:-unknown}"
    case "$cmd" in
        "clean") go clean -modcache ;;
        "down") go mod download ;;
        "tidy") go mod tidy ;;
        "up") go get -u ./... ;;
        *) echo "Invalid command: $cmd" ;;
    esac
}
