#!/bin/bash

case "$1" in
    up)
        ddcutil --sleep-multiplier=.1 setvcp 10 + 5
        ;;
    down)
        ddcutil --sleep-multiplier=.1 setvcp 10 - 5
        ;;
esac

pkill -RTMIN+8 waybar
