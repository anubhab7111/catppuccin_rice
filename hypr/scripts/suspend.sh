#!/bin/bash
swayidle -w \
  timeout 900 'systemctl suspend' \
  resume 'notify-send "Resumed"'

