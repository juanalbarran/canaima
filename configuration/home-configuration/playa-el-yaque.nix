# configuration/home-configuration/playa-el-yaque.nix
{pkgs, ...}: {
  imports = [
    # ui: sway, waybar, wallpapers, themes, and wofi
    ./../../home/modules/ui/sway
    ./../../home/modules/ui/waybar
    ./../../home/modules/ui/wallpapers
    ./../../home/modules/ui/themes
    ./../../home/modules/ui/wofi
    ./../../home/modules/kanshi # -> i'm i actually using this?
    # browsers
    ./../../home/modules/browsers
    # terminals
    ./../../home/modules/terminals
    # tui
    ./../../home/modules/tui/gazelle
    # ai: opencode
    ./../../home/modules/ai
  ];
}
