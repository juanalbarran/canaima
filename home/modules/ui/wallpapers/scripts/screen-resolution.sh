#!/usr/bin/env bash

# we get the dimentions using swaymsg
dimensions=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | "\(.rect.width) \(.rect.height)"')

# we separate the values
read -r width height <<< "$dimensions"

# we calculate the ratio
ratio=$(( width * 100 / height ))

if [ "$ratio" -gt 230 ]; then
  screen_type="ultrawide"
elif [ "$ratio" -ge 170 ]; then
  screen_type="wide"
else
  screen_type="normal"
fi

echo "$screen_type"
