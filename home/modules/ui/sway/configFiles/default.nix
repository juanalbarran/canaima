# home/modules/ui/sway/config/default.nix
{
  config,
  lib,
  ...
}: let
  isNixOS = config.hostSpec.isNixOS;
  path =
    if isNixOS
    then ""
    else "$HOME/.nix-profile/bin/";
in {
  xdg.configFile = {
    "sway/config" = lib.mkForce {source = ./config;};
    "sway/variables.conf".text = ''
      # Home row direction keys, like vim
      set $left h
      set $down j
      set $up k
      set $right l

      # these binaries need full path — sway's exec environment only has the system PATH
      set $swaymsg ${path}swaymsg
      set $wallpaper ${path}wallpaper
    '';
    "sway/autostart.conf".source = ./autostart.conf;
    "sway/bindings.conf".source = ./bindings.conf;
    "sway/monitors.conf".source = ./monitors.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
}
