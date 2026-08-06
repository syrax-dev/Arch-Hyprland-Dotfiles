#!/bin/bash

BATTERY_DIR=$(find /sys/class/power_supply -maxdepth 1 -name "ps-controller-battery-*" | head -n1)

[ -z "$BATTERY_DIR" ] && exit 0

BAT=$(<"$BATTERY_DIR/capacity")
STATUS=$(<"$BATTERY_DIR/status")

if [ "$STATUS" = "Charging" ]; then
    printf '{"text":"󰊴 %s%% 󰂄"}' "$BAT"
else
    printf '{"text":"󰊴 %s%%"}' "$BAT"
fi
