#!/bin/bash

# Get the default network interface
INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

# If no default interface, try to get any active interface
if [ -z "$INTERFACE" ]; then
    INTERFACE=$(ip link show | grep 'state UP' | grep -v 'lo:' | awk -F': ' '{print $2}' | head -n1)
fi

# If still no interface, exit
if [ -z "$INTERFACE" ]; then
    echo '{"text":"󰈀 N/A","tooltip":"No network interface found"}'
    exit 0
fi

# Read initial values
RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)

# Wait 1 second
sleep 1

# Read final values
RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)

# Calculate speeds in bytes per second
RX_SPEED=$((RX2 - RX1))
TX_SPEED=$((TX2 - TX1))

# Function to format bytes to human readable (in bits per second)
format_speed() {
    local speed=$1
    local bits=$((speed * 8))

    if [ $bits -lt 1000 ]; then
        echo "${bits}bps"
    elif [ $bits -lt 1000000 ]; then
        echo "$(awk "BEGIN {printf \"%.1f\", $bits/1000}")Kbps"
    else
        echo "$(awk "BEGIN {printf \"%.1f\", $bits/1000000}")Mbps"
    fi
}

DOWN=$(format_speed $RX_SPEED)
UP=$(format_speed $TX_SPEED)

# Show only download speed, with both speeds in tooltip
echo "{\"text\":\"󰇚 $DOWN\",\"tooltip\":\"Interface: $INTERFACE\\nDownload: $DOWN\\nUpload: $UP\",\"class\":\"network-speed\"}"
