# Mac OS system information
alias macinfo='system_profiler SPHardwareDataType'

# Mac OS updates
alias macsoft='softwareupdate'
alias softcheck='macsoft -l'
alias softrun='sudo macsoft -i -a -R'

# Mac OS network
alias cleardns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
