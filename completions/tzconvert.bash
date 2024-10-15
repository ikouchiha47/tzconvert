_tzcomplete_bash() {
    local cache_file="/tmp/tzcomplete_cache.txt"
    local tzdir="/usr/share/zoneinfo"
    
    # Check if cache exists and is recent (less than 1 day old)
    if [[ -f "$cache_file" && $(($(date +%s) - $(date +%s -r "$cache_file"))) -lt 86400 ]]; then
        mapfile -t timezones < "$cache_file"
    else
        # Rebuild the cache if it doesn't exist or is outdated
        find /usr/share/zoneinfo/ -type f  \
            -exec file {} + | \
            grep 'timezone data (fat)' | \
            awk -F':' '{print $1}' | \
            sed "s|$tzdir/||" > "$cache_file"

        mapfile -t timezones < "$cache_file"
    fi
    
    # Complete the second argument (timezone)
    if [[ ${COMP_CWORD} -eq 2 ]]; then
        COMPREPLY=($(compgen -W "${timezones[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
    fi
}

# Register the completion function for tzconvert
complete -F _tzcomplete_bash tzconvert
