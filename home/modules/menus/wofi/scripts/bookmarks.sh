#!/usr/bin/env bash

# Export Nix path so we find qutebrowser/swaymsg
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"

# Apply software rendering when we are in Sway
if [ -n "${SWAYSOCK:-}" ]; then
    export QT_QUICK_BACKEND=software
fi

set -eu

# Configuration
bookmarks_directory="$HOME/.config/bookmarks"
prebookmarks_conf="$HOME/.config/wofi/prebookmarks-menu.conf"
bookmarks_conf="$HOME/.config/wofi/bookmarks-menu.conf"

qutebrowser="$(command -v qutebrowser || true)"
qutebrowser_id="org.qutebrowser.qutebrowser"

brave="$(command -v brave || command -v brave-browser || true)"
brave_id="brave-browser"

get_height() {
    # Count lines. Note: wc -l usually counts newlines, so we ensure accurate counting
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    # Formula: (lines * 32px per line) + 28px padding
    echo $(( (line_count * 32) + 28 ))
}

# We get the menu with the name of the files
cd "$bookmarks_directory" || exit

categories=$(for file in *.txt; do
    name="${file%.*}"
    name="${name^}"
    echo "$name"
done)

categories_height=$(get_height "$categories")

selected_category=$(echo "$categories" | wofi \
    --conf="$prebookmarks_conf" \
    --height="$categories_height" \
    -p "Bookmarks:" -i)

# Check if a category was selected
if [ -z "$selected_category" ]; then
    exit 0
fi

filename="${selected_category,,}"
filename="${filename}.txt"

open_with() {
  app_id="$1"
  cmd="$2"
  target_url="$3"

  # If command wasn't found, log it and return
  if [ "$cmd" = "true" ] || [ -z "$cmd" ]; then 
    echo "Error: Browser command not found for ID: $app_id"
    return
  fi

  if [ "${XDG_CURRENT_DESKTOP:-}" = "Hyprland" ]; then
      # --- HYPRLAND LOGIC ---
      if hyprctl clients | grep -q "class: $app_id"; then
          hyprctl dispatch focuswindow "class:^$app_id$"
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi

  elif [ -n "${SWAYSOCK:-}" ]; then
      # --- SWAY LOGIC ---
      # Try to focus. If it returns 0 (success), window exists.
      if swaymsg "[app_id=\"$app_id\"] focus"; then
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi
  
  else
      # --- FALLBACK ---
      nohup "$cmd" "$target_url" >/dev/null 2>&1 &
  fi
  
  # Disown the process so it survives script exit
  disown
  exit 0
}


if [ -f "$filename" ]; then
    bookmarks=$(grep -v "^#" "$filename")
    bookmarks_height=$(get_height "$bookmarks")
    selected_link=$(echo "$bookmarks" | wofi \
        --conf="$bookmarks_conf" \
        --height="$bookmarks_height" \
        -p "$selected_category Links:" -i)

    if [ -n "$selected_link" ]; then
        url=$(echo "$selected_link" | awk '{print $NF}')
        if [ "$filename" = "work.txt" ]; then
            open_with "$brave_id" "$brave" "$url" >/dev/null 2>&1
        else
            open_with "$qutebrowser_id" "$qutebrowser" "$url" >/dev/null 2>&1
        fi
        notify-send "Opening browser" "Target: $url"
    fi
else
    notify-send "Error" "Couldnot find file: $filename"
    exit 1
fi

