#!/bin/sh

inc=${2:-3}
device=/sys/class/backlight/acpi_video0/brightness
current=$(cat $device)
if [ "$1" = "up" ]; then
  current=$(($current + $inc))
else
  current=$(($current - $inc))
fi

[ "$current" -lt 10 ] && current=10
[ "$current" -gt 100 ] && current=100

echo $current > $device