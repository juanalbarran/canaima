# home/users/juan/default.nix
{...}: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./../../modules/kanshi
    ./../../modules/browsers
    ./../../modules/terminals
    # UI modules
    # ./../../modules/ui/hyprland
    # ./../../modules/ui/hyprlock
    ./../../modules/ui/sway
    ./../../modules/ui/swaylock
    ./../../modules/ui/wallpapers
    ./../../modules/ui/waybar
    ./../../modules/ui/wofi
    ./../../modules/ui/themes
    ./../../modules/ai
  ];

  host.isNixOS = true;

  home = {
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.11";
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };
}
