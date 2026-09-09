# Mac OS system information
alias macinfo='system_profiler SPHardwareDataType'

# Mac OS network
alias macdnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias mactimesync='sudo sntp -sS time.apple.com'

# Mac OS caffeine (prevent sleep)
alias macspike='caffeinate -u -t 43200'
