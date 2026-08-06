#!/bin/bash

brightness=$(ddcutil --sleep-multiplier=.1 getvcp 10 | grep -oP 'current value =\s*\K\d+')

if [ "$brightness" -le 25 ]; then
    icon="󰃞"
elif [ "$brightness" -le 60 ]; then
    icon="󰃟"
else
    icon="󰃠"
fi

echo "$icon $brightness%"