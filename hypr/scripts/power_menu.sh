#!/bin/bash

chosen=$(echo -e "⏻ Power Off\n Reboot\n Logout\n󰍁 Suspend\n Lock" | \
    wofi --dmenu \
         --width=400 \
         --height=300 \
         --prompt "" \
         --insensitive \
         --cache-file=/dev/null)

case "$chosen" in
    "⏻ Power Off") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Logout") hyprctl dispatch exit ;;
    "󰍁 Suspend") systemctl suspend ;;
    " Lock") hyprlock ;;
    *) exit 1 ;;
esac

