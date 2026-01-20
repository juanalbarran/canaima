#!/bin/sh
set -eu

# Set your terminal:
terminal="st"
terminal_app_id="st"

# Paths
projects_path="$HOME/dev"
vim_path="$HOME/.nix-profile/bin/nvim-base"
bash_path="$HOME/.nix-profile/bin/bash"

# Set your dmenu flags
# dmenu="$HOME/.nix-profile/bin/dmenu"
dmenu="dmenu"

# Pick repo
selected_name="$(find "$projects_path" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | $dmenu -l 30 -fn "JetBrainsMono Nerd Font:size=12" -p "Projects:")"
[ -n "$selected_name" ] || exit 0

selected_path="$projects_path/$selected_name"
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
        tmux switch-client -c "$tty" =t "$session_name"
    done
else
    $terminal -n "$terminal_app_id" -e tmux attach-session -t "$session_name"
fi
# if tmux switch-client -t "$session_name" 2>/dev/null; then
#     wmctrl -x -a "$terminal_app_id"
# else
#     $terminal -e tmux attach-session -t "$session_name"
# fi

