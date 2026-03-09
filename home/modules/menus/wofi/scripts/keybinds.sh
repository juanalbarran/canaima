#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:$PATH"
# Function to display text cleanly without a pager
display_hud() {
    clear
    echo "$1"
    # Wait for a single keypress silently (-s) and without return (-n 1)
    read -n 1 -s -r
}

# Define the text for Hyprland
HYPR_TEXT='

   HYPRLAND KEYBINDINGS
   ==============================================================
   KEY                     DESCRIPTION
   
   SUPER + Q                 Ghostty
   SUPER + B                Firefox
   SUPER + A                Gemini
   SUPER + E               File Manager
   SUPER + R               Application Menu
   SUPER + C               󰧻 Kill Active Window
   SUPER + V               Toggle Floating
   SUPER + P               Pseudo Tiling (Dwindle)
   SUPER + T               Toggle Split (Dwindle)
   SUPER + S               Toggle Special Workspace (Scratchpad)
   SUPER + /                Show Keybindings (You are here)
   
   SUPER + SHIFT + W       Change Wallpaper
   SUPER + SHIFT + S       Move Active to Special Workspace
   SUPER + CTRL + Q        Lock Screen
   SUPER + CTRL + K        Launch Kitty
   SUPER + M               Exit Hyprland
   
   Print                   Screenshot (Whole Screen)
   CTRL + Print            Screenshot (Active Window)
   SHIFT + Print           Screenshot (Selected Area)
   ==============================================================
   (Press any key to close)'

# Define the text for Sway
SWAY_TEXT='

   SWAY KEYBINDINGS
   ====================================================================
   KEY                     DESCRIPTION
   
   SUPER + q                 Ghostty
   SUPER + b                Firefox
   SUPER + a                Gemini
   SUPER + d               Start Launcher
   SUPER + c               󰧻 Kill Active Window
   SUPER + /                Show Keybindings (You are here)
   
   PRINT                   Screenshot -> ~/Pictures/screenshots/
   PRINT + Shift           Screenshot Area -> ~/Pictures/screenshots/
   PRINT + CRTL            Screenshot Area -> Clipboard
   
   SUPER + Shift + w       Change Wallpaper
   SUPER + Shift + i       Network Manager (Floating)
   SUPER + Shift + c       Reload Sway Config
   SUPER + Shift + e       Exit Sway Session
   
   SUPER + Ctrl + q        Lock Screen
   
   SUPER + Shift + Space   Toggle Floating Mode
   SUPER + Space           Swap Focus (Tiling <-> Floating)
   SUPER + Shift + Minus   Move Window to Scratchpad
   SUPER + Minus           Cycle Scratchpad Windows
   SUPER + r               Enter Resize Mode
   ====================================================================
   (Press any key to close)'

# Detect Environment and Run
if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    display_hud "$HYPR_TEXT"
elif [ -n "$SWAYSOCK" ]; then
    display_hud "$SWAY_TEXT"
else
    echo "Unknown Environment."
    read -n 1 -s -r
fi
