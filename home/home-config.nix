# home/home-config.nix
{ ... }:
{
  imports = [
    ./modules/common.nix
    ./modules/ghostty
    ./modules/hyprland
    ./modules/waybar
    ./modules/kanshi
    ./modules/extras
    ./modules/tmux
    ./modules/starship
  ];

  home = {
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.05";
  };
}
