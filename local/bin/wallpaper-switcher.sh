#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.cache/wallpaper-current"

mkdir -p ~/.cache

mapfile -t WALLS < <(find "$WALL_DIR" \
-type f \( \
-iname "*.jpg" -o \
-iname "*.jpeg" -o \
-iname "*.png" -o \
-iname "*.webp" \
\) | sort)

TOTAL=${#WALLS[@]}

[ $TOTAL -eq 0 ] && exit 1

if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

INDEX=$(cat "$STATE_FILE")

if [ "$INDEX" -ge "$TOTAL" ]; then
    INDEX=0
fi

WALL="${WALLS[$INDEX]}"

TRANSITIONS=(
    fade
    wipe
    grow
    center
    wave
    outer
)

TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

pgrep swww-daemon >/dev/null || swww-daemon &

sleep 0.3

swww img "$WALL" \
    --transition-type "$TRANSITION" \
    --transition-fps 144 \
    --transition-duration 1

NEXT=$(( (INDEX + 1) % TOTAL ))

echo "$NEXT" > "$STATE_FILE"
