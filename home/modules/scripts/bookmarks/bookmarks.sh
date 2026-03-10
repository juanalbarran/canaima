#!/usr/bin/env bash

# Export Nix path so we find qutebrowser/swaymsg
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"

# --- Parameter Parser ---
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <menu_command> [menu_args...]"
  exit 1
fi

# Capture the command and all base arguments into an array
MENU_CMD=("$@")
MENU_PROG="$1" 

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
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    echo $(( (line_count * 32) + 28 ))
}

# --- MENU WRAPPER FUNCTION ---
run_menu() {
    local prompt="$1"
    local input_data="$2"
    local conf_file="${3:-}"
    local height_val="${4:-}"

    if [[ "$MENU_PROG" == *"wofi"* ]]; then
        echo "$input_data" | "${MENU_CMD[@]}" --conf="$conf_file" --height="$height_val" -p "$prompt"
    else
        echo "$input_data" | "${MENU_CMD[@]}" -p "$prompt"
    fi
}

# We get the menu with the name of the files
cd "$bookmarks_directory" || exit

categories=$(for file in *.txt; do
    name="${file%.*}"
    name="${name^}"
    echo "$name"
done)

categories_height=$(get_height "$categories")

# Execute the Category Menu
selected_category=$(run_menu "Bookmarks:" "$categories" "$prebookmarks_conf" "$categories_height")

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

  if [ "$cmd" = "true" ] || [ -z "$cmd" ]; then 
    echo "Error: Browser command not found for ID: $app_id"
    return
  fi

  if [ "${XDG_CURRENT_DESKTOP:-}" = "Hyprland" ]; then
      if hyprctl clients | grep -q "class: $app_id"; then
          hyprctl dispatch focuswindow "class:^$app_id$"
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi
  elif [ -n "${SWAYSOCK:-}" ]; then
      if swaymsg "[app_id=\"$app_id\"] focus"; then
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi
  else
      nohup "$cmd" "$target_url" >/dev/null 2>&1 &
  fi
  
  disown
  exit 0
}

if [ -f "$filename" ]; then
    bookmarks=$(grep -v "^#" "$filename")
    bookmarks_height=$(get_height "$bookmarks")
    
    # Execute the Links Menu
    selected_link=$(run_menu "$selected_category Links:" "$bookmarks" "$bookmarks_conf" "$bookmarks_height")

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

