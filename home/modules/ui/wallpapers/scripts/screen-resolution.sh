#!/usr/bin/env bash

# we get the dimentions using swaymsg
dimentions=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | "\(.rect.width) \(.rect.height)"')

# we separate the values
read -r width height <<< "$dimentions"

# we calculate the ratio
ratio=$(( width * 100 / height ))

if [ "$ratio" -gt 200 ]; then
  screen_type="wide"
else
  screen_type="normal"
fi

echo "$screen_type"
