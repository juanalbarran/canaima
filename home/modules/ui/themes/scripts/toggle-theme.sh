#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"
# configuration
cache_dir="$HOME/.cache/style"
theme_dir="$HOME/.config/themes"

# create cache directory if it doesnt exists
mkdir -p "$cache_dir"

# --- logic ---

# detect current mode (default to dark)
current_mode=$(cat "$cache_dir/mode" 2>/dev/null || echo "dark")

if [ "$current_mode" = "dark" ]; then
  new_mode="light"
  gtk_theme="adwaita"
  prefer_dark="false"
  color_scheme="default"
  # qutebrowser manual variables
  qb_dark_bool="false"
  qb_scheme_str="light"
else
  new_mode="dark"
  gtk_theme="adwaita-dark"
  prefer_dark="true"
  color_scheme="prefer-dark"
  # qutebrowser manual variables
  qb_dark_bool="true"
  qb_scheme_str="light"
fi

echo "switching to $new_mode"

# updating symlinks of style files
ln -sf "$theme_dir/$new_mode/waybar.css" "$cache_dir/waybar-colors.css"
ln -sf "$theme_dir/$new_mode/qutebrowser.py" "$cache_dir/qutebrowser-theme.py"
ln -sf "$theme_dir/$new_mode/ghostty" "$cache_dir/ghostty-theme"
ln -sf "$theme_dir/$new_mode/wofi.css" "$cache_dir/wofi.css"
ln -sf "$theme_dir/$new_mode/foot" "$cache_dir/foot-theme"

# we save the new state
echo "$new_mode" > "$cache_dir/mode"

#ghostty
pkill --signal USR2 ghostty

# waybar
pkill waybar
waybar &

# qutebrowser
qutebrowser ":config-source ;; set colors.webpage.darkmode.enabled $qb_dark_bool ;; set colors.webpage.preferred_color_scheme $qb_scheme_str ;; reload -f" >/dev/null 2>&1 || true

# foot
pkill -HUP foot

if command -v gsettings &> /dev/null; then
  gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
  gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
  # gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme "$prefer_dark"
fi

notify-send "theme switched" "mode: $new_mode"

