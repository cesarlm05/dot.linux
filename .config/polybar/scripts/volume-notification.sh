#!/bin/sh

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function strep {
 for i in $(seq 1 $2); do
  ret=$ret$1
 done
 echo $ret
}

msgid="99876678"

if is_mute; then
  dunstify -a "volume" -u low -r $msgid "Muted" -i notification-audio-volume-muted
else
  volume=`get_volume`
  icon=medium
  [ "$volume" -lt 30 ] && icon=low
  [ "$volume" -gt 70 ] && icon=high
  width=12
  fw=$(echo "$volume / 100 * $width" | bc --mathlib)
  fw=$(printf "%.0f\n" "$fw")
  echo $fw
  ew=$(( $width - $fw ))
  bar=$(strep "⬤" $fw)
  bar=$bar$(strep "◯" $ew)
  echo $bar
  dunstify "$volume%  $bar" -a volume -u low -r $msgid -i notification-audio-volume-$icon -t 1000
fi
