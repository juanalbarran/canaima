# home/modules/wallpapers/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.canaima-wallpapers;

  # 1. Determine the command prefix (Wrap with nixGL on Ubuntu)
  nixGLPrefix =
    if cfg.withNixGL
    then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL "
    else "";

  # 2. Prepare the script with explicit paths for the commands
  scriptFile = pkgs.replaceVars ./wallpaper.sh.in {
    bash = "${pkgs.bash}/bin/bash";
    jq = "${pkgs.jq}/bin";
    coreutils = "${pkgs.coreutils}/bin";
    findutils = "${pkgs.findutils}/bin";
    libnotify = "${pkgs.libnotify}/bin";
    procps = "${pkgs.procps}/bin";

    # We pass the full command string (e.g. "nixGL /path/to/swww")
    swww_daemon_cmd = "${nixGLPrefix}${pkgs.swww}/bin/swww-daemon";
    swww_client_cmd = "${nixGLPrefix}${pkgs.swww}/bin/swww";
  };

  # 3. Create the executable launcher
  wallpaperManager = pkgs.writeShellScriptBin "wallpaper-manager" ''
    exec ${pkgs.bash}/bin/bash "${scriptFile}" "$@"
  '';
in {
  # Define options for users to configure
  options.programs.canaima-wallpapers = {
    enable = mkEnableOption "Enable wallpaper manager";
    withNixGL = mkOption {
      type = types.bool;
      default = false;
      description = "Wrap swww with NixGL (Required for Ubuntu).";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
      jq
      procps
      wallpaperManager
    ];
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
        ExecStart = "${wallpaperManager}/bin/wallpaper-manager";
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
  };
}
