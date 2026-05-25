#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:$PATH"

show_page() {
    clear
    echo "$1"
    read -n 1 -s -r
}

SYSTEM_TEXT='
   SYSTEM KEYBINDINGS
   ====================================================================
   KEY                         DESCRIPTION

   Run or Raise
   Super + Q                   Primary terminal
   Super + Shift + Q           Auxiliary terminal
   Super + A                   AI / Gemini
   Super + B                   Browser
   Super + S                   Slack
   Super + F                   Firefox
   Super + G                   Google Chrome
   Super + Shift + F           Factorio

   Screenshots
   Print                       Full screen → file
   Shift + Print               Area → file
   Ctrl + Print                Area → clipboard

   Actions
   Super + C                   Kill focused window
   Super + Shift + C           Reload config
   Super + Shift + E           Exit session
   Super + Ctrl + Q            Lock screen
   Super + Shift + Ctrl + T    Toggle theme

   Menus
   Super + D                   App launcher
   Super + M                   Bookmarks
   Super + P                   Projects
   Super + Shift + P           Projects (CTwo)

   Misc
   Super + Shift + W           Change wallpaper
   Super + Shift + /           Show keybinds (you are here)
   Super + Shift + I           Network manager
   ====================================================================
   (Press any key to go back)'

NEOVIM_TEXT='
   NEOVIM KEYBINDINGS
   ====================================================================

   (neovim keybinds go here)

   ====================================================================
   (Press any key to go back)'

main_menu() {
    while true; do
        clear
        echo ""
        echo "   KEYBINDINGS"
        echo ""
        PS3="   Choose a section: "
        select opt in "System" "Neovim" "Quit"; do
            case $opt in
                "System") show_page "$SYSTEM_TEXT"; break ;;
                "Neovim") show_page "$NEOVIM_TEXT"; break ;;
                "Quit")   exit 0 ;;
                *)        break ;;
            esac
        done
    done
}

main_menu
