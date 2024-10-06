#!/bin/bash
swayidle -w \
  timeout 300 'hyprlock -f'  
  timeout 900 'hyprctl dispatch dpms off' after-resume 'hyprctl dispatch dpms on'  
  timeout 1200 'systemctl suspend -i'  
  before-sleep 'hyprlock -f --grace 0'
