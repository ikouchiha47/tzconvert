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

    set -l cache_file "/tmp/tzcomplete_cache.txt"
    set -l tzdir "/usr/share/zoneinfo"

    # Check if cache exists and is recent (less than 1 day old)
    if test -f $cache_file
        set -l cache_mtime (date -r $cache_file +%s)
        set -l current_time (date +%s)
        set -l day_in_seconds 86400

        if test (math $current_time - $cache_mtime) -lt $day_in_seconds
            # If cache is recent, read from it
            set -l timezones (cat $cache_file)
        end
    end

    # Otherwise, rebuild the cache
    if not set -q timezones

        find "$tzdir" -type f  \
        -exec file {} + | \
        grep 'timezone data (fat)' | \
        awk -F':' '{print $1}' | sed "s|$tzdir/||" > $cache_file

        set timezones (cat $cache_file)
    end

    # Provide completion based on the number of arguments
    switch (count $argv)
        case 1
            # If only one argument, complete the 'from' timezone
            _describe 'to timezone' timezones
        case 2
            _describe 'from timezone' timezones
        case '*'
            return 0
    end

    cat $cache_file
end

complete -c tzconvert -a "(_tzcomplete)" #-n '__fish_use_subcommand'
