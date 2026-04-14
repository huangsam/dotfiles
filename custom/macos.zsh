# Enable Mac OS key remapping
mackeyon() {
    local keymap_file="$HOME/.keymap.json"
    if [[ ! -f "$keymap_file" ]]; then
        echo "Error: keymap.json not found at $keymap_file"
        return 1
    fi

    local mapping=$(jq '.mappings[0]' "$keymap_file")
    local src=$(echo "$mapping" | jq -r '.src')
    local dst=$(echo "$mapping" | jq -r '.dst')
    hidutil property --set "{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":${src},\"HIDKeyboardModifierMappingDst\":${dst}}]}"
}

# Disable Mac OS key remapping
mackeyoff() {
    hidutil property --set '{"UserKeyMapping":[]}'
}

# Mac OS system information
alias macinfo='system_profiler SPHardwareDataType'

# Mac OS updates
alias macsoft='softwareupdate'
alias macsoftlist='macsoft -l'

# Mac OS network
alias macdnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias mactimesync='sudo sntp -sS time.apple.com'

# Mac OS files
alias macshow='defaults write com.apple.finder AppleShowAllFiles -bool TRUE && killall finder'
alias machide='defaults write com.apple.finder AppleShowAllFiles -bool FALSE && killall finder'
