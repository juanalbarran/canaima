#!/bin/sh
set -eu

# Set your terminal:
terminal="st"
terminal_app_id="st"

# Paths
projects_path="$HOME/dev"
vim_path="$HOME/.nix-profile/bin/nvim-base"
bash_path="$HOME/.nix-profile/bin/bash"
cache_file="$HOME/.cache/dmenu_projects_history"

# Set your dmenu flags
# dmenu="$HOME/.nix-profile/bin/dmenu"
dmenu="dmenu"

# Check if the cache file exists
if [ ! -f "$cache_file" ]; then
    mkdir -p "$(dirname "$cache_file")"
    touch "$cache_file"
fi

all_projects=$(find "$projects_path" -mindepth 1 -maxdepth 1 -type d -printf "%f\n") 
sorted_list=$( (cat "$cache_file"; echo "$all_projects") | awk '!seen[$0]++' )

# Pick repo
selected_name="$(echo "$sorted_list" | $dmenu -l 30 -fn "JetBrainsMono Nerd Font:size=12" -p "Projects:")"
[ -n "$selected_name" ] || exit 0

selected_path="$projects_path/$selected_name"

if [ ! -d "$selected_path" ]; then
    notify-send "Project Error" "Directory $selected_name does not exist."
    grep -vxF "$selected_name" "$cache_file" > "${cache_file}.tmp" && mv "${cache_file}.tmp" "$cache_file"
    exit 1
fi

{ echo "$selected_name"; grep -vxF "$selected_name" "$cache_file"; } > "${cache_file}.tmp" && mv "${cache_file}.tmp" "$cache_file"

session_name=$(echo "$selected_name" | tr . _)

if ! tmux has-session -t "$session_name" 2>/dev/null; then

    tmux new-session \
        -d -s "$session_name" \
        -n "editor" \
        -c "$selected_path" "$vim_path; exec $bash_path"
    tmux new-window \
        -t "$session_name" \
        -n "console" \
        -c "$selected_path" "exec $bash_path"
    tmux new-window \
        -t "$session_name" \
        -n "lazygit" \
        -c "$selected_path" "lazygit; exec $bash_path"

    project_config="$selected_path/.tmux-init.conf"

    if [ -f "$project_config" ]; then
        SESSION="$session_name" . "$project_config"
    else
        tmux select-window -t "${session_name}:editor"
    fi
fi

if wmctrl -x -l | grep -q "$terminal_app_id"; then
    wmctrl -x -a "$terminal_app_id"
    tmux list-clients -F "#{client_tty}" | while read -r tty; do
        tmux switch-client -c "$tty" -t "$session_name"
    done
else
    $terminal -n "$terminal_app_id" -e tmux attach-session -t "$session_name"
fi

