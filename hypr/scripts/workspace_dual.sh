#!/bin/bash

# Constants
MAX_VIRTUAL_WS=5

# Function to move workspaces on both monitors
move_workspaces() {
    local command=$1
    
    hyprctl dispatch focusmonitor $MONITOR_NONFOCUSED
    hyprctl dispatch workspace $command
    hyprctl dispatch focusmonitor $MONITOR_FOCUSED
    hyprctl dispatch workspace $command
}

# Function to determine monitors
setup_monitors() {
    if [ $((WS_RAW_FOCUS % 2)) -eq 0 ]; then
        MONITOR_FOCUSED="HDMI-A-1"
        MONITOR_NONFOCUSED="DP-1"
    else
        MONITOR_FOCUSED="DP-1"
        MONITOR_NONFOCUSED="HDMI-A-1"
    fi
}

# Main script
ACTION=$1
WS_RAW_FOCUS=$(hyprctl activeworkspace -j | jq -r '.id')
VIRTUAL_WS=$(( (WS_RAW_FOCUS + 1) / 2 ))

setup_monitors

if [ "$ACTION" == "next" ]; then
    if [ $VIRTUAL_WS -ge $MAX_VIRTUAL_WS ]; then
        move_workspaces "r~1"
    else
        move_workspaces "r+1"
    fi
else
    if [ $VIRTUAL_WS -le 1 ]; then
        move_workspaces "r~$MAX_VIRTUAL_WS"
    else
        move_workspaces "r-1"
    fi
fi