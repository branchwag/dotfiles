#!/usr/bin/env bash

# Note that this is from following a lovely tutorial by YSAP here:
#   https://www.youtube.com/watch?v=U4CzyBXyOms
# Go visit his GitHub and star it! :D 
# https://github.com/bahamas10/ysap/blob/main/code/2025-08-21-progress-bar/progress-bar

BATCHSIZE=1

#pretty colors
RED=$'\e[31m'
GREEN=$'\e[32m'
RESET=$'\e[0m'

progress-bar() {
    local current=$1
    local len=$2

    local bar_char='|'
    local empty_char=' '
    local length=50
    local perc_done=$((current * 100 / len))
    local num_bars=$((perc_done * length / 100))

    #color: red while loading, green when done
    local color="$RED"
    if (( current == len )); then
        color="$GREEN"
    fi

    #build colored sections (apply color once!)
    local filled=$(printf "%${num_bars}s" | tr ' ' "$bar_char")
    local empty=$(printf "%$((length - num_bars))s" | tr ' ' "$empty_char")

    #draw bar
    printf "\r[%s%s%s] %d/%d (%d%%)" \
        "${color}${filled}${RESET}" \
        "$empty" \
        "$RESET" \
        "$current" "$len" "$perc_done"
}

process-files() {
    local files=("$@")
    sleep .01
}

shopt -s globstar nullglob

echo 'finding files'
files=(./**/*cache)
len=${#files[@]}
echo "found $len files"

for ((i = 0; i < len; i += BATCHSIZE)); do
    progress-bar "$((i+1))" "$len"
    process-files "${files[@]:i:BATCHSIZE}"
done

# Final green bar
progress-bar "$len" "$len"
echo
