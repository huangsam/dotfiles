#!/bin/zsh

# Copy hidden files to home directory
for fl in .*; do
    # Skip directories and internal repo files
    case "$fl" in
        .git|.gitignore|.DS_Store) continue ;;
        *) [[ -d "$fl" ]] && continue ;;
    esac

    if [[ -n "${FORCE:-}" ]]; then
        cp -f "$fl" "$HOME/$fl"
    else
        cp -n "$fl" "$HOME/$fl"
    fi
done

# Indicate completion
echo -e "$0 complete! ✨ 🍰 ✨"
