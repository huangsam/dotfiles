# Manage Go module dependencies
gomo () {
    local cmd="${1:-unknown}"
    case "$cmd" in
        "clean") go clean -modcache ;;
        "down") go mod download ;;
        "tidy") go mod tidy ;;
        "list") go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all ;;
        "outdated") go list -m -u -f '{{if and .Update (not .Indirect)}}{{.Path}} {{.Version}} -> {{.Update.Version}}{{end}}' all ;;
        *) echo "Invalid command: $cmd" ;;
    esac
}
