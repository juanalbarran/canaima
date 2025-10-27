{ pkgs, ... }:
{
  xdg.configFile = {
    "waybar/config".source = ./waybar.jsonc;
    "waybar/style.css".source = ./waybar-style.css;
  };
}
