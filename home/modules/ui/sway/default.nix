# home/modules/sway/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  isNixOS = config.hostSpec.isNixOS;
in {
  imports = [
    ./special-binds
    ./configFiles
  ];
  wayland.windowManager.sway = {
    package =
      if config.host.isNixOS
      then pkgs.sway
      else null;
    checkConfig = true;
    config = {
      extraConfig = builtins.readFile ./config;
    };
  };
  home = {
    packages = with pkgs; [
      grim
      slurp
      wtype
      wev
    ];
    activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/Pictures/screenshots
    '';
  };
}
