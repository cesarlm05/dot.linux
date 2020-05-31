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

black=0x2f343f
red=0xef6155
green=0x48b685
yellow=0xfec418
blue=0x06b6ef

echo "[bspwm:external:rules] $pid::$wid::$instance.$class.$pname" >> ~/.cache/bspwm/logs/rules.log

case "$instance.$class.$pname" in

	dropdown*) echo "sticky=on state=floating rectangle=1200x600+0+0 border=on center=on";;

	code*) echo "desktop=^2 rectangle=2000x1600+0+0";;

	Dunst*) echo "border=off";;

	kitty*) echo "state=pseudo_tiled rectangle=1280x800+0+0";;

	keep.google.com.*)
		chwb -c $yellow $wid
		echo "state=floating sticky=on"
	;;

	mail.google.com*)
		chwb -c $red $wid
		echo "state=floating sticky=on"
	;;

	web.whatsapp.com.*)
		chwb -c $green $wid
		echo "state=floating sticky=on"
	;;

	www.messenger.com.*)
		chwb -c $blue $wid
		echo "state=floating sticky=on"
	;;

	*spotify) echo "state=floating sticky=on";;
esac
