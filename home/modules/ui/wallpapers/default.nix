# home/modules/wallpapers/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = pkgs.writeShellScriptBin "wallpaper" (builtins.readFile ./scripts/wallpaper.sh);
  screen-resolution = pkgs.writeShellScriptBin "screen-resolution" (builtins.readFile ./scripts/screen-resolution.sh);
in {
  home.packages = with pkgs; [
    wallpaper
    screen-resolution
  ];
  home.file."Pictures/Wallpapers" = {
    source = ../../../assets/wallpapers;
    recursive = true;
  };
  systemd.user = {
    services.wallpaper-manager = {
      Unit = {
        Description = "Select a random wallpaper and the change it";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        Environment = "PATH=%h/.nix-profile/bin:/run/current-system/sw/bin:/usr/bin:/bin";
        ExecStart = "${wallpaper}/bin/wallpaper";
      };
    };
    timers.wallpaper-manager = {
      Unit = {
        Description = "Timer to update wallpapaer every 5 minutes";
      };
      Timer = {
        OnBootSec = "1m";
        OnUnitActiveSec = "5m";
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
