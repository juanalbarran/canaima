#!/usr/bin/env bash

# Export Nix path so we find commands
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"

set -eu

# --- CONFIGURATION ---
bookmarks_directory="$HOME/.config/bookmarks"

# Browsers
# We define the command AND the WM_CLASS for wmctrl
# You can find a window's class by running 'xprop' and clicking the window
qutebrowser_cmd="$(command -v qutebrowser || true)"
qutebrowser_class="qutebrowser"

brave_cmd="$(command -v brave || command -v brave-browser || true)"
brave_class="brave-browser"

# Move to directory
cd "$bookmarks_directory" || exit

# 1. Prepare Categories
categories=$(for file in *.txt; do
    name="${file%.*}"
    name="${name^}"
    echo "$name"
done)

# 2. Show Category Menu (dmenu)
selected_category=$(echo "$categories" | dmenu -i -l 15 -p "Bookmarks:")

# Check if cancelled
if [ -z "$selected_category" ]; then
    exit 0
fi

filename="${selected_category,,}"
filename="${filename}.txt"

# --- OPEN WITH FUNCTION (DWM / X11) ---
open_with() {
  wm_class="$1"
  cmd="$2"
  target_url="$3"

  # Error check
  if [ -z "$cmd" ] || [ "$cmd" = "true" ]; then 
    echo "Error: Browser command not found."
    return
  fi

  # --- RUN OR RAISE LOGIC ---
  # wmctrl -x -a tries to activate (focus) a window with that class
  if wmctrl -x -a "$wm_class"; then
      # If window found and focused, open the URL in it
      # Browsers handle 'opening in existing window' automatically when you run the command again
      nohup "$cmd" "$target_url" >/dev/null 2>&1 &
  else
      # If window NOT found, launch it fresh
      nohup "$cmd" "$target_url" >/dev/null 2>&1 &
  fi
   
  disown
  exit 0
}

# 3. Show Links Menu
if [ -f "$filename" ]; then
    bookmarks=$(grep -v "^#" "$filename")
    
    # Show links in dmenu
    selected_link=$(echo "$bookmarks" | dmenu -i -l 20 -p "$selected_category Links:")

    if [ -n "$selected_link" ]; then
        url=$(echo "$selected_link" | awk '{print $NF}')
        
        # Notify user
        notify-send "Opening browser" "Target: $url"

        # Pass the WM_CLASS and the COMMAND
        if [ "$filename" = "work.txt" ]; then
            open_with "$brave_class" "$brave_cmd" "$url" >/dev/null 2>&1
        else
            open_with "$qutebrowser_class" "$qutebrowser_cmd" "$url" >/dev/null 2>&1
        fi
    fi
else
    notify-send "Error" "Could not find file: $filename"
    exit 1
fi
