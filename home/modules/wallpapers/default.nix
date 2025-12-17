# home/modules/wallpapers/default.nix
{
  pkgs,
  config,
  lib,
  ...
}: let
  wallpaperScript = pkgs.substituteAll {
    src = ./wallpaper.sh.in;
    isExecutable = true;
    bash = "${pkgs.bash}/bin/bash";
    # We add jq here to parse JSON
    jq = "${pkgs.jq}/bin";
    coreutils = "${pkgs.coreutils}/bin";
    findutils = "${pkgs.findutils}/bin";
    swww = "${pkgs.swww}/bin";
    libnotify = "${pkgs.libnotify}/bin";
    procps = "${pkgs.procps}/bin";
  };
in {
  home.packages = with pkgs; [
    swww
    jq
    procps
  ]; # Ensure jq is installed

  home.file.".local/bin/wallpaper-manager".source = wallpaperScript;

  home.file."Pictures/Wallpapers" = {
    source = ../../assets/wallpapers;
    recursive = true;
  };

  systemd.user.services.wallpaper-cycler = {
    Unit = {
      Description = "Cycle wallpapers using swww";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/wallpaper-manager";
      Type = "oneshot";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };

  systemd.user.timers.wallpaper-cycler = {
    Unit = {Description = "Timer for wallpaper cycling";};
    Timer = {
      OnUnitActiveSec = "15m";
      OnBootSec = "1m";
    };
    Install = {WantedBy = ["timers.target"];};
  };
}
