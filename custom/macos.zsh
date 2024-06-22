# Show Mac OS system information
alias macinfo='system_profiler SPHardwareDataType'

# Check for system updates on Mac OS
alias macupdates='softwareupdate -l'

# Clear DNS cache on Mac OS
alias cleardns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
