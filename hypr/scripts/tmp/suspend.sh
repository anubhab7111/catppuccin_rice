#!/bin/bash
swayidle -w \
timeout 300 'hyprlock' \
timeout 500 ' hyprctl dispatch dpms off' \
timeout 12000 'systemctl suspend' \
resume ' hyprctl dispatch dpms on' \
before-sleep 'hyprlock'
