# Manage Go module dependencies
gomo() {
    local cmd="${1:-unknown}"
    shift 2>/dev/null || true
    case "$cmd" in
        clean) go clean -modcache "$@" ;;
        down) go mod download "$@" ;;
        tidy) go mod tidy "$@" ;;
        list) go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all | grep -v '^$' ;;
        outdated) go list -m -u -f '{{if and .Update (not .Indirect)}}{{.Path}} {{.Version}} -> {{.Update.Version}}{{end}}' all | grep -v '^$' ;;
        *)
            print -u2 -r -- "Error: Invalid command '$cmd'"
            print -u2 -r -- "Usage: gomo <clean|down|tidy|list|outdated>"
            return 1
            ;;
    esac
}

# Python HTTP server
pyhttp() {
    python3 -m http.server --directory "${1:-.}" "${2:-8000}"
}

# Python virtual environment shortcut
alias pyvenv='python3 -m venv'

# List installed macOS JDKs
alias jdkls='/usr/libexec/java_home -V'
