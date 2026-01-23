#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"
# Configuration
cache_dir="$HOME/.cache/style"
theme_dir="$HOME/.config/themes"

# Create cache directory if it doesnt exists
mkdir -p "$cache_dir"

# --- Logic ---

# Detect current mode (default to dark)
current_mode=$(cat "$cache_dir/mode" 2>/dev/null || echo "dark")

if [ "$current_mode" = "dark" ]; then
  new_mode="light"
  gtk_theme="Adwaita"
else
  new_mode="dark"
  gtk_theme="Adwaita-dark"
fi

echo "Switching to $new_mode"

# Updating symlinks of style files
ln -sf "$theme_dir/$new_mode/waybar.css" "$cache_dir/waybar-colors.css"

# we save the new state
echo "$new_mode" > "$cache_dir/mode"

# waybar
pkill waybar
waybar &

if command -v gsettings &> /dev/null; then
  gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-$new_mode"
fi

notify-send "Theme Switched" "Mode: $new_mode"

