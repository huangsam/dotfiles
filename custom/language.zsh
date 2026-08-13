# Manage Go module dependencies
gomo() {
    local cmd="${1:-unknown}"
    case "$cmd" in
        clean) go clean -modcache ;;
        down) go mod download ;;
        tidy) go mod tidy ;;
        list) go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all ;;
        outdated) go list -m -u -f '{{if and .Update (not .Indirect)}}{{.Path}} {{.Version}} -> {{.Update.Version}}{{end}}' all ;;
        *)
            print -u2 -r -- "Error: Invalid command '$cmd'"
            print -u2 -r -- "Usage: gomo <clean|down|tidy|list|outdated>"
            return 1
            ;;
    esac
}

# Run fresh Maven install
alias mvnci='mvn clean install'

# Setup Gradle assets for new project
alias gradnew='gradle init wrapper'

# Show available Java JDKs
alias jdkapple='ls /Library/Java/JavaVirtualMachines'
alias jdklinux='ls /usr/lib/jvm'

# Python HTTP server
alias pyhttp='python3 -m http.server --directory'
