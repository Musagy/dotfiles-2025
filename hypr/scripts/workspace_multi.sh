#!/bin/bash

# Constants
MAX_VIRTUAL_WS=5
MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))
NUMBER_OF_MONITORS=${#MONITORS[@]}

# Function to move workspaces
move_workspaces() {
    local command=$1
    local current_focused_monitor=$2

    # Move non-focused monitors first
    for monitor in "${MONITORS[@]}"; do
        if [ "$monitor" != "$current_focused_monitor" ]; then
            hyprctl dispatch focusmonitor "$monitor"
            hyprctl dispatch workspace $command
        fi
    done

    # Move focused monitor last
    hyprctl dispatch focusmonitor "$current_focused_monitor"
    hyprctl dispatch workspace $command
}

# Main script
ACTION=$1
WS_RAW_FOCUS=$(hyprctl activeworkspace -j | jq -r '.id')
VIRTUAL_WS=$(( (WS_RAW_FOCUS + NUMBER_OF_MONITORS - 1) / NUMBER_OF_MONITORS ))
CURRENT_FOCUSED_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

if [ "$ACTION" == "next" ]; then
    if [ $VIRTUAL_WS -ge $MAX_VIRTUAL_WS ]; then
        move_workspaces "r~1" "$CURRENT_FOCUSED_MONITOR"
    else
        move_workspaces "r+1" "$CURRENT_FOCUSED_MONITOR"
    fi
else
    if [ $VIRTUAL_WS -le 1 ]; then
        move_workspaces "r~$MAX_VIRTUAL_WS" "$CURRENT_FOCUSED_MONITOR"
    else
        move_workspaces "r-1" "$CURRENT_FOCUSED_MONITOR"
    fi
fi