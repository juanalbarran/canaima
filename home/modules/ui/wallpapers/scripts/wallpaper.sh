#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:$PATH"

# configuration
cache_dir="$HOME/.cache/style"
state_file="$cache_dir/mode"
base_wallpaper_dir="$HOME/Pictures/Wallpapers"

# logic

# identify the current mode (light/dark)
current_mode=$(cat "$state_file" 2>/dev/null || echo "dark")
echo "The current mode is: $current_mode mode"
# identififying current screen resolution
resolution="$(screen-resolution)"

# now we can get the wallpaper_dir
wallpaper_dir="$base_wallpaper_dir/$resolution/$current_mode/"

# select a random wallpaper
selected_wallpaper=$(find -L "$wallpaper_dir" -type f 2>/dev/null | shuf -n 1)

if [ -z "$selected_wallpaper" ]; then
  echo "Error: No wallpapers found in $wallpaper_dir"
  exit 1
fi

# set the wallpaper
swaymsg "output * bg '$selected_wallpaper' fill"

