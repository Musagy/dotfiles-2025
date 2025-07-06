#!/bin/bash

# Número máximo de espacios de trabajo
MAX_WORKSPACES=6

# Obtener el espacio de trabajo actual
CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

if [ "$1" == "next" ]; then
    if [ $CURRENT_WS -ge $MAX_WORKSPACES ]; then
        hyprctl dispatch movetoworkspace r~1
    else
        hyprctl dispatch movetoworkspace r+1
    fi
elif [ "$1" == "prev" ]; then
    if [ $CURRENT_WS -le 1 ]; then
        hyprctl dispatch movetoworkspace r~$MAX_WORKSPACES
    else
        hyprctl dispatch movetoworkspace r-1
    fi
fi