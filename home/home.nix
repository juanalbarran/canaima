# home/home.nix
{ config, pkgs, kukenan, system, ... }:

{
  home-manager.users.juan = {
    imports = [
      ./modules/common.nix
      ./modules/ghostty
      ./modules/hyprland
      ./modules/waybar
      ./modules/kanshi
    ];

    home = { 
      username = "juan";
      homeDirectory = "/home/juan";
      stateVersion = "25.05";
    };
  };
}
