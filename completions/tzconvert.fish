# ~/.config/fish/completions/tzcompletions.fish

# Define a function that provides timezone completions
function _tzcomplete
    set -l cache_file "/tmp/tzcomplete_cache.txt"
    set -l tzdir "/usr/share/zoneinfo"

    # Check if cache file exists and is newer than 1 day
    if test -f $cache_file
        # Use stat to get the modification time of the cache file
        set -l cache_mtime (date -r $cache_file +%s)
        set -l current_time (date +%s)
        set -l day_in_seconds 86400

        if test (math $current_time - $cache_mtime) -lt $day_in_seconds
            # If cache is recent, read from it
            cat $cache_file
            return
        end
    end

    find "$tzdir" -type f  -exec file {} + | grep 'timezone data (fat)' | awk -F':' '{print $1}' | sed "s|$tzdir/||" > $cache_file
    cat $cache_file
end

# Use the completion for the second argument (timezone)
complete -c tzconvert -a "(_tzcomplete)" -n '__fish_use_subcommand'
