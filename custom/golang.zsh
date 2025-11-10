# Manage Go module dependencies
gomo () {
    local cmd="${1:-unknown}"
    case "$cmd" in
        "clean") go clean -modcache ;;
        "down") go mod download ;;
        "tidy") go mod tidy ;;
        "list") go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all ;;
        "up") go get $(go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all) ;;
        *) echo "Invalid command: $cmd" ;;
    esac
}
