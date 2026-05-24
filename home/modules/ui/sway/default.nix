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
    ./configFiles
  ];
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    config = null;
  };
  xdg.dataFile."wayland-sessions/sway.desktop" = lib.mkIf (!isNixOS) {
    text = ''
      [Desktop Entry]
      Name=Sway
      Comment=An i3-compatible Wayland compositor
      Exec=${config.home.homeDirectory}/.nix-profile/bin/sway
      Type=Application
    '';
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
