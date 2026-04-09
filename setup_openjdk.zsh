#!/bin/zsh
set -eu -o pipefail

HOMEBREW_PREFIX=$(brew --prefix)
JVM_DIR="/Library/Java/JavaVirtualMachines"

echo "Setup OpenJDK symlinks for macOS in $JVM_DIR..."

# Enable nullglob to safely handle when no matching files are found
setopt nullglob

# Track processed real paths to avoid redundant symlinks (e.g., openjdk@23 -> openjdk)
typeset -A seen_paths
# Track managed symlink names to identify stale ones for cleanup
typeset -A managed_links

found=0
for jdk_path in $HOMEBREW_PREFIX/opt/openjdk*; do
    # Verify the JDK libexec directory exists
    if [[ -d "$jdk_path/libexec/openjdk.jdk" ]]; then
        # Resolve the real path of the JDK to find unique installations
        real_jdk_path=$(readlink -f "$jdk_path")

        # Skip if we already linked this exact JDK installation
        # Using (( ${+seen_paths...} )) is the safe zsh way to check key existence with set -u
        if (( ${+seen_paths[$real_jdk_path]} )); then
            continue
        fi
        seen_paths[$real_jdk_path]=1

        found=1
        jdk_name=$(basename "$jdk_path")

        # Determine the destination symlink name by being explicit with the major version
        # We look inside the release file to get the true version
        local release_file="$jdk_path/libexec/openjdk.jdk/Contents/Home/release"
        local major_version=""

        if [[ -f "$release_file" ]]; then
            # Extract JAVA_VERSION="25.0.2" -> 25
            local FullVersion=$(grep "^JAVA_VERSION=" "$release_file" | cut -d'"' -f2)
            major_version=$(echo "$FullVersion" | cut -d'.' -f1)
        fi

        # Fallback to parsing name if release file fails (unlikely)
        if [[ -z "$major_version" ]]; then
            if [[ "$jdk_name" == "openjdk" ]]; then
                # Default to a generic name if we can't find version
                dest_name="openjdk.jdk"
            else
                major_version=${jdk_name#openjdk@}
                dest_name="openjdk.${major_version}.jdk"
            fi
        else
            dest_name="openjdk.${major_version}.jdk"
        fi

        dest_path="$JVM_DIR/$dest_name"

        echo "Creating symlink for $jdk_name -> $dest_name"
        sudo ln -sfn "$jdk_path/libexec/openjdk.jdk" "$dest_path"

        # Track this as a managed link so it doesn't get cleaned up
        managed_links[$dest_name]=1
    fi
done

# Cleanup phase: remove any openjdk*.jdk symlinks that we didn't just create/update
echo "Cleaning up stale symlinks in $JVM_DIR..."
for link in $JVM_DIR/openjdk*.jdk; do
    local link_name=$(basename "$link")
    # Only remove it if it's a symlink AND we didn't just manage it
    if [[ -L "$link" ]] && (( ! ${+managed_links[$link_name]} )); then
        echo "Removing stale symlink: $link_name"
        sudo rm "$link"
    fi
done

if [[ $found -eq 0 ]]; then
    echo "No Homebrew OpenJDK installations found."
else
    echo "Done linking OpenJDKs."
fi
