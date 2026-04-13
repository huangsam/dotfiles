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
