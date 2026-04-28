#!/bin/bash

# YouTube Video Clipper - Bash version
# Dependencies: yt-dlp, ffmpeg

# check depends
if ! command -v yt-dlp &> /dev/null || ! command -v ffmpeg &> /dev/null; then
    echo "Error: This script requires yt-dlp and ffmpeg"
    exit 1
fi

# check args
if [ $# -lt 3 ]; then
    echo "Usage: $0 <youtube_url> <start_time> <end_time> [output_directory]"
    echo "Example: $0 https://www.youtube.com/watch?v=pKAnDcqInb4 21:40 22:00"
    exit 1
fi

URL="$1"
START="$2"
END="$3"
OUTPUT_DIR="${4:-.}"  # Default to current directory

#create tmp directory
TEMP_DIR="/tmp/youtube_clip_$$"
mkdir -p "$TEMP_DIR"

# Generate a base filename (without extension)
TEMP_BASE="$TEMP_DIR/video_$$"

echo "Downloading video from: $URL"
# Use -o without extension so yt-dlp can choose the correct one
yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" -o "$TEMP_BASE.%(ext)s" "$URL"

# Find the downloaded file (could be mp4, webm, mkv, etc.)
TEMP_FILE=$(find "$TEMP_DIR" -type f -not -name "*.part" | head -n 1)

if [ -z "$TEMP_FILE" ] || [ ! -f "$TEMP_FILE" ]; then
    echo "Error: Download failed or file not found in $TEMP_DIR"
    ls -la "$TEMP_DIR"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Downloaded file: $TEMP_FILE"

# Get video title for the output filename
TITLE=$(yt-dlp --get-title "$URL" | sed 's/[^a-zA-Z0-9]/_/g')

# Convert timestamps to seconds
function time_to_seconds() {
    local TIME=$1
    if [[ $TIME =~ ^[0-9]+$ ]]; then
        # It's already in seconds
        echo $TIME
    elif [[ $TIME =~ ^[0-9]+:[0-9]+$ ]]; then
        # It's MM:SS
        local MINS=$(echo $TIME | cut -d: -f1)
        local SECS=$(echo $TIME | cut -d: -f2)
        echo $((MINS*60 + SECS))
    elif [[ $TIME =~ ^[0-9]+:[0-9]+:[0-9]+$ ]]; then
        # It's HH:MM:SS
        local HOURS=$(echo $TIME | cut -d: -f1)
        local MINS=$(echo $TIME | cut -d: -f2)
        local SECS=$(echo $TIME | cut -d: -f3)
        echo $((HOURS*3600 + MINS*60 + SECS))
    else
        echo "Error: Invalid time format: $TIME"
        exit 1
    fi
}

START_SECONDS=$(time_to_seconds "$START")
END_SECONDS=$(time_to_seconds "$END")
DURATION=$((END_SECONDS - START_SECONDS))

# create output filename
OUTPUT_FILE="$OUTPUT_DIR/${TITLE}_${START//:/}-${END//:/}.mp4"

echo "Extracting clip from $START to $END..."
ffmpeg -i "$TEMP_FILE" -ss "$START_SECONDS" -t "$DURATION" -c:v libx264 -c:a aac "$OUTPUT_FILE" -y

# Check if ffmpeg was successful
if [ $? -eq 0 ]; then
    echo "Clip saved to: $OUTPUT_FILE"
else
    echo "Error: Failed to create clip"
fi

# Clean up
rm -rf "$TEMP_DIR"
