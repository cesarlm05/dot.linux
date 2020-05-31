#!/usr/bin/bash

# General Syntax
#     rule COMMANDS
#
# Commands
#     -a, --add (<class_name>|*)[:(<instance_name>|*)] [-o|--one-shot]
#     [monitor=MONITOR_SEL|desktop=DESKTOP_SEL|node=NODE_SEL] [state=STATE] [layer=LAYER]
#     [split_dir=DIR] [split_ratio=RATIO]
#     [(hidden|sticky|private|locked|marked|center|follow|manage|focus|border)=(on|off)]
#     [rectangle=WxH+X+Y]
#         Create a new rule.
#
#     -r, --remove ^<n>|head|tail|(<class_name>|*)[:(<instance_name>|*)]...
#         Remove the given rules.
#
#     -l, --list
#         List the rules.

wid=$1
class=$2
instance=$3
pid=$(xdotool getwindowpid $wid)
pname=$(ps -p $pid -o comm=)

echo "[bspwm:external:rules] $pid::$wid::$instance.$class.$pname" >> ~/.cache/bspwm/logs/rules.log


case "$instance.$class.$pname" in
	keep.google.com.*) echo "state=floating sticky=on";;

	*spotify) echo "state=floating sticky=on";;
esac
