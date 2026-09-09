# Convert video (MOV, MP4, etc.) to optimized GIF using ffmpeg
mov2gif() {
    if [[ -z "$1" ]]; then
        print -u2 -r -- "Usage: mov2gif <input_file> [width] [fps]"
        return 1
    fi

    local input="$1"
    if [[ ! -f "$input" ]]; then
        print -u2 -r -- "Error: File '$input' not found"
        return 1
    fi

    local width="${2:-800}"
    local fps="${3:-15}"
    local output="${input%.*}.gif"

    print -r -- "Converting '$input' to '$output' (width: ${width}px, fps: ${fps})..."

    ffmpeg -i "$input" -vf "fps=${fps},scale=${width}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$output"

    print -r -- "Done! Saved as '$output'"
}

# Print DrawThings prompt and generation settings
dtprompt() {
    exiftool -s3 -XMP-dc:Description ${1:-**/*.png(Nom[1])}
}

# Fuzzy search DrawThings generation prompts
dtfind() {
    local dir="${1:-.}"
    exiftool -T -Directory -FileName -XMP-dc:Description "$dir" -r 2>/dev/null \
        | awk -F'\t' '$3 != "" && $3 != "-" {print $1"/"$2 "\t" $3}' \
        | fzf --delimiter='\t' --with-nth=2 --preview 'echo {2}' --preview-window=down:wrap \
        | cut -f1
}

# Download video or audio streams via yt-dlp
alias ytdl='yt-dlp'
