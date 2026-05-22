# home/modules/sway/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  isNixOS = config.hostSpec.isNixOs;
in {
  imports = [
    ./special-binds
    ./configFiles
  ];
  wayland.windowManager.sway = {
    package =
      if isNixOS
      then pkgs.sway
      else null;
    config = null;
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
